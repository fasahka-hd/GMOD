eui.JustBet.matches = eui.JustBet.matches or {}
eui.JustBet.endMatches = {}
eui.JustBet.coof = eui.JustBet.coof or {}

util.AddNetworkString('eui.JustBet:OpenMenu')
util.AddNetworkString('eui.JustBet:PlaceBet')

local db = rp._Stats
db:Query('CREATE TABLE IF NOT EXISTS `just_bet` (steamid bigint(20), data text)')

hook.Add('PlayerInitialSpawn', 'eui.JustBet:PlayerInitialSpawn', function(pl)
	if IsValid(pl) and pl:IsPlayer() then
		local steamid64 = pl:SteamID64()
		db:Query('SELECT * FROM `just_bet` WHERE steamid = ?', steamid64, function(data)
			if data and data[1] then
				return
			end

			db:Query('INSERT INTO `just_bet` VALUES(?, ?)', steamid64, util.TableToJSON({}))
		end)
	end
end)

do
	local plMeta = FindMetaTable('Player')

	function plMeta:StartJustParticipating(match, command, money)
		self:AddMoney(-money, 'Оплата за участие в Just Bet на матч ' .. command .. ' ' .. match or 'хз какой')
		eui.battlepass.AddProgress(self, 16)

		eui.JustBet.matches[match] = eui.JustBet.matches[match] or {}
		eui.JustBet.matches[match][self:SteamID64()] = {command, money}
	end
end

net.Receive('eui.JustBet:PlaceBet', function(_, pl)
	local match = net.ReadUInt(6)
	local command = net.ReadString()
	local price = net.ReadUInt(32)

	if price < eui.JustBet.cfg.price.min then
		rp.Notify(pl, 0, 'Ставка слишком маленькая')
		return
	end

	if price > eui.JustBet.cfg.price.max then
		rp.Notify(pl, 0, 'Ставка слишком большая')
		return
	end

	if not pl:canAfford(price) then
		rp.Notify(pl, 0, 'У вас недостаточно средств')
		return
	end

	if eui.JustBet.endMatches[match] then
		rp.Notify(pl, 0, 'Матч уже закончен')
		return
	end

	if eui.JustBet.matches[match] and eui.JustBet.matches[match][pl:SteamID64()] then
		rp.Notify(pl, 0, 'Вы уже поставили ставку на этот матч')
		return
	end

	rp.Notify(pl, 1, 'Вы поставили ставку на этот матч!')
	pl:StartJustParticipating(match, command, price)
end)

do
	local random = math.random
	local round = math.Round
	local clamp = math.Clamp

	function getRandom()
		local num = random() * (2.82 - 1.01) + 1.01
		return round(num, 2)
	end

	function eui.JustBet.CalculationCoefficient()
		for k, v in next, eui.JustBet.cfg.matches do
			eui.JustBet.coof[k] = eui.JustBet.coof[k] or {}

			local coof1 = getRandom()
			local coof2 = round(1.01 * (2.82 - coof1), 2)
			coof2 = clamp(coof2, 1.01, 2.82)

			local tbl = eui.JustBet.coof[k]
			tbl[v.team1] = coof1
			tbl[v.team2] = coof2
		end
	end

	eui.JustBet.CalculationCoefficient()
end

function eui.JustBet.AppendHistory(sid, team1, team2, win, bet, date, money)
	db:Query('SELECT * FROM `just_bet` WHERE steamid = ?', sid, function(data)
		local tbl = data[1].data
		tbl = util.JSONToTable(tbl)

		tbl[#tbl + 1] = {
			team1 = team1,
			team2 = team2,
			win = win,
			bet = bet,
			date = date,
			money = money
		}

		db:Query('UPDATE `just_bet` SET data = ? WHERE steamid = ?', util.TableToJSON(tbl), sid)
	end)
end

do
	local match = string.match
	local tonumber = tonumber
	local floor = math.floor
	local max = math.max

	function getTime(time)
		local hours, minutes = match(time, '(%d+):(%d+)')
		hours = tonumber(hours)
		minutes = tonumber(minutes)
		return hours, minutes
	end

	local function getTimeInMinutes(hours, minutes)
		return (hours * 60) + minutes
	end

	local function calculateTime(startTime, currentTime)
		local oldH, oldM = getTime(startTime)
		local newH, newM = getTime(currentTime)

		local startMinutes = getTimeInMinutes(oldH, oldM)
		local curMinutes = getTimeInMinutes(newH, newM)

		if curMinutes < startMinutes then
			local start = startMinutes - curMinutes
			return floor(start / 60), start % 60
		end

		if curMinutes >= startMinutes then
			curMinutes = curMinutes + 1440
		end

		local elapsed = curMinutes - startMinutes
		local remaining = 60 - elapsed

		remaining = max(remaining, 0)

		local hour = floor(remaining / 60)
		local min = remaining % 60

		return hour, min
	end

	local function setTime()
		local tbl = {}
		for k, v in next, eui.JustBet.cfg.matches do
			local hour, min = getTime(v.start)
			local curHour = tonumber(os.date('%H'))
			local curMin = tonumber(os.date('%M'))

			if curHour > hour then continue end
			if curHour == hour and curMin >= min then continue end

			local hour, min = calculateTime(v.start, os.date('%H:%M'))
			tbl[k] = {hour = hour, min = min}
		end
		return tbl
	end

	function openMenu(pl)
		if not pl:Alive() then return end

		local tbl = {}
		for match, _ in next, eui.JustBet.cfg.matches do
			if not eui.JustBet.matches[match] then continue end
			if eui.JustBet.endMatches[match] then continue end

			for sid, money in next, eui.JustBet.matches[match] do
				if not (sid == pl:SteamID64()) then continue end
				tbl[match] = money[2]
			end
		end

		db:Query('SELECT * FROM `just_bet` WHERE steamid = ?', pl:SteamID64(), function(data)
			net.Start('eui.JustBet:OpenMenu')
			eui.nets.WriteTable(setTime())
			eui.nets.WriteTable(eui.JustBet.coof)
			eui.nets.WriteTable(tbl)
			eui.nets.WriteTable(util.JSONToTable(data[1].data))
			net.Send(pl)
		end)
	end

	concommand.Add('JustBet', openMenu)
end

function eui.JustBet.CalculateWin(coof1, coof2)
	local first = 1 / coof1
	local second = 1 / coof2

	local total = first + second
	local win1 = first / total
	local win2 = second / total

	return win1, win2
end

function eui.JustBet.GetWinner(match, team1, team2, coof1, coof2)
	local win1, win2 = eui.JustBet.CalculateWin(coof1, coof2)
	local randomValue = math.random()
	return randomValue <= win1 and team1 or team2
end

local function sendAll(txt)
	for k, v in next, player.GetAll() do
		v:ChatPrint(txt)
	end
end

function eui.JustBet.EndMatch(match)
	if not eui.JustBet.matches[match] then
		return
	end

	local cfgMatch = eui.JustBet.cfg.matches[match]
	local coofs = eui.JustBet.coof[match]

	local team1, team2 = cfgMatch.team1, cfgMatch.team2
	local coof1, coof2 = coofs[team1], coofs[team2]
	local winner = eui.JustBet.GetWinner(match, team1, team2, coof1, coof2)

	sendAll('Матч №' .. match .. ' завершился. Победила команда: ' .. winner .. ' !')

	for k, v in next, eui.JustBet.matches[match] do
		local pl = player.GetBySteamID64(k)
		local isWin = v[1] == winner
		v[2] = isWin and v[2] * coofs[winner] or v[2]

		eui.JustBet.AppendHistory(k, team1, team2, winner, v[1], os.date('%d.%m.%y - %H:%M'), v[2])

		if not isWin then
			if IsValid(pl) then
				rp.Notify(pl, 0, 'Ваша ставка проиграла!')
			end
			continue
		end

		if IsValid(pl) then
			rp.Notify(pl, 1, 'Ваша ставка успешно сыграла!')
			pl:AddMoney(v[2], 'Выдача деньги за ставку Just Bet ' .. match .. ' команда: ' .. winner)
			continue
		end

		db:Query('UPDATE `player_data` SET `Money` = `Money` + ? WHERE SteamID = ?', v[2], k)
	end

	eui.JustBet.endMatches[match] = true
end

timer.Create('eui.JustBet:Matches', 60, 0, function()
	for k, v in next, eui.JustBet.cfg.matches do
		if eui.JustBet.endMatches[k] then continue end

		local oldH, oldM = getTime(v.start)
		local newH, newM = getTime(os.date('%H:%M'))
		if not (oldH == newH and oldM == newM) then continue end

		eui.JustBet.EndMatch(k)
	end
end)
