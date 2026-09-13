--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher

STUNGUN = {} -- General stungun stuff table

STUNGUN.IsDarkRP = ((type(DarkRP) == "table") or (RPExtraTeams != nil))
STUNGUN.IsDarkRP25 = (STUNGUN.IsDarkRP and (type(DarkRP) == "table") and DarkRP.getPhrase)
STUNGUN.IsTTT = ((ROLE_TRAITOR != nil) and (ROLE_INNOCENT != nil) and (ROLE_DETECTIVE != nil) and (GetRoundState != nil)) -- For a gamemode to be TTT, these should probably exist.

include("config.lua")

if STUNGUN.IsTTT then
	SWEP.Base = "weapon_tttbase"
	SWEP.AmmoEnt = ""
	SWEP.IsSilent = false
	SWEP.NoSights = true
end

SWEP.Author = "Donkie"
SWEP.Instructions = string.format("Left click to stun a person.%s", STUNGUN.CanUntaze and "\nRight click to unstun a person." or "")
SWEP.Contact = ""
SWEP.Purpose = ""

SWEP.ViewModelFOV = 50
SWEP.ViewModelFlip = false
SWEP.ViewModel = Model("models/weapons/c_pistol.mdl")
SWEP.WorldModel = Model("models/weapons/w_pistol.mdl")

SWEP.UseHands = true

SWEP.Spawnable = true
SWEP.AdminOnly = true

-- SWEP.InfiniteAmmo = (SWEP.Ammo <= -1) -- Not used anymore
if SWEP.InfiniteAmmo then
	SWEP.Primary.ClipSize = -1
	SWEP.Primary.DefaultClip = 0
	SWEP.Primary.Ammo = "none"
else
	SWEP.Primary.ClipSize = 1
	SWEP.Primary.DefaultClip = 1

	if STUNGUN.IsTTT then
		SWEP.Primary.ClipMax = SWEP.Ammo
	end

	SWEP.Primary.Ammo = "ammo_stungun"
end
SWEP.Primary.Automatic = false

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"

-- print(SERVER and "SERVER INIT" or "CLIENT INIT")

SWEP.Uncharging = false

game.AddAmmoType({
	name = "ammo_stungun",
	dmgtype = DMG_GENERIC,
	tracer = TRACER_NONE,
	plydmg = 0,
	npcdmg = 0,
	force = 0,
	minsplash = 0,
	maxsplash = 0
})

if STUNGUN.AddAmmoItem >= 0 then
	if DarkRP and DarkRP.createAmmoType then
		DarkRP.createAmmoType("ammo_stungun", {
			name = "Stungun Charges",
			model = "models/Items/battery.mdl",
			price = math.ceil(STUNGUN.AddAmmoItem),
			amountGiven = 1
		})
	elseif GAMEMODE.AddAmmoType then
		GAMEMODE:AddAmmoType("ammo_stungun", "Stungun Charges", "models/Items/battery.mdl", math.ceil(STUNGUN.AddAmmoItem), 1)
	end
end

function SWEP:DoEffect(tr)
	-- Animations
	self:SendWeaponAnim( ACT_VM_PRIMARYATTACK )
	self.Owner:SetAnimation(PLAYER_ATTACK1)

	-- Electric bolt, taken from toolgun
	local effectdata = EffectData()
		effectdata:SetOrigin( tr.HitPos )
		effectdata:SetStart( self.Owner:GetShootPos() )
		effectdata:SetAttachment( 1 )
		effectdata:SetEntity( self )
	util.Effect( "ToolTracer", effectdata )
end

function SWEP:PrimaryAttack()
	if self.Charge < 100 then return end

	if not self.InfiniteAmmo then
		if self:Clip1() <= 0 then return end
		self:TakePrimaryAmmo(1)
	end

	self.Uncharging = true

	-- Shoot trace
	self.Owner:LagCompensation(true)
	local tr = util.TraceLine(util.GetPlayerTrace( self.Owner ))
	self.Owner:LagCompensation(false)

	self:DoEffect(tr)

	if SERVER then
		self.Owner:EmitSound("npc/turret_floor/shoot1.wav",100,100)
	end

	local ent = tr.Entity

	if CLIENT then return end

	//if SH_SZ:GetSafeStatus(self:GetOwner()) == SH_SZ.PROTECTED then rp.Notify(self.Owner, 1, 'Вы не можете затайзерить игрока пока находитесь в этой зоне!') return end
	//if SH_SZ:GetSafeStatus(trace.Entity) == SH_SZ.PROTECTED then rp.Notify(self.Owner, 1, 'Вы не можете затайзерить игрока пока он находится в этой зоне!') return end

	-- Don't proceed if we don't hit any player
	if not IsValid(ent) or not ent:IsPlayer() then return end
	if ent == self.Owner then return end
	if IsValid(ent.tazeragdoll) then return end
	if self.Owner:GetShootPos():Distance(tr.HitPos) > self.Range then return end

	if not STUNGUN.IsPlayerImmune(ent) and (STUNGUN.AllowFriendlyFire or not STUNGUN.SameTeam(self.Owner, ent)) then
		-- Damage
		if (STUNGUN.StunDamage and STUNGUN.StunDamage > 0) and not ent.tazeimmune then
			local dmginfo = DamageInfo()
				dmginfo:SetDamage(STUNGUN.StunDamage)
				dmginfo:SetAttacker(self.Owner)
				dmginfo:SetInflictor(self)
				dmginfo:SetDamageType(DMG_SHOCK)
				dmginfo:SetDamagePosition(tr.HitPos)
				dmginfo:SetDamageForce(self.Owner:GetAimVector() * 30)
			ent:TakeDamageInfo(dmginfo)
		end

		hook.Run("PlayerTazed", ent, self.Owner)

		--The player might have died while getting tazed
		if ent:Alive() then
			-- Electrolute the player
			STUNGUN.Electrolute( ent, (ent:GetPos() - self.Owner:GetPos()):GetNormal() )
		end

		if STUNGUN.pLogs then
			plogs.PlayerLog(ent, "Stungun", string.format("%s was tazed by %s.", ent:NameID(), self.Owner:NameID()), {
				["Name"]             = ent:Name(),
				["SteamID"]          = ent:SteamID(),
				["Attacker Name"]    = self.Owner:Name(),
				["Attacker SteamID"] = self.Owner:SteamID(),
			})
		end
	end
end

local chargeinc
function SWEP:Think()
	-- In charge of charging the swep
	-- Since we got the same in-sensitive code both client and serverside we don't need to network anything.
	if SERVER or (CLIENT and IsFirstTimePredicted()) then
		if not chargeinc then
			-- Calculate how much we should increase charge every tick based on how long we want it to take.
			chargeinc = ((100 / self.RechargeTime) * engine.TickInterval())
		end

		local inc = self.Uncharging and (-5) or chargeinc

		if self:Clip1() <= 0 and not self.InfiniteAmmo then inc = math.min(inc, 0) end -- If we're out of clip, we shouldn't be allowed to recharge.

		self.Charge = math.min(self.Charge + inc, 100)
		if self.Charge < 0 then self:Reload() self.Uncharging = false self.Charge = 0 end
	end
end

function SWEP:FailAttack()
	self:SetNextSecondaryFire(CurTime() + 0.5)
	self.Owner:EmitSound( "Weapon_Pistol.Empty" )
end

function SWEP:SecondaryAttack()
	if STUNGUN.CanUntaze then
		if self:GetNextSecondaryFire() >= CurTime() then self:FailAttack() return end

		-- Shoot trace
		self.Owner:LagCompensation(true)
		local tr = util.TraceLine(util.GetPlayerTrace( self.Owner ))
		self.Owner:LagCompensation(false)

		local ent = tr.Entity

		if CLIENT then return end

		-- Don't proceed if we don't hit any raggy
		if not IsValid(ent) or ent:GetClass() != "prop_ragdoll" or not IsValid(ent.tazeplayer) then self:FailAttack() return end
		if self.Owner:GetShootPos():Distance(tr.HitPos) > self.Range then self:FailAttack() return end

		self:DoEffect(tr)

		self.Owner:EmitSound("npc/turret_floor/shoot1.wav",100,100)

		local ply = ent.tazeplayer
		timer.Simple(.4, function() ply:EmitSound("items/smallmedkit1.wav",100,100) end)

		hook.Run("PlayerPreUnTazed", ply, self.Owner)

		STUNGUN.UnMute( ply )
		STUNGUN.UnElectrolute( ply )

		local id = ply:UserID()
		timer.Remove("Unelectrolute" .. id)
		timer.Remove("tazeUngag" .. id)

		if STUNGUN.pLogs then
			plogs.PlayerLog(ply, "Stungun", string.format("%s was un-tazed by %s.", ply:NameID(), self.Owner:NameID()), {
				["Name"]             = ply:Name(),
				["SteamID"]          = ply:SteamID(),
				["Attacker Name"]    = self.Owner:Name(),
				["Attacker SteamID"] = self.Owner:SteamID(),
			})
		end

		self:SetNextSecondaryFire(CurTime() + 2)
	end
	return false
end

function SWEP:Reload()
	self:DefaultReload( ACT_VM_RELOAD )
	return true
end

local shoulddisable = {} -- Disables muzzleflashes and ejections
shoulddisable[21] = true
shoulddisable[5003] = true
shoulddisable[6001] = true
function SWEP:FireAnimationEvent( pos, ang, event, options )
	if shoulddisable[event] then return true end
end

hook.Add("PhysgunPickup", "Tazer", function(_,ent)
	if not STUNGUN.AllowPhysgun and IsValid(ent:GetNWEntity("plyowner")) then return false end
end)
hook.Add("CanTool", "Tazer", function(_,tr,_)
	if not STUNGUN.AllowToolgun and IsValid(tr.Entity) and IsValid(tr.Entity:GetNWEntity("plyowner")) then return false end
end)

hook.Add("StartCommand", "Tazer", function(ply, cmd)
	if ply:GetNWBool("tazefrozen", false) == false then return end

	cmd:ClearMovement()
	cmd:RemoveKey(IN_ATTACK)
	cmd:RemoveKey(IN_ATTACK2)
	cmd:RemoveKey(IN_RELOAD)
	cmd:RemoveKey(IN_USE)
	cmd:RemoveKey(IN_DUCK)
	cmd:RemoveKey(IN_JUMP)
end)

--[[
pLogs-2
]]
local function InitpLogs()
	if not plogs or not plogs.Version then return end
	local versionstr = plogs.Version
	local versiontbl = string.Explode(".", versionstr)
	if #versiontbl != 3 then return end

	local major = tonumber(versiontbl[1])
	local minor = tonumber(versiontbl[2])
	local patch = tonumber(versiontbl[3])

	plogs.Register("Stungun", true, Color(255,163,0))
	STUNGUN.pLogs = true
end

if plogs then
	InitpLogs()
else
	hook.Add("Initialize","stungun_waitforplogs",InitpLogs)
end

--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher
