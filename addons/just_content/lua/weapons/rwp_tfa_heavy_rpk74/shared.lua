--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

-- Variables that are used on both client and server
SWEP.Gun = ("rwp_weapon_heavy_rpk74") -- must be the name of your swep but NO CAPITALS!
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
SWEP.PrintName				= "RPK-74"		-- Weapon name (Shown on HUD)	
SWEP.Slot				= 3				-- Slot in the weapon selection menu
SWEP.SlotPos				= 21			-- Position in the slot
SWEP.DrawAmmo				= true		-- Should draw the default HL2 ammo counter
SWEP.DrawWeaponInfoBox			= false		-- Should draw the weapon info box
SWEP.BounceWeaponIcon   		= 	false	-- Should the weapon icon bounce?
SWEP.DrawCrosshair			= true		-- set false if you want no crosshair
SWEP.Weight				= 30			-- rank relative ot other weapons. bigger is better
SWEP.AutoSwitchTo			= true		-- Auto switch to if we pick it up
SWEP.AutoSwitchFrom			= true		-- Auto switch from if you pick up a better weapon
SWEP.HoldType 				= "ar2"		-- how others view you carrying the weapon
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

SWEP.CanBeSilenced		= false
SWEP.ViewModelFOV			= 70
SWEP.ViewModelFlip			= false
SWEP.ViewModel			= "models/weapons/v_mach_4249para.mdl"
SWEP.WorldModel			= "models/weapons/w_rif_ak47.mdl"
SWEP.Base				= "tfa_gun_base"
SWEP.Spawnable				= true
SWEP.AdminSpawnable			= true
SWEP.FiresUnderwater = false
SWEP.ShowWorldModel  = false

SWEP.Primary.Sound			= Sound("weapons/rpk/rpk-1.wav")		-- Script that calls the primary fire sound
SWEP.Primary.RPM			= 600			-- This is in Rounds Per Minute
SWEP.Primary.ClipSize			= 45		-- Size of a clip
SWEP.Primary.DefaultClip		= 0		    -- Bullets you start with
SWEP.Primary.KickUp				= 0.3		-- Maximum up recoil (rise)
SWEP.Primary.KickDown			= 0.3		-- Maximum down recoil (skeet)
SWEP.Primary.KickHorizontal		= 0.3		-- Maximum up recoil (stock)
SWEP.Primary.Automatic			= true		-- Automatic = true; Semi Auto = false
SWEP.Primary.Ammo			= "ar2"			-- pistol, 357, smg1, ar2, buckshot, slam, SniperPenetratedRound, AirboatGun
-- Pistol, buckshot, and slam always ricochet. Use AirboatGun for a light metal peircing shotgun pellets

SWEP.Secondary.IronFOV			= 65		-- How much you 'zoom' in. Less is more! 	

SWEP.data 				= {}				--The starting firemode
SWEP.data.ironsights			= 1
SWEP.FireModes = {
	"Auto",
	"Single"
}

SWEP.AutoDetectMuzzleAttachment = true --For multi-barrel weapons, detect the proper attachment?
SWEP.MoveSpeed = 0.9 --Multiply the player's movespeed by this.
SWEP.IronSightsMoveSpeed = 0.8 --Multiply the player's movespeed by this when sighting.
SWEP.Primary.NumShots	= 1		-- How many bullets to shoot per trigger pull
SWEP.Primary.Damage		= 28	-- Base damage per bullet
SWEP.Primary.Spread		= .025	-- Define from-the-hip accuracy 1 is terrible, .0001 is exact)
SWEP.Primary.IronAccuracy = .01 -- Ironsight accuracy, should be the same for shotguns

SWEP.MoveSpeed =  0.8          --Multiply the player's movespeed by this.
SWEP.IronSightsMoveSpeed = 0.5 --Multiply the player's movespeed by this when sighting.

-- Enter iron sight info and bone mod info below
SWEP.IronSightsPos = Vector(-1.852, 0, 0.5)
SWEP.IronSightsAng = Vector(2.099, 0.079, 0)
SWEP.SightsPos = Vector(-1.852, 0, 0.5)
SWEP.SightsAng = Vector(2.099, 0.079, 0)
SWEP.RunSightsPos = Vector(2, 0, 0.119)
SWEP.RunSightsAng = Vector(-9.849, 18.291, 0)
SWEP.InspectPos = Vector(4.239, -2.613, 0.959)
SWEP.InspectAng = Vector(-7.035, 40.101, 0)

sound.Add({
	name = 			"Weapon_RP4.Single",			// <-- Sound Name That gets called for
	channel = 		CHAN_USER_BASE +10,
	volume = 		1.0,
	sound = 			"weapons/rpk/rpk-1.wav"	// <-- Sound Path
})

sound.Add({
	name = 			"Weapon_RP4.reload",			
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/rpk/reload.wav"	
})

sound.Add({
	name = 			"Weapon_RP4.Clipout",			
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/rpk/out.wav"	
})

sound.Add({
	name = 			"Weapon_RP4.Clipin",			
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/rpk/in.wav"	
})

sound.Add({
	name = 			"Weapon_RP4.Back",			
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/rpk/pull.wav"	
})

sound.Add({
	name = 			"Weapon_RP4.draw",			
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/rpk/draw.wav"	
})

SWEP.WElements = {
["models/weapons/w_cst_ak47.mdl"] = { type = "Model", model = "models/weapons/w_mach_ruchpulk.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(3, 1.557, 0.518), angle = Angle(-10.52, 1.169, 180), size = Vector(1.014, 1.014, 1.014), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}

if GetConVar("sv_tfa_default_clip") == nil then
	print("sv_tfa_default_clip is missing!  You might've hit the lua limit.  Contact the SWEP author(s).")
else
	if GetConVar("sv_tfa_default_clip"):GetInt() != -1 then
		SWEP.Primary.DefaultClip = SWEP.Primary.ClipSize * GetConVar("sv_tfa_default_clip"):GetInt()
	end
end

if GetConVar("sv_tfa_unique_slots") != nil then
	if not (GetConVar("sv_tfa_unique_slots"):GetBool()) then 
		SWEP.SlotPos = 2
	end
end

--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
