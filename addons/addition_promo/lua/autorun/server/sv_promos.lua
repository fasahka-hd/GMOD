--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

local string_lower = string.lower

-- sql.Query("CREATE TABLE IF NOT EXISTS KylPromos_Players (sid TEXT, promo TEXT)")

KylPromos = KylPromos or {}
KylPromos.List = {}


KylPromos.CreatePromo = function(self, name, data)
    if not name or not data.callback then return print("Вы забыли указать необходимые параметры") end

    data.name = string_lower(name)
    table.insert(KylPromos.List, data)
end

-- Ну если я не проебался нигде то оно получает все данные от промика по его названию
KylPromos.GetPromoData = function(promo)
    for k, v in ipairs(KylPromos.List) do
        if string_lower(v.name) == string_lower(promo) then return v end
    end
end

-- Активирует промо ну блять если это не ясно иди нахуй
KylPromos.UsePromo = function(ply, promo)
    local promo = string_lower(promo)
    local optimizonGet = KylPromos.GetPromoData(promo)
    if optimizonGet then
        if optimizonGet.customcheck(ply, promo) and not KylPromos.HasActive(ply:SteamID(), promo) then
            sql.Query(string.format("INSERT INTO KylPromos_Players (sid, promo) VALUES (%s, %s)", sql.SQLStr(ply:SteamID()), sql.SQLStr(promo)))
            optimizonGet.callback(ply, promo)
        else
            if KylPromos.HasActive(ply:SteamID(), promo) then return ply:ChatPrint("Вы уже активировали этот промокод.") end
            optimizonGet.fallback(ply)
        end
    end
end

KylPromos.GetActiveCount = function(promo)
    local promo = string_lower(promo)
    local count = sql.Query(string.format("SELECT COUNT(promo) as count FROM KylPromos_Players WHERE promo = %s", sql.SQLStr(promo)))
    return tonumber(count[1].count)
end

KylPromos.HasActive = function(sid, promo)
    local promoa = string_lower(promo)
    local active = sql.Query(string.format("SELECT promo FROM KylPromos_Players WHERE sid = %s AND promo = %s", sql.SQLStr(sid), sql.SQLStr(promoa)))
    if not active then
        return false
    end
    return true
end



local UseKD = 1
concommand.Add("kyl_usepromo", function(ply, _, _, promo)
    promo = string.gsub(promo, '"', '')
    if ply.PromoUseKD and CurTime() < ply.PromoUseKD + UseKD then return end
    KylPromos.UsePromo(ply, promo)
    ply.PromoUseKD = CurTime() + UseKD
end)

--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
