--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

ENT.Type = "anim"
ENT.RenderGroup = RENDERGROUP_TRANSLUCENT

ENT.PrintName = "Bank"
ENT.Category = "RP"

ENT.Spawnable = true
ENT.AdminOnly = true

if SERVER then
	AddCSLuaFile()

	function ENT:Initialize()
		self:SetModel( "models/props_c17/Lockers001a.mdl" )

		self:PhysicsInit( SOLID_VPHYSICS )
		self:SetMoveType( MOVETYPE_VPHYSICS )
		self:SetSolid( SOLID_VPHYSICS )
		self:SetUseType( SIMPLE_USE )

		self:GetPhysicsObject():EnableMotion( false )
	end

	function ENT:SpawnFunction( pl, trace, class )
		local ent = ents.Create( class )
		ent:SetPos( trace.HitPos + trace.HitNormal * 16 )
		ent:Spawn()

		return ent
	end

	function ENT:Use( pl )
		if not IsValid( pl ) then return end

		pl.Bank:Sync()
		pl:OpenContainer( pl.Bank:GetID(), itemstore.Translate( "bank" ) )
	end

	concommand.Add( "itemstore_savebanks", function( pl )
		if not game.SinglePlayer() and IsValid( pl ) then return end

		local banks = {}

		for _, ent in ipairs( ents.FindByClass( "itemstore_bank" ) ) do
			table.insert( banks, {
				Position = ent:GetPos(),
				Angles = ent:GetAngles()
			} )
		end

		file.Write( "itemstore/banks/" .. game.GetMap() .. ".txt", util.TableToJSON( banks ) )

		print( "Banks for map " .. game.GetMap() .. " saved." )
	end )

	hook.Add( "InitPostEntity", "ItemStoreSpawnBanks", function()
		local banks = util.JSONToTable( file.Read( "itemstore/banks/" .. game.GetMap() .. ".txt", "DATA" ) or "" ) or {}

		for _, data in ipairs( banks ) do
			local bank = ents.Create( "itemstore_bank" )
			bank:SetPos( data.Position )
			bank:SetAngles( data.Angles )
			bank:Spawn()
		end
	end )
else
	function ENT:DrawTranslucent()
	    self:DrawModel()
		local dist = (LocalPlayer():GetShootPos() - self.Entity:GetPos()):Length()
		if (dist > 300) then return end
		if ( IsValid( self ) && LocalPlayer():GetPos():Distance( self:GetPos() ) < 500 ) then

		    local ang = Angle( 0, ( LocalPlayer():GetPos() - self:GetPos() ):Angle()[ "yaw" ], ( LocalPlayer():GetPos() - self:GetPos() ):Angle()[ "pitch" ] ) + Angle( 0, 90, 90 )

		    cam.IgnoreZ( false )
		    cam.Start3D2D( self:GetPos() + Vector( 0, 0, 50 ), ang, .4 )
		        draw.SimpleTextOutlined( "БАНК", "TargetID", 0, 0, Color(255,255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, .5, Color( 0, 0, 0, 255 ) )
		    cam.End3D2D()
		end
	end
end


--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
