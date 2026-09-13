--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

AddCSLuaFile("cl_init.lua") 
AddCSLuaFile("shared.lua") 
include("shared.lua") 

function ENT:Initialize()
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetCollisionGroup(COLLISION_GROUP_WORLD)
	if self.wake then
		self:GetPhysicsObject():Wake()
	end
	
	timer.Simple(math.random(self.FoodTabel[7], self.FoodTabel[8]), function()
		if(self:IsValid())then
			self:VisualEffect()
		end
	end)
end

function ENT:SetFoodBaseTabel( tabel, wake )
	self.FoodBaseTabel = tabel
	self.wake = wake
	self:SetFoodTabel( tabel )
end

function ENT:SetFoodTabel( tabel )
	self.DTTabel = tabel[1]
	self.FoodTabel = tabel[2]
	
	self:SetDTString( 0, self.DTTabel[1] )
	self:SetDTInt( 1, self.DTTabel[2].r )
	self:SetDTInt( 2, self.DTTabel[2].g )
	self:SetDTInt( 3, self.DTTabel[2].b )
	self:SetDTVector( 4, self.DTTabel[3] )
	self:SetModel(self.DTTabel[4])
end

function ENT:GetFoodBaseTabel()
	return self.FoodBaseTabel
end

function ENT:OnTakeDamage(dmginfo)
	self:EmitSound("physics/body/body_medium_break"..math.random(2, 4)..".wav")
	self:VisualEffect()
end

function ENT:Use(ply)
	if (ply:GetEyeTrace().Entity == self) and (ply:GetPos():Distance(self:GetPos()) < HFM_Config.HUDEntDrawDistance) then
		ply:HFM_AddHunger(	self.FoodTabel[1],	self.FoodTabel[2])
		ply:HFM_AddThirsty(	self.FoodTabel[3],	self.FoodTabel[4])
		ply:HFM_AddHealth(	self.FoodTabel[5],	self.FoodTabel[6])
		if self.FoodTabel[1] < self.FoodTabel[3] then
			ply:EmitSound("foods/drinking.wav")	
		else
			ply:EmitSound("foods/eating.wav")
		end
		self:VisualEffect()				
	end
end

function ENT:VisualEffect()
	local effectData = EffectData()	
	effectData:SetStart(self:GetPos())
	effectData:SetOrigin(self:GetPos())
	effectData:SetScale(8)
	util.Effect("GlassImpact", effectData, true, true)
	self:Remove()
end

--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
