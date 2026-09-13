--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

rp_box = {}

if SERVER then
	util.AddNetworkString( "PlayerDisplayChat" )
	local PLAYER = FindMetaTable( "Player" )
	if PLAYER then
	    function PLAYER:SendMessageFD( ... )
	         local args = { ... }
	         net.Start( "PlayerDisplayChat" )
	             net.WriteTable( args )
	         net.Send( self )
	    end
	end
end

if CLIENT then
	net.Receive( "PlayerDisplayChat", function()
	    local args = net.ReadTable()
	    chat.AddText( unpack( args ) )
	end )
end

--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
