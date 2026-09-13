require("chttp")

local WEBHOOK_URL = "https://discord.com/api/webhooks/1478488546926006334/djgpHHsOGkxO1b73ZEOaJFYnLq05GLjQyeeFQ5thQtnWJBqW76Kj9c3ZlyszfHt8QEXl"

util.AddNetworkString("Auc:OpenMenu")
util.AddNetworkString("Auc:CreateLot")
util.AddNetworkString("Auc:PlaceBid")
util.AddNetworkString("Auc:CancelLot")
util.AddNetworkString("Auc:Sync")

local function SendAucLog(title, message, color, isAlert)
    if not CHTTP then return end
    
    if isAlert then
        CHTTP({
            method = "POST",
            url = WEBHOOK_URL,
            body = util.TableToJSON({
                content = "@here ⚠️ ОБНАРУЖЕНА ПОДОЗРИТЕЛЬНАЯ ЦЕНА НА БИРЖЕ!"
            }),
            type = "application/json"
        })
    end

    local payload = {
        username = "Биржа ЛОГИ",
        embeds = {
            {
                title = (isAlert and "⚠️ " or "📝 ") .. title,
                description = message,
                color = color or 3447003,
                timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ")
            }
        }
    }

    CHTTP({
        method = "POST",
        url = WEBHOOK_URL,
        body = util.TableToJSON(payload),
        type = "application/json"
    })
end

hook.Add("Initialize", "Auc:InitDB", function()
    sql.Query("CREATE TABLE IF NOT EXISTS auction_payouts (steamid TEXT, amount INTEGER, item_name TEXT, buyer_name TEXT)")
end)

hook.Add("PlayerInitialSpawn", "Auc:OfflineCheck", function(ply)
    local sid = ply:SteamID64()
    local data = sql.Query("SELECT * FROM auction_payouts WHERE steamid = " .. sql.SQLStr(sid))
    if data then
        for _, v in ipairs(data) do
            ply:addMoney(tonumber(v.amount))
            ply:ChatPrint("[Биржа] Продано: " .. v.item_name .. " за " .. DarkRP.formatMoney(v.amount) .. " (Покупатель: " .. v.buyer_name .. ")")
        end
        sql.Query("DELETE FROM auction_payouts WHERE steamid = " .. sql.SQLStr(sid))
    end
end)

local LotID = LotID or 0

net.Receive("Auc:CreateLot", function(len, ply)
    local itemUID = net.ReadString()
    local price = net.ReadUInt(32)
    local sid = ply:SteamID64()
    
    local active = 0
    for _, l in pairs(AUCTION.Lots) do if l.ownerID == sid then active = active + 1 end end
    if active >= 1 then ply:ChatPrint("У вас уже есть активный лот!") return end
    
    local inv = IGS.Inventory(ply)
    local item_sell = nil
    for _, v in ipairs(inv or {}) do if v.Item == itemUID then item_sell = v break end end
    if not item_sell then return end
    
    local itemDef = IGS.GetItemByUID(itemUID)
    local normalPrice = (itemDef.price or 0) * AUCTION.Config.RubToGameMoney
    local isSuspicious = price > (normalPrice * 10) and normalPrice > 0

    IGS.DeletePlayerInventoryItemLocally(ply, item_sell.ID)
    IGS.DeleteInventoryItem(function(ok)
        if not ok then return end
        LotID = LotID + 1
        AUCTION.Lots[LotID] = {
            id = LotID,
            name = itemDef.name,
            model = itemDef.model or itemDef.icon or "models/error.mdl",
            itemUID = itemUID,
            ownerID = sid,
            ownerName = ply:Nick(),
            currentBid = price,
            endTime = os.time() + AUCTION.Config.MaxDuration,
            history = {},
            lastBidderID = nil
        }
        
        local logColor = isSuspicious and 16711680 or 3066993
        local logMsg = string.format("Игрок **%s** (%s) выставил **%s** за **%s**", 
            ply:Nick(), sid, itemDef.name, DarkRP.formatMoney(price))
        
        if isSuspicious then
            logMsg = logMsg .. "\n🛑 **ВНИМАНИЕ: Цена сильно завышена!**"
        end

        SendAucLog("Новый лот", logMsg, logColor, isSuspicious)
        net.Start("Auc:Sync") net.WriteTable(AUCTION.Lots) net.Broadcast()
    end, item_sell.ID)
end)

net.Receive("Auc:PlaceBid", function(len, ply)
    local id = net.ReadUInt(32)
    local bid = net.ReadUInt(32)
    local lot = AUCTION.Lots[id]
    
    if not lot or lot.endTime < os.time() or lot.ownerID == ply:SteamID64() then return end
    if bid < (lot.currentBid + AUCTION.Config.MinBidStep) then return end
    if not ply:canAfford(bid) then return end

    lot.currentBid = bid
    lot.lastBidderID = ply:SteamID64()
    lot.lastBidderName = ply:Nick()
    table.insert(lot.history, 1, {name = ply:Nick(), amount = bid, date = os.date("%d.%m"), time = os.date("%H:%M")})
    
    SendAucLog("Новая ставка", string.format("Игрок **%s** сделал ставку **%s** на лот **%s**", 
        ply:Nick(), DarkRP.formatMoney(bid), lot.name), 15105570, false)
        
    net.Start("Auc:Sync") net.WriteTable(AUCTION.Lots) net.Broadcast()
end)

net.Receive("Auc:CancelLot", function(len, ply)
    local id = net.ReadUInt(32)
    local lot = AUCTION.Lots[id]
    if not lot or lot.ownerID ~= ply:SteamID64() or #lot.history > 0 then return end
    
    SendAucLog("Лот отменен", string.format("Игрок **%s** снял с продажи **%s**", ply:Nick(), lot.name), 8359034, false)
    
    IGS.AddToInventory(ply, lot.itemUID)
    AUCTION.Lots[id] = nil
    net.Start("Auc:Sync") net.WriteTable(AUCTION.Lots) net.Broadcast()
end)

timer.Create("Auc:Timer", 1, 0, function()
    local changed = false
    for id, lot in pairs(AUCTION.Lots) do
        if lot.endTime <= os.time() then
            local bidder = lot.lastBidderID and player.GetBySteamID64(lot.lastBidderID)
            if bidder and IsValid(bidder) and bidder:canAfford(lot.currentBid) then
                bidder:addMoney(-lot.currentBid)
                IGS.AddToInventory(bidder, lot.itemUID)
                local profit = lot.currentBid - math.floor(lot.currentBid * AUCTION.Config.CommissionPercent)
                local owner = player.GetBySteamID64(lot.ownerID)
                
                SendAucLog("Лот ПРОДАН", string.format("Предмет: **%s**\nПродавец: **%s**\nПокупатель: **%s**\nСумма: **%s**", 
                    lot.name, lot.ownerName, bidder:Nick(), DarkRP.formatMoney(lot.currentBid)), 1752220, false)

                if IsValid(owner) then
                    owner:addMoney(profit)
                    owner:ChatPrint("[Биржа] Лот " .. lot.name .. " продан за " .. DarkRP.formatMoney(profit))
                else
                    sql.Query(string.format("INSERT INTO auction_payouts VALUES (%s, %d, %s, %s)", sql.SQLStr(lot.ownerID), profit, sql.SQLStr(lot.name), sql.SQLStr(bidder:Nick())))
                end
            else
                local owner = player.GetBySteamID64(lot.ownerID)
                if IsValid(owner) then IGS.AddToInventory(owner, lot.itemUID) else IGS.AddToInventory(lot.ownerID, lot.itemUID) end
            end
            AUCTION.Lots[id] = nil
            changed = true
        end
    end
    if changed then net.Start("Auc:Sync") net.WriteTable(AUCTION.Lots) net.Broadcast() end
end)

function AUCTION:OpenMenu(ply)
    net.Start("Auc:Sync")
    net.WriteTable(AUCTION.Lots)
    net.Send(ply)
    net.Start("Auc:OpenMenu")
    net.Send(ply)
end