--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

--leak by matveicher
--vk group - https://vk.com/slivaddonov
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds - matveicher#5801

AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

ENT.AutomaticFrameAdvance = true 

function ENT:Initialize()
	self:SetModel(AAS.BodyGroupModel)
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetUseType(SIMPLE_USE)

	local AASPhys = self:GetPhysicsObject()
	if not IsValid(AASPhys) then return end 
	AASPhys:EnableMotion(false)
	AASPhys:Wake()
end

function ENT:Use(activator)
	if AAS.BlackListBodyGroup[team.GetName(activator:Team())] then activator:AASNotify(5, AAS.GetSentence("jobProblem")) return end

	activator.AASSpam = activator.AASSpam or CurTime()
    if activator.AASSpam > CurTime() then return end 
    activator.AASSpam = CurTime() + 1

	net.Start("AAS:Main")
		net.WriteUInt(4, 5)
	net.Send(activator)
end
--leak by matveicher
--vk group - https://vk.com/slivaddonov
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds - matveicher#5801


--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
