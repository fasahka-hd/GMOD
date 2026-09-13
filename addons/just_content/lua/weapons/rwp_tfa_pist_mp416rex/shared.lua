--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

-- Variables that are used on both client and server
SWEP.Gun = ("rwp_tfa_pist_mp416rex") -- must be the name of your swep but NO CAPITALS!
if (GetConVar(SWEP.Gun.."_allowed")) != nil then
	if not (GetConVar(SWEP.Gun.."_allowed"):GetBool()) then SWEP.Base = "tfa_blacklisted" SWEP.PrintName = SWEP.Gun return end
end
SWEP.Category				= "RWP"
SWEP.Author				= "SMG"
SWEP.Contact				= ""
SWEP.Purpose				= ""
SWEP.Instructions				= ""
SWEP.MuzzleAttachment			= "1" 	-- Should be "1" for CSS models or "muzzle" for hl2 models
SWEP.ShellEjectAttachment			= "2" 	-- Should be "2" for CSS models or "1" for hl2 models
SWEP.PrintName				= "MP-412 REX"		-- Weapon name (Shown on HUD)	
SWEP.Slot				= 1				-- Slot in the weapon selection menu
SWEP.SlotPos				= 22			-- Position in the slot
SWEP.DrawAmmo				= true		-- Should draw the default HL2 ammo counter
SWEP.DrawWeaponInfoBox			= false		-- Should draw the weapon info box
SWEP.BounceWeaponIcon   		= 	false	-- Should the weapon icon bounce?
SWEP.DrawCrosshair			= true		-- set false if you want no crosshair
SWEP.Weight				= 30			-- rank relative ot other weapons. bigger is better
SWEP.AutoSwitchTo			= true		-- Auto switch to if we pick it up
SWEP.AutoSwitchFrom			= true		-- Auto switch from if you pick up a better weapon
SWEP.HoldType 				= "pistol"		-- how others view you carrying the weapon
-- normal melee melee2 fist knife smg ar2 pistol rpg physgun grenade shotgun crossbow slam passive 
-- you're mostly going to use ar2, smg, shotgun or pistol. rpg and crossbow make for good sniper rifles

SWEP.BlowbackEnabled = true --Enable Blowback?
SWEP.BlowbackVector = Vector(0,-1,0) --Vector to move bone <or root> relative to bone <or view> orientation.
SWEP.BlowbackCurrentRoot = 0 --Amount of blowback currently, for root
SWEP.BlowbackCurrent = 0 --Amount of blowback currently, for bones
SWEP.BlowbackBoneMods = nil --Viewmodel bone mods via SWEP Creation Kit
SWEP.Blowback_Only_Iron = true --Only do blowback on ironsights
SWEP.Blowback_PistolMode = false --Do we recover from blowback when empty?
SWEP.Blowback_PistolMode_Disabled = {
	[ACT_VM_RELOAD] = true,
	[ACT_VM_RELOAD_EMPTY] = true,
	[ACT_VM_DRAW_EMPTY] = true,
	[ACT_VM_IDLE_EMPTY] = true,
	[ACT_VM_HOLSTER_EMPTY] = true,
	[ACT_VM_DRYFIRE] = true
}
SWEP.Blowback_Shell_Enabled = true
SWEP.Blowback_Shell_Effect = ""

SWEP.SelectiveFire		= true

SWEP.ViewModelFOV			= 70
SWEP.ViewModelFlip			= false
SWEP.ViewModel				= "models/weapons/v_bf3_mp412rex.mdl"	-- Weapon view model
SWEP.WorldModel				= "models/weapons/w_bf3_mp412rex.mdl"	-- Weapon world model
SWEP.ShowWorldModel			= false
SWEP.Base				= "tfa_gun_base"
SWEP.Spawnable				= true
SWEP.AdminSpawnable			= true
SWEP.FiresUnderwater = false
SWEP.MuzzleFlashEffect = nil

SWEP.Primary.Sound			= Sound("weapons/44magnum/44magnum-1.wav")		-- Script that calls the primary fire sound
SWEP.Primary.RPM			= 120			-- This is in Rounds Per Minute
SWEP.Primary.ClipSize			= 6		-- Size of a clip
SWEP.Primary.DefaultClip		= 0		-- Bullets you start with
SWEP.Primary.KickUp				= 0.45		-- Maximum up recoil (rise)
SWEP.Primary.KickDown			= 0.36		-- Maximum down recoil (skeet)
SWEP.Primary.KickHorizontal		= 0.28		-- Maximum up recoil (stock)
SWEP.Primary.Automatic			= false		-- Automatic = true; Semi Auto = false
SWEP.Primary.Ammo			= "357"			-- pistol, 357, smg1, ar2, buckshot, slam, SniperPenetratedRound, AirboatGun
-- Pistol, buckshot, and slam always ricochet. Use AirboatGun for a light metal peircing shotgun pellets

SWEP.Secondary.IronFOV			= 65		-- How much you 'zoom' in. Less is more! 	

SWEP.data 				= {}				--The starting firemode
SWEP.data.ironsights			= 1

SWEP.AutoDetectMuzzleAttachment = true --For multi-barrel weapons, detect the proper attachment?
SWEP.MoveSpeed = 1 --Multiply the player's movespeed by this.
SWEP.IronSightsMoveSpeed = 0.9 --Multiply the player's movespeed by this when sighting.
SWEP.Primary.NumShots	= 1		-- How many bullets to shoot per trigger pull
SWEP.Primary.Damage		= 35    -- Base damage per bullet
SWEP.Primary.Spread		= .04	-- Define from-the-hip accuracy 1 is terrible, .0001 is exact)
SWEP.Primary.IronAccuracy = .07 -- Ironsight accuracy, should be the same for shotguns

-- Enter iron sight info and bone mod info below

SWEP.IronSightsPos = Vector(-2.35, 0, 0.6)
SWEP.IronSightsAng = Vector(0.5, 0, 0)
SWEP.SightsPos = Vector(-2.35, 0, 0.6)
SWEP.SightsAng = Vector(0.5, 0, 0)
SWEP.RunSightsPos = Vector(0.079, -3.217, -2.491)
SWEP.RunSightsAng = Vector(30.25, -1.407, 0)
SWEP.InspectPos = Vector(4.69, -5.026, -0.201)
SWEP.InspectAng = Vector(0, 44.321, 0)

sound.Add({
	name = 			"Weapon_MP412.Close",
	channel = 		CHAN_USER_BASE+10,
	volume = 		1.0,
	sound = 			"weapons/44magnum/44magnum_chamber_in.wav" 
})

sound.Add({
	name = 			"Weapon_MP412.Open",
	channel = 		CHAN_USER_BASE+10,
	volume = 		1.0,
	sound = 			"weapons/44magnum/44magnum_chamber_out.wav" 
})

sound.Add({
	name = 			"Weapon_MP412.Bulletout",
	channel = 		CHAN_USER_BASE+10,
	volume = 		1.0,
	sound = 			"weapons/44magnum/44magnum_clipout.wav" 
})

sound.Add({
	name = 			"Weapon_MP412.Bulletin",
	channel = 		CHAN_USER_BASE+10,
	volume = 		1.0,
	sound = 			"weapons/44magnum/44magnum_clipin.wav" 
})

sound.Add({
	name = 			"Weapon_MP412.Draw",
	channel = 		CHAN_USER_BASE+10,
	volume = 		1.0,
	sound = 			"weapons/44magnum/44magnum_deploy.wav" 
})

sound.Add({
	name = 			"Weapon_MP412.1",
	channel = 		CHAN_USER_BASE+10,
	volume = 		1.0,
	sound = 			"weapons/44magnum/44magnum-1.wav" 
})

SWEP.WElements = {
	["element_name"] = { type = "Model", model = "models/weapons/w_bf3_mp412rex.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(3.635, 1.557, 1.557), angle = Angle(0, 0, 180), size = Vector(1.014, 1.014, 1.014), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}

--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
