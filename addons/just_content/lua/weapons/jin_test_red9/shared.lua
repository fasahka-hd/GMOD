--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

-------------------------------------------------------------------
--Misc-------------------------------------------------------------
-------------------------------------------------------------------

SWEP.Gun					= ("jin_test_red9")
SWEP.Base				= "tfa_gun_base"
SWEP.Category				= "WW11"
SWEP.Author				= "Jin"
SWEP.Spawnable				= true
SWEP.AdminSpawnable			= true
SWEP.Manufacturer = "Mauser"
SWEP.PrintName				= "Mauser C96"
SWEP.Slot				= 2
SWEP.SlotPos				= 5
SWEP.Type = "Pistol"

-------------------------------------------------------------------
--Sounds-----------------------------------------------------------
-------------------------------------------------------------------

SWEP.Primary.Sound 			= Sound("weapons/red9/fire.wav")

-------------------------------------------------------------------
--Damage-----------------------------------------------------------
-------------------------------------------------------------------

SWEP.Primary.PenetrationMultiplier = 1.5
SWEP.Primary.Damage		= 22
SWEP.Primary.NumShots	= 1
SWEP.Primary.Automatic			= false
SWEP.Primary.RPM				= 355
SWEP.SelectiveFire		= false
SWEP.DisableBurstFire	= false
SWEP.OnlyBurstFire		= false
SWEP.DefaultFireMode 	= ""
SWEP.Primary.ClipSize			= 14
SWEP.Primary.DefaultClip			= 21
SWEP.Primary.Ammo			= "pistol"
SWEP.DisableChambering = false

-------------------------------------------------------------------
--Accuracy And Recoil----------------------------------------------
-------------------------------------------------------------------

SWEP.Primary.KickUp			= 0.9
SWEP.Primary.KickDown			= 0.33
SWEP.Primary.KickHorizontal			= 0.34
SWEP.Primary.StaticRecoilFactor = 0.1
SWEP.Primary.Spread		= .035
SWEP.Primary.IronAccuracy = .01
SWEP.WeaponLength = 40
SWEP.MoveSpeed = 1

-------------------------------------------------------------------
--Viewmodel--------------------------------------------------------
-------------------------------------------------------------------

SWEP.ViewModel			= "models/weapons/v_pist_red9.mdl"
SWEP.ViewModelFOV			= 70
SWEP.ViewModelFlip			= true

-------------------------------------------------------------------
--World Model------------------------------------------------------
-------------------------------------------------------------------

SWEP.WorldModel			= "models/weapons/w_pist_red9.mdl"
SWEP.HoldType 				= "pistol"

-------------------------------------------------------------------
--Angle Things----------------------------------------------------
-------------------------------------------------------------------

SWEP.data 				= {}
SWEP.data.ironsights			= 1
SWEP.Secondary.IronFOV			= 70
SWEP.RunSightsPos = Vector(0.804, -7.84, -2.814)
SWEP.RunSightsAng = Vector(38.693, -2.814, 2.813)
SWEP.IronSightsPos = Vector(3.799, 0, 2.039)
SWEP.IronSightsAng = Vector(0, 0, 0)
SWEP.InspectPos = Vector(-2.618, -10.231, 0.403)
SWEP.InspectAng = Vector(30.03, -60.804, 0.663)

-------------------------------------------------------------------
--Shell and Muzzle-------------------------------------------------
-------------------------------------------------------------------

SWEP.MuzzleAttachment			= "1"
SWEP.ShellAttachment			= "2"
SWEP.LuaShellEject = true
SWEP.LuaShellEjectDelay = 0.05
SWEP.LuaShellEffect = nil

--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
