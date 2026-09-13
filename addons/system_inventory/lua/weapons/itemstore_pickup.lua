--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

if SERVER then
	AddCSLuaFile()
end

SWEP.PrintName = "Инвентарь"

SWEP.Purpose = ""
SWEP.Instructions = ""

SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.ViewModel = "models/weapons/c_arms.mdl"
SWEP.WorldModel = ""
SWEP.UseHands = true
SWEP.Category = "RP"

SWEP.Primary.Clipsize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "none"

SWEP.Secondary.Clipsize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"

SWEP.Slot               = 2
SWEP.SlotPos 			= 10
SWEP.DrawAmmo           = false
SWEP.DrawCrosshair      = true

function SWEP:Initialize()
	self:SetHoldType( "normal" )
end

function SWEP:OnDrop()
	self:Remove()
end

SWEP.Range = 140

function SWEP:PrimaryAttack()
	self:SetNextPrimaryFire(CurTime() + 0.35)

	if CLIENT then return end

	local owner = self:GetOwner()
	if not IsValid(owner) then return end

	local tr = util.TraceLine({
		start = owner:GetShootPos(),
		endpos = owner:GetShootPos() + owner:GetAimVector() * self.Range,
		filter = owner
	})

	local ent = tr.Entity
	if not IsValid(ent) then return end

	if owner.EncPickupEntityToInventory then
		owner:EncPickupEntityToInventory(ent)
		return
	end

	if owner.PickupItem then
		owner:PickupItem(ent)
	end
end

function SWEP:SecondaryAttack()
	self:SetNextSecondaryFire(CurTime() + 0.35)

	if CLIENT and enc and enc.inventory then
		enc.inventory()
	end
end


--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher