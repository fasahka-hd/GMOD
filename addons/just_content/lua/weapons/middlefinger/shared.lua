--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

if CLIENT then
SWEP.DrawWeaponInfoBox	= false
SWEP.BounceWeaponIcon = false 
end
SWEP.Base = "leafy_base"

SWEP.AdminSpawnable = true

SWEP.AutoSwitchTo = false
SWEP.Slot = 4
SWEP.PrintName = "Middle-Finger"
SWEP.Author = "Leafdroid"
SWEP.Spawnable = true
SWEP.AutoSwitchFrom = false
SWEP.Weight = 5
SWEP.DrawCrosshair = false
SWEP.CustomCrosshair = false
SWEP.CrossColor = Color( 0, 255, 0, 150 )
SWEP.Category = "Handies"
SWEP.SlotPos = 2
SWEP.DrawAmmo = false
SWEP.Instructions = "Hold left click to point your middle finger and right click to shout gethellout.wav!"
SWEP.Contact = "Leafdroids@gmail.com"
SWEP.Purpose = "Tell someone to fuck off"
SWEP.HoldType = "normal"
SWEP.ViewModelFOV = 113
SWEP.ViewModelFlip = false
SWEP.ViewModel = "models/weapons/c_smg1.mdl"
SWEP.WorldModel = "models/weapons/c_pistol.mdl"
SWEP.UseHands = true
SWEP.ShowViewModel = false
SWEP.ShowWorldModel = false
SWEP.LaserSight = 0
SWEP.Dissolve = 1

SWEP.IronsightTime = 0.1
SWEP.DisableMuzzle = 1
SWEP.ViewModelBoneMods = {
	["ValveBiped.Bip01_R_Finger1"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(-7.778, -61.112, -10) },
	["ValveBiped.Bip01_R_Finger21"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 85.555, 0) },
	["ValveBiped.Bip01_R_Finger11"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, -32.223, 0) },
	["ValveBiped.base"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
	["ValveBiped.Bip01_R_Finger4"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, -32.223, 0) },
	["ValveBiped.Bip01_R_UpperArm"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(3.332, -25.556, -10) },
	["ValveBiped.Bip01_R_Forearm"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(5.556, -1.111, 87.777) },
	["ValveBiped.Bip01_L_UpperArm"] = { scale = Vector(1, 1, 1), pos = Vector(-30, -30, -30), angle = Angle(0, 0, 0) },
	["ValveBiped.Bip01_R_Finger22"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 61.111, 0) },
	["ValveBiped.Bip01_R_Finger2"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 10, 0) },
	["ValveBiped.Bip01"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
	["ValveBiped.Bip01_R_Finger3"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, -14.445, 0) },
	["ValveBiped.Bip01_R_Hand"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(23.333, -25.556, -21.112) },
	["ValveBiped.Bip01_R_Finger0"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, -18.889, -18.889) }
}

SWEP.IronSightsPos = Vector(-0, -7, 1.629)
SWEP.IronSightsAng = Vector(-1, 0, 0)

//SWEP.PrimaryReloadSound = Sound("Weapon_SMG1.Reload")
SWEP.PrimarySound = Sound("weapons/ar1/ar1_dist2.wav")

SWEP.Primary.Damage = 20
SWEP.Primary.TakeAmmo = 1
SWEP.Primary.ClipSize = -1
SWEP.Primary.Ammo = "ar2"
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Spread = 15
SWEP.Primary.Cone = 0.3
SWEP.IronCone = 0.1
SWEP.DefaultCone = 0.3
SWEP.Primary.NumberofShots = 1
SWEP.Primary.Automatic = true
SWEP.Primary.Recoil = 1.2
SWEP.Primary.Delay = 0.1
SWEP.Primary.Force = 3
SWEP.Tracer = 10
SWEP.CustomTracerName = "blu_pulse_tracer"
SWEP.ShotEffect = "blupulse_light"

SWEP.IronFOV = 70

--if CLIENT then

function SWEP:DoBones()
local FT = FrameTime()

local ply = self.Owner
local ang1 = ply:GetNWFloat("ang1")
local ang2 = ply:GetNWFloat("ang2")

	if IsValid(ply) then
		self.ViewModelBoneMods["ValveBiped.Bip01_R_UpperArm"].angle = Angle(15, -25*ang1, 10)
		self.ViewModelBoneMods["ValveBiped.Bip01_R_UpperArm"].pos = Vector(0 , -20 +(15*ang1), 4)
	end
end

--end

function SWEP:SecondThink()

local ply = self.Owner
local FT = FrameTime()

local ang1 = ply:GetNWFloat("ang1")
local ang2 = ply:GetNWFloat("ang2")

if self.Owner:KeyDown(IN_ATTACK) then
ply:SetNWFloat("ang1", Lerp(FT*9, ang1, 1) )
ply:SetNWFloat("ang2", Lerp(FT*9, ang1, 45) )
else
ply:SetNWFloat("ang1", Lerp(FT*9, ang1, 0) )
ply:SetNWFloat("ang2", Lerp(FT*9, ang2, 0) )
end

	if IsValid(ply) and SERVER then
		local bone = ply:LookupBone("ValveBiped.Bip01_R_UpperArm")
		if bone then 
			ply:ManipulateBoneAngles( bone, Angle(15*ang1,-55*ang1,-0*ang1) )
		end
	
		local bone = ply:LookupBone("ValveBiped.Bip01_R_Forearm")
		if bone then 
			ply:ManipulateBoneAngles( bone, Angle(0*ang1,-55*ang1,-0*ang1) )
		end
		
		local bone = ply:LookupBone("ValveBiped.Bip01_R_Hand")
		if bone then 
			ply:ManipulateBoneAngles( bone, Angle(20*ang1,20*ang1,90*ang1) )
		end
		
		local bone = ply:LookupBone("ValveBiped.Bip01_R_Finger1")
		if bone then 
			ply:ManipulateBoneAngles( bone, Angle(20*ang1,-40*ang1,-0*ang1) )
		end
		
		local bone = ply:LookupBone("ValveBiped.Bip01_R_Finger3")
		if bone then 
			ply:ManipulateBoneAngles( bone, Angle(0*ang1,-30*ang1,0*ang1) )
		end
		local bone = ply:LookupBone("ValveBiped.Bip01_R_Finger4")
		if bone then 
			ply:ManipulateBoneAngles( bone, Angle(-10*ang1,-40*ang1,0*ang1) )
		end
		local bone = ply:LookupBone("ValveBiped.Bip01_R_Finger11")
		if bone then 
			ply:ManipulateBoneAngles( bone, Angle(-0*ang1,-70*ang1,-0*ang1) )
		end
		
		local bone = ply:LookupBone("ValveBiped.Bip01_R_Finger31")
		if bone then 
			ply:ManipulateBoneAngles( bone, Angle(0*ang1,-70*ang1,0*ang1) )
		end
		local bone = ply:LookupBone("ValveBiped.Bip01_R_Finger41")
		if bone then 
			ply:ManipulateBoneAngles( bone, Angle(0*ang1,-70*ang1,0*ang1) )
		end
		local bone = ply:LookupBone("ValveBiped.Bip01_R_Finger12")
		if bone then 
			ply:ManipulateBoneAngles( bone, Angle(-0*ang1,-70*ang1,-0*ang1) )
		end
		
		local bone = ply:LookupBone("ValveBiped.Bip01_R_Finger32")
		if bone then 
			ply:ManipulateBoneAngles( bone, Angle(0*ang1,-70*ang1,0*ang1) )
		end
		local bone = ply:LookupBone("ValveBiped.Bip01_R_Finger42")
		if bone then 
			ply:ManipulateBoneAngles( bone, Angle(0*ang1,-70*ang1,0*ang1) )
		end
	end

end



function SWEP:Holster()
local ply = self.Owner
	if IsValid(ply) then
		
	if SERVER then
		self.ViewModelBoneMods["ValveBiped.Bip01_R_UpperArm"].angle = Angle(0, 0, 0)
		self.ViewModelBoneMods["ValveBiped.Bip01_L_UpperArm"].angle = Angle(0, 0, 0)

		local bone = ply:LookupBone("ValveBiped.Bip01_R_Hand")
		if bone then 
			ply:ManipulateBoneAngles( bone, Angle(0,0,0) )
		local bone = ply:LookupBone("ValveBiped.Bip01_R_UpperArm")
		end
		if bone then 
			ply:ManipulateBoneAngles( bone, Angle(0,0,0) )
		end
		local bone = ply:LookupBone("ValveBiped.Bip01_R_Forearm")
		if bone then 
			ply:ManipulateBoneAngles( bone, Angle(0,0,0) )
		end
	end
	end
	
	if CLIENT and IsValid(self.Owner) and self.Owner:IsPlayer() then
		local vm = self.Owner:GetViewModel()
		if IsValid(vm) then
			self:ResetBonePositions(vm)
		end
	end
	
return true
end


function SWEP:PrimaryAttack()

end

function SWEP:Reload()

end

SWEP.NxtSec = 0

function SWEP:SecondaryAttack()
//No ironsights, mothefucker, deal with it!
if self.NxtSec < CurTime() then
self.Weapon:EmitSound("vo/npc/male01/gethellout.wav")
self.NxtSec = CurTime() + 2.3
end
end

function SWEP:QuadsHere()
end

SWEP.VElements = {
}
SWEP.WElements = {
}

--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
