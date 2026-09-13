term.Add('AdminExt', '# потушил #.')

term.Add('EnteredAdminmode', '# включил админ-мод.')
term.Add('ExitedAdminmode', '# выключил админ-мод.')

term.Add('AdminFrozePlayersProps', '# заморозил пропы #')
term.Add('AdminFrozeAllProps', '# заморозил все пропы.')

term.Add('CannotUnown', 'Вы не можете использовать команду unown на эту дверь.')
term.Add('AdminUnownedYourDoor', '# отнял владение у вашей двери.')
term.Add('AdminUnownedPlayerDoor', '# отнял владение двери у #.')

term.Add('ExtCooldown', 'Подождите прежде чем потушить игрока еще раз. (КД: 15 секунд)')
term.Add('AdminStrippedWeaponsYou', '# забрал у вас всё оружие.')
term.Add('AdminStrippedWeaponsPlayer', '# забрал у # всё оружие.')
term.Add('GeoIPResult', 'Игрок # играет из: #')

----------------------------
-- Ext
----------------------------

ba.cmd.Create('ext', function(pl, args)
	pl.DelayExtung = pl.DelayExtung or 0

	if CurTime() < pl.DelayExtung then 
		ba.notify_err(pl, term.Get('ExtCooldown'))
		return 
	end
	args.target:Extinguish()
	ba.notify_staff(term.Get('AdminExt'), pl, args.target)
    pl.DelayExtung = CurTime() + 15
end)
:AddParam('player_entity', 'target')
:SetFlag('S')
:SetHelp('Тушит игрока Пример: /ext (ник)')

-------------------------------------------------
-- Adminmode
-------------------------------------------------

ba.cmd.Create('AdminMode', function(pl, args)
	if pl:HasAccess('l') or pl:IsRoot() then
		local newState = not pl:GetBVar('adminmode')
		pl:SetNWBool('ba_adminmode', newState)
		pl:SetBVar('adminmode', newState)
		ba.notify_staff(newState and term.Get('EnteredAdminmode') or term.Get('ExitedAdminmode'), pl)
	elseif pl:Team() == TEAM_ADMIN then
		pl:ChangeTeam(1, true)
		pl:SetNWBool('ba_adminmode', false)
		pl:SetBVar('adminmode', false)
		ba.notify_staff(term.Get('ExitedAdminmode'), pl)
	else
		pl:ChangeTeam(TEAM_ADMIN, true)
		pl:SetNWBool('ba_adminmode', true)
		pl:SetBVar('adminmode', true)
		ba.notify_staff(term.Get('EnteredAdminmode'), pl)
	end
end)
:SetFlag('M')
:SetHelp('Включает админ-мод. head-admin+ могут без смены профессии.')
:AddAlias("am")

-------------------------------------------------
-- Freeze Props
-------------------------------------------------

ba.cmd.Create('Freeze Props', function(pl, args)
	if IsValid(args.target) then
		ba.notify_staff(term.Get('AdminFrozePlayersProps'), pl, args.target)
		for k, v in ipairs(ents.GetAll()) do
	        if IsValid(v) and v:IsProp() and (v:CPPIGetOwner() == args.target) then
	            local phys = v:GetPhysicsObject()
	            if IsValid(phys) then
	                phys:EnableMotion(false)
	            end
	            constraint.RemoveAll(v)
	        end
	    end
	else
		ba.notify_staff(term.Get('AdminFrozeAllProps'), pl)
		for k, v in ipairs(ents.GetAll()) do
	        if IsValid(v) and v:IsProp() then
	            local phys = v:GetPhysicsObject()
	            if IsValid(phys) then
	                phys:EnableMotion(false)
	            end
	            constraint.RemoveAll(v)
	        end
	    end
	end
end)
:AddParam('player_entity', 'target', 'optional')
:SetFlag 'E'
:SetHelp 'Заморозить все пропы'

-------------------------------------------------
-- Unown
-------------------------------------------------

ba.cmd.Create('Unown', function(pl, args)
	local ent = pl:GetEyeTrace().Entity
	if IsValid(ent) and ent:IsDoor() then
		local owner = ent:DoorGetOwner()
		ba.notify(owner, term.Get('AdminUnownedYourDoor'), pl)
		ba.notify_staff(term.Get('AdminUnownedPlayerDoor'), pl, owner)
		ent:DoorUnOwn()
	else
		ba.notify_err(pl, term.Get('CannotUnown'))
	end
end)
:SetFlag 'E'
:SetHelp 'Убрать владельца двери'

----------------------------
-- GeoIP
----------------------------

ba.cmd.Create('geoip', function(pl, args)
	local ip = string.Split(args.target:IPAddress(), ":")[1]
	http.Fetch(string.format("http://ip-api.com/json/%s", ip), function(body)
		local data = util.JSONToTable(body)
		local country = data and data['country'] or 'Неизвестно'
		ba.notify(pl, term.Get('GeoIPResult'), args.target, country)
	end)
end)
:AddParam('player_entity', 'target')
:SetFlag('M')
:SetHelp('Страна из которой играет игрок. Пример: /geoip (ник)')

----------------------------
-- Strip Weapons
----------------------------

ba.cmd.Create('Strip Weapons', function(pl, args)
	args.target:StripWeapons()
	ba.notify(args.target, term.Get('AdminStrippedWeaponsYou'), pl)
	ba.notify_staff(term.Get('AdminStrippedWeaponsPlayer'), pl, args.target)
end)
:AddParam('player_entity', 'target')
:SetFlag('L')
:SetHelp('Забирает все оружие у игрока')