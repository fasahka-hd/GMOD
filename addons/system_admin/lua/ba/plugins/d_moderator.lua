
term.Add('AdminFrozePlayer', '# заморозил #.')
term.Add('AdminUnfrozePlayer', '# разморозил #.')
term.Add('AdminGoneTo', '# телепортировался к #.')
term.Add('AdminRoomUnset', 'База Админов не назначена!')
term.Add('AdminGoneToAdminRoom', '# отправился на Базу Админов.')
term.Add('AdminRoomSet', 'База Админов обозначена.')
term.Add('AdminReturnedSelf', '# вернул себя в последнюю локацию.')
term.Add('NoKnownPosition', 'У вас нет последней локации.')
term.Add('NoKnownPositionPlayer', 'У # нет последней локации!')
term.Add('AdminBroughtPlayer', '# телепортировал к себе #.')
term.Add('AdminReturnedPlayer', '# вернул # в последнюю локацию.')

-------------------------------------------------
-- Freeze
-------------------------------------------------
ba.cmd.Create('Freeze', function(pl, args)
	if not args.target:Alive() then
		args.target:Spawn()
	end
		
	if args.target:InVehicle() then
		args.target:ExitVehicle()
	end

	if not args.target:IsFrozen() then
		args.target:Freeze(true)
		ba.notify_staff(term.Get('AdminFrozePlayer'), pl, args.target)
	else
		args.target:Freeze(false)
		ba.notify_staff(term.Get('AdminUnfrozePlayer'), pl, args.target)
	end
end)
:AddParam('player_entity', 'target')
:SetFlag('M')
:SetHelp('Замораживает/Размораживает игрока. Пример: /freeze (ник)')
:SetIcon('icon16/lock.png')

-------------------------------------------------
-- Tele
-------------------------------------------------
ba.cmd.Create('Tele', function(pl, args)
	for k, v in ipairs(args.targets) do
		if (not v:Alive()) then
			v:Spawn()
		end

		if v:InVehicle() then
			v:ExitVehicle()
		end

		v:SetBVar('ReturnPos', v:GetPos())

		v:SetPos(util.FindEmptyPos(pl:GetEyeTrace().HitPos))

	end

	if #args.targets == 1 then
		ba.notify_staff(term.Get('AdminBroughtPlayer'), pl, args.targets[1])
	else
		ba.notify_staff('# телепортировал к себе ' .. ('# '):rep(#args.targets) .. '.', pl, unpack(args.targets))
	end
end)
:AddParam('player_entity_multi', 'targets')
:SetFlag('M')
:SetHelp('Телепортирует к себе игрока. Пример: /tp (ник)')
:SetIcon('icon16/arrow_up.png')
:AddAlias('tp')

-------------------------------------------------
-- Goto
-------------------------------------------------
ba.cmd.Create('Goto', function(pl, args)
	local pos = util.FindEmptyPos(args.target:GetPos()) 

	if not pl:Alive() then
		pl:Spawn()
	end
	
	if pl:InVehicle() then
		pl:ExitVehicle()
	end
	
	pl:SetBVar('ReturnPos', pl:GetPos())

	pl:SetPos(pos)

	ba.notify_staff(term.Get('AdminGoneTo'), pl, args.target)
end)
:AddParam('player_entity', 'target')
:SetFlag('M')
:SetHelp('Телепортирует вас к игроку. Пример: /goto (ник)')
:SetIcon('icon16/arrow_down.png')

-------------------------------------------------
-- Sit
-------------------------------------------------
local adminBasePos = Vector(1173.9055175781, 2015.2238769531, -1204.3088378906)

ba.cmd.Create('Sit', function(pl, args)
    if not pl:Alive() then
        pl:Spawn()
    end

    pl:SetBVar('ReturnPos', pl:GetPos())

    local pos = util.FindEmptyPos(adminBasePos)

    pl:SetPos(pos)

    ba.notify_staff(term.Get('AdminGoneToAdminRoom'), pl)
end)
:SetFlag('M')
:SetHelp('Телепортирует вас в админ-базу.')


-------------------------------------------------
-- Return
-------------------------------------------------
ba.cmd.Create('Return', function(pl, args)
	if (args.targets == nil) then
		if (pl:GetBVar('ReturnPos') ~= nil) then
			if not pl:Alive() then
				pl:Spawn()
			end
			
			local pos = util.FindEmptyPos(pl:GetBVar('ReturnPos'))
			pl:SetPos(pos)

			pl:SetBVar('ReturnPos', nil)

			ba.notify_staff(term.Get('AdminReturnedSelf'), pl)
		else
			ba.notify_err(pl, term.Get('NoKnownPosition'))
		end
		return
	end

	for k, v in ipairs(args.targets) do
		if (v:GetBVar('ReturnPos') == nil) then
			ba.notify_err(pl, term.Get('NoKnownPositionPlayer'), v)
			return
		end

		if not v:Alive() then
			v:Spawn()
		end
			
		if v:InVehicle() then
			v:ExitVehicle()
		end

		local pos = util.FindEmptyPos(v:GetBVar('ReturnPos'))

		v:SetPos(pos)
		v:SetBVar('ReturnPos', nil)
	end

	if #args.targets == 1 then
		ba.notify_staff(term.Get('AdminReturnedPlayer'), pl, args.targets[1])
	else
		ba.notify_staff('# вернул ' .. ('# '):rep(#args.targets) .. ' в последнюю локацию.', pl, unpack(args.targets))
	end
end)
:AddParam('player_entity_multi', 'targets', 'optional')
:SetFlag('M')
:SetHelp('Возращает игрока в последнюю локацию. Пример: /return (ник)')
:SetIcon('icon16/arrow_down.png')