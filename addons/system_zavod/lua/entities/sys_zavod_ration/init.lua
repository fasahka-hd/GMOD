--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()

	self:SetModel("models/weapons/w_package.mdl")

	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetUseType( SIMPLE_USE )

	local phys = self:GetPhysicsObject()
	phys:Wake()

	self:SetNWInt("RWater", 0)
	self:SetNWInt("RFood", 0)

	timer.Simple(15, function() if IsValid( self ) then self:Remove() end end)

	self.LastUse = 0
	self.Delay = 2

end

function ENT:Use(activator)

	if self.LastUse <= CurTime() then
		if activator:Team() != TEAM_ZAVOD then return end

		if self:GetNWInt("RWater") == 0 or self:GetNWInt("RFood") == 0 then return end

		activator:SetNWBool("userat", true)
		activator:SendLua([[RationMenu()]])

		self.LastUse = CurTime() + self.Delay
		self:Remove()
	end
end

function ENT:StartTouch( hitEnt )
	if hitEnt:GetClass() == "sys_zavod_water" && self:GetNWInt("RWater") == 0 then
		self:EmitSound("items/medshot4.wav");
		self:SetNWInt("RWater", 1)
		hitEnt:Remove()
	end
	if hitEnt:GetClass() == "sys_zavod_food" && self:GetNWInt("RFood") == 0 then
		self:EmitSound("items/medshot4.wav");
		self:SetNWInt("RFood", 1)
		hitEnt:Remove()
	end
end


--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
