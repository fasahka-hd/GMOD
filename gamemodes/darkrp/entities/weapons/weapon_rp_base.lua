--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

--[[
gamemodes/rp_base/entities/weapons/weapon_rp_base.lua
--]]
AddCSLuaFile()

SWEP.Base = "weapon_base"

if SERVER then
	SWEP.AutoSwitchTo = false
	SWEP.AutoSwitchFrom = false
else
	SWEP.PrintName = "RP Weapon Base"
	SWEP.DrawAmmo = false
	SWEP.DrawCrosshair = false
	SWEP.ViewModelFOV = 68
	SWEP.Category = "RP"
	SWEP.Author = "code_gs"
end

SWEP.HoldType = "normal"

SWEP.ViewModel = ""
SWEP.WorldModel = ""

SWEP.AdminOnly = true
SWEP.UseHands = true

SWEP.Primary = {
	ClipSize = -1,
	DefaultClip = -1,
	Automatic = true,
	Ammo = "none",
	Delay = 0.5,
	Sound = Sound('ambient/voices/cough1.wav')
}

SWEP.Secondary = {
	ClipSize = -1,
	DefaultClip = -1,
	Automatic = true,
	Ammo = "none",
	Delay = 0.5,
	Sound = Sound('ambient/voices/cough2.wav')
}

SWEP._Reload = {
	Delay = 2,
	Sound = Sound('npc/combine_soldier/vo/administer.wav')
}

SWEP.HitDistance = 100

SWEP.Melee = {
	DotRange = 0.70721, -- Max dot product for a hull trace to hit. 1/sqrt(2)
	HullRadius = 1.732, -- Test amount of the forward vector for the end point oof the hull trace. sqrt(3)
	TestHull = Vector(16, 16, 16), -- Test hull mins/maxs
	Mask = MASK_SHOT_HULL -- Mask to use for melee trace
}

function SWEP:SetupDataTables()
	self:NetworkVar("Float", 0, "NextReload")
end

function SWEP:Initialize()
	self:SetHoldType(self.HoldType)
end

function SWEP:PrimaryAttack()
	self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
end

function SWEP:SecondaryAttack()
	self:SetNextSecondaryFire(CurTime() + self.Secondary.Delay)
end

function SWEP:Reload()
	self:SetNextReload(CurTime() + self._Reload.Delay)
end

function SWEP:CanReload()
	return CurTime() > self:GetNextReload()
end

function SWEP:Holster()
	return true
end

function SWEP:GetTrace(foward)
	local tMelee = self.Melee
	local pPlayer = self:GetOwner()
	pPlayer:LagCompensation(true)

	local vSrc     = pPlayer:EyePos()
	local vForward = pPlayer:GetAimVector()
	local vEnd     = vSrc + vForward * (foward or 60)

	local tbl = {
		start = vSrc,
		endpos = vEnd,
		mask = self.Melee.Mask,
		filter = pPlayer
	}

	local tr    = util.TraceLine(tbl)
	local bMiss = tr.Fraction == 1

	if (bMiss) then
		-- Hull is +/- 16, so use cuberoot of 3 to determine how big the hull is from center to the corner point
		tbl.endpos = vEnd - vForward * tMelee.HullRadius
		tbl.mins = -tMelee.TestHull
		tbl.maxs = tMelee.TestHull
		tbl.output = tr

		util.TraceHull(tbl)
		bMiss = tr.Fraction == 1 or tr.Entity == NULL

		if (not bMiss) then
			local vTarget = tr.Entity:GetPos() - vSrc
			vTarget:Normalize()

			-- Make sure they are sort of facing the guy at least
			if (vTarget:Dot(vForward) < tMelee.DotRange) then
				-- Force amiss
				tr.Fraction = 1
				tr.Entity = NULL
				bMiss = true
			else
				util.FindHullIntersection(tbl, tr)
				bMiss = tr.Fraction == 1 or tr.Entity == NULL
			end
		end
	else
		bMiss = tr.Entity == NULL
	end

	pPlayer:LagCompensation(false)
	return tr
end



--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
