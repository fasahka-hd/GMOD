util.AddNetworkString('CheatCheck.OverlayV2')

local POS_FILE = 'cheatcheck_positions.json'

local function getCfg()
	return (CheatCheck and CheatCheck.Config) or {}
end

local function isChecked(pl)
	return IsValid(pl) and pl._CheatCheck ~= nil and pl._CheatCheck.active == true
end

local function sendOverlay(target, active)
	if not IsValid(target) then return end

	local st = target._CheatCheck or {}
	local c = getCfg()

	net.Start('CheatCheck.OverlayV2')
		net.WriteBool(active)
		net.WriteString(target:SteamID64())
		net.WriteString(active and (c.DiscordURL or '') or '')
		net.WriteString(active and st.admin or '')
	net.Send(target)
end

local function getCheckPos()
	if not file.Exists(POS_FILE, 'DATA') then return end

	local data = util.JSONToTable(file.Read(POS_FILE, 'DATA') or '')
	if not istable(data) then return end

	local m = data[game.GetMap()]
	if not istable(m) then return end

	return Vector(m.x or 0, m.y or 0, m.z or 0), Angle(m.pitch or 0, m.yaw or 0, 0)
end

local function setCheckPos(pl)
	local data = {}
	if file.Exists(POS_FILE, 'DATA') then
		data = util.JSONToTable(file.Read(POS_FILE, 'DATA') or '') or {}
	end

	local pos, ang = pl:GetPos(), pl:EyeAngles()
	data[game.GetMap()] = {x = pos.x, y = pos.y, z = pos.z, pitch = ang.p, yaw = ang.y}

	file.Write(POS_FILE, util.TableToJSON(data, true))
end

local function teleportToCheckPoint(target)
	local pos, ang = getCheckPos()
	if not pos then return false end

	target:SetPos(pos)
	if ang then target:SetEyeAngles(ang) end

	return true
end

local function cheatCheckStart(pl, target)
	local c = getCfg()

	target._CheatCheck = {
		active    = true,
		returnPos = target:GetPos(),
		admin     = IsValid(pl) and ((pl.NameID and pl:NameID()) or pl:Name()) or 'Console',
	}

	if target:InVehicle() then target:ExitVehicle() end
	if not target:Alive() then target:Spawn() end

	local teleported = teleportToCheckPoint(target)

	if c.FreezeOnCheck ~= false then target:Freeze(true) end

	sendOverlay(target, true)
	timer.Simple(0.6, function()
		if isChecked(target) then sendOverlay(target, true) end
	end)

	return teleported
end

local function cheatCheckStop(pl, target)
	local st = target._CheatCheck or {}

	target._CheatCheck = {active = false}

	if getCfg().FreezeOnCheck ~= false then target:Freeze(false) end
	if getCfg().ReturnAfterCheck ~= false and st.returnPos then
		target:SetPos(st.returnPos)
	end

	sendOverlay(target, false)
end

local function registerCommands()
	ba.cmd.Create('check', function(pl, args)
		local target = args.target
		if not IsValid(target) then return end

		if isChecked(target) then
			cheatCheckStop(pl, target)
			ba.notify_staff('# снял проверку читов с #.', pl, target)
			ba.notify(target, '# снял с вас проверку читов.', pl)
		else
			local teleported = cheatCheckStart(pl, target)
			ba.notify_staff('# вызвал # на проверку читов.', pl, target)
			ba.notify(target, '# вызвал вас на проверку читов. Вся информация у вас на экране.', pl)

			if not teleported then
				ba.notify_err(pl, 'Точка проверки не установлена: игрок НЕ телепортирован. Встаньте в нужное место и пропишите !checkchitspos')
			end
		end
	end)
	:AddParam('player_entity', 'target')
	:SetFlag('l')
	:SetHelp('Вызвать игрока на проверку читов. Повторный ввод — снять с проверки. Пример: /checkchits (ник)')
	:SetIcon('icon16/shield.png')

	ba.cmd.Create('CheckChitsPos', function(pl, args)
		setCheckPos(pl)
		ba.notify(pl, 'Точка телепорта для проверки читов установлена на вашу текущую позицию.')
	end)
	:SetFlag('*')
	:SetHelp('Установить точку телепорта для проверки читов на вашу текущую позицию')
	:SetIcon('icon16/flag_red.png')
end

local function initCommands()
	if not (ba and ba.cmd) then return end
	registerCommands()
end

initCommands()
hook.Add('bAdmin_Loaded', 'CheatCheck.Init', initCommands)

timer.Simple(5, initCommands)
timer.Simple(20, initCommands)
timer.Simple(60, initCommands)

local serverChanging = false

hook.Add('ShutDown', 'CheatCheck.ShutDown', function()
	serverChanging = true
end)

hook.Add('PlayerDisconnected', 'CheatCheck.Autoban', function(pl)
	if serverChanging then return end
	if not isChecked(pl) then return end

	local c = getCfg()
	local nick = (pl.NameID and pl.NameID()) or (pl:Name() .. ' (' .. pl:SteamID() .. ')')
	local sid  = pl:SteamID()
	local sid64 = pl:SteamID64()

	pl._CheatCheck = nil

	if ba and ba.IsBanned and ba.IsBanned(sid64) then return end
        
	local reason = c.BanReason or 'Выход с проверки'
	RunConsoleCommand('ba', 'perma', sid, reason)

	print(('[CheatCheck] %s — перманентный бан через ba perma %s "%s"'):format(nick, sid, reason))
	ba.notify_staff('# покинул сервер во время проверки читов и получил перманентный бан (Console).', nick)
end)

hook.Add('PlayerSpawn', 'CheatCheck.Respawn', function(pl)
	if not isChecked(pl) then return end

	timer.Simple(0.1, function()
		if not isChecked(pl) then return end

		teleportToCheckPoint(pl)
		if getCfg().FreezeOnCheck ~= false then pl:Freeze(true) end
		sendOverlay(pl, true)
	end)
end)