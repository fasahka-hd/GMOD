
AddCSLuaFile("autorun/sh_cladmen_config.lua")
AddCSLuaFile("autorun/client/cl_cladmen.lua")

util.AddNetworkString("cladmen_order_start")
util.AddNetworkString("cladmen_order_update")
util.AddNetworkString("cladmen_order_end")
util.AddNetworkString("cladmen_progress")

local function IsCladmen(ply)
    return CLADMEN.JobCheck(ply)
end
local function PlaceOnGround(pos)
    local tr = util.TraceLine({
        start = pos + Vector(0,0,64),
        endpos = pos - Vector(0,0,256),
        mask = MASK_SOLID_BRUSHONLY
    })
    if tr.Hit then
        return tr.HitPos + Vector(0,0,4)
    end
    return pos
end
local function CleanupCladmenPlayer(ply, reason)
    if not IsValid(ply) then return end

    timer.Remove("Cladmen_OrderCooldown_" .. ply:SteamID64())
    timer.Remove("Cladmen_DropTimer_" .. ply:SteamID64())

    if IsValid(ply.CladmenSupplyEnt) then
        ply.CladmenSupplyEnt:Remove()
    end
    ply.CladmenSupplyEnt = nil

    if ply.CladmenDrops then
        for _, ent in pairs(ply.CladmenDrops) do
            if IsValid(ent) then ent:Remove() end
        end
    end
    ply.CladmenDrops = nil
    ply.CladmenActiveOrder = nil
    ply.CladmenDropsDone = 0
    ply.CladmenDropsTotal = 0

    net.Start("cladmen_order_end")
        net.WriteString(reason or "cancel")
    net.Send(ply)
end

local function SendOrderUpdate(ply)
    if not IsValid(ply) then return end
    net.Start("cladmen_order_update")
        net.WriteUInt(ply.CladmenDropsDone or 0, 8)
        net.WriteUInt(ply.CladmenDropsTotal or 0, 8)
        net.WriteFloat(ply.CladmenOrderEndTime or 0)
    net.Send(ply)
end

local function FinishOrder(ply, success)
    if not IsValid(ply) then return end
    timer.Remove("Cladmen_DropTimer_" .. ply:SteamID64())

    if ply.CladmenDrops then
        for _, ent in pairs(ply.CladmenDrops) do
            if IsValid(ent) then ent:Remove() end
        end
    end
    ply.CladmenDrops = nil

    if success then
        ply:addMoney(CLADMEN.Reward or 2000)
        CLADMEN.Notify(ply, "Заказ выполнен! Получено $" .. (CLADMEN.Reward or 2000), 0)
        net.Start("cladmen_order_end")
            net.WriteString("success")
        net.Send(ply)
    else
        CLADMEN.Notify(ply, "Заказ провален! Время вышло.", 1)
        net.Start("cladmen_order_end")
            net.WriteString("fail")
        net.Send(ply)
    end

    ply.CladmenActiveOrder = nil
    ply.CladmenDropsDone = 0
    ply.CladmenDropsTotal = 0

    if IsCladmen(ply) then

        timer.Create("Cladmen_OrderCooldown_" .. ply:SteamID64(), math.random(CLADMEN.OrderCooldownMin, CLADMEN.OrderCooldownMax), 1, function()
            if IsValid(ply) and IsCladmen(ply) then

                hook.Run("Cladmen_GiveOrder", ply)
            end
        end)
    end
end

function CLADMEN.StartDropPhase(ply)
    if not IsValid(ply) then return end
    if not IsCladmen(ply) then return end

    if ply.CladmenDrops then
        for _, e in pairs(ply.CladmenDrops) do if IsValid(e) then e:Remove() end end
    end

    local dropCount = math.random(1,5)
    local spawns = table.Copy(CLADMEN.DropSpawns)
    if #spawns < dropCount then
        CLADMEN.Notify(ply, "Ошибка конфигурации: недостаточно точек закладок! Нужно " .. dropCount .. ", есть " .. #spawns, 1)
        return
    end

    for i = #spawns, 2, -1 do
        local j = math.random(i)
        spawns[i], spawns[j] = spawns[j], spawns[i]
    end

    ply.CladmenDrops = {}
    ply.CladmenDropsDone = 0
    ply.CladmenDropsTotal = dropCount
    ply.CladmenActiveOrder = true
    ply.CladmenOrderEndTime = CurTime() + (CLADMEN.DropTime or 300)

    for i = 1, dropCount do
        local s = spawns[i]
        local ent = ents.Create("cladmen_drop")
        if IsValid(ent) then
            local gpos = PlaceOnGround(s.pos)
            ent:SetPos(gpos)
            ent:SetAngles(s.ang or Angle(0,0,0))
            ent:Spawn()
            ent:SetOwnerPlayer(ply)
            ent.DropID = i
            table.insert(ply.CladmenDrops, ent)
        end
    end

    net.Start("cladmen_order_start")
        net.WriteUInt(dropCount, 8)
        net.WriteFloat(ply.CladmenOrderEndTime)
    net.Send(ply)

    SendOrderUpdate(ply)

    timer.Create("Cladmen_DropTimer_" .. ply:SteamID64(), CLADMEN.DropTime or 300, 1, function()
        if IsValid(ply) and ply.CladmenActiveOrder then
            FinishOrder(ply, false)
        end
    end)
end

local function GiveOrder(ply)
    if not IsValid(ply) then return end
    if not IsCladmen(ply) then return end
    if ply.CladmenActiveOrder then return end
    if IsValid(ply.CladmenSupplyEnt) then ply.CladmenSupplyEnt:Remove() end

    if #CLADMEN.SupplySpawns == 0 then
        CLADMEN.Notify(ply, "Ошибка: не настроены точки выдачи! Смотрите sh_cladmen_config.lua", 1)
        return
    end

    local spawn = table.Random(CLADMEN.SupplySpawns)

    local ent = ents.Create("cladmen_supply")
    if not IsValid(ent) then return end
    local spos = PlaceOnGround(spawn.pos)
    ent:SetPos(spos)
    ent:SetAngles(spawn.ang or Angle(0,0,0))
    ent:Spawn()
    ent:SetOwnerPlayer(ply)

    ply.CladmenSupplyEnt = ent
    ply.CladmenActiveOrder = "supply"

    CLADMEN.Notify(ply, "Пришёл новый заказ! Заберите посылку. Отмечено на карте.", 0)
    timer.Create("Cladmen_SupplyExpire_" .. ply:SteamID64(), 300, 1, function()
        if IsValid(ent) then ent:Remove() end
        if IsValid(ply) and ply.CladmenSupplyEnt == ent then
            ply.CladmenSupplyEnt = nil
            ply.CladmenActiveOrder = nil
            CLADMEN.Notify(ply, "Заказ на выдачу истёк.", 1)

            timer.Create("Cladmen_OrderCooldown_" .. ply:SteamID64(), math.random(CLADMEN.OrderCooldownMin, CLADMEN.OrderCooldownMax), 1, function()
                if IsValid(ply) and IsCladmen(ply) then GiveOrder(ply) end
            end)
        end
    end)
end

hook.Add("Cladmen_GiveOrder", "CladmenInternal", GiveOrder)

local function StartOrderCooldown(ply)
    if not IsValid(ply) then return end
    if not IsCladmen(ply) then return end
    if ply.CladmenActiveOrder then return end

    local cd = math.random(CLADMEN.OrderCooldownMin, CLADMEN.OrderCooldownMax)
    timer.Create("Cladmen_OrderCooldown_" .. ply:SteamID64(), cd, 1, function()
        if IsValid(ply) and IsCladmen(ply) then
            GiveOrder(ply)
        end
    end)
    CLADMEN.Notify(ply, "Вы кладмен. Следующий заказ через " .. math.floor(cd/60) .. " мин.", 0)
end

hook.Add("OnPlayerChangedTeam", "Cladmen_TeamChange", function(ply, before, after)
    timer.Simple(0.5, function()
        if not IsValid(ply) then return end
        if IsCladmen(ply) then

            StartOrderCooldown(ply)
        else

            CleanupCladmenPlayer(ply, "teamchange")
        end
    end)
end)

hook.Add("PlayerInitialSpawn", "Cladmen_InitSpawn", function(ply)
    timer.Simple(5, function()
        if IsValid(ply) and IsCladmen(ply) then
            StartOrderCooldown(ply)
        end
    end)
end)

hook.Add("PlayerDisconnected", "Cladmen_Disconnect", function(ply)
    CleanupCladmenPlayer(ply, "disconnect")
end)

hook.Add("PlayerDeath", "Cladmen_Death", function(ply)
    if IsCladmen(ply) and ply.CladmenActiveOrder then
        CLADMEN.Notify(ply, "Заказ провален из-за смерти!", 1)
        CleanupCladmenPlayer(ply, "death")

        timer.Simple(2, function()
            if IsValid(ply) and IsCladmen(ply) then
                StartOrderCooldown(ply)
            end
        end)
    end
end)

function CLADMEN.OnSupplyPickup(ply, ent)
    if not IsValid(ply) then return end
    timer.Remove("Cladmen_SupplyExpire_" .. ply:SteamID64())
    if ply.CladmenSupplyEnt == ent then
        ply.CladmenSupplyEnt = nil
    end
    if IsValid(ent) then ent:Remove() end

    CLADMEN.Notify(ply, "Посылка получена!", 0)
    CLADMEN.StartDropPhase(ply)
end

function CLADMEN.OnDropUse(ply, ent)
    if not IsValid(ply) then return end
    if not ply.CladmenActiveOrder then return end
    if not ply.CladmenDrops then return end

    for k, v in pairs(ply.CladmenDrops) do
        if v == ent then
            ply.CladmenDrops[k] = nil
            break
        end
    end

    if IsValid(ent) then ent:Remove() end

    ply.CladmenDropsDone = (ply.CladmenDropsDone or 0) + 1
    CLADMEN.Notify(ply, "Закладка " .. ply.CladmenDropsDone .. "/" .. ply.CladmenDropsTotal .. " установлена!", 0)
    SendOrderUpdate(ply)

    if ply.CladmenDropsDone >= ply.CladmenDropsTotal then
        FinishOrder(ply, true)
    end
end

concommand.Add("cladmen_force_order", function(ply)
    if IsValid(ply) and ply:IsSuperAdmin() then
        GiveOrder(ply)
        ply:ChatPrint("Cladmen: force order")
    else

        if IsCladmen(ply) then
            GiveOrder(ply)
        end
    end
end)

concommand.Add("cladmen_getpos", function(ply)
    if not IsValid(ply) then return end
    local pos = ply:GetPos()
    local ang = ply:EyeAngles()
    local str = string.format('{pos = Vector(%.3f, %.3f, %.3f), ang = Angle(%.1f, %.1f, %.1f)},', pos.x, pos.y, pos.z, ang.p, ang.y, ang.r)
    print(str)
    ply:ChatPrint(str)

end)