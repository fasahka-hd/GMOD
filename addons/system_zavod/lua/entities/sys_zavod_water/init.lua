--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()
	self:SetModel("models/props_junk/PopCan01a.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	local phys = self:GetPhysicsObject()
	phys:Wake()
	-- предотвращение абуза
	self:SetUseType( SIMPLE_USE )
	-- автоудаление чтобы не спамили	
	timer.Simple(15, function()
		if IsValid( self ) then
			self:Remove()
		end
	end)
	self.LastUse = 0
	self.Delay = 2
	
end

function ENT:Use(activator)
-- таймер для предотвращения абуза
	if self.LastUse <= CurTime() then
		self.LastUse = CurTime() + self.Delay
		
		DarkRP.notify(activator, 3, 3, "Заполните рацион едой и водой.")
		timer.Simple(1.2, function()
		
			DarkRP.notify(activator, 3, 3, "Далее - положите заполненный рацион в коробку.")
		
		end)
		
	end
end


--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
