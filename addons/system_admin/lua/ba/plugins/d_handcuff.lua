term.Add('AdminHandcuffedPlayer', '# надел наручники на #.')
term.Add('AdminHandcuffPlayerAlready', '# уже в наручниках.')
term.Add('AdminHandcuffPlayerOffline', 'Игрок должен быть на сервере.')

local function SetCuffBone(pl, bone, ang)
	local boneId = pl:LookupBone(bone)
	if boneId then
		pl:ManipulateBoneAngles(boneId, ang)
	end
end

local function HandcuffPlayer(pl)
	if pl:GetNWBool('isHandcuffed', false) then return false end

	if pl.InVehicle and pl:InVehicle() then
		pl:ExitVehicle()
	end

	pl:SetNWBool('isHandcuffed', true)

	SetCuffBone(pl, 'ValveBiped.Bip01_L_UpperArm', Angle(20, 8.8, 0))
	SetCuffBone(pl, 'ValveBiped.Bip01_L_Forearm', Angle(15, 0, 0))
	SetCuffBone(pl, 'ValveBiped.Bip01_L_Hand', Angle(0, 0, 75))
	SetCuffBone(pl, 'ValveBiped.Bip01_R_Forearm', Angle(-15, 0, 0))
	SetCuffBone(pl, 'ValveBiped.Bip01_R_Hand', Angle(0, 0, -75))
	SetCuffBone(pl, 'ValveBiped.Bip01_R_UpperArm', Angle(-20, 16.6, 0))

	local walkSpeed = rp and rp.cfg and rp.cfg.WalkSpeed or pl:GetWalkSpeed()
	local runSpeed = rp and rp.cfg and rp.cfg.RunSpeed or pl:GetRunSpeed()

	pl:SetWalkSpeed(walkSpeed / 2.5)
	pl:SetRunSpeed(runSpeed / 2.5)

	pl.HandcuffedWeapons = {}
	pl.HandcuffedWeaponAmmo = {}
	pl.HandcuffedWeaponAmmoType = {}

	for i, v in ipairs(pl:GetWeapons()) do
		pl.HandcuffedWeapons[i] = {v:GetClass(), v.donate or v.DisableDrop}
		pl.HandcuffedWeaponAmmo[v:GetPrimaryAmmoType()] = pl:GetAmmoCount(v:GetPrimaryAmmoType())
	end

	pl:StripWeapons()
	hook.Call('PlayerCuf', GAMEMODE, pl)

	return true
end

ba.cmd.Create('Handcuff', function(pl, args)
	if not IsValid(args.target) or not args.target:IsPlayer() then
		return ba.notify_err(pl, term.Get('AdminHandcuffPlayerOffline'))
	end

	if not HandcuffPlayer(args.target) then
		return ba.notify_err(pl, term.Get('AdminHandcuffPlayerAlready'), args.target)
	end

	ba.notify_staff(term.Get('AdminHandcuffedPlayer'), pl, args.target)
end)
:AddParam('player_steamid', 'target')
:SetFlag('*')
:SetHelp('Надеть наручники на игрока.')
:SetIcon('icon16/lock.png')
:AddAlias('cuff')