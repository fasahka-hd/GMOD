--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

-- Variables that are used on both client and server
SWEP.Gun = ("rwp_weapon_sniper_vss") -- must be the name of your swep but NO CAPITALS!
if (GetConVar(SWEP.Gun.."_allowed")) != nil then
	if not (GetConVar(SWEP.Gun.."_allowed"):GetBool()) then SWEP.Base = "tfa_blacklisted" SWEP.PrintName = SWEP.Gun return end
end
SWEP.Category				= "RWP"
SWEP.Author				= ""
SWEP.Contact				= ""
SWEP.Purpose				= ""
SWEP.Instructions				= ""
SWEP.MuzzleAttachment			= "1" 	-- Should be "1" for CSS models or "muzzle" for hl2 models
SWEP.ShellEjectAttachment			= "2" 	-- Should be "2" for CSS models or "1" for hl2 models
SWEP.PrintName				= "VSS Vintorez"		-- Weapon name (Shown on HUD)	
SWEP.MuzzleFlashEffect = "tfa_muzzleflash_silenced"
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
SWEP.BoltAction				= false		-- Is this a bolt action rifle?
SWEP.HoldType 				= "rpg"		-- how others view you carrying the weapon
-- normal melee melee2 fist knife smg ar2 pistol rpg physgun grenade shotgun crossbow slam passive 
-- you're mostly going to use ar2, smg, shotgun or pistol. rpg and crossbow make for good sniper rifles

SWEP.ViewModelFOV			= 70
SWEP.ViewModelFlip			= false
SWEP.ViewModel				= "models/weapons/v_p4f_vss.mdl"	-- Weapon view model
SWEP.WorldModel				= "models/weapons/w_p4f_vss.mdl"	-- Weapon world model
SWEP.Base 				= "tfa_scoped_base"
SWEP.ShowWorldModel         = false
SWEP.Spawnable				= true
SWEP.AdminSpawnable			= true

SWEP.Primary.Sound			= Sound("weapons/p4f_vss/galil-1.wav")		-- script that calls the primary fire sound
SWEP.Primary.RPM				= 600		-- This is in Rounds Per Minute
SWEP.Primary.ClipSize			= 10		-- Size of a clip
SWEP.Primary.DefaultClip		= 0	-- Bullets you start with
SWEP.Primary.KickUp				= .2				-- Maximum up recoil (rise)
SWEP.Primary.KickDown			= .2			-- Maximum down recoil (skeet)
SWEP.Primary.KickHorizontal		= .2		-- Maximum up recoil (stock)
SWEP.Primary.Automatic			= true		-- Automatic/Semi Auto
SWEP.Primary.Ammo			= "ar2"	-- pistol, 357, smg1, ar2, buckshot, slam, SniperPenetratedRound, AirboatGun
-- Pistol, buckshot, and slam always ricochet. Use AirboatGun for a light metal peircing shotgun pellets

SWEP.Secondary.ScopeZoom			= 12
SWEP.Secondary.UseACOG			= false -- Choose one scope type
SWEP.Secondary.UseMilDot		= false	-- I mean it, only one	
SWEP.Secondary.UseSVD			= true	-- If you choose more than one, your scope will not show up at all
SWEP.Secondary.UseParabolic		= false	
SWEP.Secondary.UseElcan			= false
SWEP.Secondary.UseGreenDuplex	= false	
SWEP.Secondary.UseAimpoint		= false
SWEP.Secondary.UseMatador		= false

SWEP.data 				= {}
SWEP.data.ironsights		= 1
SWEP.ScopeScale 			= 0.6

SWEP.AutoDetectMuzzleAttachment = true --For multi-barrel weapons, detect the proper attachment?
SWEP.MoveSpeed = 1 --Multiply the player's movespeed by this.
SWEP.IronSightsMoveSpeed = 0.8 --Multiply the player's movespeed by this when sighting.
SWEP.Primary.NumShots	= 1		--how many bullets to shoot per trigger pull
SWEP.Primary.Damage		= 35	--base damage per bullet
SWEP.Primary.Spread		= .01	--define from-the-hip accuracy 1 is terrible, .0001 is exact)
SWEP.Primary.IronAccuracy = .0001 -- ironsight accuracy, should be the same for shotguns

-- enter iron sight info and bone mod info below
SWEP.SightsPos = Vector (-3.08, -3.8, -0.281)
SWEP.SightsAng = Vector (-3.5, -0.401, 0)
SWEP.RunSightsPos = Vector (1.6, 0, -2.8)
SWEP.RunSightsAng = Vector (-12.5, 32.5, -21.8)
SWEP.InspectPos = Vector(3.48, -0.84, 1.399)
SWEP.InspectAng = Vector(0, 11.1, 29)

SWEP.WElements = {
	["element_name"] = { type = "Model", model = "models/weapons/w_p4f_vss.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(-1.558, 0.819, -0.519), angle = Angle(-3.507, 1.169, 180), size = Vector(1.014, 1.014, 1.014), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}

sound.Add({
	name = 			"p4f_vss.Single",			// <-- Sound Name That gets called for
	channel = 		CHAN_USER_BASE +10,
	volume = 		1.0,
	sound = 			"weapons/p4f_vss/galil-1.wav"	// <-- Sound Path
})

sound.Add({
	name = 			"p4f_vss.out",			
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/p4f_vss/out.wav"	
})

sound.Add({
	name = 			"p4f_vss.in",			
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/p4f_vss/in.wav"	
})

sound.Add({
	name = 			"p4f_vss.pull",			
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/p4f_vss/pull.wav"	
})

sound.Add({
	name = 			"p4f_vss.release",			
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/p4f_vss/release.wav"	
})

sound.Add({
	name = 			"p4f_vss.deploy",			
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/p4f_vss/deploy.wav"	
})

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
