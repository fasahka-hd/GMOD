AFKSystem = AFKSystem or {}

AFKSystem.Config = {
    MapName = "rp_downtown_tits_v2",

    ZonePos1 = Vector(894.89727783203, -6064.5083007812, -202.96875),
    ZonePos2 = Vector(534.75573730469, -6478.55859375, -203.96875),

    ZoneZMinOffset = 10,
    ZoneZMaxOffset = 160,

    DrawZone = true,
    ZoneTitle = "АФК зона заработка",
    ZoneTitleOffsetZ = 70,
    ZoneTitleAngle = Angle(0, 90, 90),

    RewardAmount = 50,
    RewardInterval = 1800,
    CheckInterval = 1,

    EnterMessage = "Вы вошли в зону AFK заработка!",
    ExitMessage = "Вы вышли из зоны AFK заработка!",
    RewardMessage = "Вы получили {amount} AZ за AFK!",

    EnterColor = Color(0, 255, 0),
    ExitColor = Color(255, 0, 0),
    RewardColor = Color(255, 215, 0),
}

function AFKSystem.CalculateZoneBounds()
    local pos1 = AFKSystem.Config.ZonePos1
    local pos2 = AFKSystem.Config.ZonePos2
    local zMinOffset = tonumber(AFKSystem.Config.ZoneZMinOffset) or 0
    local zMaxOffset = tonumber(AFKSystem.Config.ZoneZMaxOffset) or 0

    AFKSystem.ZoneCenter = (pos1 + pos2) / 2
    AFKSystem.ZoneMins = Vector(
        math.min(pos1.x, pos2.x),
        math.min(pos1.y, pos2.y),
        math.min(pos1.z, pos2.z) - zMinOffset
    )
    AFKSystem.ZoneMaxs = Vector(
        math.max(pos1.x, pos2.x),
        math.max(pos1.y, pos2.y),
        math.max(pos1.z, pos2.z) + zMaxOffset
    )
end

AFKSystem.CalculateZoneBounds()

function AFKSystem.IsCorrectMap()
    return game.GetMap() == AFKSystem.Config.MapName
end

function AFKSystem.IsInZone(ply)
    if not IsValid(ply) then return false end
    if not AFKSystem.IsCorrectMap() then return false end
    if not AFKSystem.ZoneMins or not AFKSystem.ZoneMaxs then return false end

    local pos = ply:GetPos()

    return pos.x >= AFKSystem.ZoneMins.x and pos.x <= AFKSystem.ZoneMaxs.x and
           pos.y >= AFKSystem.ZoneMins.y and pos.y <= AFKSystem.ZoneMaxs.y and
           pos.z >= AFKSystem.ZoneMins.z and pos.z <= AFKSystem.ZoneMaxs.z
end

function AFKSystem.GetZoneTitlePos()
    local center = AFKSystem.ZoneCenter
    if not center then return Vector(0, 0, 0) end

    return center + Vector(-180, 0, tonumber(AFKSystem.Config.ZoneTitleOffsetZ) or 70)
end

function AFKSystem.AddMoney(ply, amount)
    if not SERVER then return false end
    if not IsValid(ply) then return false end

    amount = tonumber(amount) or 0
    if amount <= 0 then return false end

    if ply.AddIGSFunds then
        ply:AddIGSFunds(amount, "AFK зона заработка")
        return true
    end

    if ply.AddMoney then
        ply:AddMoney(amount, "AFK зона заработка")
        return true
    end

    if ply.addMoney then
        ply:addMoney(amount)
        return true
    end

    if ply.PS_GivePoints then
        ply:PS_GivePoints(amount)
        return true
    end

    print("[AFK System] Не удалось выдать валюту игроку " .. ply:Nick())
    return false
end

print("[AFK System] Конфиг загружен для карты: " .. AFKSystem.Config.MapName)
print("[AFK System] Зона: от " .. tostring(AFKSystem.ZoneMins) .. " до " .. tostring(AFKSystem.ZoneMaxs))
