--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

local meta = FindMetaTable("Player")

if SERVER then
	util.AddNetworkString( "HFM_Sync" )
	function meta:FMSyncVar(var,data)
		local TB2Send = {}
		TB2Send.var = var
		TB2Send.data = data
		net.Start( "HFM_Sync" )
			net.WriteString(util.TableToJSON(TB2Send))
		net.Send(self)
	end
else
	net.Receive( "HFM_Sync", function( len, ply )
		if !LocalPlayer() or !LocalPlayer():IsValid() then return end
		
		local Data = util.JSONToTable(net.ReadString())
		LocalPlayer().HFMVars = LocalPlayer().HFMVars or {}
		LocalPlayer().HFMVars[Data.var] = Data.data
	end)
	function meta:HFMGetVar(luaname)
		if !LocalPlayer() or !LocalPlayer():IsValid() then return 0 end
		
		LocalPlayer().HFMVars = LocalPlayer().HFMVars or {}
		return LocalPlayer().HFMVars[luaname] or 0
	end
end

--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
