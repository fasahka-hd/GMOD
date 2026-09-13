--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( "shared.lua" )

function ENT:Initialize()
	self:SetHullType( HULL_HUMAN )
	self:SetHullSizeNormal()
	self:SetNPCState( NPC_STATE_SCRIPT )
	self:SetSolid( SOLID_BBOX )
	self:CapabilitiesAdd( CAP_ANIMATEDFACE )
	self:DropToFloor()
	self:SetMaxYawSpeed( 90 )
	self:SetCollisionGroup( COLLISION_GROUP_NONE )
end

function ENT:AcceptInput( string, ply )
	if IsValid( ply ) and ply:IsPlayer() and ( self.LastUsed or CurTime() ) <= CurTime() then
		self.LastUsed = CurTime() + 1.5
		
		net.Start( "CH_CryptoCurrencies_ShowCryptoMenu" )
		net.Send( ply )
	end
end

function ENT:OnTakeDamage( dmg )
	return 0
end

--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
