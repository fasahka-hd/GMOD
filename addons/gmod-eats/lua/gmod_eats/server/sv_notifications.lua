--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

local meta = FindMetaTable( "Player" )

util.AddNetworkString("GmodEats.NotifyPlayer")

function meta:UE_Notif( msg, time )
	
	local ply = self
	
	if not IsValid( ply ) or not ply:IsPlayer() then return end
	
	msg = msg or ""
	time = time or 5
	
	net.Start("GmodEats.NotifyPlayer")
		net.WriteString( msg )
		net.WriteInt( time, 32 )
	net.Send( ply )
end

--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
