--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

local lang = GmodEats.Config.Language
local sentences = GmodEats.Config.Lang

function ENT:Initialize()

	self:SetModel("models/anthon/gmod_eats_bag.mdl")
	self:SetSkin(1)
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetUseType(SIMPLE_USE)
	
	local phys = self:GetPhysicsObject()
	
	if phys:IsValid() then
	
		phys:Wake()
		
	end
	
end

function ENT:Use(a,c)
	
	if GmodEats.Config.LimitedToJob and not table.HasValue(GmodEats.Config.Jobs, c:Team()) then return end

	if not IsValid( self:GetPlayer() ) then self:SetPlayer(c) end
	
	if IsValid(self:GetPlayer()) and self:GetPlayer() != c then c:UE_Notif(sentences["You can't take this backpack"][lang]) return end
	
	c:Give("uber_eat_bag_weap")
	
	self:Remove()
end

function ENT:OnRemove()
	
	local ply = self:GetPlayer()
	
	if IsValid( ply ) then
		
		ply.ListMissions = ply.ListMissions or {}		
			
		for k, v in pairs( ply.ListMissions ) do 
		
			local ent = GmodEats.Config.ClientPos[v.Client].Entity  or NULL
			
			if IsValid( ent ) then ent:Remove() end
			
			GmodEats.Config.ClientPos[v.Client].NotFree = false
			
		end
		
	end
	
end

--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
