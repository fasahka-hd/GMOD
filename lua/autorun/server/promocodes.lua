VibeRP = VibeRP or {}

local PromoCodes = VibeRP.PromoCodes or {}
VibeRP.PromoCodes = PromoCodes

local Pending = {}
local PROMO_SYNC_TIMER = "VibeRP_PromoSync"
local PROMO_REGISTER_TIMER = "VibeRP_PromoRegisterCommands"

local ERROR_TEXT = {
    NOT_FOUND     = "Промокод не найден",
    BAD_CODE      = "Некорректный промокод",
    BAD_PARAMS    = "Некорректный запрос промокода",
    INACTIVE      = "Промокод выключен",
    EXPIRED       = "Промокод истёк",
    LIMIT_REACHED = "Промокод исчерпан",
    ALREADY_USED  = "Вы уже использовали этот промокод",
    DB_ERROR      = "Ошибка сервера промокодов",
}

local function promoPrint(msg)
    print("[ПРОМОКОДЫ] " .. tostring(msg))
end

local function getConfig()
    if not VibeRP or not VibeRP.Config then return nil end
    if not VibeRP.Config.PanelURL or VibeRP.Config.PanelURL == "" then return nil end
    if not VibeRP.Config.Secret or VibeRP.Config.Secret == "" then return nil end
    return VibeRP.Config
end

local function panelURL()
    local cfg = getConfig()
    if not cfg then return nil end
    local url = tostring(cfg.PanelURL or "")
    url = string.gsub(url, "/+$", "")
    return url
end

local function urlEncode(str)
    str = tostring(str or "")
    str = string.gsub(str, "\n", "\r\n")
    str = string.gsub(str, "([^%w _%%%-%.~])", function(c)
        return string.format("%%%02X", string.byte(c))
    end)
    str = string.gsub(str, " ", "+")
    return str
end

local function buildQuery(params)
    local q = {}
    for k, v in pairs(params or {}) do
        if v ~= nil then
            q[#q + 1] = urlEncode(k) .. "=" .. urlEncode(v)
        end
    end
    return table.concat(q, "&")
end

local function normalizeCode(code)
    code = tostring(code or "")
    code = string.gsub(code, "\"", "")
    code = string.Trim and string.Trim(code) or string.match(code, "^%s*(.-)%s*$") or code
    code = string.upper(code)
    code = string.gsub(code, "[^A-Z0-9_]", "")
    return code
end

local function notify(ply, msg)
    if not IsValid(ply) then return end
    msg = tostring(msg or "")
    if ply.Notify then
        ply:Notify(NOTIFY_GENERIC or 0, msg)
    else
        ply:ChatPrint(msg)
    end
end

local function parseJson(body)
    local ok, data = pcall(util.JSONToTable, body or "")
    if ok and istable(data) then return data end
    return nil
end

local function httpGet(endpoint, params, callback, attempt)
    attempt = attempt or 1
    local cfg = getConfig()
    local base = panelURL()
    if not cfg or not base then
        promoPrint("PanelURL/Secret не настроены в site.lua")
        if callback then callback(nil, 0) end
        return
    end

    params = params or {}
    params.password = cfg.Secret

    local query = buildQuery(params)
    local url = base .. endpoint .. (query ~= "" and ("?" .. query) or "")
    HTTP({
        url = url,
        method = "GET",
        headers = {
            ["X-API-Password"] = cfg.Secret,
            ["Accept"] = "application/json"
        },
        success = function(code, body)
            local data = parseJson(body)
            if code >= 200 and code < 300 and data then
                if callback then callback(data, code) end
            else
                local maxRetries = tonumber(cfg.HttpRetries) or 3
                if attempt < maxRetries then
                    timer.Simple(tonumber(cfg.HttpRetryDelay) or 2, function()
                        httpGet(endpoint, params, callback, attempt + 1)
                    end)
                else
                    promoPrint("GET " .. endpoint .. " failed, HTTP " .. tostring(code))
                    if callback then callback(data, code) end
                end
            end
        end,
        failed = function(reason)
            local maxRetries = tonumber(cfg.HttpRetries) or 3
            if attempt < maxRetries then
                timer.Simple(tonumber(cfg.HttpRetryDelay) or 2, function()
                    httpGet(endpoint, params, callback, attempt + 1)
                end)
            else
                promoPrint("GET " .. endpoint .. " failed: " .. tostring(reason))
                if callback then callback(nil, 0) end
            end
        end
    })
end

local function httpPost(endpoint, payload, callback, attempt)
    attempt = attempt or 1
    local cfg = getConfig()
    local base = panelURL()
    if not cfg or not base then
        promoPrint("PanelURL/Secret не настроены в site.lua")
        if callback then callback(nil, 0) end
        return
    end

    payload = payload or {}
    payload.password = cfg.Secret

    HTTP({
        url = base .. endpoint,
        method = "POST",
        body = util.TableToJSON(payload) or "{}",
        type = "application/json",
        headers = {
            ["X-API-Password"] = cfg.Secret,
            ["Content-Type"] = "application/json",
            ["Accept"] = "application/json"
        },
        success = function(code, body)
            local data = parseJson(body)
            if code >= 200 and code < 300 and data then
                if callback then callback(data, code) end
            else
                local maxRetries = tonumber(cfg.HttpRetries) or 3
                if attempt < maxRetries then
                    timer.Simple(tonumber(cfg.HttpRetryDelay) or 2, function()
                        httpPost(endpoint, payload, callback, attempt + 1)
                    end)
                else
                    promoPrint("POST " .. endpoint .. " failed, HTTP " .. tostring(code) .. ", body: " .. tostring(body))
                    if callback then callback(data, code) end
                end
            end
        end,
        failed = function(reason)
            local maxRetries = tonumber(cfg.HttpRetries) or 3
            if attempt < maxRetries then
                timer.Simple(tonumber(cfg.HttpRetryDelay) or 2, function()
                    httpPost(endpoint, payload, callback, attempt + 1)
                end)
            else
                promoPrint("POST " .. endpoint .. " failed: " .. tostring(reason))
                if callback then callback(nil, 0) end
            end
        end
    })
end

local function promoIsExpired(promo)
    if not promo or not promo.exp_date or promo.exp_date == "" then return false end
    local y, mo, d, h, mi, s = string.match(tostring(promo.exp_date), "(%d+)-(%d+)-(%d+)%s+(%d+):(%d+):(%d+)")
    if not y then return false end
    local ts = os.time({
        year = tonumber(y), month = tonumber(mo), day = tonumber(d),
        hour = tonumber(h), min = tonumber(mi), sec = tonumber(s)
    })
    return ts and os.time() > ts
end

local function cachePromo(row)
    if not istable(row) then return end
    local code = normalizeCode(row.code)
    if code == "" then return end
    local active = row.is_active == true or row.is_active == 1 or row.is_active == "1"
    if not active then
        PromoCodes[code] = nil
        return
    end

    PromoCodes[code] = {
        id         = tonumber(row.id) or 0,
        code       = code,
        donate     = tonumber(row.donate) or 0,
        money      = tonumber(row.money) or 0,
        max_uses   = tonumber(row.max_uses) or 0,
        used_count = tonumber(row.used_count) or 0,
        exp_date   = row.expiration_date,
        is_active  = true,
    }
end

local function canGiveDonate(amount)
    amount = tonumber(amount) or 0
    if amount <= 0 then return true end
    if KylDonate and isfunction(KylDonate.AddDonateCoins) then return true end
    if IGS and IGS.PLAYER and isfunction(IGS.PLAYER.AddFunds) then return true end
    return true
end

local function giveDonate(ply, amount, promoCode)
    amount = tonumber(amount) or 0
    if amount <= 0 then return true end
    if not IsValid(ply) then return false end

    if isfunction(ply.AddIGSFunds) then
        local ok, err = pcall(function()
            ply:AddIGSFunds(amount, "Промокод " .. tostring(promoCode or ""), function()
                if IsValid(ply) then
                    promoPrint("AddIGSFunds callback OK: выдано " .. amount .. " донат-рублей игроку " .. ply:SteamID())
                end
            end)
        end)
        if ok then
            promoPrint("Выдано " .. amount .. " донат-рублей через AddIGSFunds игроку " .. ply:SteamID() .. " за промокод " .. tostring(promoCode or ""))
            return true
        else
            promoPrint("AddIGSFunds error: " .. tostring(err))
        end
    else
        promoPrint("У игрока нет функции AddIGSFunds. Проверяю другие способы выдачи...")
    end

    if KylDonate and isfunction(KylDonate.SetDonateCoins) then
        local current = 0
        if isfunction(ply.GetNWInt) then current = tonumber(ply:GetNWInt("kyl_balance", 0)) or 0 end
        local newBalance = math.max(0, math.floor(current + amount))
        local ok, err = pcall(function()
            KylDonate.SetDonateCoins(ply:SteamID(), newBalance)
            ply:SetNWInt("kyl_balance", newBalance)
        end)
        if ok then
            promoPrint("Выдано " .. amount .. " донат-рублей через KylDonate.SetDonateCoins игроку " .. ply:SteamID())
            return true
        else
            promoPrint("KylDonate.SetDonateCoins error: " .. tostring(err))
        end
    end

    if KylDonate and isfunction(KylDonate.AddDonateCoins) then
        local ok, err = pcall(function() KylDonate.AddDonateCoins(ply:SteamID(), amount) end)
        if ok then
            promoPrint("Выдано " .. amount .. " донат-рублей через KylDonate.AddDonateCoins игроку " .. ply:SteamID())
            return true
        else
            promoPrint("KylDonate.AddDonateCoins error: " .. tostring(err))
        end
    end

    if IGS and IGS.PLAYER and isfunction(IGS.PLAYER.AddFunds) then
        local ok, err = pcall(function() IGS.PLAYER.AddFunds(ply, amount) end)
        if ok then return true else promoPrint("IGS.PLAYER.AddFunds error: " .. tostring(err)) end
    end

    if isfunction(ply.addDonate) then
        local ok, err = pcall(function() ply:addDonate(amount) end)
        if ok then return true else promoPrint("addDonate error: " .. tostring(err)) end
    end

    return false
end

local function giveMoney(ply, amount)
    amount = tonumber(amount) or 0
    if amount <= 0 then return true end
    if not IsValid(ply) then return false end

    if isfunction(ply.addMoney) then
        local ok = pcall(function() ply:addMoney(amount) end)
        if ok then return true end
    end

    if isfunction(ply.AddMoney) then
        local ok = pcall(function() ply:AddMoney(amount) end)
        if ok then return true end
    end

    return false
end

local function applyReward(ply, code, reward)
    if not IsValid(ply) then return false end
    reward = reward or {}

    local donate = tonumber(reward.donate) or 0
    local money = tonumber(reward.money) or 0
    local rewardText = {}

    if donate > 0 then
        if not giveDonate(ply, donate, code) then
            notify(ply, "Ошибка: система доната не найдена")
            return false
        end
        rewardText[#rewardText + 1] = donate .. " донат-рублей"
    end

    if money > 0 then
        if not giveMoney(ply, money) then
            notify(ply, "Ошибка: система денег не найдена")
            return false
        end
        rewardText[#rewardText + 1] = string.Comma(money) .. "$"
    end

    if #rewardText == 0 then
        notify(ply, "Промокод активирован, но награда пустая")
        return true
    end

    notify(ply, "Вы получили: " .. table.concat(rewardText, " + ") .. " за промокод " .. code .. "!")

    for _, v in ipairs(player.GetAll()) do
        if IsValid(v) and v ~= ply then
            v:ChatPrint(ply:Nick() .. " активировал промокод /" .. string.lower(code))
        end
    end

    return true
end

local function handlePromoError(ply, err)
    notify(ply, ERROR_TEXT[tostring(err or "")] or "Ошибка проверки промокода, попробуйте позже")
end

local function getCachedRewardById(id)
    id = tonumber(id) or 0
    for _, promo in pairs(PromoCodes) do
        if tonumber(promo.id) == id then
            return { donate = promo.donate or 0, money = promo.money or 0 }, promo.code
        end
    end
    return nil, nil
end

local function fallbackActivateCached(ply, code, done)
    local promo = PromoCodes[code]
    if not promo then
        handlePromoError(ply, "NOT_FOUND")
        if done then done() end
        return
    end

    if promoIsExpired(promo) then
        handlePromoError(ply, "EXPIRED")
        if done then done() end
        return
    end

    if promo.max_uses > 0 and promo.used_count >= promo.max_uses then
        handlePromoError(ply, "LIMIT_REACHED")
        if done then done() end
        return
    end

    local function recordNow()
        httpPost("/api/promos_sync", {
            action    = "record_use",
            promo_id  = promo.id,
            steamid64 = ply:SteamID64(),
            steamid32 = ply:SteamID(),
            nickname  = ply:Nick(),
        }, function(data)
            if not IsValid(ply) then if done then done() end return end

            if data and data.ok and (data.recorded ~= false) then
                if applyReward(ply, code, { donate = promo.donate, money = promo.money }) then
                    timer.Simple(1, function() if VibeRP.SyncPromos then VibeRP.SyncPromos() end end)
                end
            else
                handlePromoError(ply, data and data.error or "DB_ERROR")
            end

            if done then done() end
        end)
    end

    httpGet("/api/promos_sync", {
        action = "has_used",
        promo_id = promo.id,
        steamid64 = ply:SteamID64(),
    }, function(usedData)
        if not IsValid(ply) then if done then done() end return end
        if usedData and usedData.ok and usedData.used == true then
            handlePromoError(ply, "ALREADY_USED")
            if done then done() end
            return
        end

        if promo.max_uses > 0 then
            httpGet("/api/promos_sync", { action = "get_usage_count", promo_id = promo.id }, function(countData)
                if not IsValid(ply) then if done then done() end return end
                if countData and countData.ok and tonumber(countData.count or 0) >= promo.max_uses then
                    handlePromoError(ply, "LIMIT_REACHED")
                    if done then done() end
                    return
                end
                recordNow()
            end)
        else
            recordNow()
        end
    end)
end

function VibeRP.SyncPromos()
    if not getConfig() then
        promoPrint("site.lua ещё не загрузился или не настроен")
        return
    end

    httpGet("/api/promos_sync", { action = "list" }, function(data)
        if not data or not data.ok then
            promoPrint("Не удалось получить список промокодов")
            return
        end

        local newPromos = {}
        PromoCodes = newPromos
        VibeRP.PromoCodes = PromoCodes

        for _, row in ipairs(data.items or {}) do
            cachePromo(row)
        end

        promoPrint("Синхронизировано " .. table.Count(PromoCodes) .. " промокодов с сайта")
        VibeRP.RegisterPromoCommands()
    end)
end

function VibeRP.ActivatePromo(ply, rawCode)
    if not IsValid(ply) or not ply:IsPlayer() or ply:IsBot() then return end

    local code = normalizeCode(rawCode)
    if code == "" or #code < 2 then
        notify(ply, "Введите промокод")
        return
    end

    local sid64 = ply:SteamID64()
    if Pending[sid64] and Pending[sid64] > CurTime() then
        notify(ply, "Подождите, промокод уже проверяется...")
        return
    end
    Pending[sid64] = CurTime() + 10

    local function activateCached()
        local cached = PromoCodes[code]
        if not cached then return false end

        if not cached.id or tonumber(cached.id) <= 0 then
            promoPrint("Промокод " .. code .. " есть в кеше, но без id. Обновляю список с сайта.")
            PromoCodes[code] = nil
            return false
        end

        if promoIsExpired(cached) then
            Pending[sid64] = nil
            handlePromoError(ply, "EXPIRED")
            return true
        end

        if cached.max_uses > 0 and cached.used_count >= cached.max_uses then
            Pending[sid64] = nil
            handlePromoError(ply, "LIMIT_REACHED")
            return true
        end

        if (cached.donate or 0) > 0 and not canGiveDonate(cached.donate) then
            Pending[sid64] = nil
            notify(ply, "Ошибка: система доната не найдена")
            return true
        end

        fallbackActivateCached(ply, code, function()
            Pending[sid64] = nil
        end)
        return true
    end

    if activateCached() then return end

    promoPrint("Промокод " .. code .. " не найден в локальном кеше, обновляю список с сайта...")
    httpGet("/api/promos_sync", { action = "list" }, function(data)
        if not IsValid(ply) then Pending[sid64] = nil return end

        if not data or not data.ok then
            Pending[sid64] = nil
            handlePromoError(ply, "DB_ERROR")
            return
        end

        for _, row in ipairs(data.items or {}) do
            cachePromo(row)
        end

        if activateCached() then return end

        Pending[sid64] = nil
        handlePromoError(ply, "NOT_FOUND")
    end)
end

function VibeRP.RegisterPromoCommands()
    local function usePromoCommand(ply, cmd, args, argStr)
        if not IsValid(ply) then return end
        local code = argStr or ""
        if code == "" and istable(args) then code = table.concat(args, " ") end
        VibeRP.ActivatePromo(ply, code)
    end

    concommand.Add("kyl_usepromo", usePromoCommand)
    concommand.Add("viberp_usepromo", usePromoCommand)
    concommand.Add("promo_use", usePromoCommand)
    concommand.Add("promocode", usePromoCommand)

    if KylPromos and istable(KylPromos) then
        KylPromos.UsePromo = function(a, b, c)
            local ply, promo
            if IsValid(a) then
                ply, promo = a, b
            else
                ply, promo = b, c
            end
            if not IsValid(ply) then return end
            VibeRP.ActivatePromo(ply, promo)
        end
    end

    for code in pairs(PromoCodes) do
        local cmdName = string.lower(code)
        if cmdName ~= "" then
            concommand.Add(cmdName, function(ply)
                VibeRP.ActivatePromo(ply, code)
            end)

            if ba and ba.cmd and isfunction(ba.cmd.Create) then
                local exists = false
                if isfunction(ba.cmd.Exists) then
                    local ok, res = pcall(ba.cmd.Exists, cmdName)
                    exists = ok and res == true
                end
                if not exists then
                    pcall(function()
                        ba.cmd.Create(cmdName, function(ply)
                            VibeRP.ActivatePromo(ply, code)
                        end):SetHelp("Активировать промокод " .. cmdName)
                    end)
                end
            end
        end
    end
end

hook.Add("PlayerSay", "VibeRP_PromoChatCommands", function(ply, text)
    text = tostring(text or "")
    local code = string.match(text, "^[!/%.]promo%s+(.+)$") or string.match(text, "^[!/%.]promocode%s+(.+)$")
    if code then
        VibeRP.ActivatePromo(ply, code)
        return ""
    end
end)

hook.Add("Initialize", "VibeRP_PromoInit", function()
    timer.Simple(2, function()
        if VibeRP.RegisterPromoCommands then VibeRP.RegisterPromoCommands() end
    end)

    timer.Simple(8, function()
        if VibeRP.SyncPromos then VibeRP.SyncPromos() end
    end)

    local interval = 120
    if VibeRP.Config and tonumber(VibeRP.Config.PromoSyncInterval) then
        interval = tonumber(VibeRP.Config.PromoSyncInterval)
    end
    timer.Create(PROMO_SYNC_TIMER, interval, 0, function()
        if VibeRP.SyncPromos then VibeRP.SyncPromos() end
    end)

    timer.Create(PROMO_REGISTER_TIMER, 5, 3, function()
        if VibeRP.RegisterPromoCommands then VibeRP.RegisterPromoCommands() end
    end)
end)

timer.Simple(1, function()
    if VibeRP.RegisterPromoCommands then VibeRP.RegisterPromoCommands() end
end)
timer.Simple(10, function()
    if VibeRP.SyncPromos then VibeRP.SyncPromos() end
end)

promoPrint("Модуль загружен. F4-команда kyl_usepromo теперь отправляет активации на сайт.")