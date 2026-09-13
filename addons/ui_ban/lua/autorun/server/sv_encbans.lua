util.AddNetworkString("EncBans_BuyUnban")
util.AddNetworkString("EncBans_BuyUnbanResult")

local pendingUnban = {}

local function getUnbanPrice()
    if IGS and IGS.GetItem then
        local item = IGS.GetItem("unban")
        if item and item.Price then
            return item:Price()
        elseif item and item.price then
            return item.price
        end
    end
    return 449
end

local function sendResult(ply, success, reason)
    net.Start("EncBans_BuyUnbanResult")
    net.WriteBool(success)
    if not success then
        net.WriteString(reason)
    end
    net.Send(ply)
end

net.Receive("EncBans_BuyUnban", function(len, ply)
    if not IsValid(ply) then return end

    local sid = ply:SteamID64()

    if pendingUnban[sid] then
        sendResult(ply, false, "Покупка уже обрабатывается, подождите.")
        return
    end

    if not ply:IsBanned() then
        sendResult(ply, false, "Вы не в бане!")
        return
    end

    local unbanPrice = getUnbanPrice()
    local balance = ply:IGSFunds()
    if balance < unbanPrice then
        sendResult(ply, false, "Недостаточно средств на балансе доната. Необходимо: " .. unbanPrice .. " руб., у вас: " .. balance .. " руб.")
        return
    end

    pendingUnban[sid] = true

    ply:AddIGSFunds(-unbanPrice)
    ba.bans.Unban(sid, "Покупка разбана")

    pendingUnban[sid] = nil

    net.Start("OtecAndEncBans")
    net.WriteString("unban")
    net.Send(ply)

    sendResult(ply, true)

    print("[EncBans] " .. ply:Nick() .. " (" .. sid .. ") купил разбан за " .. unbanPrice .. " руб. IGS")
end)