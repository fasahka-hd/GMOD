local bannedIPs = {}

local bannedIPsFile = "banned_ips.txt"

local function LoadBannedIPs()
    if file.Exists(bannedIPsFile, "DATA") then
        local data = file.Read(bannedIPsFile, "DATA")
        bannedIPs = util.JSONToTable(data) or {}
    else
        bannedIPs = {}
    end
end

local function SaveBannedIPs()
    local data = util.TableToJSON(bannedIPs, true)
    file.Write(bannedIPsFile, data)
end

local function BanIP(ip, reason)
    bannedIPs[ip] = reason or "No reason specified"
    SaveBannedIPs()
end

local function UnbanIP(ip)
    bannedIPs[ip] = nil
    SaveBannedIPs()
end

local function IsIPBanned(ip)
    return bannedIPs[ip] ~= nil
end

hook.Add("CheckPassword", "BlockBannedIPs", function(steamID64, ipAddress)
    local ip = string.match(ipAddress, "^([^:]+)")
    if IsIPBanned(ip) then
        return false, "Ваш IP-адрес заблокирован: " .. bannedIPs[ip]
    end
end)

concommand.Add("banip", function(ply, cmd, args)
    if IsValid(ply) and not ply:IsSuperAdmin() then
        ply:ChatPrint("У вас нет прав для использования этой команды.")
        return
    end

    local ip = args[1]
    local reason = table.concat(args, " ", 2)

    if not ip then
        print("Использование: banip <IP> [причина]")
        return
    end

    BanIP(ip, reason)
    print("IP " .. ip .. " был забанен. Причина: " .. (reason or "Не указана"))
end)

concommand.Add("unbanip", function(ply, cmd, args)
    if IsValid(ply) and not ply:IsSuperAdmin() then
        ply:ChatPrint("У вас нет прав для использования этой команды.")
        return
    end

    local ip = args[1]

    if not ip then
        print("Использование: unbanip <IP>")
        return
    end

    UnbanIP(ip)
    print("IP " .. ip .. " был разбанен.")
end)

LoadBannedIPs()
