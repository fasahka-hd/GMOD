--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

libfuse = libfuse or {}
util.AddNetworkString"LibFuse:set_status"
sql.Query( "CREATE TABLE IF NOT EXISTS libfuse_status ( SteamID TEXT, Status TEXT, Color TEXT )" )
print("prefix load")
function libfuse.SaveToDB( ply, status, color )
	local data = sql.Query( "SELECT Status FROM libfuse_status WHERE SteamID = " .. sql.SQLStr( ply:SteamID() ) .. ";")
	if ( data ) then
		sql.Query( "UPDATE libfuse_status SET Status = " .. sql.SQLStr(status) .. " WHERE SteamID = " .. sql.SQLStr( ply:SteamID() ) .. ";" )
		sql.Query( "UPDATE libfuse_status SET Color = " .. sql.SQLStr(color) .. " WHERE SteamID = " .. sql.SQLStr( ply:SteamID() ) .. ";" )
	else
        sql.Query("INSERT INTO libfuse_status (SteamID, Status, Color) VALUES(" .. sql.SQLStr(ply:SteamID()) .. ", " .. sql.SQLStr(status) .. ", " .. sql.SQLStr(color) .. ")")
	end
end

function libfuse.LoadFromDB( ply )
	local val = sql.QueryValue( "SELECT Status FROM libfuse_status WHERE SteamID = " .. sql.SQLStr( ply:SteamID() ) .. ";" )
	local val2 = sql.QueryValue( "SELECT Color FROM libfuse_status WHERE SteamID = " .. sql.SQLStr( ply:SteamID() ) .. ";" )

	return {
		["status"] = val,
		["color"] = val2
	}
end

function libfuse.RemoveFromDB( ply )
    sql.QueryValue( "DELETE FROM libfuse_status WHERE SteamID = " .. sql.SQLStr( ply:SteamID() ) .. ";" )
end

function libfuse.PrintFromDB( ply )
	print( sql.QueryValue( "SELECT Status FROM libfuse_status WHERE SteamID = " .. sql.SQLStr( ply:SteamID() ) .. ";" ) )
end

hook.Add('PlayerInitialSpawn', 'status', function(ply)
	local tbltojson = util.TableToJSON(libfuse.LoadFromDB(ply))
    ply:SetNWString('status', tbltojson)
end)

net.Receive('LibFuse:set_status', function(len, ply)
	if ply.status_limit == nil then ply.status_limit = 0 end
	if ply.status_limit > CurTime() then return ply:ChatPrint("Ты в кд") end
    local gov = net.ReadString()
	local color = net.ReadTable()
    if string.len(gov) * 2 > 40 then return ply:ChatPrint("Крч слишком длинный префикс иди нахуй") end

	libfuse.SaveToDB(ply, gov, util.TableToJSON(color))

	local qweee = util.TableToJSON(libfuse.LoadFromDB(ply))
    ply:SetNWString('status', qweee)
	ply:ChatPrint("Установил тебе новый префикс.")
	ply.status_limit = CurTime() + 5
end)


// HOW TO SAVE
-- local tbl_test = Color(255,0,0)
-- libfuse.SaveToDB(Entity(1), "lol", util.TableToJSON(tbl_test))

// HOW TO GET
-- PrintTable( libfuse.LoadFromDB(Entity(2)) )
-- local bbb = util.JSONToTable(libfuse.LoadFromDB(Entity(2))["color"])
-- print(bbb.r, bbb.g, bbb.b)

// CLIENT GET
-- local kasanov_info = util.JSONToTable(Entity(2):GetNWString('status', tbltojson))
-- PrintTable(kasanov_info)

--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
