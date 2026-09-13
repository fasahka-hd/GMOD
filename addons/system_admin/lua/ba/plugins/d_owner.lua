
term.Add('AdminBurn', '# поджог # на # секунд.')

term.Add('AdminSetHunger', '# установил # голод на #.')
term.Add('AdminSetYourHunger', '# установил ваш голод на #.')

term.Add('AbusePlayerNotAlive', '# мёртв!')
term.Add('AbuseAdminSlainPlayer', '# убил #.')

term.Add('AdminFrozePlayersProps', '# заморозил пропы #')
term.Add('AdminFrozeAllProps', '# заморозил все пропы.')

term.Add('AdminunFoodPlayer', '# восстановил голод,хп,броню #.')
term.Add('Adminunresfoodyou', '# восстановил вам голод,хп,броню')


----------------------------
-- Burn
----------------------------

ba.cmd.Create('burn', function(pl, args)
	pl.DelayBurn = pl.DelayBurn or 0

	if CurTime() < pl.DelayBurn then 
		ba.notify(pl, "Подождите прежде чем поджечь еще раз. (КД: 15 секунд)")
		return 
	end
    args.target:Ignite(args.time)
	ba.notify_staff(term.Get('AdminBurn'), pl, args.target, args.time)
    pl.DelayBurn = CurTime() + 15
end)
:AddParam('player_entity', 'target')
:AddParam('string', 'time')
:SetFlag('C')
:SetHelp('Поджигает игрока Пример: /burn (ник)')

----------------------------
-- SetFOOD
----------------------------

ba.cmd.Create('Set Food', function(pl, args)
	args.target:HFM_SetHunger(args.hunger)

	ba.notify_staff(term.Get('AdminSetHunger'), pl, args.target, args.hunger)
	ba.notify(args.target, term.Get('AdminSetYourHunger'), pl, args.hunger)
end)
:AddParam('player_entity', 'target')
:AddParam('string', 'hunger')
:SetFlag 'L'
:SetHelp 'Установить голод'
local function addTime(pl, amount, cback)
local db = rp._Stats
	db:Query('SELECT * FROM `ba_users` WHERE steamid="'..pl:SteamID64()..'";', function(_data)
		local data = _data[1] or {}
		local total = amount * 60 + data.playtime
		db:Query("UPDATE `ba_users` SET `playtime`="..total.." WHERE steamid="..pl:SteamID64()..";")
		pl:SetNetVar('PlayTime', total)	
	end)
end

----------------------------
-- Invsee
----------------------------

ba.cmd.Create('invsee', function(pl, args)

	local inv = args.target.Inventory
	if not inv then return end

	inv:Sync( pl )
	pl:OpenContainer( inv:GetID(), itemstore.Translate( "inventory" ), true )

end)
:AddParam('player_entity', 'target')
:SetFlag('M')
:SetHelp('Инвентарь игрока. Пример: /invsee (ник)')

----------------------------
-- pmtoggle
----------------------------


ba.cmd.Create('pmtoggle', function(pl, args)

	if pl:GetNetVar("PM_Allow") then
		pl:SetNetVar('PM_Allow', false)
		ba.notify(pl, "Вы выключили личные сообщения /pm")
	else
		pl:SetNetVar('PM_Allow', true)
		ba.notify(pl, "Вы включили личные сообщения /pm")
	end

end)
:SetFlag('C')
:SetHelp('Включает/Отключает лс в /pm. Пример: /pmtoggle')

----------------------------
-- kill
----------------------------

ba.cmd.Create('kill', function(pl, args)
	if not args.target:Alive() then
		ba.notify_err(pl, term.Get('AbusePlayerNotAlive'), args.target)
		return
	end

	args.target:SetVelocity(Vector(0, 0, 2048))
	timer.Simple(0.2, function()	
		local effect = EffectData()
		effect:SetOrigin(args.target:GetPos())
		effect:SetMagnitude(512)
		effect:SetScale(128)
		util.Effect('Explosion', effect)
		args.target:Kill()
	end)

	ba.notify_staff(term.Get('AbuseAdminSlainPlayer'), pl, args.target)
end)
:AddParam('player_entity', 'target')
:SetFlag('S')
:SetHelp('Убивает игрока. Пример: /kill (ник)')
:SetIcon('icon16/bomb.png')
:AddAlias("slay")
----------------------------
-- Freeze PROPS
----------------------------

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
:SetFlag 'C'
:SetHelp 'Заморозить все пропы'

----------------------------
-- Resfood
----------------------------

ba.cmd.Create('Res Food', function(pl, args)
		ba.notify(args.target, term.Get('Adminunresfoodyou'), pl)
		ba.notify_staff(term.Get('AdminunFoodPlayer'), pl, args.target)
	args.target:HFM_SetHunger(100)
    --args.target:HFM_SetThirsty(100)
	args.target:SetHealth(100)
	args.target:SetArmor(100)
end)
:AddParam('player_entity', 'target')
:SetFlag'E'
:SetHelp'Force resfood a player'
:AddAlias'resfood'
