local CAMERAS         = CamersSystem.CAMERAS
local CAM_COUNT       = CamersSystem.CAM_COUNT
local REPAIR_DIST_SQR = CamersSystem.REPAIR_DIST_SQR
local REPAIR_TIME     = CamersSystem.REPAIR_TIME
local AUTO_REPAIR     = CamersSystem.AUTO_REPAIR
local IsPolice        = CamersSystem.IsPolice

util.AddNetworkString("CamersSystem_Open")
util.AddNetworkString("CamersSystem_RequestOpen")
util.AddNetworkString("CamersSystem_SyncBroken")
util.AddNetworkString("CamersSystem_SyncAll")

resource.AddFile("materials/camers_system/logo.vmt")
resource.AddFile("materials/camers_system/logo.vtf")

local breakTimestamps = {}

local function BroadcastBroken(idx, broken)
    CAMERAS[idx].broken = broken
    if broken then
        breakTimestamps[idx] = CurTime()
    else
        breakTimestamps[idx] = nil
    end
    timer.Simple(0, function()
        net.Start("CamersSystem_SyncBroken")
        net.WriteUInt(idx, 4)
        net.WriteBool(broken)
        net.Broadcast()
    end)
end

CamersSystem.BroadcastBroken = BroadcastBroken

net.Receive("CamersSystem_RequestOpen", function(len, ply)
    if not IsValid(ply) then return end
    if not IsPolice(ply) then
        ply:ChatPrint("[Камеры] У вас нет доступа к системе наблюдения!")
        return
    end
    net.Start("CamersSystem_Open")
    net.Send(ply)
end)

local function SyncAllToPlayer(ply)
    net.Start("CamersSystem_SyncAll")
    for i = 1, CAM_COUNT do
        net.WriteBool(CAMERAS[i].broken)
    end
    net.Send(ply)
end

hook.Add("PlayerInitialSpawn", "CamSys_Sync", function(ply)
    timer.Simple(1, function()
        if IsValid(ply) then SyncAllToPlayer(ply) end
    end)
end)

timer.Create("CamSys_RandomBreak", 120, 0, function()
    if math.random() > 0.3 then return end
    local working = {}
    for i = 1, CAM_COUNT do
        if not CAMERAS[i].broken then working[#working + 1] = i end
    end
    if #working > 0 then
        BroadcastBroken(working[math.random(#working)], true)
    end
end)

timer.Create("CamSys_AutoRepair", 30, 0, function()
    local ct = CurTime()
    for i = 1, CAM_COUNT do
        if CAMERAS[i].broken and breakTimestamps[i] and ct - breakTimestamps[i] >= AUTO_REPAIR then
            BroadcastBroken(i, false)
        end
    end
end)

local repairProgress = {}

hook.Add("Think", "CamSys_Repair", function()
    for _, ply in ipairs(player.GetAll()) do
        if ply:Alive() and IsPolice(ply) and ply:KeyDown(IN_USE) then
            local nearIdx = nil
            for i = 1, CAM_COUNT do
                if CAMERAS[i].broken and ply:GetPos():DistToSqr(CAMERAS[i].pos) < REPAIR_DIST_SQR then
                    nearIdx = i
                    break
                end
            end

            if nearIdx then
                if not repairProgress[ply] or repairProgress[ply].idx ~= nearIdx then
                    repairProgress[ply] = { idx = nearIdx, start = CurTime() }
                end
                if CurTime() - repairProgress[ply].start >= REPAIR_TIME then
                    BroadcastBroken(nearIdx, false)
                    repairProgress[ply] = nil
                end
            else
                repairProgress[ply] = nil
            end
        else
            repairProgress[ply] = nil
        end
    end
end)

hook.Add("PlayerDisconnected", "CamSys_Cleanup", function(ply)
    repairProgress[ply] = nil
end)

concommand.Add("camers_open", function(ply)
    if not IsValid(ply) or not ply:IsSuperAdmin() then return end
    net.Start("CamersSystem_Open")
    net.Send(ply)
end)

concommand.Add("camers_break", function(ply, cmd, args)
    if not IsValid(ply) or not ply:IsSuperAdmin() then return end
    local idx = tonumber(args[1])
    if not idx or idx < 1 or idx > CAM_COUNT then return end
    BroadcastBroken(idx, true)
end)

concommand.Add("camers_repair", function(ply, cmd, args)
    if not IsValid(ply) or not ply:IsSuperAdmin() then return end
    local idx = tonumber(args[1])
    if not idx or idx < 1 or idx > CAM_COUNT then return end
    BroadcastBroken(idx, false)
end)

concommand.Add("camers_breakall", function(ply)
    if not IsValid(ply) or not ply:IsSuperAdmin() then return end
    for i = 1, CAM_COUNT do BroadcastBroken(i, true) end
end)

concommand.Add("camers_repairall", function(ply)
    if not IsValid(ply) or not ply:IsSuperAdmin() then return end
    for i = 1, CAM_COUNT do BroadcastBroken(i, false) end
end)