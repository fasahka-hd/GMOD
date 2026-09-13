util.AddNetworkString("BizSys_UpdateClient")
util.AddNetworkString("BizSys_BuyShares")
util.AddNetworkString("BizSys_SellShares")
util.AddNetworkString("BizSys_Upgrade")
util.AddNetworkString("BizSys_Deposit")
util.AddNetworkString("BizSys_Withdraw")
util.AddNetworkString("BizSys_PlaceBid")
util.AddNetworkString("BizSys_SellBusiness")

BizSystem.Data = BizSystem.Data or {}

local function CheckDB()
    sql.Query("CREATE TABLE IF NOT EXISTS biz_core (id TEXT PRIMARY KEY, owner TEXT, owner_name TEXT, bank INTEGER, auction_time INTEGER, top_bid INTEGER, top_bidder TEXT, top_bidder_name TEXT)")
    sql.Query("CREATE TABLE IF NOT EXISTS biz_upgrades (id TEXT PRIMARY KEY, staff INTEGER, quality INTEGER, max_profit INTEGER, max_bank INTEGER)")
    sql.Query("CREATE TABLE IF NOT EXISTS biz_shares (id TEXT PRIMARY KEY, price INTEGER, history TEXT)")
    sql.Query("CREATE TABLE IF NOT EXISTS biz_players (steamid TEXT, biz_id TEXT, shares INTEGER, PRIMARY KEY(steamid, biz_id))")
    sql.Query("CREATE TABLE IF NOT EXISTS biz_refunds (steamid TEXT PRIMARY KEY, amount INTEGER DEFAULT 0)")

    sql.Query("ALTER TABLE biz_core ADD COLUMN top_bid INTEGER DEFAULT 0")
    sql.Query("ALTER TABLE biz_core ADD COLUMN top_bidder TEXT DEFAULT 'none'")
    sql.Query("ALTER TABLE biz_core ADD COLUMN owner_name TEXT DEFAULT 'none'")
    sql.Query("ALTER TABLE biz_core ADD COLUMN top_bidder_name TEXT DEFAULT 'none'")
end

local function GenerateHistory()
    local hist = {}
    local startPrice = math.random(80, 120)
    for i = 1, 24 do
        startPrice = startPrice + math.random(-5, 5)
        table.insert(hist, math.max(10, startPrice))
    end
    return util.TableToJSON(hist)
end

local function LoadData()
    CheckDB()
    for id, cfg in pairs(BizSystem.Config.Businesses) do
        local core = sql.QueryRow("SELECT * FROM biz_core WHERE id = " .. sql.SQLStr(id))
        local upg  = sql.QueryRow("SELECT * FROM biz_upgrades WHERE id = " .. sql.SQLStr(id))
        local sh   = sql.QueryRow("SELECT * FROM biz_shares WHERE id = " .. sql.SQLStr(id))

        if not core then
            sql.Query("INSERT INTO biz_core (id, owner, owner_name, bank, auction_time, top_bid, top_bidder, top_bidder_name) VALUES (" .. sql.SQLStr(id) .. ", 'none', 'none', 0, 0, " .. cfg.base_price .. ", 'none', 'none')")
            sql.Query("INSERT INTO biz_upgrades (id, staff, quality, max_profit, max_bank) VALUES (" .. sql.SQLStr(id) .. ", 1, 1, 1, 1)")
            sql.Query("INSERT INTO biz_shares (id, price, history) VALUES (" .. sql.SQLStr(id) .. ", 100, " .. sql.SQLStr(GenerateHistory()) .. ")")

            core = { owner = "none", owner_name = "none", bank = 0, auction_time = 0, top_bid = cfg.base_price, top_bidder = "none", top_bidder_name = "none" }
            upg  = { staff = 1, quality = 1, max_profit = 1, max_bank = 1 }
            sh   = { price = 100, history = GenerateHistory() }
        end

        BizSystem.Data[id] = {
            owner           = core.owner,
            owner_name      = core.owner_name or "none",
            bank            = tonumber(core.bank),
            auction_time    = tonumber(core.auction_time),
            top_bid         = tonumber(core.top_bid) or cfg.base_price,
            top_bidder      = core.top_bidder or "none",
            top_bidder_name = core.top_bidder_name or "none",
            upgrades = {
                staff      = tonumber(upg.staff),
                quality    = tonumber(upg.quality),
                max_profit = tonumber(upg.max_profit),
                max_bank   = tonumber(upg.max_bank)
            },
            share_price  = tonumber(sh.price),
            history      = util.JSONToTable(sh.history) or {},
            player_shares = {}
        }
    end
end

hook.Add("Initialize", "BizSys_InitCore", LoadData)

local function SaveBizData(id)
    local d = BizSystem.Data[id]
    if not d then return end
    sql.Query("UPDATE biz_core SET owner = " .. sql.SQLStr(d.owner) .. ", owner_name = " .. sql.SQLStr(d.owner_name) .. ", bank = " .. d.bank .. ", auction_time = " .. d.auction_time .. ", top_bid = " .. d.top_bid .. ", top_bidder = " .. sql.SQLStr(d.top_bidder) .. ", top_bidder_name = " .. sql.SQLStr(d.top_bidder_name) .. " WHERE id = " .. sql.SQLStr(id))
    sql.Query("UPDATE biz_upgrades SET staff = " .. d.upgrades.staff .. ", quality = " .. d.upgrades.quality .. ", max_profit = " .. d.upgrades.max_profit .. ", max_bank = " .. d.upgrades.max_bank .. " WHERE id = " .. sql.SQLStr(id))
    sql.Query("UPDATE biz_shares SET price = " .. d.share_price .. ", history = " .. sql.SQLStr(util.TableToJSON(d.history)) .. " WHERE id = " .. sql.SQLStr(id))
end

local function SyncData(ply)
    local toSend = table.Copy(BizSystem.Data)
    for k, v in pairs(toSend) do v.player_shares = {} end
    local allShares = sql.Query("SELECT * FROM biz_players")
    if allShares then
        for _, row in ipairs(allShares) do
            if toSend[row.biz_id] then toSend[row.biz_id].player_shares[row.steamid] = tonumber(row.shares) end
        end
    end
    net.Start("BizSys_UpdateClient")
    net.WriteTable(toSend)
    if ply then net.Send(ply) else net.Broadcast() end
end

local function AddRefund(steamid, amount)
    local existing = sql.QueryRow("SELECT amount FROM biz_refunds WHERE steamid = " .. sql.SQLStr(steamid))
    if existing then
        sql.Query("UPDATE biz_refunds SET amount = " .. (tonumber(existing.amount) + amount) .. " WHERE steamid = " .. sql.SQLStr(steamid))
    else
        sql.Query("INSERT INTO biz_refunds (steamid, amount) VALUES (" .. sql.SQLStr(steamid) .. ", " .. amount .. ")")
    end
end

local function ProcessRefund(ply)
    local sid = ply:SteamID()
    local ref = sql.QueryRow("SELECT amount FROM biz_refunds WHERE steamid = " .. sql.SQLStr(sid))
    if ref and tonumber(ref.amount) > 0 then
        ply:addMoney(tonumber(ref.amount))
        DarkRP.notify(ply, 0, 6, "Возвращено " .. DarkRP.formatMoney(tonumber(ref.amount)) .. " (перебитая ставка)")
        sql.Query("DELETE FROM biz_refunds WHERE steamid = " .. sql.SQLStr(sid))
    end
end

local SHARE_COOLDOWN    = 60
local MAX_SHARES_PER_BIZ = 100
local SELL_COMMISSION   = 0.05
local MAX_BUY_PER_TX    = 10
local MAX_SELL_PER_TX   = 10
local VALID_UPGRADE_TYPES = { staff = true, quality = true, max_profit = true, max_bank = true }

local playerShareCooldowns = {}

local function IsOnShareCooldown(ply)
    local sid = ply:SteamID()
    if playerShareCooldowns[sid] and playerShareCooldowns[sid] > CurTime() then
        local left = math.ceil(playerShareCooldowns[sid] - CurTime())
        DarkRP.notify(ply, 1, 5, "Подождите " .. left .. " сек. перед следующей сделкой!")
        return true
    end
    return false
end

local function SetShareCooldown(ply)
    playerShareCooldowns[ply:SteamID()] = CurTime() + SHARE_COOLDOWN
end

local function IsValidBizId(id)
    return BizSystem.Config.Businesses[id] ~= nil and BizSystem.Data[id] ~= nil
end

local function GetPlayerShares(ply, biz_id)
    local res = sql.QueryRow("SELECT shares FROM biz_players WHERE steamid = " .. sql.SQLStr(ply:SteamID()) .. " AND biz_id = " .. sql.SQLStr(biz_id))
    return res and tonumber(res.shares) or 0
end

local function SetPlayerShares(ply, biz_id, amount)
    if amount <= 0 then
        sql.Query("DELETE FROM biz_players WHERE steamid = " .. sql.SQLStr(ply:SteamID()) .. " AND biz_id = " .. sql.SQLStr(biz_id))
    else
        sql.Query("REPLACE INTO biz_players (steamid, biz_id, shares) VALUES (" .. sql.SQLStr(ply:SteamID()) .. ", " .. sql.SQLStr(biz_id) .. ", " .. amount .. ")")
    end
end

hook.Add("PlayerInitialSpawn", "BizSys_SyncSpawn", function(ply)
    timer.Simple(3, function()
        if not IsValid(ply) then return end
        for id, d in pairs(BizSystem.Data) do
            if d.owner == ply:SteamID() and (not d.owner_name or d.owner_name == "none") then
                d.owner_name = ply:Name()
                SaveBizData(id)
            end
            if d.top_bidder == ply:SteamID() and (not d.top_bidder_name or d.top_bidder_name == "none") then
                d.top_bidder_name = ply:Name()
                SaveBizData(id)
            end
        end
        SyncData(ply)
        ProcessRefund(ply)
    end)
end)

hook.Add("PlayerDisconnected", "BizSys_CleanCooldowns", function(ply)
    playerShareCooldowns[ply:SteamID()] = nil
end)

timer.Create("BizSys_AuctionTicker", 5, 0, function()
    local updated = false
    for id, d in pairs(BizSystem.Data) do
        if d.owner == "none" and d.top_bidder ~= "none" and d.auction_time > 0 and os.time() >= d.auction_time then
            d.owner      = d.top_bidder
            d.owner_name = d.top_bidder_name
            d.top_bid    = 0
            d.top_bidder = "none"
            d.top_bidder_name = "none"
            d.auction_time = 0
            SaveBizData(id)
            updated = true

            local winner = player.GetBySteamID(d.owner)
            if IsValid(winner) then
                DarkRP.notify(winner, 0, 8, "Поздравляем! Вы стали владельцем бизнеса " .. BizSystem.Config.Businesses[id].name)
            end
        end
    end
    if updated then SyncData() end
end)

timer.Create("BizSys_StockTicker", 10, 0, function()
    for id, d in pairs(BizSystem.Data) do
        local chance = 40 + (d.upgrades.quality * 3) + (d.upgrades.staff * 2)
        local change = math.random(-15, 20)
        if math.random(1, 100) > chance then change = -math.abs(change) end
        d.share_price = math.max(10, d.share_price + change)
        table.insert(d.history, d.share_price)
        if #d.history > 24 then table.remove(d.history, 1) end
        SaveBizData(id)
    end
    SyncData()
end)

timer.Create("BizSys_IncomeTicker", 3600, 0, function()
    for id, d in pairs(BizSystem.Data) do
        if d.owner ~= "none" then
            local maxBank  = 10000000 * d.upgrades.max_bank
            local gross    = 100000 + (50000 * d.upgrades.max_profit)
            local netIncome = gross - 20000
            d.bank = math.min(math.max(0, d.bank + netIncome), maxBank)
            SaveBizData(id)
        end
    end
    SyncData()
end)

net.Receive("BizSys_PlaceBid", function(len, ply)
    local id  = net.ReadString()
    local bid = net.ReadInt(32)

    if not IsValidBizId(id) then return end
    local d = BizSystem.Data[id]

    if not d or d.owner ~= "none" then return end
    if not bid or bid <= 0 then return end

    local owned = 0
    for _, b in pairs(BizSystem.Data) do
        if b.owner == ply:SteamID() or b.top_bidder == ply:SteamID() then owned = owned + 1 end
    end
    if owned >= 1 then
        DarkRP.notify(ply, 1, 5, "Вы можете владеть или ставить только на 1 бизнес!")
        return
    end

    if bid <= d.top_bid then
        DarkRP.notify(ply, 1, 5, "Ставка должна быть больше текущей!")
        return
    end

    if ply:canAfford(bid) then
        if d.top_bidder ~= "none" then
            local oldBidder = player.GetBySteamID(d.top_bidder)
            if IsValid(oldBidder) then
                oldBidder:addMoney(d.top_bid)
                DarkRP.notify(oldBidder, 1, 5, "Вашу ставку перебили! Деньги возвращены.")
            else
                AddRefund(d.top_bidder, d.top_bid)
            end
        end
        if d.top_bidder == "none" then
            d.auction_time = os.time() + 86400
        end
        ply:addMoney(-bid)
        d.top_bid         = bid
        d.top_bidder      = ply:SteamID()
        d.top_bidder_name = ply:Name()
        SaveBizData(id)
        SyncData()
        DarkRP.notify(ply, 0, 5, "Ставка принята!")
    else
        DarkRP.notify(ply, 1, 5, "Недостаточно средств!")
    end
end)

net.Receive("BizSys_SellBusiness", function(len, ply)
    local id = net.ReadString()
    if not IsValidBizId(id) then return end
    local d   = BizSystem.Data[id]
    local cfg = BizSystem.Config.Businesses[id]

    if not d or d.owner ~= ply:SteamID() then return end

    local upgCost  = (d.upgrades.staff - 1 + d.upgrades.quality - 1 + d.upgrades.max_profit - 1 + d.upgrades.max_bank - 1) * 5000000
    local sellPrice = math.floor((cfg.base_price * 0.5) + (upgCost * 0.5))

    ply:addMoney(sellPrice + d.bank)
    d.owner           = "none"
    d.owner_name      = "none"
    d.bank            = 0
    d.upgrades        = { staff = 1, quality = 1, max_profit = 1, max_bank = 1 }
    d.auction_time    = 0
    d.top_bid         = cfg.base_price
    d.top_bidder      = "none"
    d.top_bidder_name = "none"

    SaveBizData(id)
    SyncData()
    DarkRP.notify(ply, 0, 5, "Бизнес продан за " .. DarkRP.formatMoney(sellPrice))
end)

net.Receive("BizSys_BuyShares", function(len, ply)
    local id     = net.ReadString()
    local amount = net.ReadInt(32)

    if not IsValidBizId(id) then return end
    if not amount or amount <= 0 or amount > MAX_BUY_PER_TX then
        DarkRP.notify(ply, 1, 5, "Можно купить от 1 до " .. MAX_BUY_PER_TX .. " акций за раз!")
        return
    end
    if IsOnShareCooldown(ply) then return end

    local d        = BizSystem.Data[id]
    local curShares = GetPlayerShares(ply, id)

    if curShares + amount > MAX_SHARES_PER_BIZ then
        DarkRP.notify(ply, 1, 5, "Максимум " .. MAX_SHARES_PER_BIZ .. " акций на один бизнес!")
        return
    end

    local cost = d.share_price * amount
    if ply:canAfford(cost) then
        ply:addMoney(-cost)
        SetPlayerShares(ply, id, curShares + amount)
        SetShareCooldown(ply)
        SyncData()
        DarkRP.notify(ply, 0, 5, "Куплено " .. amount .. " акций.")
    else
        DarkRP.notify(ply, 1, 5, "Недостаточно средств!")
    end
end)

net.Receive("BizSys_SellShares", function(len, ply)
    local id     = net.ReadString()
    local amount = net.ReadInt(32)

    if not IsValidBizId(id) then return end
    if not amount or amount <= 0 or amount > MAX_SELL_PER_TX then
        DarkRP.notify(ply, 1, 5, "Можно продать от 1 до " .. MAX_SELL_PER_TX .. " акций за раз!")
        return
    end
    if IsOnShareCooldown(ply) then return end

    local d   = BizSystem.Data[id]
    local cur = GetPlayerShares(ply, id)
    if cur >= amount then
        local revenue    = d.share_price * amount
        local commission = math.floor(revenue * SELL_COMMISSION)
        local payout     = revenue - commission
        ply:addMoney(payout)
        SetPlayerShares(ply, id, cur - amount)
        SetShareCooldown(ply)
        SyncData()
        DarkRP.notify(ply, 0, 5, "Акции проданы за " .. DarkRP.formatMoney(payout) .. " (комиссия " .. DarkRP.formatMoney(commission) .. ")")
    else
        DarkRP.notify(ply, 1, 5, "У вас нет столько акций!")
    end
end)

net.Receive("BizSys_Withdraw", function(len, ply)
    local id     = net.ReadString()
    local amount = net.ReadInt(32)
    if not IsValidBizId(id) then return end
    local d = BizSystem.Data[id]
    if not d or d.owner ~= ply:SteamID() or amount <= 0 then return end
    if d.bank >= amount then
        d.bank = d.bank - amount
        ply:addMoney(amount)
        SaveBizData(id)
        SyncData()
        DarkRP.notify(ply, 0, 5, "Снято " .. DarkRP.formatMoney(amount))
    else
        DarkRP.notify(ply, 1, 5, "В сейфе нет столько денег!")
    end
end)

net.Receive("BizSys_Deposit", function(len, ply)
    local id     = net.ReadString()
    local amount = net.ReadInt(32)
    if not IsValidBizId(id) then return end
    local d = BizSystem.Data[id]

    if not d or d.owner ~= ply:SteamID() or amount <= 0 then return end

    local maxBank = 10000000 * d.upgrades.max_bank
    if d.bank + amount > maxBank then
        DarkRP.notify(ply, 1, 5, "Сейф не вместит такую сумму!")
        return
    end

    if ply:canAfford(amount) then
        ply:addMoney(-amount)
        d.bank = d.bank + amount
        SaveBizData(id)
        SyncData()
        DarkRP.notify(ply, 0, 5, "Вы положили " .. DarkRP.formatMoney(amount) .. " в сейф.")
    else
        DarkRP.notify(ply, 1, 5, "У вас недостаточно средств!")
    end
end)

net.Receive("BizSys_Upgrade", function(len, ply)
    local id      = net.ReadString()
    local upgType = net.ReadString()
    if not IsValidBizId(id) then return end
    if not VALID_UPGRADE_TYPES[upgType] then return end
    local d = BizSystem.Data[id]
    if not d or d.owner ~= ply:SteamID() then return end
    local curLvl = d.upgrades[upgType]
    if not curLvl or curLvl >= 5 then return end
    if d.bank >= 5000000 then
        d.bank = d.bank - 5000000
        d.upgrades[upgType] = curLvl + 1
        SaveBizData(id)
        SyncData()
        DarkRP.notify(ply, 0, 5, "Улучшение успешно куплено!")
    else
        DarkRP.notify(ply, 1, 5, "Недостаточно средств в сейфе бизнеса!")
    end
end)