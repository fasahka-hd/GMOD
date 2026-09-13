AddCSLuaFile('cl_init.lua')
AddCSLuaFile('shared.lua')
include('shared.lua')

local allowedteams = {
	[TEAM_SUD] = true,
	[TEAM_LEYPOLICE] = true,
	[TEAM_FSB] = true
}

hook.Add('PlayerDisconnected', 'Handcuffs.BanOnDisconnect', function(pl)
	if not IsValid(pl) or not pl:IsPlayer() then return end
	if not pl:GetNWBool('isHandcuffed', false) then return end

	local steamid = pl:SteamID()
	if not steamid or steamid == 'BOT' or steamid == '' then return end

	RunConsoleCommand('ba', 'ban', steamid, '1h', 'Выход', 'в', 'наручниках')
end)

function SWEP:SecretPrimaryAttack()
	self.Owner:SetAnimation(ACT_VM_PRIMARYATTACK)

	self:SetNextPrimaryFire(CurTime() + 1)

	local tr = self.Owner:GetEyeTraceNoCursor()

	if (not tr.Entity:IsPlayer()) then return end
	if tr.Entity:InVehicle() then tr.Entity:ExitVehicle() end
	if (SafeZones and SafeZones.IsInZone and (SafeZones.IsInZone(self.Owner:GetPos()) or SafeZones.IsInZone(tr.Entity:GetPos()))) then return rp.Notify(self.Owner, NOTIFY_ERROR, 'В зеленой зоне запрещено использовать наручники.') end
	if tr.Entity:IsCP() and not allowedteams[self.Owner:Team()] then return rp.Notify(self:GetOwner(), NOTIFY_ERROR, 'Вы не можете надевать наручники на других копов.') end
	if tr.Entity:Team() == TEAM_ADMIN then return rp.Notify(self.Owner, NOTIFY_ERROR, 'На администратора нельзя надеть наручники.') end
	if tr.Entity:Team() == TEAM_MAYOR then return rp.Notify(self.Owner, NOTIFY_ERROR, 'На мэра нельзя надеть наручники.') end

	if (self:GetOwner():EyePos():Distance(tr.Entity:GetPos()) < 150) and (tr.Entity:GetNWBool('isHandcuffed') == false) then
		tr.Entity:SetNWBool('isHandcuffed', true)

		tr.Entity:SetWalkSpeed(rp.cfg.WalkSpeed / 2.5)
		tr.Entity:SetRunSpeed(rp.cfg.RunSpeed / 2.5)

		tr.Entity.HandcuffedWeapons = {}
		tr.Entity.HandcuffedWeaponAmmo = {}
		tr.Entity.HandcuffedWeaponAmmoType = {}

		local weps = tr.Entity:GetWeapons()

		for i, v in ipairs(weps) do
			tr.Entity.HandcuffedWeapons[i] = {v:GetClass(), v.donate}
			tr.Entity.HandcuffedWeaponAmmo[v:GetPrimaryAmmoType()] = tr.Entity:GetAmmoCount(v:GetPrimaryAmmoType())
		end

		tr.Entity:StripWeapons()
	end
end

function SWEP:SecretSecondaryAttack()
	local tr = self.Owner:GetEyeTraceNoCursor()

	if (not tr.Entity:IsPlayer()) then return end
	if tr.Entity:InVehicle() then tr.Entity:ExitVehicle() end

	if (self:GetOwner():EyePos():Distance(tr.Entity:GetPos()) < 150) and (tr.Entity:GetNWBool('isHandcuffed') == true) then
		tr.Entity:SetNWBool('isHandcuffed', false)

		self:GiveHandcuffWeaponsBack(tr.Entity)
		self:GiveHandcuffWeaponAmmoBack(tr.Entity)

		tr.Entity:SwitchToDefaultWeapon()

		tr.Entity:SetWalkSpeed(rp.cfg.WalkSpeed)
		tr.Entity:SetRunSpeed(rp.cfg.RunSpeed)
	end
end

function SWEP:GiveHandcuffWeaponsBack(pl)
	if not pl.HandcuffedWeapons then return end

	for i, v in ipairs(pl.HandcuffedWeapons) do
		if v[2] == true then
			pl:Give(v[1], true).donate = true
		else
			pl:Give(v[1], true)
		end
	end
end

function SWEP:GiveHandcuffWeaponAmmoBack(pl)
	if not pl.HandcuffedWeaponAmmo then return end

	for k, v in pairs(pl.HandcuffedWeaponAmmo) do
		pl:SetAmmo(v, k)
	end
end