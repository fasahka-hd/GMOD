AntiFakeAuth = AntiFakeAuth or {}

AntiFakeAuth.Config = {
    Enabled = true,
    AllowBots = true,
    AuthStateStart = 2,
    AuthStateDone = 3,
    Timeout = 30,
    CheckInterval = 5,
    KickReason = "Ошибка авторизации, перезайди!",
    Log = true
}

AntiFakeAuth.Pending = AntiFakeAuth.Pending or {}

local function Log(...)
    if not AntiFakeAuth.Config.Log then return end
    print("[AntiFakeAuth]", ...)
end

local function GetPlayerByUserID(userid)
    userid = tonumber(userid)
    if not userid then return nil end
    return Player(userid)
end

local function IsAllowedBot(userid)
    if not AntiFakeAuth.Config.AllowBots then return false end

    local ply = GetPlayerByUserID(userid)
    return IsValid(ply) and ply:IsBot()
end

local function RemovePending(userid)
    AntiFakeAuth.Pending[userid] = nil
end

local function AddPending(userid)
    if IsAllowedBot(userid) then
        RemovePending(userid)
        return
    end

    AntiFakeAuth.Pending[userid] = CurTime()
end

local function KickUser(userid)
    if IsAllowedBot(userid) then
        RemovePending(userid)
        return
    end

    local ply = GetPlayerByUserID(userid)
    local name = IsValid(ply) and ply:Name() or "Unknown"

    Log("kick", userid, name, AntiFakeAuth.Config.KickReason)
    game.KickID(userid, AntiFakeAuth.Config.KickReason)
    RemovePending(userid)
end

hook.Add("ClientSignOnStateChanged", "AntiFakeAuth.SignOnCheck", function(userid, oldState, newState)
    if not AntiFakeAuth.Config.Enabled then return end

    if IsAllowedBot(userid) then
        RemovePending(userid)
        return
    end

    if newState < oldState and newState ~= 0 then
        Log("bad state", userid, oldState .. " -> " .. newState)
    end

    if newState == AntiFakeAuth.Config.AuthStateStart then
        AddPending(userid)
    elseif newState >= AntiFakeAuth.Config.AuthStateDone or newState == 0 then
        RemovePending(userid)
    end
end)

hook.Add("PlayerDisconnected", "AntiFakeAuth.Cleanup", function(ply)
    if not IsValid(ply) then return end
    RemovePending(ply:UserID())
end)

timer.Remove("FindLey")
timer.Remove("AntiFakeAuth.CheckPending")

timer.Create("AntiFakeAuth.CheckPending", AntiFakeAuth.Config.CheckInterval, 0, function()
    if not AntiFakeAuth.Config.Enabled then return end

    local now = CurTime()

    for userid, startedAt in pairs(AntiFakeAuth.Pending) do
        if IsAllowedBot(userid) then
            RemovePending(userid)
        elseif now - startedAt >= AntiFakeAuth.Config.Timeout then
            KickUser(userid)
        end
    end
end)

concommand.Add("antifake_reload", function(ply)
    if IsValid(ply) and not ply:IsSuperAdmin() then return end

    AntiFakeAuth.Pending = {}
    Log("pending list cleared")
end)

concommand.Add("antifake_bots", function(ply, cmd, args)
    if IsValid(ply) and not ply:IsSuperAdmin() then return end

    local value = tonumber(args[1] or "")
    if value == nil then
        Log("AllowBots =", tostring(AntiFakeAuth.Config.AllowBots))
        return
    end

    AntiFakeAuth.Config.AllowBots = value ~= 0
    AntiFakeAuth.Pending = {}
    Log("AllowBots changed to", tostring(AntiFakeAuth.Config.AllowBots))
end)