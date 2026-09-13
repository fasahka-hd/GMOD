--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

-- "gamemodes\\darkrp\\entities\\weapons\\weapon_c4\\shared.lua"
-- Retrieved by https://github.com/c4fe/glua-steal
if (SERVER) then
	AddCSLuaFile('shared.lua')
end

SWEP.PrintName = 'C4'
SWEP.Slot = 1
SWEP.SlotPos = 1
SWEP.DrawAmmo = false
SWEP.DrawCrosshair = false
SWEP.Instructions = 'Click to blow shit up'
SWEP.Author = 'aStonedPenguin'
SWEP.Contact = ''
SWEP.Purpose = ''

SWEP.ViewModel				= Model("models/weapons/2_c4.mdl")	-- Weapon view model

SWEP.WorldModel				= Model("models/weapons/3_c4.mdl")	-- Weapon world model
SWEP.ViewModelFOV = 62
SWEP.ViewModelFlip = false
SWEP.AnimPrefix = 'rpg'
SWEP.Spawnable = true
SWEP.Category = 'RP'
SWEP.Sound = ''
SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = 0
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = ''
SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = 0
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = ''

function SWEP:Initialize()

	self.nextReload = 0

	self:SetHoldType('slam')

end

function SWEP:PrimaryAttack()
	self:SetHoldType('pistol')
	if (SERVER) then
		local tr = util.TraceLine({
			start = self.Owner:GetShootPos(),
			endpos = self.Owner:GetShootPos() + 100 * self.Owner:GetAimVector(),
			filter = {self.Owner}
		})

		local c4 = ents.Create('ent_c4')
		--rp.achievements.AddProgress(self.Owner, ACHIEVEMENT_C4, 1)
		c4:SetPos(tr.HitPos)
		c4:SetAngles(tr.HitNormal:Angle() - Angle(90, 180, 0))
		c4:Spawn()
		c4.ItemOwner = self.Owner

		if tr.Entity and IsValid(tr.Entity) and not (tr.Entity:GetClass() == "gmod_rtcameraprop") then
			if tr.Entity:GetPhysicsObject():IsValid() then
				c4:SetParent(tr.Entity)
			elseif not tr.Entity:IsNPC() and not tr.Entity:IsPlayer() and tr.Entity:GetPhysicsObject():IsValid() then
				constraint.Weld(c4, tr.Entity)
			end
		else
			c4:SetMoveType(MOVETYPE_NONE)
		end

		hook.Call('PlayerPlaceC4', nil, self.Owner, tr.Entity)

		if not tr.Hit then
			c4:SetMoveType(MOVETYPE_VPHYSICS)
		end

		self.Owner:EmitSound("c4.PlantSound")
		self.Owner:StripWeapon('weapon_c4')
	end
end

function SWEP:SecondaryAttack()
	self:PrimaryAttack()
end

-- "gamemodes\\darkrp\\entities\\weapons\\weapon_c4\\shared.lua"
-- Retrieved by https://github.com/c4fe/glua-steal
/*
Я ЕБУ ЖИВОТНЫХ.
*/

-- "gamemodes\\darkrp\\entities\\weapons\\weapon_c4\\shared.lua"
-- Retrieved by https://github.com/c4fe/glua-steal
/*
Я ЕБУ ЖИВОТНЫХ.
*/



--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
