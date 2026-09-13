--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

-- Variables that are used on both client and server
SWEP.Gun = ("rwp_weapon_sniper_sv98") -- must be the name of your swep but NO CAPITALS!
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
SWEP.PrintName				= "SV-98"		-- Weapon name (Shown on HUD)	
SWEP.Slot				= 4				-- Slot in the weapon selection menu
SWEP.SlotPos				= 42			-- Position in the slot
SWEP.DrawAmmo				= true		-- Should draw the default HL2 ammo counter
SWEP.DrawWeaponInfoBox		= false		-- Should draw the weapon info box
SWEP.BounceWeaponIcon   	= false	-- Should the weapon icon bounce?
SWEP.DrawCrosshair			= false		-- Set false if you want no crosshair from hip
SWEP.XHair					= false		-- Used for returning crosshair after scope. Must be the same as DrawCrosshair
SWEP.Weight				= 50			-- Rank relative ot other weapons. bigger is better
SWEP.AutoSwitchTo			= true		-- Auto switch to if we pick it up
SWEP.AutoSwitchFrom			= true		-- Auto switch from if you pick up a better weapon
SWEP.BoltAction				= true		-- Is this a bolt action rifle?
SWEP.HoldType 				= "rpg"		-- how others view you carrying the weapon
-- normal melee melee2 fist knife smg ar2 pistol rpg physgun grenade shotgun crossbow slam passive 
-- you're mostly going to use ar2, smg, shotgun or pistol. rpg and crossbow make for good sniper rifles

SWEP.ViewModelFOV			= 70
SWEP.ViewModelFlip		= false
SWEP.ViewModel			= "models/weapons/v_snip_sv98.mdl"
SWEP.WorldModel			= "models/weapons/w_snip_bf3_sv98.mdl"
SWEP.Base 				= "tfa_scoped_base"
SWEP.Spawnable				= true
SWEP.ShowWorldModel         = false
SWEP.AdminSpawnable			= true

SWEP.Primary.Sound			= Sound("SV98.Single")		-- script that calls the primary fire sound
SWEP.Primary.RPM				= 50		-- This is in Rounds Per Minute
SWEP.Primary.ClipSize			= 10		-- Size of a clip
SWEP.Primary.DefaultClip		= 0	-- Bullets you start with
SWEP.Primary.KickUp				= .5				-- Maximum up recoil (rise)
SWEP.Primary.KickDown			= .6			-- Maximum down recoil (skeet)
SWEP.Primary.KickHorizontal		= .4		-- Maximum up recoil (stock)
SWEP.Primary.Automatic			= false		-- Automatic/Semi Auto
SWEP.Primary.Ammo			= "SniperPenetratedRound"	-- pistol, 357, smg1, ar2, buckshot, slam, SniperPenetratedRound, AirboatGun
-- Pistol, buckshot, and slam always ricochet. Use AirboatGun for a light metal peircing shotgun pellets

SWEP.Secondary.ScopeZoom			= 10
SWEP.Secondary.UseACOG			= false -- Choose one scope type
SWEP.Secondary.UseMilDot		= false	-- I mean it, only one	
SWEP.Secondary.UseSVD			= false	-- If you choose more than one, your scope will not show up at all
SWEP.Secondary.UseParabolic		= false	
SWEP.Secondary.UseElcan			= false
SWEP.Secondary.UseGreenDuplex	= true
SWEP.Secondary.UseAimpoint		= false
SWEP.Secondary.UseMatador		= false

SWEP.data 				= {}
SWEP.data.ironsights		= 1
SWEP.ScopeScale 			= 0.6

SWEP.AutoDetectMuzzleAttachment = true --For multi-barrel weapons, detect the proper attachment?
SWEP.MoveSpeed = 1 --Multiply the player's movespeed by this.
SWEP.IronSightsMoveSpeed = 0.8 --Multiply the player's movespeed by this when sighting.
SWEP.Primary.NumShots	= 1		--how many bullets to shoot per trigger pull
SWEP.Primary.Damage		= 50	--base damage per bullet
SWEP.Primary.Spread		= .03	--define from-the-hip accuracy 1 is terrible, .0001 is exact)
SWEP.Primary.IronAccuracy = .0001 -- ironsight accuracy, should be the same for shotguns

-- enter iron sight info and bone mod info below

SWEP.IronSightsPos = Vector (-3.36, -4.921, 1.2)
SWEP.IronSightsAng = Vector (-5.1, 2.799, 0)
SWEP.SightsPos = Vector (-3.36, -4.921, 1.2)
SWEP.SightsAng = Vector (-5.1, 2.799, 0)
SWEP.RunSightsPos = Vector(3.24, -2.412, 0.68)
SWEP.RunSightsAng = Vector(-8.443, 31.658, 0)
SWEP.InspectPos = Vector(4.239, -2.613, 0.959)
SWEP.InspectAng = Vector(-7.035, 40.101, 0)

sound.Add({
	name = 			"SV98.Single",			// <-- Sound Name That gets called for
	channel = 		CHAN_USER_BASE +10,
	volume = 		1.0,
	sound = 			"weapons/sv98b/1.wav"// <-- Sound Path
})

sound.Add({
	name = 			"SV98_Bolt1",			
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/sv98b/bolt.wav"	
})

sound.Add({
	name = 			"SV98_Clipout",			
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/sv98b/clipout.wav"	
})


sound.Add({
	name = 			"SV98_Clipin",			
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/sv98b/clipin.wav"	
})

sound.Add({
	name = 			"SV98_Boltback",			
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/sv98b/boltback.wav"	
})

sound.Add({
	name = 			"SV98_Boltforward",			
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/sv98b/boltforward.wav"	
})

SWEP.WElements = {
	["element_name"] = { type = "Model", model = "models/weapons/w_snip_bf3_sv98.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(0.518, 0.518, 0), angle = Angle(-8.183, -1.17, 180), size = Vector(1.014, 1.014, 1.014), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
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
