--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

// MISC
SWEP.Base					= "tfa_ins2_nade_base"
SWEP.Category				= "TFA Born To Kill: Vietnam"
SWEP.Author					= "The Master MLG"
SWEP.Manufacturer = "" --Gun Manufactrer (e.g. Hoeckler and Koch )
SWEP.Contact				= ""
SWEP.PrintName				= "RGD-5"
SWEP.Purpose				= "Make the motherland great again, blast them."
SWEP.Type				    = "Soviet Fragmentation Hand Grenade"
SWEP.Slot					= 4
SWEP.SlotPos				= 99
SWEP.DrawAmmo				= true
SWEP.DrawCrosshair			= false
SWEP.Weight					= 2
SWEP.AutoSwitchTo				= true
SWEP.AutoSwitchFrom			= true
SWEP.HoldType 				= "grenade"
SWEP.Spawnable				= true
SWEP.AdminSpawnable			= true
SWEP.Sprint_Mode 				= TFA.Enum.LOCOMOTION_ANI
SWEP.SelectiveFire = false

// VIEWMODEL
SWEP.ViewModelFOV				= 65
SWEP.ViewModelFlip			= false
SWEP.ViewModel				= "models/weapons/v_nam_rgd5.mdl"

// WORLDMODEL
SWEP.WorldModel				= "models/weapons/w_nam_rgd5.mdl"

// NADE STUFF
SWEP.Primary.RPM				= 30
SWEP.Primary.ClipSize			= 1
SWEP.Primary.DefaultClip		= 3
SWEP.Primary.Automatic			= false
SWEP.Primary.Ammo				= "grenade"
SWEP.Primary.Round 			= ("tfa_nam_rgd5_entities")
SWEP.Velocity = 1500
SWEP.Velocity_Underhand = 780
SWEP.Delay = 0.23
SWEP.DelayCooked = 0.24
SWEP.Delay_Underhand = 0.245
SWEP.CookStartDelay = 1
SWEP.UnderhandEnabled = true
SWEP.CookingEnabled = true
SWEP.CookTimer = 5

SWEP.Offset = {
	Pos = {
		Up = -2.5,
		Right = 1.4,
		Forward = 2.595
	},
	Ang = {
		Up = -1.043,
		Right = 0,
		Forward = 180,
	},
	Scale = 1
} --Procedural world model animation, defaulted for CS:S purposes.

SWEP.WElements = {
	["ref"] = { type = "Model", model = SWEP.WorldModel, bone = "oof", rel = "", pos = Vector(0, 0, 0), angle = Angle(0, 0, 0), size = Vector(0.9, 0.9, 0.9), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {}, bonemerge = true, active = false },
}

SWEP.SprintAnimation = {
	["loop"] = {
		["type"] = TFA.Enum.ANIMATION_SEQ,
		["value"] = "base_sprint",
		["is_idle"] = true
	}
}

SWEP.InspectPos 				= Vector(4, -3.619, -0.787)
SWEP.InspectAng 				= Vector(22.386, 34.417, 5)


--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
