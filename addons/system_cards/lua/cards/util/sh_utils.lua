local obicnaya  = Color(196,196,196)
local neploho   = Color(251,255,39)
local srednak   = Color(255,130,39)
local kruto     = Color(255,77,119)
local ebanuto   = Color(77,255,126)

enc.cardsmenu = {
    {
        name = '5 000₽',
        model = 'models/props/cs_assault/Money.mdl',
        wep = false,
        max = 1,
        rarity = obicnaya,
        chance = 100000,
        desc = 'Собрав карту вы получите 5 000₽. Вы можете разобрать карту и получить 1 фрагмент',
        cost = 2,
        analysis = 1,
        prize = function(pl)
            pl:AddMoney(5000, 'Получение с Cards 5.000₽')
        end,
    },
    {
        name = '25 000₽',
        model = 'models/props/cs_assault/Money.mdl',
        wep = false,
        max = 2,
        rarity = obicnaya,
        chance = 95000,
        desc = 'Собрав карту вы получите 25 000₽. Вы можете разобрать карту и получить 1 фрагмент',
        cost = 5,
        analysis = 1,
        prize = function(pl)
            pl:AddMoney(25000, 'Получение с Cards 25.000₽')
        end,
    },
    {
        name = '50 000₽',
        model = 'models/props/cs_assault/Money.mdl',
        wep = false,
        max = 3,
        rarity = obicnaya,
        chance = 90000,
        desc = 'Собрав карту вы получите 50 000₽. Вы можете разобрать карту и получить 1 фрагмент',
        cost = 6,
        analysis = 1,
        prize = function(pl)
            pl:AddMoney(50000, 'Получение с Cards 50.000₽')
        end,
    },
    {
        name = '100 000₽',
        model = 'models/props/cs_assault/Money.mdl',
        wep = false,
        max = 4,
        rarity = neploho,
        chance = 8500,
        desc = 'Собрав карту вы получите 100 000₽. Вы можете разобрать карту и получить 1 фрагмент',
        cost = 7,
        analysis = 1,
        prize = function(pl)
            pl:AddMoney(100000, 'Получение с Cards 100.000₽')
        end,
    },
    {
        name = '500 000₽',
        model = 'models/props/cs_assault/Money.mdl',
        wep = false,
        max = 4,
        rarity = srednak,
        chance = 600,
        desc = 'Собрав карту вы получите 500 000₽. Вы можете разобрать карту и получить 3 фрагмента',
        cost = 10,
        analysis = 3,
        prize = function(pl)
            pl:AddMoney(500000, 'Получение с Cards 500.000₽')
        end,
    },
    {
        name = '15 JC',
        model = 'models/props/cs_assault/Money.mdl',
        wep = false,
        max = 5,
        rarity = neploho,
        chance = 4000,
        desc = 'Собрав карту вы получите 15 JC. Вы можете разобрать карту и получить 2 фрагмента',
        cost = 15,
        analysis = 2,
        prize = function(pl)
            KylDonate.AddDonateCoins(pl:SteamID(), 15)
        end,
    },
    {
        name = '50 JC',
        model = 'models/props/cs_assault/Money.mdl',
        wep = false,
        max = 10,
        rarity = srednak,
        chance = 200,
        desc = 'Собрав карту вы получите 50 JC. Вы можете разобрать карту и получить 3 фрагмента',
        cost = 30,
        analysis = 3,
        prize = function(pl)
            KylDonate.AddDonateCoins(pl:SteamID(), 50)
        end,
    },
    {
        name = 'Glock 18',
        model = 'models/weapons/tfa_w_dmg_glock.mdl',
        wep = true,
        max = 10,
        rarity = neploho,
        chance = 8000,
        desc = 'Собрав карту вы получите Glock 18 навсегда. Вы можете разобрать карту и получить 3 фрагмента',
        cost = 40,
        analysis = 3,
        prize = function(pl)
            KylDonate.BuyItem2DBWeapon(pl:SteamID(), "tfa_glock")
        end,
    },
    {
        name = 'P08 Luger',
        model = 'models/weapons/tfa_w_luger_p08.mdl',
        wep = true,
        max = 10,
        rarity = neploho,
        chance = 8000,
        desc = 'Собрав карту вы получите P08 Luger навсегда. Вы можете разобрать карту и получить 3 фрагмента',
        cost = 40,
        analysis = 3,
        prize = function(pl)
            KylDonate.BuyItem2DBWeapon(pl:SteamID(), "tfa_luger_p08")
        end,
    },
    {
        name = 'HK 416',
        model = 'models/weapons/tfa_w_hk_416.mdl',
        wep = true,
        max = 15,
        rarity = srednak,
        chance = 30,
        desc = 'Собрав карту вы получите HK 416 навсегда. Вы можете разобрать карту и получить 5 фрагмента',
        cost = 100,
        analysis = 5,
        prize = function(pl)
            KylDonate.BuyItem2DBWeapon(pl:SteamID(), "tfa_m416")
        end,
    },
    {
        name = 'AS VAL',
        model = 'models/weapons/tfa_w_dmg_vally.mdl',
        wep = true,
        max = 15,
        rarity = srednak,
        chance = 30,
        desc = 'Собрав карту вы получите AS VAL навсегда. Вы можете разобрать карту и получить 5 фрагмента',
        cost = 100,
        analysis = 5,
        prize = function(pl)
            KylDonate.BuyItem2DBWeapon(pl:SteamID(), "tfa_val")
        end,
    },
    {
        name = 'PKM',
        model = 'models/weapons/tfa_w_mach_russ_pkm.mdl',
        wep = true,
        max = 30,
        rarity = kruto,
        chance = 15,
        desc = 'Собрав карту вы получите PKM навсегда. Вы можете разобрать карту и получить 5 фрагмента',
        cost = 180,
        analysis = 5,
        prize = function(pl)
            KylDonate.BuyItem2DBWeapon(pl:SteamID(), "tfa_pkm")
        end,
    },
    {
        name = 'Double Barrel',
        model = 'models/weapons/tfa_w_double_barrel_shotgun.mdl',
        wep = true,
        max = 35,
        rarity = kruto,
        chance = 10,
        desc = 'Собрав карту вы получите Double Barrel навсегда. Вы можете разобрать карту и получить 5 фрагмента',
        cost = 200,
        analysis = 5,
        prize = function(pl)
            KylDonate.BuyItem2DBWeapon(pl:SteamID(), "tfa_dbarrel")
        end,
    },
    {
        name = 'SVD Dragunov',
        model = 'models/weapons/tfa_w_svd_dragunov.mdl',
        wep = true,
        max = 40,
        rarity = ebanuto,
        chance = 2,
        desc = 'Собрав карту вы получите SVD Dragunov навсегда. Вы можете разобрать карту и получить 7 фрагментов',
        cost = 350,
        analysis = 7,
        prize = function(pl)
            KylDonate.BuyItem2DBWeapon(pl:SteamID(), "tfa_dragunov")
        end,
    },
    {
        name = 'Barret M82',
        model = 'models/weapons/tfa_w_barret_m82.mdl',
        wep = true,
        max = 45,
        rarity = ebanuto,
        chance = 2,
        desc = 'Собрав карту вы получите Barret M82 навсегда. Вы можете разобрать карту и получить 8 фрагментов',
        cost = 375,
        analysis = 8,
        prize = function(pl)
            KylDonate.BuyItem2DBWeapon(pl:SteamID(), "tfa_barret_m82")
        end,
    },
    {
        name = 'RPG',
        model = 'models/weapons/w_rocket_launcher.mdl',
        wep = true,
        max = 100,
        rarity = ebanuto,
        chance = 1,
        desc = 'Собрав карту вы получите RPG навсегда. Вы можете разобрать карту и получить 10 фрагментов',
        cost = 1000,
        analysis = 10,
        prize = function(pl)
            KylDonate.BuyItem2DBWeapon(pl:SteamID(), "rpg")
        end,
    },
}
