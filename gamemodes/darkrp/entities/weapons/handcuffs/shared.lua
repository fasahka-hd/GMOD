--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

SWEP.Contact = ""
--SWEP.Purpose = "Used around a suspect's wrist to detain/arrest."
--SWEP.Instructions = "Left click to detain, right click to release."
SWEP.Category = "RP"
SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.DrawAmmo = false
SWEP.Base = "weapon_base"

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "none"

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"

SWEP.ViewModelFOV = 90
SWEP.ViewModel = "models/sterling/c_enhanced_handcuffs.mdl"
SWEP.WorldModel = "models/sterling/w_enhanced_handcuffs.mdl"
util.PrecacheModel( "models/sterling/c_enhanced_handcuffs.mdl" )
util.PrecacheModel( "models/sterling/w_enhanced_handcuffs.mdl" )


SWEP.ViewModelFlip = false
SWEP.AutoSwitchTo = false
SWEP.AutoSwitchFrom = false

SWEP.UseHands = true
SWEP.HoldType = "slam"
SWEP.FiresUnderwater = true

SWEP.DrawCrosshair = false

function SWEP:Initialize()

	self:SetHoldType(self.HoldType)
end


function SWEP:PrimaryAttack()
if SERVER then return self:SecretPrimaryAttack() end
	if !IsFirstTimePredicted then return end
	if self:GetOwner():GetEyeTraceNoCursor().Entity:IsPlayer() and self:GetOwner():GetEyeTraceNoCursor().Entity:GetNWBool("isHandcuffed") == false  then
		self:EmitSound(Sound("handcuff_lock.wav"))
	end

end

function SWEP:SecondaryAttack()
	self:SetNextSecondaryFire(CurTime() + 1.5)
	if SERVER then return self:SecretSecondaryAttack() end
	if self:GetOwner():GetEyeTraceNoCursor().Entity:IsPlayer() and self:GetOwner():GetEyeTraceNoCursor().Entity:GetNWBool("isHandcuffed") == false  then
		self:EmitSound(Sound("handcuff_lock.wav"))
	end

end

--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
