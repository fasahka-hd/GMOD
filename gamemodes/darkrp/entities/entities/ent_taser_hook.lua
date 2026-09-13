--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

AddCSLuaFile()
ENT.Type = "anim"
local Tmodel = Model("models/props_c17/TrapPropeller_Lever.mdl")
local Tsound = Sound("ambient/energy/spark5.wav")

function ENT:SetupDataTables()
	self:NetworkVar("Int", 0, "Damage")
end

function ENT:GravGunPickupAllowed()
	return false
end

function ENT:Initialize()
	self:SetModel(Tmodel)
	self:SetMoveType(MOVETYPE_FLYGRAVITY)
	self:SetSolid(SOLID_NONE)
	self:PhysicsInit(SOLID_NONE)
	self:DrawShadow(false)
end


if CLIENT then return end

hook.Add("CanPlayerSuicide", "GS-Taser-CanPlayerSuicide", function(ply)
	if (IsValid(ply) and ply.Tased) then return false end
end)

hook.Add("DoPlayerDeath", "GS-Taser-DoPlayerDeath", function(ply)
	if (IsValid(ply) and ply.Tased) then
		ResetPlayer(ply)
	end
end)

--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
