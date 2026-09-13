--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()
	self:SetModel("models/props_junk/wood_crate001a.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetUseType( SIMPLE_USE )
	local phys = self:GetPhysicsObject()
	phys:EnableMotion(false)
end

function ENT:Use(ply)
	if IsValid(ply) and ply:IsPlayer() and ply:Alive() and (self:GetPos():Distance(ply:GetPos()) < 130) and (ply:IsArrested() or ply:Team() == TEAM_GRUZCHIK) then
		if ply:GetNWBool("TakeBox", false) == false then
			ply:SetNWBool("TakeBox", true)
			ply.OldWalkSpeed = ply:GetWalkSpeed()
			ply.OldRunSpeed = ply:GetRunSpeed()
			ply.OldMaxSpeed = ply:GetMaxSpeed()

			ply:SetMaxSpeed(ply.OldWalkSpeed * .4)
			ply:SetWalkSpeed(ply.OldWalkSpeed * .4)
			ply:SetRunSpeed(ply.OldWalkSpeed * .4)
			ply:SetCanWalk( false )
			ply:Give("rp_box_in_hands")
			ply:SelectWeapon("rp_box_in_hands")
			ply:ChatPrint( "Теперь отнеси коробку в соседнюю комнату. Пытайся не бегать с ней!")
		else
			ply:ChatPrint("Ты слишком хилый что бы нести больше одной коробки.")
		end
	end
end

--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
