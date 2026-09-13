--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

/*-----------------------------------------------------------------------------------------------
--Name of the addon: Machines mod
--email: miguelgrafe001@hotmail.com {Contact me if you have any problem}
	
--License: You can use this addon for your server, but never sell to others or leak it.
	
--Info: In this file you can edit the settings of the coffe machine.
	
--I´m sorry if i wrote something bad in English. (English isn´t my native language)
-----------------------------------------------------------------------------------------------*/
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( "shared.lua" )

function ENT:Initialize()
	self:SetModel( "models/props_interiors/VendingMachineSoda01a.mdl" )
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )
	self:SetUseType( SIMPLE_USE )
	self:DropToFloor()
end


function ENT:StartTouch(ent)
	if ent:IsValid() and not ent:IsPlayer() then
		ent:Remove()
	end
end

ENT.Once = false
function ENT:Use( ply, activator )
	if timer.Exists(self:EntIndex() .. "cm_coffe") then return end
	local coffeprice = cm.coffeprice
	
	if not activator:canAfford( coffeprice ) then
		DarkRP.notify( ply, 1, 4, "You can't afford a coffe!" )
		return ""
	end
	
	self.Once = true
	
	activator:addMoney( -coffeprice, 'Покупка кофе' )
	DarkRP.notify( ply, 1, 4, "Вы купили кофе за ".. coffeprice .. "$" )
	activator:EmitSound("items/ammocrate_close.wav", 50, 100)
	timer.Create( self:EntIndex() .. "cm_coffe", 1.5, 1, function()
		if not IsValid(self) then return end
		self:CreateCoffe()
	end )
end

function ENT:CreateCoffe()
	self.Once = false
	local pos, ang = LocalToWorld( Vector(24,-5,-25), Angle( -90, -90, 0 ), self:GetPos(), self:GetAngles() )
	local coffe = ents.Create( "cm_coffe" )
	coffe:SetPos( pos )
	coffe:SetAngles( ang )
	coffe:Spawn()
end

function ENT:OnRemove()
	if not IsValid(self) then return end
	timer.Destroy( self:EntIndex() .. "cm_coffe" )
end

--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
