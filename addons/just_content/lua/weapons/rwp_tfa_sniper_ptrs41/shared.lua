--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

-- Variables that are used on both client and server
SWEP.Gun = ("rwp_weapon_sniper_ptrs41") -- must be the name of your swep but NO CAPITALS!
if (GetConVar(SWEP.Gun.."_allowed")) != nil then
	if not (GetConVar(SWEP.Gun.."_allowed"):GetBool()) then SWEP.Base = "tfa_blacklisted" SWEP.PrintName = SWEP.Gun return end
end
SWEP.Category				= "RWP"
SWEP.Author				= "SMG"
SWEP.Contact				= ""
SWEP.Purpose				= ""
SWEP.MuzzleAttachment			= "1" 	-- Should be "1" for CSS models or "muzzle" for hl2 models
SWEP.ShellEjectAttachment			= "2" 	-- Should be "2" for CSS models or "1" for hl2 models
SWEP.PrintName				= "PTRS-41"		-- Weapon name (Shown on HUD)	
SWEP.Slot				= 4				-- Slot in the weapon selection menu
SWEP.SlotPos				= 51			-- Position in the slot
SWEP.DrawAmmo				= true		-- Should draw the default HL2 ammo counter
SWEP.DrawWeaponInfoBox		= false		-- Should draw the weapon info box
SWEP.BounceWeaponIcon   	= false	-- Should the weapon icon bounce?
SWEP.DrawCrosshair			= false		-- Set false if you want no crosshair from hip
SWEP.XHair					= false		-- Used for returning crosshair after scope. Must be the same as DrawCrosshair
SWEP.Weight				= 50			-- Rank relative ot other weapons. bigger is better
SWEP.AutoSwitchTo			= true		-- Auto switch to if we pick it up
SWEP.AutoSwitchFrom			= true		-- Auto switch from if you pick up a better weapon
SWEP.BoltAction				= false		-- Is this a bolt action rifle?
SWEP.HoldType 				= "rpg"		-- how others view you carrying the weapon
-- normal melee melee2 fist knife smg ar2 pistol rpg physgun grenade shotgun crossbow slam passive 
-- you're mostly going to use ar2, smg, shotgun or pistol. rpg and crossbow make for good sniper rifle

SWEP.ViewModelFOV			= 70
SWEP.ViewModelFlip			= true
SWEP.ShowWorldModel         = false
SWEP.ViewModel				= "models/weapons/v_snip_ptrscope.mdl"	-- Weapon view model
SWEP.WorldModel				= "models/weapons/w_snip_ptrscope.mdl"	-- Weapon world model
SWEP.Base 				= "tfa_scoped_base"
SWEP.Spawnable				= true
SWEP.AdminSpawnable			= true

SWEP.Primary.Sound			= Sound("weapons/ptrs/ptrs-shoot.wav")		-- script that calls the primary fire sound
SWEP.Primary.RPM				= 100	    -- This is in Rounds Per Minute
SWEP.Primary.ClipSize			= 5		    -- Size of a clip
SWEP.Primary.DefaultClip		= 0	-- Bullets you start with
SWEP.Primary.KickUp				= .4				-- Maximum up recoil (rise)
SWEP.Primary.KickDown			= .3			-- Maximum down recoil (skeet)
SWEP.Primary.KickHorizontal		= .2		-- Maximum up recoil (stock)
SWEP.Primary.Automatic			= false		-- Automatic/Semi Auto
SWEP.Primary.Ammo			= "SniperPenetratedRound"	-- pistol, 357, smg1, ar2, buckshot, slam, SniperPenetratedRound, AirboatGun
-- Pistol, buckshot, and slam always ricochet. Use AirboatGun for a light metal peircing shotgun pellets

SWEP.Secondary.ScopeZoom			= 15	
SWEP.Secondary.UseACOG			= false -- Choose one scope type
SWEP.Secondary.UseMilDot		= true	-- I mean it, only one	
SWEP.Secondary.UseSVD			= false	-- If you choose more than one, your scope will not show up at all
SWEP.Secondary.UseParabolic		= false	
SWEP.Secondary.UseElcan			= false
SWEP.Secondary.UseGreenDuplex	= false	
SWEP.Secondary.UseAimpoint		= false
SWEP.Secondary.UseMatador		= false

SWEP.data 				= {}
SWEP.data.ironsights		= 1
SWEP.ScopeScale 			= 0.6

SWEP.AutoDetectMuzzleAttachment = true --For multi-barrel weapons, detect the proper attachment?
SWEP.MoveSpeed = 0.9 --Multiply the player's movespeed by this.
SWEP.IronSightsMoveSpeed = 0.8 --Multiply the player's movespeed by this when sighting.
SWEP.Primary.NumShots	= 1		--how many bullets to shoot per trigger pull
SWEP.Primary.Damage		= 82	--base damage per bullet
SWEP.Primary.Spread		= .02	--define from-the-hip accuracy 1 is terrible, .0001 is exact)
SWEP.Primary.IronAccuracy = .0001 -- ironsight accuracy, should be the same for shotguns

-- enter iron sight info and bone mod info below

SWEP.IronSightsPos = Vector (3.39, -3, 1.9)
SWEP.IronSightsAng = Vector (-4.1, -1.65, 0)
SWEP.SightsPos = Vector (3.39, -3, 1.9)
SWEP.SightsAng = Vector (-4.1, -1.65, 0)
SWEP.RunSightsPos = Vector(-0.921, 0, 2.599)
SWEP.RunSightsAng = Vector(-15.478, -16.181, 0)
SWEP.InspectPos = Vector(-5.421, -3.016, 0.639)
SWEP.InspectAng = Vector(-4.222, -42.916, 0)

sound.Add({
    name = "PTRS-41.Deploy",
	channel = CHAN_ITEM,
	colume = 1.0,
	sound = "weapons/ptrs/PTRS_deploy.wav"
})

sound.Add({
    name = "PTRS-41.Clipout",
	channel = CHAN_ITEM,
	colume = 1.0,
	sound = "weapons/ptrs/PTRS_clipout.wav"
})

sound.Add({
    name = "PTRS-41.Clipin",
	channel = CHAN_ITEM,
	colume = 1.0,
	sound = "weapons/ptrs/PTRS_clipin.wav"
})

sound.Add({
    name = "PTRS-41.Bolt",
	channel = CHAN_ITEM,
	colume = 1.0,
	sound = "weapons/ptrs/PTRS_bolt.wav"
})

SWEP.WElements = {
	["element_name"] = { type = "Model", model = "models/weapons/w_snip_ptrscope.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(0.518, 0.518, -2.6), angle = Angle(0, 3.5, 180), size = Vector(1.014, 1.014, 1.014), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}


--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
