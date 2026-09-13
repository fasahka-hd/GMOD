--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

local gps_pos = gps_pos or {}

util.AddNetworkString("JustRP.SendMyGpsPoint")
local function UpdateGPSPoints()
	net.Start("JustRP.SendMyGpsPoint")
		net.WriteTable(gps_pos)
	net.Broadcast()
end

-- concommand.Add("GPS_AddMyPoint",function(ply,cmd,args)
-- 	local pname = "Моя позиция"
-- 	if args[1] ~= nil then
-- 		pname = args[1] or nil
-- 		if string.len(pname) > 60 then 
-- 			pname = "Моя позиция"
-- 			ply:rp_send_message(Color(0,255,128),"[GPS] ", Color(255,255,255), "Ошибка слишком большое название!")
-- 		end
-- 	end
-- 	if not ply.HasGPSPoint and ply:Alive() then
-- 		gps_pos[ply:SteamID64()] = {name = pname, pl = ply, pos = ply:GetPos()}
-- 		UpdateGPSPoints()
-- 		ply.HasGPSPoint = true
-- 		ply:rp_send_message(Color(0,255,128),"[GPS] ", Color(255,255,255), "Ваша точка GPS была ",Color(0,255,0),"создана!")
-- 	else
-- 		gps_pos[ply:SteamID64()] = {name = pname, pl = ply, pos = ply:GetPos()}
-- 		UpdateGPSPoints()
-- 		ply:rp_send_message(Color(0,255,128),"[GPS] ", Color(255,255,255), "Ваша прошлая точка GPS была ",Color(200,200,0),"обновлена!")
-- 	end
-- end)

-- concommand.Add("GPS_RemoveMyPoint",function(ply,cmd,args)
-- 	if ply.HasGPSPoint then
-- 		gps_pos[ply:SteamID64()] = nil
-- 		UpdateGPSPoints()
-- 		ply.HasGPSPoint = false
-- 		ply:rp_send_message(Color(0,255,128),"[GPS] ", Color(255,255,255), "Ваша точка GPS была ",Color(200,0,0),"удалена!")
-- 	else
-- 		ply:rp_send_message(Color(0,255,128),"[GPS] ", Color(255,255,255), "У вас нету GPS точки.")
-- 	end
-- end)

net.Receive("JustRP.SendMyGpsPoint",function(len,ply)
	if ply.gps_loaded then return end
	net.Start("JustRP.SendMyGpsPoint")
		net.WriteTable(gps_pos)
	net.Send(ply)
	ply.gps_loaded = true
end)

hook.Add("PlayerDisconnected","RemoveGPSPos",function(p)
	if gps_pos[p:SteamID64()] ~= nil then
		gps_pos[p:SteamID64()] = nil
		UpdateGPSPoints()
	end
end)

-- hook.Add("PlayerDeath","RemoveGPSPos_Death",function(victim, inflictor, attacker)
-- 	if gps_pos[victim:SteamID64()] ~= nil then
-- 		gps_pos[victim:SteamID64()] = nil
-- 		UpdateGPSPoints()
-- 		victim:rp_send_message(Color(0,255,128),"[GPS] ", Color(255,255,255), "Ваша точка GPS была ",Color(200,0,0),"удалена!")
-- 	end
-- end)

--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
