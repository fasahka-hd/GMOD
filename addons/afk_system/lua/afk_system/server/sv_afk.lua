AddCSLuaFile("afk_system/sh_config.lua")
AddCSLuaFile("afk_system/client/cl_afk.lua")

include("afk_system/sh_config.lua")

util.AddNetworkString("AFKSystem_Notify")

AFKSystem.PlayerTimes = AFKSystem.PlayerTimes or {}

local function Notify(ply, message, color)
    if not IsValid(ply) then return end

    net.Start("AFKSystem_Notify")
        net.WriteString(tostring(message or ""))
        net.WriteColor(color or Color(255, 255, 255))
    net.Send(ply)
end

local function EnterZone(ply)
    if AFKSystem.PlayerTimes[ply] then return end

    local now = CurTime()
    AFKSystem.PlayerTimes[ply] = {
        entered = now,
        nextReward = now + AFKSystem.Config.RewardInterval
    }

    Notify(ply, AFKSystem.Config.EnterMessage, AFKSystem.Config.EnterColor)
    print("[AFK System] " .. ply:Nick() .. " вошёл в AFK зону")
end

local function ExitZone(ply)
    if not AFKSystem.PlayerTimes[ply] then return end

    AFKSystem.PlayerTimes[ply] = nil
    Notify(ply, AFKSystem.Config.ExitMessage, AFKSystem.Config.ExitColor)
    print("[AFK System] " .. ply:Nick() .. " вышел из AFK зоны")
end

local function GiveReward(ply, state)
    if not IsValid(ply) then return end
    if not state then return end

    if AFKSystem.AddMoney(ply, AFKSystem.Config.RewardAmount) then
        Notify(
            ply,
            string.Replace(AFKSystem.Config.RewardMessage, "{amount}", tostring(AFKSystem.Config.RewardAmount)),
            AFKSystem.Config.RewardColor
        )

        print("[AFK System] " .. ply:Nick() .. " получил " .. AFKSystem.Config.RewardAmount .. " AZ")
    end

    state.nextReward = CurTime() + AFKSystem.Config.RewardInterval
end

if not AFKSystem.IsCorrectMap() then
    print("[AFK System] ПРЕДУПРЕЖДЕНИЕ: система настроена для карты " .. AFKSystem.Config.MapName .. ", но текущая карта: " .. game.GetMap())
    print("[AFK System] AFK зона отключена на этой карте.")
    return
end

timer.Remove("AFKSystem_Reward")
timer.Create("AFKSystem_Reward", AFKSystem.Config.CheckInterval or 1, 0, function()
    local now = CurTime()

    for _, ply in ipairs(player.GetAll()) do
        if AFKSystem.IsInZone(ply) then
            EnterZone(ply)

            local state = AFKSystem.PlayerTimes[ply]
            if state and now >= (state.nextReward or 0) then
                GiveReward(ply, state)
            end
        else
            ExitZone(ply)
        end
    end

    for ply in pairs(AFKSystem.PlayerTimes) do
        if not IsValid(ply) then
            AFKSystem.PlayerTimes[ply] = nil
        end
    end
end)

hook.Add("PlayerDisconnected", "AFKSystem_Cleanup", function(ply)
    AFKSystem.PlayerTimes[ply] = nil
end)

print("[AFK System] Серверная часть загружена!")
