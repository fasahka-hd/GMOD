--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

-- weapon_vape/shared.lua
-- Defines common shared code/defaults for Vape SWEP

-- Original Vape SWEP by Swamp Onions - http://steamcommunity.com/id/swamponions/

SWEP.Author = "NELT"

SWEP.Instructions = "LMB: Rip Fat Clouds(Hold and release)\nReload play sound "

SWEP.PrintName = "HQD Pineapple"

SWEP.IconLetter	= "V"
SWEP.Category = "Other"
SWEP.Slot = 1
SWEP.SlotPos = 0

SWEP.ViewModelFOV = 62 --default


SWEP.BounceWeaponIcon = false

SWEP.ViewModel = "models/c_arms/c_arms_p.mdl"
SWEP.WorldModel = "models/hqd_p/hqd_p.mdl"
SWEP.Spawnable = true
SWEP.AdminOnly = false
SWEP.UseHads = true
SWEP.ViewModelFOV = 54

SWEP.Primary.Clipsize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "none"

SWEP.Secondary.Clipsize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"

SWEP.DrawAmmo = false
SWEP.HoldType = "slam"

SWEP.VapeID = 1

function SWEP:PostDrawViewModel( vm, ply, weapon )

	if ( weapon.UseHands || !weapon:IsScripted() ) then

		local hands = LocalPlayer():GetHands()
		if ( IsValid( hands ) ) then hands:DrawModel() end

	end

end

function SWEP:Deploy()
	vm = self.Owner:GetViewModel()
	self:SetHoldType("slam")
	vm:SetSequence("take")
	if self.Owner:KeyReleased(IN_ATTACK) then
		vm:SetSequence("out")
	end
	return true
end

function SWEP:PrimaryAttack()
	if SERVER then
		VapeUpdate(self.Owner, self.VapeID)
	end
	vm = self.Owner:GetViewModel()
	if self.Owner:KeyDown(IN_ATTACK) then
		vm:SetSequence("in")
	end
	self.Weapon:SetNextPrimaryFire(CurTime() + 0.1)
end

function SWEP:Think()
	vm = self.Owner:GetViewModel()
	if self.Owner:KeyReleased(IN_ATTACK) then
		vm:SetSequence("out")
	end
end

function SWEP:Holster()
	if SERVER and IsValid(self.Owner) then
		ReleaseVape(self.Owner)
	end
	return true
end

SWEP.OnDrop = SWEP.Holster
SWEP.OnRemove = SWEP.Holster

--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
