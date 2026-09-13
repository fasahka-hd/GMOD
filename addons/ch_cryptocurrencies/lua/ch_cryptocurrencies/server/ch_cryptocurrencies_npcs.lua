--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

local map = string.lower( game.GetMap() )

--[[
	Spawn the crypto NPC
--]]
function CH_CryptoCurrencies.SpawnCryptoNPC()
	if not CH_CryptoCurrencies.Config.UseCryptoNPC then
		return
	end
	
	local PositionFile = file.Read( "craphead_scripts/ch_cryptocurrencies/entities/".. map .."/npc/crypto_npc.json", "DATA" )
	
	local Pos = util.JSONToTable( PositionFile )
	local TheVector = Vector( Pos.EntityVector.x, Pos.EntityVector.y, Pos.EntityVector.z )
	local TheAngle = Angle( Pos.EntityAngles.x, Pos.EntityAngles.y, Pos.EntityAngles.z )
	
	local cryptocurrency_npc = ents.Create( "ch_cryptocurrencies_npc" )
	if not IsValid( cryptocurrency_npc ) then return end
	cryptocurrency_npc:SetModel( "models/breen.mdl" )
	cryptocurrency_npc:SetPos( TheVector )
	cryptocurrency_npc:SetAngles( TheAngle )
	cryptocurrency_npc:Spawn()
	cryptocurrency_npc:SetMoveType( MOVETYPE_NONE )
	cryptocurrency_npc:SetSolid( SOLID_BBOX )
	cryptocurrency_npc:SetCollisionGroup( COLLISION_GROUP_PLAYER )
end

--[[
	Console command to set NPC position
--]]
local function CH_CryptoCurrencies_SetNPCPos( ply )
	if not ply:IsAdmin() then
		CH_CryptoCurrencies.NotifyPlayer( ply, CH_CryptoCurrencies.LangString( "Only administrators can perform this action!" ) )
		return
	end
	
	local Entity_Position = {
		EntityVector = {
			x = ply:GetPos().x,
			y = ply:GetPos().y,
			z = ply:GetPos().z,
		},
		EntityAngles = {
			x = ply:GetAngles().x,
			y = ply:GetAngles().y,
			z = ply:GetAngles().z,
		},
	}
	
	file.Write( "craphead_scripts/ch_cryptocurrencies/entities/".. map .."/npc/crypto_npc.json", util.TableToJSON( Entity_Position ), "DATA" )
	
	CH_CryptoCurrencies.NotifyPlayer( ply, CH_CryptoCurrencies.LangString( "New position for the crypto NPC has been succesfully set!" ) )
	CH_CryptoCurrencies.NotifyPlayer( ply, CH_CryptoCurrencies.LangString( "The NPC will respawn in 5 seconds. Move out the way." ) )
	
	-- Respawn the NPC after 5 seconds
	-- 76561198845136653
	for k, v in ipairs( ents.FindByClass( "ch_cryptocurrencies_npc" ) ) do
		if IsValid( v ) then
			v:Remove()
		end
	end
	
	timer.Simple( 5, function()
		CH_CryptoCurrencies.SpawnCryptoNPC()
		
		if IsValid( ply ) then
			CH_CryptoCurrencies.NotifyPlayer( ply, "The NPC has been respawned." )
		end
	end )
end
concommand.Add( "ch_cryptocurrencies_setnpcpos", CH_CryptoCurrencies_SetNPCPos )

local function CH_CryptoCurrencies_RespawnNPCCleanup()
	MsgC( Color( 52, 152, 219 ), "CryptoCurrencies by Crap-Head | ", color_white, "Map cleaned up. Respawning crypto NPC.\n")
	
	timer.Simple( 1, function()
		CH_CryptoCurrencies.SpawnCryptoNPC()
		
		CH_CryptoCurrencies.SpawnCurrencyScreens()
	end )
end
hook.Add( "PostCleanupMap", "CH_CryptoCurrencies_RespawnNPCCleanup", CH_CryptoCurrencies_RespawnNPCCleanup )

--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
