--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

-- Variables that are used on both client and server
SWEP.Gun = ("rwp_weapon_smg_pp1901") -- must be the name of your swep but NO CAPITALS!
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
SWEP.PrintName				= "PP19-01 Vityaz"		-- Weapon name (Shown on HUD)	
SWEP.Slot				= 2				-- Slot in the weapon selection menu
SWEP.SlotPos				= 22			-- Position in the slot
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

SWEP.ViewModelFOV			= 60
SWEP.ViewModelFlip			= false
SWEP.ViewModel				= "models/weapons/v_smg_ppv.mdl"	-- Weapon view model
SWEP.WorldModel				= "models/weapons/w_smg_ppv.mdl"	-- Weapon world model
SWEP.ShowWorldModel			= false
SWEP.Base				= "tfa_gun_base"
SWEP.Spawnable				= true
SWEP.AdminSpawnable			= true
SWEP.FiresUnderwater = false

SWEP.Primary.Sound = Sound ("weapons/pp19vityaz/mp5-1.wav")-- Script that calls the primary fire sound
SWEP.Primary.RPM			= 700			-- This is in Rounds Per Minute
SWEP.Primary.ClipSize			= 30		-- Size of a clip
SWEP.Primary.DefaultClip		= 0		-- Bullets you start with
SWEP.Primary.KickUp				= 0.28		-- Maximum up recoil (rise)
SWEP.Primary.KickDown			= 0.2		-- Maximum down recoil (skeet)
SWEP.Primary.KickHorizontal		= 0.3		-- Maximum up recoil (stock)
SWEP.Primary.Automatic			= true		-- Automatic = true; Semi Auto = false
SWEP.Primary.Ammo			= "smg1"			-- pistol, 357, smg1, ar2, buckshot, slam, SniperPenetratedRound, AirboatGun
-- Pistol, buckshot, and slam always ricochet. Use AirboatGun for a light metal peircing shotgun pellets

SWEP.Secondary.IronFOV			= 65		-- How much you 'zoom' in. Less is more! 	

SWEP.data 				= {}				--The starting firemode
SWEP.data.ironsights			= 1

SWEP.AutoDetectMuzzleAttachment = true --For multi-barrel weapons, detect the proper attachment?
SWEP.MoveSpeed = 1 --Multiply the player's movespeed by this.
SWEP.IronSightsMoveSpeed = 0.8 --Multiply the player's movespeed by this when sighting.
SWEP.Primary.NumShots	= 1		-- How many bullets to shoot per trigger pull
SWEP.Primary.Damage		= 20	-- Base damage per bullet
SWEP.Primary.Spread		= .05	-- Define from-the-hip accuracy 1 is terrible, .0001 is exact)
SWEP.Primary.IronAccuracy = .013 -- Ironsight accuracy, should be the same for shotguns

-- Enter iron sight info and bone mod info below

SWEP.IronSightsPos = Vector(-3.12, 0, 1.08)
SWEP.IronSightsAng = Vector(0.3, 0, 0)
SWEP.SightsPos = Vector(-3.12, 0, 1.08)
SWEP.SightsAng = Vector(0.3, 0, 0)
SWEP.RunSightsPos = Vector(3.319, -2.814, 0.8)
SWEP.RunSightsAng = Vector(-9.849, 23.92, 0)
SWEP.InspectPos = Vector(6.369, -5.628, 0.959)
SWEP.InspectAng = Vector(-10.554, 56.28, 0)

SWEP.Offset = {
        Pos = {
        Up = 0,
        Right = 0,
        Forward = -2,
        },
        Ang = {
        Up = 0,
        Right = -9,
        Forward = 180,
        },
		Scale = 1.0
}

sound.Add({
	name = 			"Weapon_pp19vit.Cloth",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/pp19vityaz/mp5_cloth.wav"
})

sound.Add({
	name = 			"Weapon_pp19vit.Cliprelease",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/pp19vityaz/mp5_cliprelease.wav"
})

sound.Add({
	name = 			"Weapon_pp19vit.Clipout",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/pp19vityaz/mp5_clipout.wav"
})

sound.Add({
	name = 			"Weapon_pp19vit.Clipin",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/pp19vityaz/mp5_clipin.wav"
})
sound.Add({
	name = 			"Weapon_pp19vit.Slideback",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/pp19vityaz/mp5_slideback.wav"
})
sound.Add({
	name = 			"Weapon_pp19vit.drawcloth",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/pp19vityaz/mp5_drawcloth.wav"
})
sound.Add({
	name = 			"Weapon_pp19vit.draw",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/pp19vityaz/mp5_draw.wav"
})

SWEP.WElements = {
	["element_name"] = { type = "Model", model = "models/weapons/w_smg_ppv.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(-2.597, 0.518, -0.519), angle = Angle(0, 0, 180), size = Vector(1.014, 1.014, 1.014), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}

--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
