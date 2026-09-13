--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

util.AddNetworkString('rAdminDb.sendData')
rAdminDb.onlineInfo = rAdminDb.onlineInfo or {}
rAdminDb.onlineInfoSteamIDMap = rAdminDb.onlineInfoSteamIDMap or {}

local tag = 'rAdminDb'

function rAdminDb.addToWatchlist(ply)
    local steamid = ply:SteamID()
    if rAdminDb.onlineInfoSteamIDMap[steamid] then
        return
    end

    local info = {
        steamid = steamid,
        nick = ply:Nick(),
        online = 0,
        reports = 0,
    }

    local newIndex = #rAdminDb.onlineInfo + 1
    rAdminDb.onlineInfo[newIndex] = info
    rAdminDb.onlineInfoSteamIDMap[steamid] = newIndex
    return info
end

function rAdminDb.getAdminInfo(ply)
    return rAdminDb.onlineInfo[rAdminDb.onlineInfoSteamIDMap[ply:SteamID()]]
end

local function setAdminMode(ply, mode)
    local info = rAdminDb.getAdminInfo(ply)
    if not info then
        return
    end

    if mode then
        if info.countTimeFrom then
            return
        end

        info.countTimeFrom = CurTime()
    else
        local now = CurTime()
        info.online = info.online + math.floor(now - (info.countTimeFrom or now))
        info.countTimeFrom = nil
    end
end

function rAdminDb.updateTime(ply)
    setAdminMode(ply, rAdminDb.adminJobs[ply:Team()] or ply:GetBVar('adminmode'))
end

function rAdminDb.isAdminGroup(ply)
    return rAdminDb.adminRanks[ply:GetRank()]
end

function rAdminDb.shouldCountAdmin(ply)
    return rAdminDb.isAdminGroup(ply) and (rAdminDb.adminJobs[ply:Team()] or ply:GetBVar('adminmode'))
end

function rAdminDb.increaseReportCount(ply)
    local info = rAdminDb.getAdminInfo(ply)
    if not info then
        info = rAdminDb.addToWatchlist(ply)
    end

    info.reports = info.reports + 1
end

function rAdminDb.getTotalOnline(steamid)
    local info = rAdminDb.onlineInfo[rAdminDb.onlineInfoSteamIDMap[steamid]]
    if info then
        if info.countTimeFrom then
            return info.online + (CurTime() - info.countTimeFrom)
        else
            return info.online
        end
    end
    return 0
end

function rAdminDb.sendAdminsData(ply)
    net.Start('rAdminDb.sendData')

    local data = rAdminDb.onlineInfo
    net.WriteUInt(#data, 7)
    for i = 1, #data do
        local adminData = data[i]
        net.WriteString(adminData.steamid)
        net.WriteString(adminData.nick)
        net.WriteUInt(math.floor(rAdminDb.getTotalOnline(adminData.steamid)), 18)
        net.WriteUInt(adminData.reports, 10)
    end
    net.Send(ply)
end

hook.Add('PlayerSitRequestClosedSucc', tag, function(_, admin)
    if rAdminDb.shouldCountAdmin(admin) then
        rAdminDb.increaseReportCount(admin)
    end
end)

hook.Add('playerChangedRPName', tag, function(ply, nick)
    local info = rAdminDb.getAdminInfo(ply)
    if info then
        info.nick = nick
    end
end)

do
    local function watchPlayer(ply)
        timer.Simple(1, function()
            if not isstring(ply) and IsValid(ply) and rAdminDb.isAdminGroup(ply) then
                rAdminDb.addToWatchlist(ply)
            end
        end)
    end

    hook.Add('playerRankLoaded', tag, watchPlayer)
    hook.Add('playerSetRank', tag, watchPlayer)
end

hook.Add('OnPlayerChangedTeam', tag, function(ply, old, new)
    if not rAdminDb.isAdminGroup(ply) then
        return
    end

    if rAdminDb.adminJobs[new] or rAdminDb.adminJobs[old] then
        rAdminDb.updateTime(ply)
    end
end)

hook.Add('OnAdminModeStateChanged', tag, function(ply, state)
    if rAdminDb.isAdminGroup(ply) then
        rAdminDb.updateTime(ply)
    end
end)

hook.Add('PlayerDisconnected', tag, function(ply)
    if rAdminDb.isAdminGroup(ply) then
        setAdminMode(ply, false)
    end
end)


--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
