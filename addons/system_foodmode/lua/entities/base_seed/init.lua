--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

local matTable = { 68, 85, 78 }

function ENT:Initialize()
	self:SetModel("models/props_lab/box01a.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:GetPhysicsObject():SetMass(105)
	self:GetPhysicsObject():Wake()
	self:GetPhysicsObject():SetPos(self:GetPhysicsObject():GetPos() + Vector(0, 0, 15))
	self:SetCollisionGroup(COLLISION_GROUP_WORLD)
	
		
	self.nextUse = CurTime()
	self.nextSec = CurTime()
	self.Stay = 0
	self.Time = 0
	self.Fertilized = false
	

	self.Food		= self.SeedBaseTabel[2]
	self.GrowModel	= self.SeedBaseTabel[3]
	self.DrawVec	= self.SeedBaseTabel[4]
	self.GrowVec	= self.SeedBaseTabel[5]
	self.VT			= self.SeedBaseTabel[6]
	self.FoodAmount = self.SeedBaseTabel[7]
	self.Blooms		= self.SeedBaseTabel[8][1]
	self.GrowTime	= self.SeedBaseTabel[8][2]
	self.BloomTime	= self.SeedBaseTabel[8][3]
	
	
	self.FoodColor = HFM_Config.TableFoods[self.Food][1][2]
	self:SetDTString(0, self.SeedBaseTabel[1])
	self:SetDTInt(4, self.FoodColor.r)
	self:SetDTInt(5, self.FoodColor.g)
	self:SetDTInt(6, self.FoodColor.b)
	self:SetDTVector(0, Vector(0, 0, 25))
end

function ENT:SetSeedBaseTabel( tabel )
	self.SeedBaseTabel = tabel
end

function ENT:GetSeedBaseTabel()
	return self.SeedBaseTabel
end

function ENT:Shake()
	local shake = ents.Create("env_shake")
	shake:SetPos(self:GetPos())
	shake:SetKeyValue("amplitude", "256")
	shake:SetKeyValue("radius", "64")
	shake:SetKeyValue("duration", "0.5")
	shake:SetKeyValue("frequency", "128")
	shake:SetKeyValue("spawnflags", "4")
	shake:Spawn()
	shake:Activate()
	shake:Fire("StartShake", "", 0)
	
	self:EmitSound("physics/body/body_medium_impact_hard"..math.random(1, 6)..".wav")
	self:WakeFruits()
end

function ENT:Plant()
	if !self:CanPlant() then return end
	self:EmitSound("physics/surfaces/sand_impact_bullet4.wav")
	self:SetModel("models/props/de_inferno/crate_fruit_break_gib2.mdl")
	self:SetMaterial("models/props_wasteland/dirtwall001a")
	self:SetPos(self:GetPos() + Vector(0, 0, -3))
	self:GetPhysicsObject():EnableMotion(false)
	self:SetCollisionGroup(COLLISION_GROUP_WORLD)
	self.Stay = 1
	self.Time = self.GrowTime
end

function ENT:Grow()
	self:EmitSound("physics/surfaces/sand_impact_bullet4.wav")
	self:SetModel(self.GrowModel)
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetPos(self:GetPos() + self.GrowVec)
	self:SetAngles(Angle(0, math.random(0, 360), 0))
	self:GetPhysicsObject():EnableMotion(false)
	self:SetMaterial("")
	self:SetColor(self.FoodColor)
	self.Stay = 2
	self.Time = self.BloomTime 
	self:SetDTVector(0, self.DrawVec)
end

function ENT:Bloom()
	local rnd_amount = math.random(self.FoodAmount[1], self.FoodAmount[2])
	for i=1, rnd_amount do
		local vec = Vector(math.random(-self.VT[1], self.VT[1]), math.random(-self.VT[1], self.VT[1]), math.random(self.VT[2], self.VT[3]))
		local pos = self:GetPos() + vec
		local ent = GenerateFoodEnt( self.Food )	
		ent:SetPos(pos)
		ent:Spawn()  
	end
	self.Stay = 3
	self.Blooms = self.Blooms - 1
end

function ENT:CanPlant()
	local traceData = {}	
	traceData.start = self:GetPos()
	traceData.endpos = self:GetPos() + Vector(0, 0, -8)
	traceData.filter = self
	local trace = util.TraceLine(traceData)
	
	return table.HasValue(matTable, trace.MatType)
end

function ENT:CanBloom()
	local fruits = 0
	local Dist = self.VT[3] - self.VT[2]
	local Up = self.VT[2] + Dist / 2
	for k, v in pairs(ents.FindInSphere(self:GetPos() + Vector(0, 0, Up), Dist)) do
		if v:GetClass() == "base_food" then
			fruits = fruits + 1
		end
	end
	if fruits == 0 then
		if self.Blooms > 0 then
			self.Stay = 2
			self.Fertilized = false
			self.Time = self.BloomTime
			return true
		else
			self:VisualEffect()
		end
		return false
	end
end

function ENT:WakeFruits()
	local Dist = self.VT[3] - self.VT[2]
	local Up = self.VT[2] + Dist / 2
	for k, v in pairs(ents.FindInSphere(self:GetPos() + Vector(0, 0, Up), Dist)) do
		if v:GetClass() == "base_food" then
			v:GetPhysicsObject():SetVelocity(v:GetUp() * 100)
		end
	end
end

function ENT:OnTakeDamage(dmginfo)
	self:VisualEffect()
end

function ENT:Use(ply)
	local curTime = CurTime()
	if curTime < self.nextUse then return end
	
	if (ply:GetEyeTrace().Entity == self) and (ply:GetPos():Distance(self:GetPos()) < HFM_Config.HUDEntDrawDistance) then
		if self.Stay == 0 then
			self:Plant()
		elseif self.Stay == 3 then
			self:Shake()
		end
	end
		
	self.nextUse = curTime + 0.5
end

function ENT:Think()
	local curTime = CurTime()
	
	if self.nextSec <= curTime then
		if self.Stay == 1 and self.Time == 0 then
			self:Grow()
		elseif self.Stay == 2 and self.Time == 0 then
			self:Bloom()
		elseif self.Stay == 3 and self.Time == 0 then
			self:CanBloom()
		end
	
		self:SetDTInt(1, self.Stay)
		self:SetDTInt(2, self.Time)
		self:SetDTInt(3, self.Blooms)
		self:SetDTBool(4, self:CanPlant())
		
		if self.Time > 0 then
			self.Time = self.Time - 1
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
	
	self:WakeFruits()
	self:EmitSound("physics/body/body_medium_break"..math.random(2, 4)..".wav")
	self:Remove()
end

--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
