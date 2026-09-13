--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()
	self:SetModel(HFM_Config.Fertilizer.Model)
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:GetPhysicsObject():Wake()
	
	self.nextSec = CurTime()
	self:SetAngles(Angle(90,0,0))
end

function ENT:OnTakeDamage(dmginfo)
	self:VisualEffect()
end

function ENT:Think()
	local curTime = CurTime()
	
	if self.nextSec <= curTime then
		for k, v in pairs(ents.FindInSphere(self:GetPos(), 5)) do
			if v:GetClass() == "base_seed" then
				if v:GetDTInt(1) == 2 and !v.Fertilized then
					v.Time = math.Round( v.Time / 2 )
					v.Fertilized = true
					self:VisualEffect()
				end
			end
		end
		self.nextSec = curTime + 1
	end
end

function ENT:VisualEffect()
	local effectData = EffectData()
	effectData:SetStart(self:GetPos())
	effectData:SetOrigin(self:GetPos())
	effectData:SetScale(8)
	util.Effect("GlassImpact", effectData, true, true)
	
	self:EmitSound("physics/body/body_medium_break"..math.random(2, 4)..".wav")
	self:Remove()
end

--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
