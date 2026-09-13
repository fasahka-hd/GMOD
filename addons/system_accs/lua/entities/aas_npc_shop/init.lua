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

function ENT:Initialize()
	self:SetModel(AAS.ItemNpcModel)
	self:SetHullType(HULL_HUMAN)
	self:SetHullSizeNormal()
	self:SetNPCState(NPC_STATE_SCRIPT)
	self:SetSolid(SOLID_BBOX)
	self:SetUseType(SIMPLE_USE)
end

function ENT:Use(activator) 
	activator.AASSpam = activator.AASSpam or CurTime()
    if activator.AASSpam > CurTime() then return end 
    activator.AASSpam = CurTime() + 1

	net.Start("AAS:Main")
		net.WriteUInt(2, 5)
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
