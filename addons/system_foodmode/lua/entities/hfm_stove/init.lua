--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( 'shared.lua' )

function ENT:Initialize()
	self:SetModel( "models/ent/stove.mdl" )
	self.Entity:PhysicsInit(SOLID_VPHYSICS)
	self.Entity:SetMoveType(MOVETYPE_VPHYSICS)
	self.Entity:SetSolid(SOLID_VPHYSICS)
	self.Entity:DrawShadow(false)
	
	self.Pots = {}
end

function ENT:Setowning_ent(ply)
	self:CPPISetOwner(ply)
end

function ENT:GetFreeSlot()
	for k = 1, 6 do
		if !self.Pots[k] then
			return k
		end
	end
end

function ENT:DoCook(luaname, slot, ply)
	slot = slot or self:GetFreeSlot()
	if !slot then return end
	if self.Pots[slot] then return end

	local PS = self:LocalToWorld( HFMPotPositions[slot] )
		
	local Pot = ents.Create("hfm_pot")
	local POS = self:LocalToWorld( PS )
	Pot:SetPos( PS )
	Pot:SetAngles( Angle(self:GetAngles().x, self:GetAngles().y + 45, 0) )
	Pot:Spawn()
	Pot:SetParent(self)
	Pot.luaname = luaname
	Pot.CreatedTime = CurTime()
	Pot:EmitSound("ambient/fire/ignite.wav", 80)
		
	self.Pots[slot] = Pot
		
	if ply and ply:IsValid() then
		self:OpenMenu(ply)
	end
	
	timer.Simple(HFMGetTable(luaname).CookingTime,function()
		if self and self:IsValid() then
			self:EmitSound("buttons/button11.wav")
		end
	end)
	
	timer.Simple(HFMGetTable(luaname).CookingTime + HFM_Config.StoveBurnTime,function()
		if self and self:IsValid() and Pot and Pot:IsValid() then
			Pot:SetDTBool(0,true)
		end
	end)
end

function ENT:Use(ply)
	if ( ply:Team() != TEAM_COOK or ply != self:CPPIGetOwner() ) then return end
	if ( ply:GetEyeTrace().Entity == self ) and ( ply:GetPos():Distance( self:GetPos() ) < HFM_Config.HUDEntDrawDistance ) then
		self:OpenMenu(ply)
	end
end

--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
