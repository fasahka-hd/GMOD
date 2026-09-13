--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

-- ЭТОТ ПРОМИК МОЖНО АКТИВИРОВАТЬ ВСЕГО 5 РАЗ - РАЗНЫМИ ЛЮДЬМИ ( 1 активация на человека )
KylPromos:CreatePromo("START", {
    customcheck = function(ply, promo) return ply:IsPlayer() and KylPromos.GetActiveCount(promo) < 100 end,
    callback = function(ply) KylDonate.AddDonateCoins(ply:SteamID(), 100) ply:AddMoney(100000) end,
    fallback = function(ply) ply:ChatPrint("Этот промокод могли активировать только 100 человек. Прости но ты опоздал") end
})

KylPromos:CreatePromo("ARIZONA", {
    customcheck = function(ply, promo) return ply:IsPlayer() and KylPromos.GetActiveCount(promo) < 25 end,
    callback = function(ply) KylDonate.AddDonateCoins(ply:SteamID(), 50) ply:AddMoney(100000) end,
    fallback = function(ply) ply:ChatPrint("Этот промокод могли активировать только 25 человек. Прости но ты опоздал") end
})

KylPromos:CreatePromo("MICRO", {
    customcheck = function(ply, promo) return ply:IsPlayer() and KylPromos.GetActiveCount(promo) < 25 end,
    callback = function(ply) KylDonate.AddDonateCoins(ply:SteamID(), 25) ply:AddMoney(150000) end,
    fallback = function(ply) ply:ChatPrint("Этот промокод могли активировать только 25 человек. Прости но ты опоздал") end
})

KylPromos:CreatePromo("DJIGURDA", {
    customcheck = function(ply, promo) return ply:IsPlayer() and KylPromos.GetActiveCount(promo) < 25 end,
    callback = function(ply) KylDonate.AddDonateCoins(ply:SteamID(), 50) ply:AddMoney(100000) end,
    fallback = function(ply) ply:ChatPrint("Этот промокод могли активировать только 25 человек. Прости но ты опоздал") end
})
-- ЭТОТ ПРОМИК МОЖНО АКТИВИРОВАТЬ 1 раз КАЖДЫЙ ИГРОК
-- KylPromos:CreatePromo("FirstJoin", {
--     customcheck = function(ply) return ply:IsPlayer() end,
--     callback = function(ply) KylDonate.AddDonateCoins(ply:SteamID(), 200) end,
--     fallback = function(ply) end
-- })

-- KylPromos:CreatePromo("c0nfuse_2", {
--     customcheck = function(ply) return ply:IsPlayer() and ( ply:SteamID() == "STEAM_0:1:701225551" or ply:SteamID() == "STEAM_0:1:82408619" ) end,
--     callback = function(ply) KylDonate.AddDonateCoins(ply:SteamID(), 2550) end,
--     fallback = function(ply) ply:ChatPrint("dalbaeb") end
-- })

-- KylPromos:CreatePromo("tiff", {
--     customcheck = function(ply) return ply:IsPlayer() end,
--     callback = function(ply) KylDonate.AddDonateCoins(ply:SteamID(), 2550) end,
--     fallback = function(ply) ply:ChatPrint("dalbaeb") end
-- })

-- KylPromos:CreatePromo("update_soon_new_year", {
--     customcheck = function(ply) return ply:IsPlayer() end,
--     callback = function(ply) KylDonate.AddDonateCoins(ply:SteamID(), 100) ply:AddMoney(100000) ply:ChatPrint('Вы получили: 100 Just Coins и 100.000p ') end,
--     fallback = function(ply) end
-- })

-- KylPromos:CreatePromo("zavtra_tochno_obnova", {
--     customcheck = function(ply) return ply:IsPlayer() end,
--     callback = function(ply) KylDonate.AddDonateCoins(ply:SteamID(), 100) ply:AddMoney(100000) ply:ChatPrint('Вы получили: 100 Just Coins и 100.000p ') end,
--     fallback = function(ply) end
-- })

-- KylPromos:CreatePromo("newyear", {
--     customcheck = function(ply, promo) return ply:IsPlayer() and KylPromos.GetActiveCount(promo) < 35 end,
--     callback = function(ply) KylDonate.AddDonateCoins(ply:SteamID(), 50) ply:AddMoney(100000) ply:ChatPrint('Вы получили: 50 Just Coins и 100.000p ') end,
--     fallback = function(ply) ply:ChatPrint("Этот промокод могли активировать только 35 человек. Прости но ты опоздал") end
-- })


-- KylPromos:CreatePromo("2025", {
--     customcheck = function(ply, promo) return ply:IsPlayer() and KylPromos.GetActiveCount(promo) < 100 end,
--     callback = function(ply) KylDonate.AddDonateCoins(ply:SteamID(), 35) ply:AddMoney(50000, 'Активация промокода "2025"') ply:ChatPrint('Вы получили: 35 Just Coins и 50.000p ') end,
--     fallback = function(ply) ply:ChatPrint("Этот промокод могли активировать только 35 человек. Прости но ты опоздал") end
-- })

-- KylPromos:CreatePromo("sorry", {
--     customcheck = function(ply, promo) return ply:IsPlayer() and KylPromos.GetActiveCount(promo) < 25 end,
--     callback = function(ply) KylDonate.AddDonateCoins(ply:SteamID(), 50) ply:AddMoney(100000, 'Активация промокода "sorry"') ply:ChatPrint('Вы получили: 50 Just Coins и 100.000p ') end,
--     fallback = function(ply) ply:ChatPrint("Этот промокод могли активировать только 35 человек. Прости но ты опоздал") end
-- })

--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
