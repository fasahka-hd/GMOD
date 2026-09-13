AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()
	self:SetModel(self.Model)
	self:SetHullType(HULL_HUMAN)
	self:SetHullSizeNormal()
	self:SetNPCState(NPC_STATE_SCRIPT)
	self:SetSolid(SOLID_BBOX)
	self:SetMoveType(MOVETYPE_STEP)
	self:SetUseType(SIMPLE_USE)
	self:CapabilitiesAdd(CAP_ANIMATEDFACE + CAP_TURN_HEAD)
	self:SetMaxYawSpeed(90)
	self:DrawShadow(true)

	self:SetHealth(100)
	self.AutomaticFrameAdvance = true

	self:ApplyIdlePose()
	timer.Simple(0.1, function()
		if IsValid(self) then self:ApplyIdlePose() end
	end)
end

function ENT:PickIdleSequence()
	local candidates = { "idle_all_01", "idle_subtle", "idle_all_02", "LineIdle01" }
	for _, name in ipairs(candidates) do
		local seq = self:LookupSequence(name)
		if seq and seq > 0 then return seq end
	end
	local seq = self:SelectWeightedSequence(ACT_IDLE)
	if seq and seq > 0 then return seq end
	return nil
end

function ENT:ApplyIdlePose()
	local seq = self.PickedIdleSeq or self:PickIdleSequence()
	if not seq then return end
	self.PickedIdleSeq = seq
	self:ResetSequence(seq)
	self:SetCycle(math.Rand(0, 1))
	self:SetPlaybackRate(1)
	self:SetPoseParameter("move_yaw", 0)
end

function ENT:RunAI(strExp)
end

function ENT:BodyUpdate()
end

function ENT:Think()
	if SERVER and self.PickedIdleSeq and self:GetSequence() ~= self.PickedIdleSeq then
		self:ResetSequence(self.PickedIdleSeq)
		self:SetPlaybackRate(1)
	end
	self:NextThink(CurTime() + 0.05)
	return true
end

function ENT:AcceptInput(name, activator, caller)
	if name ~= "Use" then return end
	if not IsValid(activator) or not activator:IsPlayer() then return end

	self:Use(activator, caller)
end

function ENT:Use(activator)
	if not IsValid(activator) or not activator:IsPlayer() then return end

	activator.DuelsNextNpc = activator.DuelsNextNpc or 0
	if activator.DuelsNextNpc > CurTime() then return end
	activator.DuelsNextNpc = CurTime() + 0.5

	if not Duels or not Duels.SendMenu then return end

	if activator:InDuel() then
		Duels.Notify(activator, "Вы уже участвуете в дуэли!")
		return
	end

	Duels.SendMenu(activator)
end

function ENT:OnTakeDamage()
	return 0
end

function ENT:OnRemove()
end