--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

ba.banneds = ba.banneds or {}

local db = ba.data.GetDB()

-- ========================================
-- УБИРАЕМ УДАЛЕНИЕ ХУКА PLAYERSAY
-- ========================================
-- hook.Remove('PlayerSay', 'ba.cmd.PlayerSay')  -- ЗАКОММЕНТИРОВАНО

local function banPlayer(pl)
	if isplayer(pl) and IsValid(pl) then
		if pl:IsJailed() then
			ba.unJailPlayer(pl)
		end
		pl:SetNetVar('IsBanned', true)
		pl:ChangeTeam(TEAM_BANNED, true)
		pl:SetBVar('VoiceMuted', true)
		pl:SetBVar('ChatMuted', true)
		pl:Freeze(false)
		pl:Spawn()
		pl:GodEnable()
	end
end

hook.Add('OnPlayerBan', 'rp.OnPlayerBan', function(pl)
	if isplayer(pl) and IsValid(pl) then
		pl:SetBVar('adminmode', false)
		pl:DoorUnOwnAll()
		for k, v in ipairs(ents.GetAll()) do
			if IsValid(v) and (v:CPPIGetOwner() == pl) then
				v:Remove()
			end
		end
		banPlayer(pl)
	end
end)

hook.Add('OnPlayerUnban', 'rp.OnPlayerUnban', function(steamid)
	local pl = player.Find(steamid)	
	if isplayer(pl) and IsValid(pl) then
		pl:SetNetVar('IsBanned', nil)
		pl:ChangeTeam(1, true)
		pl:SetBVar('VoiceMuted', false)
		pl:SetBVar('ChatMuted', false)
		pl:GodDisable()		
	end
end)

hook.Add('KickOnPlayerBan', 'rp.KickOnPlayerBan', function(pl, reason, time, admin)
	return (time == 0)
end)

-- ========================================
-- ИСПРАВЛЕНО: УБРАНА БЛОКИРОВКА КОМАНД
-- ========================================
-- ЗАКОММЕНТИРОВАНО
-- hook.Add('playerCanRunCommand', 'rp.playerCanRunCommand', function(pl, cmd)
-- 	if pl:IsBanned() and (cmd ~= 'motd') and (cmd ~= 'smotd') then
-- 		return false, 'You cannot use commands while banned!'
-- 	end
-- end)

local msg = [[
Вы забанены!
-------------------------------------
Дата бана: %s
Дата разбана: %s
Администратор: %s
Причина: %s
-------------------------------------
Апелляцию писать в дискорд-сервер
]]

function ba.bans.CheckPassword(steamid, ip, pass, cl_pass, name)
	local banned, data = ba.IsBanned(steamid)
	ba.banneds[steamid] = banned
	if banned and (data.unban_time == 0) then
		local banDate = os.date('%d/%m/%y - %H:%M', data.ban_time)
		local unbanDate = ((data.unban_time == 0) and 'Never' or os.date('%d/%m/%y - %H:%M', data.unban_time))
		local admin = data.a_name .. '(' .. util.SteamIDFrom64(data.a_steamid) .. ')'
		return false, string.format(msg, banDate, unbanDate, admin, data.reason) 
	end
end
hook.Add('CheckPassword', 'ba.Bans.CheckPassword', ba.bans.CheckPassword)

hook.Add('PlayerEntityCreated', 'rp.checkbans', function(pl)
	if ba.banneds[pl:SteamID64()] then
		banPlayer(pl)
	end
end)

hook.Add('CanPlayerEnterVehicle', 'Banned_PlayerEnteredVehicle', function(pl)
	if pl:IsBanned() then return false end
end)

hook.Add('PlayerCanUseAdminChat', 'banned.PlayerCanUseAdminChat', function(pl)
	if pl:IsBanned() then return false end
end)

hook.Add('PlayerAdminCheck', 'banned.PlayerIsAdmin', function(pl)
	if pl:GetRankTable():IsAdmin() and not pl:IsRoot() then
		return not pl:IsBanned()
	end
end)