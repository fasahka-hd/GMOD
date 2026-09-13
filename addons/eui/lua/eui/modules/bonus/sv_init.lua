util.AddNetworkString('eui.bonus:Time')
util.AddNetworkString('eui.bonus:Claim')

local playerTime = {}

local function InitDB()
	sql.Query([[
		CREATE TABLE IF NOT EXISTS eui_bonus (
			steamid TEXT PRIMARY KEY,
			playtime INTEGER DEFAULT 0,
			claimed INTEGER DEFAULT 0
		)
	]])
end

InitDB()

local function GetPlayerData(sid)
	local row = sql.QueryRow('SELECT playtime, claimed FROM eui_bonus WHERE steamid = ' .. sql.SQLStr(sid) .. ';')
	if row then
		return tonumber(row.playtime) or 0, tonumber(row.claimed) == 1
	end
	return 0, false
end

local function SetPlayerTime(sid, time)
	sql.Query('INSERT OR REPLACE INTO eui_bonus (steamid, playtime, claimed) VALUES (' .. sql.SQLStr(sid) .. ', ' .. tonumber(time) .. ', COALESCE((SELECT claimed FROM eui_bonus WHERE steamid = ' .. sql.SQLStr(sid) .. '), 0));')
end

local function SetClaimed(sid)
	sql.Query('INSERT OR REPLACE INTO eui_bonus (steamid, playtime, claimed) VALUES (' .. sql.SQLStr(sid) .. ', 0, 1);')
end

local function ResetDB()
	sql.Query('DELETE FROM eui_bonus;')
end

local function GiveBonus(pl)
	if not IsValid(pl) then return end

	if eui.bonus and eui.bonus.AddWin then
		pcall(eui.bonus.AddWin, pl)
	end

	pl:SetNetVar('eui.bonus:Claimed', true)
end

net.Receive('eui.bonus:Claim', function(len, pl)
	local sid = pl:SteamID64()

	if pl:GetNetVar('eui.bonus:Claimed') then return end

	local savedTime, claimed = GetPlayerData(sid)
	if claimed then
		pl:SetNetVar('eui.bonus:Claimed', true)
		playerTime[sid] = nil
		return
	end

	local currentTime = playerTime[sid] or savedTime
	if currentTime < eui.bonus.time then return end

	playerTime[sid] = nil
	SetClaimed(sid)
	GiveBonus(pl)
end)

hook.Add('PlayerInitialSpawn', 'eui.bonus:PlayerInitialSpawn', function(pl)
	local sid = pl:SteamID64()
	local savedTime, claimed = GetPlayerData(sid)

	if claimed then
		pl:SetNetVar('eui.bonus:Claimed', true)
		return
	end

	playerTime[sid] = savedTime

	if playerTime[sid] >= eui.bonus.time then

		net.Start('eui.bonus:Time')
			net.WriteUInt(playerTime[sid], 32)
			net.WriteFloat(CurTime())
		net.Send(pl)
		return
	end

	net.Start('eui.bonus:Time')
		net.WriteUInt(playerTime[sid], 32)
		net.WriteFloat(CurTime())
	net.Send(pl)
end)

hook.Add('PlayerDisconnected', 'eui.bonus:PlayerDisconnected', function(pl)
	local sid = pl:SteamID64()
	if playerTime[sid] then
		SetPlayerTime(sid, playerTime[sid])
	end
end)

timer.Create('eui.bonus:Timer', 1, 0, function()
	for sid, _ in pairs(playerTime) do
		local savedTime, claimed = GetPlayerData(sid)
		if claimed then
			playerTime[sid] = nil
			continue
		end

		local pl = player.GetBySteamID64(sid)
		if not IsValid(pl) then continue end

		playerTime[sid] = playerTime[sid] + 1

		if playerTime[sid] % 60 == 0 then
			SetPlayerTime(sid, playerTime[sid])
		end

		if playerTime[sid] < eui.bonus.time then continue end

		net.Start('eui.bonus:Time')
			net.WriteUInt(playerTime[sid], 32)
			net.WriteFloat(CurTime())
		net.Send(pl)
	end
end)

concommand.Add('eui_bonus_reset', function(ply, cmd, args)
	if IsValid(ply) and not ply:IsSuperAdmin() then
		ply:ChatPrint('Недостаточно прав!')
		return
	end

	ResetDB()
	playerTime = {}

	for _, pl in ipairs(player.GetAll()) do
		pl:SetNetVar('eui.bonus:Claimed', false)

		local sid = pl:SteamID64()
		playerTime[sid] = 0

		net.Start('eui.bonus:Time')
			net.WriteUInt(0, 32)
			net.WriteFloat(CurTime())
		net.Send(pl)
	end

	local msg = 'База данных бонусов была сброшена.'
	if IsValid(ply) then
		ply:ChatPrint(msg)
	else
		print(msg)
	end
end)