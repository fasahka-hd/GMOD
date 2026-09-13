--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher

SWEP.PrintName			= "Toy Pig" -- This will be shown in the spawn menu, and in the weapon selection menu
SWEP.Author			= "JarateIsCool" -- These two options will be shown when you have the weapon highlighted in the weapon selection menu
SWEP.Purpose		= "A pig that sounds like a real one! Left click makes a pig sound. Right Click does an different pig sound."
SWEP.Spawnable = true
SWEP.AdminOnly = false
SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= -1
SWEP.Primary.Automatic		= false 
SWEP.Primary.Ammo		= "none"
SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false 
SWEP.Secondary.Ammo		= "none"
SWEP.Weight			= 5
SWEP.AutoSwitchTo		= false
SWEP.AutoSwitchFrom		= false
SWEP.Slot				= 4
SWEP.SlotPos			= 1
SWEP.DrawAmmo			= false 
SWEP.DrawCrosshair		= true
SWEP.UseHands           = true   
SWEP.ViewModel			= "models/weapons/c_mspig.mdl"
SWEP.WorldModel			= "models/weapons/w_mspig.mdl"
SWEP.ShootSound = Sound("weapons/mspig/oink1.wav")
SWEP.ShootSound2 = Sound("weapons/mspig/oink2.wav")

function SWEP:PrimaryAttack()
    self:EmitSound(self.ShootSound)
    local owner = self:GetOwner()
    local viewmodel = owner:GetViewModel()
    viewmodel:SendViewModelMatchingSequence(viewmodel:LookupSequence("squeeze"))
    self:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
	self.Owner:SetAnimation(PLAYER_ATTACK1)
    self:SetNextPrimaryFire( CurTime() + 0.1 )
end

function SWEP:SecondaryAttack()
    self:EmitSound(self.ShootSound2)
    local owner = self:GetOwner()
    local viewmodel = owner:GetViewModel()
    viewmodel:SendViewModelMatchingSequence(viewmodel:LookupSequence("squeeze"))
    self:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
	self.Owner:SetAnimation(PLAYER_ATTACK1)
    self:SetNextSecondaryFire( CurTime() + 0.1 )
end

--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher
