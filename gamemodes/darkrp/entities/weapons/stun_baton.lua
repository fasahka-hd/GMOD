--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

AddCSLuaFile()
DEFINE_BASECLASS('baton_base')

if SERVER then
	util.AddNetworkString('StunStickFlash')
else
	SWEP.PrintName = 'Дубина'
	SWEP.SlotPos = 6
	SWEP.Instructions = 'Left click sets phaser to stun\nRight click sets phaser to kill'
end

SWEP.Color = Color(0, 0, 255, 255)
local Hit = Sound('Weapon_StunStick.Melee_Hit')
local Miss = Sound('Weapon_StunStick.Melee_HitWorld')

if CLIENT then
	local function StunStickFlash()
		local alpha = 255

		hook.Add('HUDPaint', 'StunStickFlash', function()
			alpha = Lerp(0.05, alpha, 0)
			surface.SetDrawColor(255, 255, 255, alpha)
			surface.DrawRect(0, 0, ScrW(), ScrH())

			if math.Round(alpha) == 0 then
				hook.Remove('HUDPaint', 'StunStickFlash')
			end
		end)
	end

	net.Receive('StunStickFlash', StunStickFlash)
end

function SWEP:Initialize()
	self:SetHoldType(self.HoldType)
	self._Reload.Sound = Sound('Weapon_StunStick.Activate')
end

function SWEP:PrimaryAttack()
	if not IsValid(self.Owner) then return end
	BaseClass.PrimaryAttack(self)
	self:SetNextSecondaryFire(CurTime() + self.Secondary.Delay)
	if CLIENT then return end
	self.Owner:LagCompensation(true)
	local ent = self.Owner:GetEyeTrace().Entity
	self.Owner:LagCompensation(false)
	if not IsValid(ent) or (self.Owner:GetPos():Distance(ent:GetPos()) > self.HitDistance) then return end

	if ent:IsPlayer() then
		net.Start('StunStickFlash')
		net.Send(ent)
		self.Owner:EmitSound(Hit)
	else
		self.Owner:EmitSound(Miss)
	end
end

function SWEP:SecondaryAttack()
	if not IsValid(self.Owner) then return end
	BaseClass.PrimaryAttack(self)
	self:SetNextSecondaryFire(CurTime() + self.Secondary.Delay)
	if CLIENT then return end
	self.Owner:LagCompensation(true)
	local ent = self.Owner:GetEyeTrace().Entity
	self.Owner:LagCompensation(false)
	if not IsValid(ent) or (self.Owner:GetPos():Distance(ent:GetPos()) > self.HitDistance) then return end

	if ent:IsPlayer() then
		ent:TakeDamage(10, self.Owner, self)
		net.Start('StunStickFlash')
		net.Send(ent)
		self.Owner:EmitSound(Hit)
	else
		self.Owner:EmitSound(Miss)
	end
end

--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
