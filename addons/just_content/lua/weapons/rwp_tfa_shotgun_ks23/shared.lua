--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

-- Variables that are used on both client and server
SWEP.Gun = ("rwp_weapon_shotgun_ks23") -- must be the name of your swep but NO CAPITALS!
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
SWEP.PrintName				= "KS-23"		-- Weapon name (Shown on HUD)	
SWEP.Slot				= 3				-- Slot in the weapon selection menu
SWEP.SlotPos				= 24			-- Position in the slot
SWEP.DrawAmmo				= true		-- Should draw the default HL2 ammo counter
SWEP.DrawWeaponInfoBox			= false		-- Should draw the weapon info box
SWEP.BounceWeaponIcon   		= 	false	-- Should the weapon icon bounce?
SWEP.DrawCrosshair			= true		-- set false if you want no crosshair
SWEP.Weight				= 30			-- rank relative ot other weapons. bigger is better
SWEP.AutoSwitchTo			= true		-- Auto switch to if we pick it up
SWEP.AutoSwitchFrom			= true		-- Auto switch from if you pick up a better weapon
SWEP.HoldType 				= "shotgun"	-- how others view you carrying the weapon
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

SWEP.ViewModelFOV			= 75
SWEP.ViewModelFlip			= false
SWEP.ViewModel				= "models/weapons/v_bo_ks23.mdl"	-- Weapon view model
SWEP.WorldModel				= "models/weapons/w_bo_ks23.mdl"	-- Weapon world model
SWEP.Base 				= "tfa_shotty_base"
SWEP.ShowWorldModel			= false
SWEP.Spawnable				= true
SWEP.AdminSpawnable			= true

SWEP.Primary.Sound			= Sound("Weapons/tact870/m3-1.wav")		-- script that calls the primary fire sound
SWEP.Primary.RPM				= 75		-- This is in Rounds Per Minute
SWEP.Primary.ClipSize			= 4			-- Size of a clip
SWEP.Primary.DefaultClip		= 0	-- Default number of bullets in a clip
SWEP.Primary.KickUp				= 0.86			-- Maximum up recoil (rise)
SWEP.Primary.KickDown			= 0.55		-- Maximum down recoil (skeet)
SWEP.Primary.KickHorizontal		= 0.5	-- Maximum up recoil (stock)
SWEP.Primary.Automatic			= false		-- Automatic/Semi Auto
SWEP.Primary.Ammo			= "buckshot"	-- pistol, 357, smg1, ar2, buckshot, slam, SniperPenetratedRound, AirboatGun
-- Pistol, buckshot, and slam always ricochet. Use AirboatGun for a light metal peircing shotgun pellets

SWEP.Secondary.IronFOV			= 80		-- How much you 'zoom' in. Less is more! 

SWEP.data 				= {}				--The starting firemode
SWEP.data.ironsights			= 1

SWEP.ShellTime			= .45
SWEP.AutoDetectMuzzleAttachment = true --For multi-barrel weapons, detect the proper attachment?
SWEP.MoveSpeed = 1 --Multiply the player's movespeed by this.
SWEP.IronSightsMoveSpeed = 0.8 --Multiply the player's movespeed by this when sighting.
SWEP.Primary.NumShots	= 1		-- How many bullets to shoot per trigger pull, AKA pellets
SWEP.Primary.Damage		= 35	-- Base damage per bullet
SWEP.Primary.Spread		= .065	-- Define from-the-hip accuracy 1 is terrible, .0001 is exact)
SWEP.Primary.IronAccuracy = .01	-- Ironsight accuracy, should be the same for shotguns
-- Because irons don't magically give you less pellet spread!

-- Enter iron sight info and bone mod info below

SWEP.IronSightsPos = Vector(-2.01, -1.609, 1.2)
SWEP.IronSightsAng = Vector(0, -0.101, 0)
SWEP.SightsPos = Vector(-2.01, -1.609, 1.2)
SWEP.SightsAng = Vector(0, -0.101, 0)
SWEP.RunSightsPos = Vector(2.72, 0, -0.12)
SWEP.RunSightsAng = Vector(-9.849, 26.733, 0)
SWEP.InspectPos = Vector(4.38, -2.211, 0.079)
SWEP.InspectAng = Vector(-2.814, 48.542, 0)

sound.Add({
	name = 			"ks23.Single",			// <-- Sound Name That gets called for
	channel = 		CHAN_USER_BASE +10,
	volume = 		1.0,
	sound = 			"weapons/ks23/fire.wav"	// <-- Sound Path
})

sound.Add({
	name = 			"ks23.deploy",			
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/ks23/deploy.wav"	
})

sound.Add({
	name = 			"ks23.pump",			
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/ks23/pump.wav"	
})

sound.Add({
	name = 			"ks23.cloth",			
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/ks23/cloth.wav"	
})

sound.Add({
	name = 			"ks23.insert",			
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/ks23/insert.wav"	
})

SWEP.WElements = {
	["element_name"] = { type = "Model", model = "models/weapons/w_bo_ks23.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(3.635, 1.557, 2.596), angle = Angle(-15.195, 0, 180), size = Vector(1.014, 1.014, 1.014), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}


--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
