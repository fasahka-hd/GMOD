local nextlog = 0
local net_cache = 65
local net_log = false

local bn = {
	["Cuffs_GagPlayer"] = true,
	["Cuffs_FreePlayer"] = true,
	["properties"] = true,
	["Keypad"] = true,
	["PlayerIsLoaded"] = true,
	["rp.RunCommand"] = true,
	["AdvBone_ToolBoneManip_SendToSv"] = true,
	["AdvBone_EntBoneInfoTable_GetFromSv"] = true,
	["VC_StatesRequestInit"] = true,
	["VC_SetStateBool"] = true,
	["DpcPoseSelect"] = true,
}

local actmodPrefixes = {
	"A_AM.ActMod",
	"ActMod",
	"ClToSv_",
	"SvToCl_",
	"CToS_",
	"SToC_",
	"AM_",
	"avs_",
	"LTD.",
	"wts",
	"nwp",
	"aLAT",
	"iError",
	"i_MenuTErr",
	"CHangeMap",
	"CancelCamera",
	"EndActSV",
	"GetAllErrTabAct",
	"GetLisGpNow",
	"GetLogs",
	"GetTableFromPly",
	"LoadSutep",
	"Logs",
	"Ply",
	"ReLoadLua",
	"ReYourListPly",
	"SCVCom",
	"SC_T_PlyP_ToCl",
	"SGTab",
	"SLSBListD",
	"SandDataKeysTSV",
	"SetTCl_MountedSV",
	"StopAct",
	"StpGtur",
	"StratAct",
}

local function IsActmodNet(strName)
	for _, prefix in ipairs(actmodPrefixes) do
		if string.StartWith(strName, prefix) then return true end
	end
	return false
end

function net.Incoming( len, client )

	local i = net.ReadHeader()
	local strName = util.NetworkIDToString( i )

	if ( !strName ) then return end

	local func = net.Receivers[ strName:lower() ]
	if ( !func ) then return end

	len = len - 16

	local cache = client.netcache and client.netcache + 1 or 1
	if net_log then
		MsgC(RED, "[Net]", WHITE, "От " .. client:Nick() .. " (" .. client:SteamID64() .. ") [", RED, cache .. "/" .. net_cache, WHITE, "] | ", RED, strName, WHITE, " | Len - ", RED,  len .. "\n")
	end

	if not bn[strName] and not IsActmodNet(strName) then
		client.netcache = client.netcache and client.netcache + 1 or 1

		if cache > net_cache then
			if CurTime() > nextlog then
				local Timestamp = os.time()
				local TimeString = os.date( "%H:%M:%S - %d/%m/%Y" , Timestamp )

				file.Append("net_logger.txt", client:Nick() .." (".. client:SteamID() .. ") - ".. TimeString .. "  NET: " .. strName .."\n")
				nextlog = CurTime() + 15
			end

			client:Kick("Пока-пока")
		end
	end

	func( len, client )
end

timer.Create("net_logger.clear_cache", 15, 0, function()
	for k,v in ipairs(player.GetAll()) do
		if not IsValid(v) then continue end
		v.netcache = 0
	end

	if net_log then
		MsgC(RED, "[Net]", WHITE, "Кэш был очищен!\n")
	end
end)

concommand.Add("net_cache",function(ply,cmd,args)
	if IsValid(ply) and not ply:HasAccess('*') then return end

	local a = tonumber(args[1])
	if not type(a) == "number" then return end
	if a < 20 then a = 20 end

	net_cache = a
	print("[AntiNetFlooder] Кэш сейчас - " .. a)
	if IsValid(ply) then ply:ChatPrint("[AntiNetFlooder] Кэш сейчас - " .. a) end
end)

concommand.Add("net_log",function(ply,cmd,args)
	if IsValid(ply) and not ply:HasAccess('*') then return end

	local a = args[1]
	if a == "1" then
		net_log = true
		print("Логирование включено!")
		if IsValid(ply) then
			ply:ChatPrint("[AntiNetFlooder] Логирование - ВКЛ")
		end
	else
		net_log = false
		if IsValid(ply) then
			ply:ChatPrint("[AntiNetFlooder] Логирование - ВЫКЛ")
		end
		print("Логирование выключено!")
	end
end)