--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

if ( SERVER ) then
	AddCSLuaFile( "pudgehook.lua" )
	SWEP.HoldType = "melee"
end

if ( CLIENT ) then
	SWEP.PrintName = "Pudge's Hook"
	SWEP.Author = "Goldermor"
	SWEP.Contact = ""
	SWEP.Purpose = "Fresh meat"
	SWEP.Instructions = "More Fresh meat"
	SWEP.Slot = 0
	SWEP.SlotPos = 1
	SWEP.DrawAmmo = false					 

end

function SWEP:Initialize()
	self:SetHoldType( "melee" )			
end

SWEP.Category = "Dota 2"

SWEP.Spawnable= true
SWEP.AdminSpawnable= true
SWEP.AdminOnly = false

SWEP.ViewModelFOV = 45
SWEP.ViewModel = "models/weapons/c_pudge_hook.mdl" 
SWEP.WorldModel = "models/weapons/w_pudge_hook.mdl"
SWEP.ViewModelFlip = false

SWEP.AutoSwitchTo = false
SWEP.AutoSwitchFrom = false

SWEP.UseHands = true

SWEP.HoldType = "melee" 

SWEP.FiresUnderwater = true

SWEP.DrawCrosshair = true

SWEP.DrawAmmo = false

SWEP.Base = "weapon_base"

SWEP.MissSound = Sound( "Weapon_Crowbar.Single" )
SWEP.WallSound = Sound( "Weapon_Crowbar.Melee_Hit" )

SWEP.Primary.Damage = 50
SWEP.Primary.ClipSize = -1 
SWEP.Primary.Delay = 0.7
SWEP.Primary.DefaultClip = 1 
SWEP.Primary.Automatic = true 
SWEP.Primary.Ammo = "none" 

SWEP.Secondary.ClipSize = -1 
SWEP.Secondary.DefaultClip = -1 
SWEP.Secondary.Damage = 0 
SWEP.Secondary.Automatic = false 	 
SWEP.Secondary.Ammo = "none" 

function SWEP:Initialize() 
util.PrecacheSound(self.MissSound) 
util.PrecacheSound(self.WallSound) 
        self:SetWeaponHoldType( "melee" )
end 

function SWEP:PrimaryAttack()

	local tr = {}
	tr.start = self.Owner:GetShootPos()
	tr.endpos = self.Owner:GetShootPos() + ( self.Owner:GetAimVector() * 100 )
	tr.filter = self.Owner
	tr.mask = MASK_SHOT
	local trace = util.TraceLine( tr )

	self.Weapon:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
	self.Owner:SetAnimation( PLAYER_ATTACK1 )

	if ( trace.Hit ) then

		if trace.Entity:IsPlayer() or string.find(trace.Entity:GetClass(),"npc") or string.find(trace.Entity:GetClass(),"prop_ragdoll") then
			self.Weapon:SendWeaponAnim(ACT_VM_HITCENTER)
			bullet = {}
			bullet.Num    = 1
			bullet.Src    = self.Owner:GetShootPos()
			bullet.Dir    = self.Owner:GetAimVector()
			bullet.Spread = Vector(0, 0, 0)
			bullet.Tracer = 0
			bullet.Force  = 1
			bullet.Damage = self.Primary.Damage
			self.Owner:FireBullets(bullet) 
		else
			self.Weapon:SendWeaponAnim(ACT_VM_HITCENTER)
			bullet = {}
			bullet.Num    = 1
			bullet.Src    = self.Owner:GetShootPos()
			bullet.Dir    = self.Owner:GetAimVector()
			bullet.Spread = Vector(0, 0, 0)
			bullet.Tracer = 0
			bullet.Force  = 1
			bullet.Damage = self.Primary.Damage
			self.Owner:FireBullets(bullet) 
			self.Weapon:EmitSound( self.WallSound )		
		end
	else
		self.Weapon:EmitSound(self.MissSound) 
		self.Weapon:SendWeaponAnim(ACT_VM_MISSCENTER) 
	end
	end
	
function SWEP:SecondaryAttack()
end

function SWEP:Reload()
end



--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
