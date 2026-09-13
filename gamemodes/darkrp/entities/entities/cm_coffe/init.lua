--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

/*-----------------------------------------------------------------------------------------------
	Name of the addon: Machines mod
	email: miguelgrafe001@hotmail.com {Contact me if you have any problem}
	
	License: You can use this addon for your server, but never sell to others or leak it.
	
	Info: In this file you can edit the settings of the coffe machine.
	
	I´m sorry if i wrote something bad in English. (English isn´t my native language)
-----------------------------------------------------------------------------------------------*/
AddCSLuaFile("shared.lua")
include( "shared.lua" )

function ENT:Initialize()
	self:SetModel("models/props_junk/PopCan01a.mdl")
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )
	self:SetUseType( SIMPLE_USE )
	self:SetCollisionGroup(COLLISION_GROUP_WORLD)
	
	self.health = 10
	
	local phys = self:GetPhysicsObject()
	if phys:IsValid() then
		phys:Wake()
	end
end

function ENT:OnTakeDamage(dmg)
	self.health = self.health - dmg:GetDamage()
	if ( self.health <= 0 ) then
		self:Remove()
	end
end

function ENT:Use( activator )
	timer.Simple( 0, function()
		activator:EmitSound( "items/ammocrate_open.wav", 50, 100 )
	end )
	
	if cm.enablehunger == true then
		activator:HFM_AddHunger(cm.coffeenergy, 1)
	end
	
	self:Remove()
end

--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
