if CLIENT then return end

Duels = Duels or {}
Duels.Lobbies = Duels.Lobbies or {}
Duels.Config = Duels.Config or {}
DUEL = DUEL or {}
DUEL.__index = DUEL

util.AddNetworkString("duels")

Duels.NextId = Duels.NextId or 0
Duels.Cooldowns = Duels.Cooldowns or {}

local function Now()
	return CurTime()
end

function Duels.GetMoney(ply)
	if ply.getDarkRPVar then
		return ply:getDarkRPVar("money") or 0
	end

	return ply.GetMoney and ply:GetMoney() or 0
end

function Duels.AddMoney(ply, amount)
	if not IsValid(ply) then return end

	if ply.addMoney then
		ply:addMoney(amount)
	elseif ply.AddMoney then
		ply:AddMoney(amount)
	end
end

local SH_AddCredits = Duels.AddCredits

function Duels.AddCredits(ply, amount, note, callback)
	if not IsValid(ply) then return end

	if SH_AddCredits then
		return SH_AddCredits(ply, amount, note, callback)
	end

	if ply.SetCredits and ply.GetCredits then
		ply:SetCredits(math.max((ply:GetCredits() or 0) + amount, 0))
		if callback then callback(true) end
		return
	end

	MsgN("[Duels] Не найдена система донат-валюты, начисление пропущено.")
	if callback then callback(false) end
end

function Duels.CanAfford(ply, amount, isDonate)
	if not IsValid(ply) then return false end

	if isDonate then
		return Duels.GetCredits(ply) >= amount
	end

	return Duels.GetMoney(ply) >= amount
end

function Duels.TakeBet(ply, amount, isDonate)
	if not Duels.CanAfford(ply, amount, isDonate) then return false end

	if isDonate then
		Duels.AddCredits(ply, -amount)
	else
		Duels.AddMoney(ply, -amount)
	end

	return true
end

function Duels.GiveBet(ply, amount, isDonate)
	if not IsValid(ply) or amount <= 0 then return end

	if isDonate then
		Duels.AddCredits(ply, amount)
	else
		Duels.AddMoney(ply, amount)
	end
end

function Duels.Notify(ply, text, title)
	if not IsValid(ply) then return end

	net.Start("duels")
		net.WriteUInt(5, 3)
		net.WriteString(title or "Дуэли")
		net.WriteString(text)
	net.Send(ply)
end

function Duels.GetDB()

	if ba and ba.data and ba.data.GetDB then
		return ba.data.GetDB()
	end

	if Duels.DB then return Duels.DB end

	if not ptmysql or not isfunction(ptmysql.newdb) then
		MsgN("[Duels] ОШИБКА: ptmysql (tmysql4) не загружен!")
		return nil
	end

	local ip   = GetConVar('ba_db_ip')   and GetConVar('ba_db_ip'):GetString()   or '45.11.16.77'
	local user = GetConVar('ba_db_user') and GetConVar('ba_db_user'):GetString() or 'u4651_gx7IYqcAts'
	local pass = GetConVar('ba_db_pass') and GetConVar('ba_db_pass'):GetString() or '34rhSv+opAtZ!K2TkhJJ253d'
	local name = GetConVar('ba_db_name') and GetConVar('ba_db_name'):GetString() or 's4651_myserver'
	local port = GetConVar('ba_db_port') and GetConVar('ba_db_port'):GetInt()    or 3306

	local db = ptmysql.newdb(ip, user, pass, name, port)

	if db and db._db then
		Duels.DB = db
		MsgN("[Duels] Своё соединение с MySQL установлено: " .. name .. "@" .. ip)
	else
		MsgN("[Duels] ОШИБКА: не удалось подключиться к MySQL (" .. ip .. "). Проверь креды/сеть.")
	end

	return db
end

function Duels.DBRows(results)
	local out = {}
	if not istable(results) then return out end

	for _, res in ipairs(results) do
		if istable(res) then
			if res.error then

			elseif istable(res.data) then
				for _, row in ipairs(res.data) do
					out[#out + 1] = row
				end
			elseif res.steamid or res.map or res.v or res.id or res.c then
				out[#out + 1] = res
			end
		end
	end

	return out
end

function Duels.InitDB()

	local db = Duels.GetDB()

	if db and db._db then
		db._db:Query("CREATE TABLE IF NOT EXISTS duels_arenas (id INT AUTO_INCREMENT PRIMARY KEY, map VARCHAR(64) DEFAULT '', name VARCHAR(64) DEFAULT '', p1x DOUBLE DEFAULT 0, p1y DOUBLE DEFAULT 0, p1z DOUBLE DEFAULT 0, a1y DOUBLE DEFAULT 0, p2x DOUBLE DEFAULT 0, p2y DOUBLE DEFAULT 0, p2z DOUBLE DEFAULT 0, a2y DOUBLE DEFAULT 0, in_use TINYINT NOT NULL DEFAULT 0, busy_until INT NOT NULL DEFAULT 0)", function() end)
		db._db:Query("CREATE TABLE IF NOT EXISTS duels_stats (steamid VARCHAR(20) NOT NULL, name VARCHAR(64) DEFAULT '', wins INT NOT NULL DEFAULT 0, losses INT NOT NULL DEFAULT 0, favourite VARCHAR(64) DEFAULT '', PRIMARY KEY (steamid))", function() end)
		db._db:Query("CREATE TABLE IF NOT EXISTS duels_weapons (steamid VARCHAR(20) NOT NULL, weapon VARCHAR(64) NOT NULL, uses INT NOT NULL DEFAULT 0, PRIMARY KEY (steamid, weapon))", function() end)
		db._db:Query("CREATE TABLE IF NOT EXISTS duels_history (id INT AUTO_INCREMENT PRIMARY KEY, stamp INT NOT NULL DEFAULT 0, date VARCHAR(32) DEFAULT '', map VARCHAR(64) DEFAULT '', winner_sid VARCHAR(20) DEFAULT '', winner_name VARCHAR(64) DEFAULT '', loser_sid VARCHAR(20) DEFAULT '', loser_name VARCHAR(64) DEFAULT '', weapon VARCHAR(64) DEFAULT '', weapon_name VARCHAR(64) DEFAULT '', amount BIGINT NOT NULL DEFAULT 0, currency VARCHAR(16) DEFAULT 'money', donate TINYINT NOT NULL DEFAULT 0, rating TINYINT NOT NULL DEFAULT 0, armor TINYINT NOT NULL DEFAULT 0, result VARCHAR(16) DEFAULT 'win', duration INT NOT NULL DEFAULT 0)", function() end)
		db._db:Query("CREATE TABLE IF NOT EXISTS duels_site_sync (k VARCHAR(64) PRIMARY KEY, v VARCHAR(128))", function() end)
	else
		MsgN("[Duels] ВНИМАНИЕ: MySQL недоступен (ba.data.GetDB) — дуэли будут работать с ошибками!")
	end

	sql.Query("CREATE TABLE IF NOT EXISTS duels_npcs (map TEXT, posx REAL, posy REAL, posz REAL, angy REAL, model TEXT)")
end

hook.Add("Initialize", "Duels.InitDB", function()
	Duels.InitDB()
end)

Duels.InitDB()

function Duels.GetStats(ply, callback)
	local empty = { wins = 0, losses = 0, name = "", favourite = "" }
	callback = callback or function() end

	if not IsValid(ply) then callback(empty) return empty end

	local sid = ply:SteamID64()
	if not sid then callback(empty) return empty end

	local db = Duels.GetDB()
	if not db or not db._db then callback(empty) return empty end

	db._db:Query("SELECT * FROM duels_stats WHERE steamid = '" .. db:escape(sid) .. "'", function(results)
		local row = Duels.DBRows(results)[1]

		if not row then
			db._db:Query("INSERT INTO duels_stats (steamid, name, wins, losses, favourite) VALUES ('" ..
				db:escape(sid) .. "', '" .. db:escape(ply:Nick()) .. "', 0, 0, '')", function() end)

			callback({ wins = 0, losses = 0, name = ply:Nick(), favourite = "" })
			return
		end

		callback({
			wins = tonumber(row.wins) or 0,
			losses = tonumber(row.losses) or 0,
			name = tostring(row.name or ply:Nick()),
			favourite = tostring(row.favourite or ""),
		})
	end)

	return empty
end

function Duels.GetFavouriteWeapon(ply, callback)
	callback = callback or function() end

	if not IsValid(ply) then callback("") return "" end

	local sid = ply:SteamID64()
	if not sid then callback("") return "" end

	local db = Duels.GetDB()
	if not db or not db._db then callback("") return "" end

	db._db:Query("SELECT weapon FROM duels_weapons WHERE steamid = '" .. db:escape(sid) .. "' ORDER BY uses DESC LIMIT 1", function(results)
		local row = Duels.DBRows(results)[1]
		callback(row and tostring(row.weapon) or "")
	end)

	return ""
end

function Duels.AddWeaponUse(ply, class)
	if not IsValid(ply) or not class or class == "" then return end

	local sid = ply:SteamID64()
	if not sid then return end

	local db = Duels.GetDB()
	if not db or not db._db then return end

	db._db:Query("INSERT INTO duels_weapons (steamid, weapon, uses) VALUES ('" ..
		db:escape(sid) .. "', '" .. db:escape(class) .. "', 1) ON DUPLICATE KEY UPDATE uses = uses + 1", function()
		Duels.GetFavouriteWeapon(ply, function(best)
			db._db:Query("UPDATE duels_stats SET favourite = '" .. db:escape(best) .. "' WHERE steamid = '" .. db:escape(sid) .. "'", function() end)
		end)
	end)
end

function Duels.AddWin(ply, class)
	if not IsValid(ply) then return end

	local sid = ply:SteamID64()
	if not sid then return end

	local db = Duels.GetDB()
	if not db or not db._db then return end

	db._db:Query("INSERT INTO duels_stats (steamid, name, wins, losses, favourite) VALUES ('" ..
		db:escape(sid) .. "', '" .. db:escape(ply:Nick()) .. "', 1, 0, '') ON DUPLICATE KEY UPDATE wins = wins + 1, name = '" .. db:escape(ply:Nick()) .. "'", function()
		Duels.AddWeaponUse(ply, class)
	end)
end

function Duels.AddLoss(ply, class)
	if not IsValid(ply) then return end

	local sid = ply:SteamID64()
	if not sid then return end

	local db = Duels.GetDB()
	if not db or not db._db then return end

	db._db:Query("INSERT INTO duels_stats (steamid, name, wins, losses, favourite) VALUES ('" ..
		db:escape(sid) .. "', '" .. db:escape(ply:Nick()) .. "', 0, 1, '') ON DUPLICATE KEY UPDATE losses = losses + 1, name = '" .. db:escape(ply:Nick()) .. "'", function()
		Duels.AddWeaponUse(ply, class)
	end)
end

function Duels.AddHistory(winner, loser, weapon, amount, isDonate, isRating, withArmor, result, duration)
	local db = Duels.GetDB()
	if not db or not db._db then return false end

	local winnerSid = IsValid(winner) and winner:SteamID64() or ""
	local winnerName = IsValid(winner) and winner:Nick() or "-"
	local loserSid = IsValid(loser) and loser:SteamID64() or ""
	local loserName = IsValid(loser) and loser:Nick() or "-"

	if winnerSid == "" and loserSid == "" then return false end

	local q = "INSERT INTO duels_history (stamp, date, map, winner_sid, winner_name, loser_sid, loser_name, weapon, weapon_name, amount, currency, donate, rating, armor, result, duration) VALUES (" ..
		os.time() .. ", '" ..
		db:escape(os.date("%Y-%m-%d %H:%M:%S")) .. "', '" ..
		db:escape(game.GetMap()) .. "', '" ..
		db:escape(winnerSid) .. "', '" ..
		db:escape(winnerName) .. "', '" ..
		db:escape(loserSid) .. "', '" ..
		db:escape(loserName) .. "', '" ..
		db:escape(tostring(weapon or "")) .. "', '', " ..
		tostring(tonumber(amount or 0)) .. ", '" ..
		(isDonate and "credits" or "money") .. "', " ..
		(isDonate and 1 or 0) .. ", " ..
		(isRating and 1 or 0) .. ", " ..
		(withArmor and 1 or 0) .. ", '" ..
		db:escape(tostring(result or "win")) .. "', " ..
		tostring(math.max(math.floor(tonumber(duration) or 0), 0)) .. ")"

	db._db:Query(q, function() end)

	return true
end

function Duels.GetTop(count, callback)
	count = tonumber(count) or Duels.Config.TopCount
	callback = callback or function() end

	local db = Duels.GetDB()
	if not db or not db._db then callback({}) return {} end

	db._db:Query("SELECT steamid, name, wins FROM duels_stats WHERE wins > 0 ORDER BY wins DESC LIMIT " .. math.floor(count), function(results)
		local list = {}

		for _, row in ipairs(Duels.DBRows(results)) do
			list[#list + 1] = {
				sid = tostring(row.steamid or ""),
				name = tostring(row.name or "Unknown"),
				wins = tonumber(row.wins) or 0,
			}
		end

		callback(list)
	end)

	return {}
end

local function WriteLobby(lobby)
	net.WriteUInt(lobby:GetId(), 7)
	net.WriteEntity(lobby:GetOwner())
	net.WriteUInt(math.Clamp(lobby:GetAmount(), 0, 134217727), 27)
	net.WriteBool(lobby:GetArmor())
	net.WriteBool(lobby:GetDonate())
	net.WriteBool(lobby:GetRating())
	net.WriteString(lobby:GetWeapon())
	net.WriteUInt(math.Clamp(lobby:GetVictories(), 0, 1023), 10)
	net.WriteUInt(math.Clamp(lobby:GetLosses(), 0, 1023), 10)
	net.WriteBool(lobby:IsStarted())
	net.WriteUInt(math.Clamp(math.ceil(lobby:GetTimeLeft()), 0, 65535), 16)
	net.WriteEntity(lobby:GetTarget() or NULL)
end

function Duels.SyncAll(target)
	local lobbies = {}
	for _, lobby in pairs(Duels.Lobbies) do
		if not IsValid(lobby:GetOwner()) then continue end
		lobbies[#lobbies + 1] = lobby
	end

	net.Start("duels")
		net.WriteUInt(0, 3)
		net.WriteUInt(#lobbies, 8)

		for _, lobby in ipairs(lobbies) do
			WriteLobby(lobby)
		end
	if IsValid(target) then net.Send(target) else net.Broadcast() end
end

function Duels.SyncLobby(lobby, target)
	if not IsValid(lobby:GetOwner()) then return end

	net.Start("duels")
		net.WriteUInt(1, 3)
		WriteLobby(lobby)
	if IsValid(target) then net.Send(target) else net.Broadcast() end
end

function Duels.SyncRemove(id)
	net.Start("duels")
		net.WriteUInt(2, 3)
		net.WriteUInt(id, 7)
	net.Broadcast()
end

function Duels.SyncAnnounce(lobby)
	net.Start("duels")
		net.WriteUInt(4, 3)
		net.WriteUInt(lobby:GetId(), 7)
	net.Broadcast()
end

function Duels.SendMenu(ply)
	if not IsValid(ply) then return end

	Duels.GetStats(ply, function(stats)
		if not IsValid(ply) then return end

		Duels.GetFavouriteWeapon(ply, function(fav)
			if not IsValid(ply) then return end

			Duels.GetTop(Duels.Config.TopCount, function(top)
				if not IsValid(ply) then return end

				net.Start("duels")
					net.WriteUInt(3, 3)
					net.WriteUInt(math.Clamp(stats.wins or 0, 0, 1023), 10)
					net.WriteUInt(math.Clamp(stats.losses or 0, 0, 1023), 10)
					net.WriteString(fav)

					local capped = math.min(#top, 15)

					net.WriteUInt(capped, 4)
					for i = 1, capped do
						local entry = top[i]
						net.WriteUInt64(entry.sid)
						net.WriteString(entry.name)
						net.WriteUInt(math.Clamp(entry.wins, 0, 1023), 10)
					end

					local total, busy = Duels.GetArenaCounts()
					net.WriteUInt(math.Clamp(total, 0, 255), 8)
					net.WriteUInt(math.Clamp(busy, 0, 255), 8)
				net.Send(ply)

				Duels.SyncAll(ply)
			end)
		end)
	end)
end

local function NextFreeId()
	for i = 1, Duels.Config.MaxLobbies do
		if not Duels.Lobbies[i] then return i end
	end

	return nil
end

function Duels.FindArena()
	for index, arena in ipairs(Duels.Config.Arenas) do
		if not arena.InUse then return index, arena end
	end

	return nil
end

function Duels.GetArenaCounts()
	local total, busy = 0, 0

	for _, arena in ipairs(Duels.Config.Arenas) do
		total = total + 1
		if arena.InUse then busy = busy + 1 end
	end

	return total, busy
end

function Duels.SyncArenaCounts()
	local total, busy = Duels.GetArenaCounts()

	net.Start("duels")
		net.WriteUInt(6, 3)
		net.WriteUInt(math.Clamp(total, 0, 255), 8)
		net.WriteUInt(math.Clamp(busy, 0, 255), 8)
	net.Broadcast()
end

function Duels.SaveArenas(callback)
	local db = Duels.GetDB()
	if not db or not db._db then
		if callback then callback(0) end
		return 0
	end

	local map = game.GetMap()

	db._db:Query("DELETE FROM duels_arenas WHERE map = '" .. db:escape(map) .. "'", function()
		local count = 0

		for _, arena in ipairs(Duels.Config.Arenas) do
			if not arena.pos1 or not arena.pos2 then continue end

			local a1 = arena.ang1 or Angle(0, 0, 0)
			local a2 = arena.ang2 or Angle(0, 0, 0)

			local q = "INSERT INTO duels_arenas (map, name, p1x, p1y, p1z, a1y, p2x, p2y, p2z, a2y) VALUES ('" ..
				db:escape(map) .. "', '', " ..
				arena.pos1.x .. ", " .. arena.pos1.y .. ", " .. arena.pos1.z .. ", " .. a1.y .. ", " ..
				arena.pos2.x .. ", " .. arena.pos2.y .. ", " .. arena.pos2.z .. ", " .. a2.y .. ")"

			db._db:Query(q, function() end)
			count = count + 1
		end

		if callback then callback(count) end
	end)

	return 0
end

function Duels.LoadArenas(callback)
	Duels.Config.Arenas = {}

	local db = Duels.GetDB()

	if not db or not db._db then
		if callback then callback(0) end
		return 0
	end

	local ok, count = pcall(function()
		local function DoLoad(sql)
			local rows = db:query_sync(sql)
			local c = 0

			for _, row in ipairs(rows or {}) do
				Duels.Config.Arenas[#Duels.Config.Arenas + 1] = {
					pos1 = Vector(tonumber(row.p1x) or 0, tonumber(row.p1y) or 0, tonumber(row.p1z) or 0),
					ang1 = Angle(0, tonumber(row.a1y) or 0, 0),
					pos2 = Vector(tonumber(row.p2x) or 0, tonumber(row.p2y) or 0, tonumber(row.p2z) or 0),
					ang2 = Angle(0, tonumber(row.a2y) or 0, 0),
					InUse = false,
				}
				c = c + 1
			end

			return c
		end

		local map = game.GetMap()

		local c = DoLoad("SELECT * FROM duels_arenas WHERE map = '" .. db:escape(map) .. "'")

		if c == 0 then
			Duels.Config.Arenas = {}
			c = DoLoad("SELECT * FROM duels_arenas")
		end

		return c
	end)

	if not ok or not count then count = 0 end

	MsgN("[Duels] Загружено арен: " .. count)

	if callback then callback(count) end

	return count
end

Duels.ArenaPending = Duels.ArenaPending or {}

concommand.Add("duels_arena_add", function(ply)
	if IsValid(ply) and not ply:IsSuperAdmin() then
		Duels.Notify(ply, "Нет доступа!")
		return
	end

	if not IsValid(ply) then
		print("[Duels] Команду нужно выполнять в игре.")
		return
	end

	local sid = ply:SteamID64()
	local pos = ply:GetPos()
	local ang = Angle(0, ply:EyeAngles().y, 0)

	if not Duels.ArenaPending[sid] then
		Duels.ArenaPending[sid] = { pos1 = pos, ang1 = ang }
		Duels.Notify(ply, "Точка 1 записана. Встаньте на вторую точку и введите duels_arena_add снова.")
		return
	end

	local pending = Duels.ArenaPending[sid]
	Duels.ArenaPending[sid] = nil

	Duels.Config.Arenas[#Duels.Config.Arenas + 1] = {
		pos1 = pending.pos1,
		ang1 = pending.ang1,
		pos2 = pos,
		ang2 = ang,
		InUse = false,
	}

	Duels.SaveArenas()
	Duels.SyncArenaCounts()

	Duels.Notify(ply, "Арена #" .. #Duels.Config.Arenas .. " создана и сохранена.")
end)

concommand.Add("duels_arena_list", function(ply)
	if IsValid(ply) and not ply:IsSuperAdmin() then return end

	local out = IsValid(ply) and function(t) ply:ChatPrint(t) end or function(t) MsgN(t) end

	out("=== Арены дуэлей (" .. game.GetMap() .. ") ===")

	if #Duels.Config.Arenas == 0 then
		out("Арен нет. Создайте: duels_arena_add (дважды, на двух точках)")
		return
	end

	for index, arena in ipairs(Duels.Config.Arenas) do
		out("#" .. index .. " " .. tostring(arena.pos1) .. " <-> " .. tostring(arena.pos2) ..
			(arena.InUse and "  [ЗАНЯТА]" or "  [свободна]"))
	end
end)

concommand.Add("duels_arena_remove", function(ply, cmd, args)
	if IsValid(ply) and not ply:IsSuperAdmin() then return end

	local index = tonumber(args[1])

	if not index or not Duels.Config.Arenas[index] then
		Duels.Notify(ply, "Укажите номер арены: duels_arena_remove <номер>")
		return
	end

	table.remove(Duels.Config.Arenas, index)

	Duels.SaveArenas()
	Duels.SyncArenaCounts()

	local text = "Арена #" .. index .. " удалена."
	if IsValid(ply) then Duels.Notify(ply, text) else print("[Duels] " .. text) end
end)

concommand.Add("duels_arena_reload", function(ply)
	if IsValid(ply) and not ply:IsSuperAdmin() then return end

	Duels.LoadArenas(function(count)
		Duels.SyncArenaCounts()

		local text = "Загружено арен: " .. count
		if IsValid(ply) then Duels.Notify(ply, text) else print("[Duels] " .. text) end
	end)
end)

function Duels.Create(ply, amount, withArmor, isDonate, isRating, weapon)
	if not IsValid(ply) then return end

	if Duels.GetLobbyByPlayer(ply) then
		Duels.Notify(ply, "Вы уже участвуете в дуэли!")
		return
	end

	if not ply:Alive() then
		Duels.Notify(ply, "Вы должны быть живы!")
		return
	end

	local cooldown = Duels.Cooldowns[ply:SteamID64()]
	if cooldown and cooldown > Now() then
		Duels.Notify(ply, "Подождите немного перед созданием новой дуэли!")
		return
	end

	if not Duels.IsWeaponAllowed(weapon) then
		Duels.Notify(ply, "Это оружие нельзя использовать в дуэли!")
		return
	end

	if not Duels.PlayerHasWeapon(ply, weapon) then
		Duels.Notify(ply, "У вас нет этого оружия!")
		return
	end

	amount = math.floor(tonumber(amount) or 0)

	if isDonate and not Duels.Config.Credits then
		isDonate = false
	end

	local minimum, maximum = Duels.GetLimits(ply, isDonate)

	if amount < minimum then
		Duels.Notify(ply, "Минимальная ставка: " .. string.Comma(minimum))
		return
	end

	if maximum > 0 and amount > maximum then
		Duels.Notify(ply, "Максимальная ставка: " .. string.Comma(maximum))
		return
	end

	if not Duels.CanAfford(ply, amount, isDonate) then
		Duels.Notify(ply, "У вас недостаточно средств!")
		return
	end

	local id = NextFreeId()
	if not id then
		Duels.Notify(ply, "Слишком много активных дуэлей, попробуйте позже!")
		return
	end

	if not Duels.TakeBet(ply, amount, isDonate) then
		Duels.Notify(ply, "У вас недостаточно средств!")
		return
	end

	Duels.GetStats(ply, function(stats)
		if not IsValid(ply) then

			Duels.GiveBet(ply, amount, isDonate)
			return
		end

		local lobby = setmetatable({}, DUEL)
		lobby.Id = id
		lobby.Owner = ply
		lobby.Target = nil
		lobby.Amount = amount
		lobby.WithArmor = withArmor and true or false
		lobby.IsDonate = isDonate and true or false
		lobby.IsRating = isRating and true or false
		lobby.Weapon = weapon
		lobby.Victories = stats.wins or 0
		lobby.Losses = stats.losses or 0
		lobby.Started = false
		lobby.EndTime = 0

		Duels.Lobbies[id] = lobby
		Duels.Cooldowns[ply:SteamID64()] = Now() + Duels.Config.Cooldown

		Duels.SyncLobby(lobby)
		Duels.SyncAnnounce(lobby)

		hook.Run("DuelCreated", lobby)
	end)
end

function Duels.Cancel(lobby, refund)
	if not lobby then return end

	local id = lobby:GetId()
	if not Duels.Lobbies[id] then return end

	if refund ~= false then
		Duels.GiveBet(lobby:GetOwner(), lobby:GetAmount(), lobby:GetDonate())

		if lobby:IsStarted() then
			Duels.GiveBet(lobby:GetTarget(), lobby:GetAmount(), lobby:GetDonate())
		end
	end

	lobby:Cleanup()

	Duels.Lobbies[id] = nil
	Duels.SyncRemove(id)

	hook.Run("DuelCancelled", lobby)
end

function DUEL:Cleanup()
	timer.Remove("Duels.Timeout." .. self:GetId())

	if self.Arena then
		self.Arena.InUse = false
		self.Arena = nil
	end

	for _, ply in ipairs({ self:GetOwner(), self:GetTarget() }) do
		if not IsValid(ply) then continue end

		if ply.DuelRestore then
			local data = ply.DuelRestore
			ply.DuelRestore = nil

			if ply:Alive() then
				ply:StripWeapons()
				ply:RemoveAllAmmo()

				timer.Simple(0, function()
					if not IsValid(ply) then return end
					Duels.ApplyRestore(ply, data)
				end)
			else
				ply.DuelRestorePending = data
			end
		end

		ply:SetNWBool("InDuel", false)
	end
end

function DUEL:Prepare(ply, spawnPos, spawnAng)
	if not IsValid(ply) then return end

	ply:SetNWBool("InDuel", true)

	local restore = {
		pos = ply:GetPos(),
		ang = ply:EyeAngles(),
		health = ply:Health(),
		armor = ply:Armor(),
		weapons = {},
		active = IsValid(ply:GetActiveWeapon()) and ply:GetActiveWeapon():GetClass() or nil,
	}

	for _, wep in ipairs(ply:GetWeapons()) do
		if not IsValid(wep) then continue end

		restore.weapons[#restore.weapons + 1] = {
			class = wep:GetClass(),
			clip1 = wep:Clip1(),
			clip2 = wep:Clip2(),
			ammo = ply:GetAmmoCount(wep:GetPrimaryAmmoType()),
		}
	end

	ply.DuelRestore = restore

	ply:SetHealth(Duels.Config.Health)
	ply:SetMaxHealth(Duels.Config.Health)
	ply:SetArmor(self:GetArmor() and Duels.Config.Armor or 0)

	if spawnPos then
		ply:SetPos(spawnPos)
	end

	if spawnAng then
		ply:SetEyeAngles(spawnAng)
	end

	ply:StripWeapons()
	ply:RemoveAllAmmo()

	local class = self:GetWeapon()

	timer.Simple(0, function()
		if not IsValid(ply) then return end

		ply.DuelGiving = true
		local wep = ply:Give(class)
		ply.DuelGiving = nil

		if IsValid(wep) then
			ply:GiveAmmo(255, wep:GetPrimaryAmmoType(), true)
			ply:SelectWeapon(class)
		else
			Duels.Notify(ply, "Не удалось выдать оружие дуэли: " .. tostring(class))
		end
	end)
end

function Duels.ApplyRestore(ply, data, keepPos)
	if not IsValid(ply) or not data then return end

	ply.DuelGiving = true

	if not keepPos then
		if data.pos then ply:SetPos(data.pos) end
		if data.ang then ply:SetEyeAngles(data.ang) end
	end

	ply:SetHealth(math.max(tonumber(data.health) or 1, 1))
	ply:SetArmor(tonumber(data.armor) or 0)

	local ammo = {}

	for _, entry in ipairs(data.weapons or {}) do
		local wep = ply:Give(entry.class, true)
		if not IsValid(wep) then continue end

		wep:SetClip1(entry.clip1 or 0)
		wep:SetClip2(entry.clip2 or 0)

		local ammoType = wep:GetPrimaryAmmoType()
		if ammoType and ammoType >= 0 then
			ammo[ammoType] = math.max(ammo[ammoType] or 0, tonumber(entry.ammo) or 0)
		end
	end

	for ammoType, count in pairs(ammo) do
		ply:SetAmmo(count, ammoType)
	end

	if data.active then
		ply:SelectWeapon(data.active)
	end

	ply.DuelGiving = nil
end

function DUEL:Restore(ply)
	if not IsValid(ply) then return end

	local data = ply.DuelRestore
	ply.DuelRestore = nil
	ply:SetNWBool("InDuel", false)

	if not data then return end

	if not ply:Alive() then
		ply.DuelRestorePending = data
		return
	end

	ply:StripWeapons()
	ply:RemoveAllAmmo()

	timer.Simple(0, function()
		if not IsValid(ply) then return end
		Duels.ApplyRestore(ply, data)
	end)
end

function Duels.Join(ply, id)
	local lobby = Duels.Lobbies[id]

	if not lobby then
		Duels.Notify(ply, "Эта дуэль больше не существует!")
		return
	end

	if lobby:IsStarted() then
		Duels.Notify(ply, "Эта дуэль уже началась!")
		return
	end

	if lobby:GetOwner() == ply then
		Duels.Notify(ply, "Вы не можете играть сами с собой!")
		return
	end

	if Duels.GetLobbyByPlayer(ply) then
		Duels.Notify(ply, "Вы уже участвуете в дуэли!")
		return
	end

	if not IsValid(lobby:GetOwner()) or not lobby:GetOwner():Alive() then
		Duels.Cancel(lobby)
		Duels.Notify(ply, "Создатель дуэли недоступен!")
		return
	end

	if not ply:Alive() then
		Duels.Notify(ply, "Вы должны быть живы!")
		return
	end

	if not Duels.PlayerHasWeapon(ply, lobby:GetWeapon()) then
		Duels.Notify(ply, "У вас нет такого оружия: " .. Duels.GetWeaponName(lobby:GetWeapon()))
		return
	end

	if not Duels.CanAfford(ply, lobby:GetAmount(), lobby:GetDonate()) then
		Duels.Notify(ply, "У вас недостаточно средств!")
		return
	end

	local arenaIndex, arena = Duels.FindArena()
	if not arena then
		Duels.Notify(ply, "Нет свободных арен, попробуйте позже!")
		return
	end

	if not Duels.TakeBet(ply, lobby:GetAmount(), lobby:GetDonate()) then
		Duels.Notify(ply, "У вас недостаточно средств!")
		return
	end

	arena.InUse = true
	lobby.Arena = arena
	lobby.ArenaIndex = arenaIndex
	lobby.Target = ply
	lobby.Started = true
	lobby.StartTime = Now()
	lobby.EndTime = Now() + Duels.Config.Duration

	lobby:Prepare(lobby:GetOwner(), arena.pos1, arena.ang1)
	lobby:Prepare(ply, arena.pos2, arena.ang2)

	timer.Create("Duels.Timeout." .. lobby:GetId(), Duels.Config.Duration, 1, function()
		if not Duels.Lobbies[lobby:GetId()] then return end
		Duels.Finish(lobby, nil, nil, true)
	end)

	Duels.SyncLobby(lobby)
	Duels.SyncArenaCounts()

	hook.Run("DuelStarted", lobby)

	return lobby
end

function Duels.Finish(lobby, winner, loser, draw)
	if not lobby or not Duels.Lobbies[lobby:GetId()] then return end

	local id = lobby:GetId()
	local amount = lobby:GetAmount()
	local isDonate = lobby:GetDonate()

	timer.Remove("Duels.Timeout." .. id)

	lobby:Restore(lobby:GetOwner())
	lobby:Restore(lobby:GetTarget())

	local duration = 0
	if lobby.StartTime then
		duration = math.max(0, math.floor(Now() - lobby.StartTime))
	end

	local weapon = lobby:GetWeapon()
	local isRating = lobby:GetRating()
	local withArmor = lobby:GetArmor()

	if draw or not IsValid(winner) then
		Duels.GiveBet(lobby:GetOwner(), amount, isDonate)
		Duels.GiveBet(lobby:GetTarget(), amount, isDonate)

		Duels.AddHistory(lobby:GetOwner(), lobby:GetTarget(), weapon, amount, isDonate, isRating, withArmor, "draw", duration)
	else
		Duels.GiveBet(winner, amount * 2, isDonate)

		if lobby:GetRating() then
			Duels.AddWin(winner, weapon)

			if IsValid(loser) then
				Duels.AddLoss(loser, weapon)
			end
		end

		Duels.AddHistory(winner, loser, weapon, amount, isDonate, isRating, withArmor, "win", duration)

		Duels.Notify(winner, "Вы победили в дуэли и получили " .. lobby:FormatAmount() .. "!")

		if IsValid(loser) then
			Duels.Notify(loser, "Вы проиграли дуэль!")
		end
	end

	lobby:Cleanup()

	Duels.Lobbies[id] = nil
	Duels.SyncRemove(id)
	Duels.SyncArenaCounts()

	hook.Run("DuelFinished", lobby, winner, loser)
end

hook.Add("PlayerDeath", "Duels", function(victim, inflictor, attacker)
	local lobby = Duels.GetLobbyByPlayer(victim)
	if not lobby or not lobby:IsStarted() then return end

	local winner = lobby:GetOpponent(victim)

	timer.Simple(0, function()
		Duels.Finish(lobby, winner, victim)
	end)
end)

hook.Add("PlayerDisconnected", "Duels", function(ply)
	local lobby = Duels.GetLobbyByPlayer(ply)
	if not lobby then return end

	if not lobby:IsStarted() then
		Duels.Cancel(lobby)
		return
	end

	local winner = lobby:GetOpponent(ply)
	Duels.Finish(lobby, winner, ply)
end)

hook.Add("PlayerSpawn", "Duels", function(ply)
	if ply.DuelRestore then
		ply.DuelRestorePending = ply.DuelRestore
		ply.DuelRestore = nil
	end

	ply:SetNWBool("InDuel", false)

	local data = ply.DuelRestorePending
	if not data then return end

	ply.DuelRestorePending = nil

	timer.Simple(0.1, function()
		if not IsValid(ply) or not ply:Alive() then return end
		Duels.ApplyRestore(ply, data, true)
	end)
end)

hook.Add("CanPlayerSuicide", "Duels", function(ply)
	if ply:InDuel() then return false end
end)

hook.Add("PlayerCanPickupWeapon", "Duels", function(ply, wep)
	if ply.DuelGiving then return true end

	local lobby = Duels.GetLobbyByPlayer(ply)
	if not lobby or not lobby:IsStarted() then return end

	if IsValid(wep) and wep:GetClass() ~= lobby:GetWeapon() then return false end

	return true
end)

hook.Add("PlayerCanPickupItem", "Duels", function(ply)
	if ply.DuelGiving then return end
	if ply:InDuel() then return false end
end)

hook.Add("PlayerLoadout", "Duels", function(ply)
	if ply.DuelRestorePending or ply:InDuel() then return true end
end)

hook.Add("canDropWeapon", "Duels", function(ply)
	if ply:InDuel() then return false end
end)

hook.Add("PlayerSay", "Duels", function(ply, text)
	local said = string.lower(string.Trim(text))

	for _, cmd in ipairs(Duels.Config.ChatCommands) do
		if said == string.lower(cmd) then
			Duels.SendMenu(ply)
			return ""
		end
	end
end)

net.Receive("duels", function(len, ply)
	if not IsValid(ply) then return end

	ply.DuelsNextNet = ply.DuelsNextNet or 0
	if ply.DuelsNextNet > Now() then return end
	ply.DuelsNextNet = Now() + 0.2

	local action = net.ReadUInt(3)

	if action == 0 then
		local amount = net.ReadUInt(27)
		local withArmor = net.ReadBool()
		local isDonate = net.ReadBool()
		local isRating = net.ReadBool()
		local weapon = net.ReadString()

		Duels.Create(ply, amount, withArmor, isDonate, isRating, weapon)
	elseif action == 1 then
		local lobby = Duels.GetLobbyByPlayer(ply)
		if not lobby or lobby:GetOwner() ~= ply or lobby:IsStarted() then return end

		Duels.Cancel(lobby)
	elseif action == 2 then
		Duels.Join(ply, net.ReadUInt(7))
	elseif action == 3 then
		Duels.SendMenu(ply)
	end
end)

local NPC_CLASS = "npc_duels"

Duels.SpawnedNPCs = Duels.SpawnedNPCs or {}

local function IsStaff(ply)
	if not IsValid(ply) then return true end
	return ply:IsSuperAdmin()
end

function Duels.SaveNPCs()
	local map = game.GetMap()

	sql.Query("DELETE FROM duels_npcs WHERE map = " .. sql.SQLStr(map))

	local count = 0

	for _, npc in ipairs(ents.FindByClass("npc_duels")) do
		if not IsValid(npc) then continue end

		local pos = npc:GetPos()
		local ang = npc:GetAngles()

		sql.Query("INSERT INTO duels_npcs (map, posx, posy, posz, angy, model) VALUES (" ..
			sql.SQLStr(map) .. ", " ..
			pos.x .. ", " .. pos.y .. ", " .. pos.z .. ", " ..
			ang.y .. ", " ..
			sql.SQLStr(npc:GetModel() or "") .. ")")

		count = count + 1
	end

	return count
end

function Duels.SpawnNPC(pos, ang, model)
	local npc = ents.Create(NPC_CLASS)
	if not IsValid(npc) then return nil end

	npc:SetPos(pos)
	npc:SetAngles(Angle(0, ang and ang.y or 0, 0))

	if model and model ~= "" then
		npc.Model = model
	end

	npc:Spawn()
	npc:Activate()

	if npc.CapabilitiesClear then
		npc:SetMoveType(MOVETYPE_NONE)
	end

	Duels.SpawnedNPCs[#Duels.SpawnedNPCs + 1] = npc

	return npc
end

function Duels.LoadNPCs()
	local rows = sql.Query("SELECT * FROM duels_npcs WHERE map = " .. sql.SQLStr(game.GetMap()))
	if not rows then return 0 end

	local count = 0

	for _, row in ipairs(rows) do
		local pos = Vector(tonumber(row.posx) or 0, tonumber(row.posy) or 0, tonumber(row.posz) or 0)
		local ang = Angle(0, tonumber(row.angy) or 0, 0)

		if Duels.SpawnNPC(pos, ang, row.model) then
			count = count + 1
		end
	end

	return count
end

function Duels.ClearNPCs()
	local count = 0

	for _, npc in ipairs(ents.FindByClass(NPC_CLASS)) do
		if not IsValid(npc) then continue end

		npc:Remove()
		count = count + 1
	end

	Duels.SpawnedNPCs = {}

	return count
end

concommand.Add("duels_npc_spawn", function(ply)
	if not IsStaff(ply) then
		Duels.Notify(ply, "Нет доступа!")
		return
	end

	if not IsValid(ply) then
		print("[Duels] Команду нужно выполнять в игре.")
		return
	end

	local trace = ply:GetEyeTrace()
	if not trace.Hit then return end

	local ang = (ply:GetPos() - trace.HitPos):Angle()
	ang.p = 0
	ang.r = 0

	local npc = Duels.SpawnNPC(trace.HitPos + Vector(0, 0, 2), ang)
	if not IsValid(npc) then
		Duels.Notify(ply, "Не удалось создать NPC!")
		return
	end

	Duels.SaveNPCs()
	Duels.Notify(ply, "NPC создан и сохранён.")
end)

concommand.Add("duels_npc_remove", function(ply)
	if not IsStaff(ply) then
		Duels.Notify(ply, "Нет доступа!")
		return
	end

	if not IsValid(ply) then return end

	local target = ply:GetEyeTrace().Entity

	if not IsValid(target) or target:GetClass() ~= NPC_CLASS then
		Duels.Notify(ply, "Смотрите на NPC дуэлей!")
		return
	end

	target:Remove()

	for index = #Duels.SpawnedNPCs, 1, -1 do
		if not IsValid(Duels.SpawnedNPCs[index]) then
			table.remove(Duels.SpawnedNPCs, index)
		end
	end

	Duels.SaveNPCs()
	Duels.Notify(ply, "NPC удалён.")
end)

concommand.Add("duels_npc_clear", function(ply)
	if not IsStaff(ply) then return end

	local count = Duels.ClearNPCs()
	Duels.SaveNPCs()

	local text = "Удалено NPC: " .. count

	if IsValid(ply) then
		Duels.Notify(ply, text)
	else
		print("[Duels] " .. text)
	end
end)

concommand.Add("duels_npc_save", function(ply)
	if not IsStaff(ply) then return end

	local count = Duels.SaveNPCs()
	local text = "Сохранено NPC: " .. count

	if IsValid(ply) then
		Duels.Notify(ply, text)
	else
		print("[Duels] " .. text)
	end
end)

concommand.Add("duels_npc_reload", function(ply)
	if not IsStaff(ply) then return end

	Duels.ClearNPCs()
	local count = Duels.LoadNPCs()

	local text = "Загружено NPC: " .. count

	if IsValid(ply) then
		Duels.Notify(ply, text)
	else
		print("[Duels] " .. text)
	end
end)

local function DuelsTryLoadArenas()
	local arenas = Duels.LoadArenas()
	MsgN("[Duels] Автозагрузка: загружено арен: " .. arenas)
	if arenas > 0 then
		Duels.SyncArenaCounts()
	end
	return arenas
end

hook.Add("InitPostEntity", "Duels.LoadNPCs", function()
	timer.Simple(1, function()
		Duels.InitDB()

		Duels.LoadNPCs()

		local tries = 0

		local function TryLoad()
			tries = tries + 1
			local arenas = DuelsTryLoadArenas()

			if arenas > 0 then return end

			if tries < 60 then
				timer.Simple(3, TryLoad)
				return
			end

			MsgN("[Duels] ВНИМАНИЕ: БД не вернула арены за отведённое время.")
		end

		TryLoad()
	end)
end)

timer.Create("Duels.ArenaSelfHeal", 10, 0, function()
	if #Duels.Config.Arenas > 0 then return end
	DuelsTryLoadArenas()
end)

hook.Add("PlayerInitialSpawn", "Duels.ArenaSync", function(ply)
	if #Duels.Config.Arenas > 0 then
		Duels.SyncArenaCounts()
	end
end)

concommand.Add("duels_history_debug", function(ply, cmd, args)
	if IsValid(ply) and not ply:IsSuperAdmin() then return end

	local out
	if IsValid(ply) then
		out = function(t) ply:ChatPrint(t) end
	else
		out = function(t) MsgN(t) end
	end

	out("=== Duels history debug (MySQL) ===")

	local db = Duels.GetDB()
	if not db or not db._db then
		out("MySQL недоступен (ba.data.GetDB).")
		return
	end

	db._db:Query("SELECT COUNT(*) AS c, MAX(id) AS m FROM duels_history", function(results)
		local row = Duels.DBRows(results)[1]
		local cnt = tonumber(row and row.c) or 0
		local maxId = tonumber(row and row.m) or 0

		out("Записей: " .. cnt .. " · max id: " .. maxId)

		db._db:Query("SELECT v FROM duels_site_sync WHERE k = 'last_history_rowid'", function(sres)
			local srow = Duels.DBRows(sres)[1]
			local lastSent = tonumber(srow and srow.v) or 0

			out("Отправлено на сайт до id: " .. lastSent .. " · ждёт отправки: " .. math.max(maxId - lastSent, 0))

			if lastSent > maxId then
				out("ПРОБЛЕМА: указатель БОЛЬШЕ max id — логи на сайт не уйдут никогда!")
				out("Лечится: duels_history_resync")
			end
		end)
	end)

	db._db:Query("SELECT id, winner_name, loser_name, result, amount, stamp FROM duels_history ORDER BY id DESC LIMIT 3", function(results)
		for _, r in ipairs(Duels.DBRows(results)) do
			out("#" .. tostring(r.id) .. " [" .. tostring(r.stamp) .. "] " .. tostring(r.winner_name) .. " vs " .. tostring(r.loser_name) .. " = " .. tostring(r.result) .. " (" .. tostring(r.amount) .. ")")
		end
	end)

	if args[1] == "test" then
		db._db:Query("INSERT INTO duels_history (stamp, date, map, winner_sid, winner_name, loser_sid, loser_name, weapon, weapon_name, amount, currency, donate, rating, armor, result, duration) VALUES (" .. os.time() .. ", NOW(), '" .. db:escape(game.GetMap()) .. "', '00000000000000000', 'TEST', '11111111111111111', 'TEST', 'weapon_pistol', '', 0, 'money', 0, 0, 0, 'win', 0)", function()
			out("Тестовая запись добавлена. Перепроверь счётчик через duels_history_debug")
		end)
	end
end)

concommand.Add("duels_history_resync", function(ply, cmd, args)
	if IsValid(ply) and not ply:IsSuperAdmin() then return end

	local out = IsValid(ply) and function(t) ply:ChatPrint(t) end or function(t) MsgN(t) end

	local db = Duels.GetDB()
	if not db or not db._db then
		out("MySQL недоступен (ba.data.GetDB).")
		return
	end

	local from = math.max(math.floor(tonumber(args[1]) or 0), 0)

	db._db:Query("INSERT INTO duels_site_sync (k, v) VALUES ('last_history_rowid', '" .. db:escape(tostring(from)) .. "') ON DUPLICATE KEY UPDATE v = '" .. db:escape(tostring(from)) .. "'", function()
		out("[Duels] Указатель синхронизации сброшен на " .. from .. ".")

		RunConsoleCommand("duels_sync_now")
		out("[Duels] Запущена переотправка истории на панель.")
	end)
end)
