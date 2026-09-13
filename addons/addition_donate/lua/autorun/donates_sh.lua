--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

KylDonate = KylDonate or {}
KylDonate.Items = {}

KylDonate.Settings = {
    ["categorys"] = {
        ["groups"]  = true,
        ["weapons"] = true,
        ["knifes"]  = true,
        ["money"] = true,
        ["models"] = true,
        ["other"] = true
    },

    ["types"] = {
        ['models'] = true,
        ["usergroups"] = true,
        ["weapons"] = true,
        ["other"] = true
    },

    ["Ranks"] = {
        ['user'] = 1,
        ['vip'] = 2,
        ['d-moderator'] = 3,
        ['d-admin'] = 4,
        ['d-padmin'] = 5,
        ['d-sadmin'] = 6,
        ['d-hadmin'] = 7,
        ['d-owner'] = 8,
        ['d-sponsor'] = 9,
        ['helper'] = 10,
        ['moderator'] = 11,
        ['admin'] = 12,
        ['st-admin'] = 13,
        ['zam-curator'] = 14,
        ['curator'] = 15,
        ['gl-admin'] = 16,
        ['globaladmin'] = 17,
        ['sudo-root'] = 18,
        ['root'] = math.huge
    }
}

local vip1          = Material("donate/vip.png", "smooth mips")
local moderator1    = Material("donate/moderator.png", "smooth mips")
local admin1        = Material("donate/admin.png", "smooth mips")
local padmin1       = Material("donate/padmin.png", "smooth mips")
local sadmin1       = Material("donate/sadmin.png", "smooth mips")
local hadmin1       = Material("donate/hadmin.png", "smooth mips")
local owner1        = Material("donate/owner.png", "smooth mips")
local sponsor1      = Material("donate/sponsor.png", "smooth mips")

local twentyfive             = Material("donate/dpp.png", "smooth mips")
local fifty                  = Material("donate/pp.png", "smooth mips")
local onehundred             = Material("donate/stop.png", "smooth mips")
local twohundredfifty        = Material("donate/dvep.png", "smooth mips")

local patroni       = Material("donate/patroni.png", "smooth mips")
local govorilka     = Material("donate/govorilka.png", "smooth mips")

local battle_pass     = Material("f4/timecoin.png", "smooth mips")

local hqdapple      = Material("donate/apple.png", "smooth mips")
local hqdblub       = Material("donate/blub.png", "smooth mips")
local hqdenergy     = Material("donate/energy.png", "smooth mips")
local hqdananas     = Material("donate/ananas.png", "smooth mips")

local sto           = Material("donate/sto.png", "smooth mips")
local petsot        = Material("donate/petsot.png", "smooth mips")
local lyam          = Material("donate/lyam.png", "smooth mips")
local pyat          = Material("donate/pyat.png", "smooth mips")

local shield        = Material("donate/sheet.png", "smooth mips")
local lockapick     = Material("donate/lockpick.png", "smooth mips")
local crak          = Material("donate/cracker.png", "smooth mips")

local dalk            = Material("donate/knifes/dolma.png", "smooth mips")

local common        = Color(180,180,180)
local uncommon      = Color(100,151,225)
local rare          = Color(75,105,204)
local mythical      = Color(137,71,255)
local legendary     = Color(214,45,231)
local ancient       = Color(235,76,75)
local contrabanda   = Color(31,158,118)


KylDonate.RegItem = function(self, data)
    if not KylDonate.Settings["categorys"][data.category] then return print("error category in item", data.name) end
    if not KylDonate.Settings["types"][data.type] then return print("error type in item", data.name) end

    if not data.name or not data.id or not data.type or not data.category then return print("Забыли важный параметр ебланы") end

    table.insert(KylDonate.Items, data)
end

KylDonate.GetItemByName = function(name)
    for k, v in ipairs(KylDonate.Items) do
        if v.name == name then return v end
    end
end

KylDonate.GetItemByID = function(id)
    for k, v in ipairs(KylDonate.Items) do
        if v.id == id then return v end
    end
end

KylDonate.GetPermanentItemByID = function(id)
    for k, v in ipairs(KylDonate.Items) do
        if v.id == id and v.permitem then return v end
    end
end

KylDonate.CanAfford = function(ply, am)
    if ply:GetNWInt("kyl_balance") >= tonumber(am) then return true end
    return false 
end

KylDonate.CantBuy = function(item)
    if item.cantbuy then return true end
    return false
end

/*

    Обязательные параметры type, name, id, category.
    hide = показывать предмет в списке???
    permitem используется с hide = true потому что регестрирует такой же предмет, 
        отличие в том что он добавляет тег по которому система определяет выбор.
        используйте тот же id что и у не вечного предмета.
    cost = { def = int } цена на товар
    on_buy вызывается когда надо ну ето уточняйте как бы...
    weaponclass = класс какое оружие выдавать нахуй...
    cantbuy запрещает покупку
    category = категория бля
    usergroup = "привелегия "

    А вообще пошел нахуй скриптхукер хуле ты троагаешь мои фаелсы???

*/

-------------------------------------------------
-- РАНГИ
-------------------------------------------------

KylDonate:RegItem({
    name = "VIP",
    id = "vip",
    description = "▶ Возможности привилегии\n✦ VIP профессии\n✦ Покупка брони и хп\n✦ Доступ ко всем профессиям за время\n✦ Доступ к дубликатору\n✦ Доступ к стакеру",
    type = "usergroups",
    category = "groups",
    icon = vip1,
    hide = false,
    multibuy = true,
    color = Color(255,255,255),
    usergroup = "vip",
    cost = {
        def = 890,
        defperma = 1000
    },

    on_buy = function(ply)end
})

KylDonate:RegItem({
    name = "vip навсегда",
    id = "vip",
    type = "usergroups",
    category = "groups",
    icon = vip1,
    hide = true,
    multibuy = true,
    color = Color(255,255,255),
    permitem = true,  // ЭТОТ ПАРАМЕТр ГОВОРИТ ЧТО ОНА НАВСЕГДА ПОКУПАЕТСЯ
    usergroup = "vip",
    cost = {
        def = 650
    },

    on_buy = function(ply)end
})

KylDonate:RegItem({
    name = "Sponsor навсегда",
    id = "sponsor",
    type = "usergroups",
    description = "▶️ Возможности привилегии\n✦ Доступ к спавну любого автомобиля (кроме донатного и запрещенного)\n✦ Доступ к любому оружию (кроме запрещенного)\n✦ Доступ к любым профессиям\n✦ Уникальная роль в Discord\n✦ Описание доделывается..",
    category = "groups",
    icon = sponsor1,
    hide = false,
    multibuy = false,
    color = Color(255,255,255),
    permitem = true,  // ЭТОТ ПАРАМЕТр ГОВОРИТ ЧТО ОНА НАВСЕГДА ПОКУПАЕТСЯ
    usergroup = "sponsor",
    cost = {
        defperma = 6700,
    },

    on_buy = function(ply)end
})

-------------------------------------------------
-- ОРУЖИЯ
-------------------------------------------------

KylDonate:RegItem({
    name = "Пистолет Макарова",
    id = "pm",
    type = "weapons",
    w = 200,
    rare = "Обычное",
    category = "weapons",
    weaponclass = "rwp_tfa_pist_pm",
    hide = false,
    color = common,
    cost = {
        def = 350
    },

    on_buy = function(ply)end
})

KylDonate:RegItem({
    name = "TT-33",
    id = "tt33",
    w = 200,
    type = "weapons",
    category = "weapons",
    rare = "Обычное",
    weaponclass = "rwp_tfa_pist_tt33",
    hide = false,
    color = common,
    cost = {
        def = 370
    },

    on_buy = function(ply)end
})

KylDonate:RegItem({
    name = "PB",
    id = "pb",
    type = "weapons",
    w = 200,
    category = "weapons",
    rare = "Обычное",
    weaponclass = "rwp_tfa_pist_pb",
    hide = false,
    color = common,
    cost = {
        def = 400
    },

    on_buy = function(ply)end
})

KylDonate:RegItem({
    name = "OtS-33",
    id = "ot33",
    type = "weapons",
    category = "weapons",
    rare = "Необычное",
    weaponclass = "rwp_tfa_pist_ot33",
    hide = false,
    color = uncommon,
    cost = {
        def = 410
    },

    on_buy = function(ply)end
})

KylDonate:RegItem({
    name = "MP-443",
    id = "mp443",
    type = "weapons",
    category = "weapons",
    rare = "Необычное",
    weaponclass = "rwp_tfa_pist_mp443",
    hide = false,
    color = uncommon,
    cost = {
        def = 415
    },

    on_buy = function(ply)end
})

KylDonate:RegItem({
    name = "MP416",
    id = "mp416rex",
    type = "weapons",
    category = "weapons",
    rare = "Необычное",
    weaponclass = "rwp_tfa_pist_mp416rex",
    hide = false,
    color = uncommon,
    cost = {
        def = 420
    },

    on_buy = function(ply)end
})

KylDonate:RegItem({
    name = "GSH18",
    id = "gsh18",
    type = "weapons",
    category = "weapons",
    rare = "Необычное",
    weaponclass = "rwp_tfa_pist_gsh18",
    hide = false,
    color = rare,
    cost = {
        def = 430
    },

    on_buy = function(ply)end
})

KylDonate:RegItem({
    name = "SR-3M Vikhr",
    id = "vikhr",
    type = "weapons",
    category = "weapons",
    rare = "Редкое",
    weaponclass = "rwp_tfa_assault_vikhr",
    hide = false,
    color = rare,
    cost = {
        def = 560
    },

    on_buy = function(ply)end
})

KylDonate:RegItem({
    name = "AKS-74U",
    id = "aks74u",
    type = "weapons",
    category = "weapons",
    rare = "Редкое",
    weaponclass = "rwp_tfa_smg_aks74u",
    hide = false,
    color = rare,
    cost = {
        def = 610
    },

    on_buy = function(ply)end
})

KylDonate:RegItem({
    name = "PP19-01 Vityaz",
    id = "pp1901",
    type = "weapons",
    category = "weapons",
    rare = "Редкое",
    weaponclass = "rwp_tfa_smg_pp1901",
    hide = false,
    color = rare,
    cost = {
        def = 650
    },

    on_buy = function(ply)end
})

KylDonate:RegItem({
    name = "SKS",
    id = "sks",
    type = "weapons",
    category = "weapons",
    rare = "Редкое",
    weaponclass = "rwp_tfa_assault_sks",
    hide = false,
    color = rare,
    cost = {
        def = 670
    },

    on_buy = function(ply)end
})

KylDonate:RegItem({
    name = "PPSH-41",
    id = "ppsh41",
    type = "weapons",
    category = "weapons",
    rare = "Мифическое",
    weaponclass = "rwp_tfa_smg_ppsh41",
    hide = false,
    color = rare,
    cost = {
        def = 860
    },

    on_buy = function(ply)end
})

KylDonate:RegItem({
    name = "OC-14 Groza",
    id = "groza",
    w = 400,
    type = "weapons",
    category = "weapons",
    rare = "Мифическое",
    weaponclass = "rwp_tfa_assault_groza",
    hide = false,
    color = mythical,
    cost = {
        def = 730
    },

    on_buy = function(ply)end
})

KylDonate:RegItem({
    name = "Vepr",
    id = "vepr",
    type = "weapons",
    category = "weapons",
    rare = "Мифическое",
    weaponclass = "rwp_tfa_assault_vepr",
    hide = false,
    color = mythical,
    cost = {
        def = 740
    },

    on_buy = function(ply)end
})

KylDonate:RegItem({
    name = "AS VAL",
    id = "val",
    type = "weapons",
    category = "weapons",
    rare = "Мифическое",
    weaponclass = "rwp_tfa_assault_val",
    hide = false,
    color = mythical,
    cost = {
        def = 750
    },

    on_buy = function(ply)end
})

KylDonate:RegItem({
    name = "AK-74",
    id = "ak74",
    type = "weapons",
    category = "weapons",
    rare = "Мифическое",
    weaponclass = "rwp_tfa_assault_ak74",
    hide = false,
    color = mythical,
    cost = {
        def = 760
    },

    on_buy = function(ply)end
})


KylDonate:RegItem({
    name = "AK-12",
    id = "ak12",
    type = "weapons",
    category = "weapons",
    rare = "Мифическое",
    weaponclass = "rwp_tfa_assault_ak12",
    hide = false,
    color = legendary,
    cost = {
        def = 770
    },

    on_buy = function(ply)end
})

KylDonate:RegItem({
    name = "AKM",
    id = "akm",
    type = "weapons",
    category = "weapons",
    rare = "Мифическое",
    weaponclass = "rwp_tfa_assault_akm",
    hide = false,
    color = legendary,
    cost = {
        def = 780
    },

    on_buy = function(ply)end
})

KylDonate:RegItem({
    name = "AEK971",
    id = "aek971",
    type = "weapons",
    category = "weapons",
    rare = "Мифическое",
    weaponclass = "rwp_tfa_assault_aek971",
    hide = false,
    color = ancient,
    cost = {
        def = 795
    },

    on_buy = function(ply)end
})

KylDonate:RegItem({
    name = "RPK74",
    id = "rpk74",
    type = "weapons",
    category = "weapons",
    rare = "Мифическое",
    weaponclass = "rwp_tfa_heavy_rpk74",
    hide = false,
    color = ancient,
    cost = {
        def = 810
    },

    on_buy = function(ply)end
})

KylDonate:RegItem({
    name = "VSS Vintorez (Прицел)",
    id = "snipervss",
    type = "weapons",
    category = "weapons",
    rare = "Засекреченное",
    weaponclass = "rwp_tfa_sniper_vss",
    hide = false,
    color = ancient,
    cost = {
        def = 850
    },

    on_buy = function(ply)end
})

KylDonate:RegItem({
    name = "VSSK Vikhlop (Прицел)",
    id = "vssk",
    type = "weapons",
    category = "weapons",
    rare = "Засекреченное",
    weaponclass = "rwp_tfa_sniper_vssk",
    hide = false,
    color = ancient,
    cost = {
        def = 865
    },

    on_buy = function(ply)end
})

KylDonate:RegItem({
    name = "AK-101 (Прицел)",
    id = "ak101",
    type = "weapons",
    category = "weapons",
    rare = "Засекреченное",
    weaponclass = "rwp_tfa_assault_ak101",
    hide = false,
    color = ancient,
    cost = {
        def = 895
    },

    on_buy = function(ply)end
})

KylDonate:RegItem({
    name = "SVT-40",
    id = "svt40",
    type = "weapons",
    category = "weapons",
    rare = "Засекреченное",
    weaponclass = "rwp_tfa_sniper_svt40",
    hide = false,
    color = ancient,
    cost = {
        def = 900
    },

    on_buy = function(ply)end
})

KylDonate:RegItem({
    name = "SVD",
    id = "svd",
    type = "weapons",
    category = "weapons",
    rare = "Засекреченное",
    weaponclass = "rwp_tfa_sniper_svd",
    hide = false,
    color = ancient,
    cost = {
        def = 920
    },

    on_buy = function(ply)end
})

KylDonate:RegItem({
    name = "SV-98",
    id = "sv98",
    type = "weapons",
    category = "weapons",
    rare = "Засекреченное",
    weaponclass = "rwp_tfa_sniper_sv98",
    hide = false,
    color = ancient,
    cost = {
        def = 970
    },

    on_buy = function(ply)end
})

KylDonate:RegItem({
    name = "PTRS-41",
    id = "ptrs41",
    type = "weapons",
    category = "weapons",
    rare = "Засекреченное",
    weaponclass = "rwp_tfa_sniper_ptrs41",
    hide = false,
    color = ancient,
    cost = {
        def = 1300
    },

    on_buy = function(ply)end
})

KylDonate:RegItem({
    name = "Becas 12M",
    id = "becas12m",
    type = "weapons",
    category = "weapons",
    rare = "Засекреченное",
    weaponclass = "rwp_tfa_shotgun_becas12m",
    hide = false,
    color = ancient,
    cost = {
        def = 950
    },

    on_buy = function(ply)end
})

KylDonate:RegItem({
    name = "KS-23",
    id = "ks23",
    type = "weapons",
    category = "weapons",
    rare = "Засекреченное",
    weaponclass = "rwp_tfa_shotgun_ks23",
    hide = false,
    color = ancient,
    cost = {
        def = 970
    },

    on_buy = function(ply)end
})

KylDonate:RegItem({
    name = "Saiga20k",
    id = "saiga20k",
    type = "weapons",
    category = "weapons",
    rare = "Засекреченное",
    weaponclass = "rwp_tfa_shotgun_saiga20k",
    hide = false,
    color = ancient,
    cost = {
        def = 1450
    },

    on_buy = function(ply)end
})

KylDonate:RegItem({
    name = "PKM",
    id = "pkm",
    type = "weapons",
    category = "weapons",
    rare = "Засекреченное",
    weaponclass = "rwp_tfa_heavy_pkm",
    hide = false,
    color = ancient,
    cost = {
        def = 1050
    },

    on_buy = function(ply)end
})

KylDonate:RegItem({
    name = "PKP Pecheneg",
    id = "pkp",
    type = "weapons",
    category = "weapons",
    rare = "Засекреченное",
    weaponclass = "rwp_tfa_heavy_pkp",
    hide = false,
    color = ancient,
    cost = {
        def = 1350
    },

    on_buy = function(ply)end
})

KylDonate:RegItem({
    name = "PP2000",
    id = "pp2000",
    type = "weapons",
    category = "weapons",
    rare = "Засекреченное",
    weaponclass = "rwp_tfa_smg_pp2000",
    hide = false,
    color = ancient,
    cost = {
        def = 610
    },

    on_buy = function(ply)end
})

-- KylDonate:RegItem({
--     name = "RPG",
--     id = "rpg",
--     type = "weapons",
--     model = "models/weapons/w_rocket_launcher.mdl",
--     category = "weapons",
--     rare = "Контрабандное",
--     weaponclass = "weapon_rpg",
--     hide = false,
--     color = contrabanda,
--     cost = {
--         def = 2500
--     },

--     on_buy = function(ply)end
-- })

-------------------------------------------------
-- НОЖИ
-------------------------------------------------

KylDonate:RegItem({
    name = "Штык-нож | Зуб тигра",
    id = "bayonet_tiger",
    type = "weapons",
    category = "knifes",
    skin = 9,
    w = 200,
    weaponclass = "csgo_bayonet_tiger",
    hide = false,
    color = Color(220,20,20),
    cost = {
        def = 350
    },

    on_buy = function(ply)end
})

KylDonate:RegItem({
    name = "Нож-бабочка | Кровавая паутина",
    id = "butterfly_crimson",
    type = "weapons",
    category = "knifes",
    w = 200,
    skin = 3,
    weaponclass = "csgo_butterfly_crimsonwebs",
    hide = false,
    color = Color(220,20,20),
    cost = {
        def = 350
    },

    on_buy = function(ply)end
})

KylDonate:RegItem({
    name = "Нож-бабочка | Дамская сталь",
    id = "butterfly_damascus",
    type = "weapons",
    category = "knifes",
    w = 200,
    skin = 4,
    weaponclass = "csgo_butterfly_damascus",
    hide = false,
    color = Color(220,20,20),
    cost = {
        def = 350
    },

    on_buy = function(ply)end
})

KylDonate:RegItem({
    name = "Нож-бабочка | Зуб тигра",
    id = "butterfly_tiger",
    type = "weapons",
    category = "knifes",
    w = 200,
    skin = 9,
    weaponclass = "csgo_butterfly_tiger",
    hide = false,
    color = Color(220,20,20),
    cost = {
        def = 350
    },

    on_buy = function(ply)end
})

KylDonate:RegItem({
    name = "Охотничий нож | Дамская сталь",
    id = "hunstman_damscus",
    type = "weapons",
    category = "knifes",
    w = 200,
    skin = 4,
    weaponclass = "csgo_huntsman_damascus",
    hide = false,
    color = Color(220,20,20),
    cost = {
        def = 350
    },

    on_buy = function(ply)end
})

KylDonate:RegItem({
    name = "Охотничий нож | Убийство",
    id = "hunstman_ubistvo",
    type = "weapons",
    category = "knifes",
    w = 200,
    skin = 8,
    weaponclass = "csgo_huntsman_slaughter",
    hide = false,
    color = Color(220,20,20),
    cost = {
        def = 350
    },

    on_buy = function(ply)end
})

KylDonate:RegItem({
    name = "Охотничий нож | Зуб тигра",
    id = "hunstman_tiger",
    type = "weapons",
    category = "knifes",
    w = 200,
    skin = 9,
    weaponclass = "csgo_huntsman_tiger",
    hide = false,
    color = Color(220,20,20),
    cost = {
        def = 350
    },

    on_buy = function(ply)end
})

KylDonate:RegItem({
    name = "Керамбит | Кровавая паутина",
    id = "karambit_crimson",
    type = "weapons",
    category = "knifes",
    w = 200,
    skin = 3,
    weaponclass = "csgo_karambit_crimsonwebs",
    hide = false,
    color = Color(220,20,20),
    cost = {
        def = 350
    },

    on_buy = function(ply)end
})

KylDonate:RegItem({
    name = "Керамбит | Градиент",
    id = "karambit_fade",
    type = "weapons",
    category = "knifes",
    w = 200,
    skin = 6,
    weaponclass = "csgo_karambit_fade",
    hide = false,
    color = Color(220,20,20),
    cost = {
        def = 350
    },

    on_buy = function(ply)end
})

KylDonate:RegItem({
    name = "Керамбит | Зуб тигра",
    id = "karambit_tiger",
    type = "weapons",
    category = "knifes",
    w = 200,
    skin = 9,
    weaponclass = "csgo_karambit_tiger",
    hide = false,
    color = Color(220,20,20),
    cost = {
        def = 350
    },

    on_buy = function(ply)end
})

KylDonate:RegItem({
    name = "Штык-нож М9 | Кровавая паутина",
    id = "m9bayonet_crimson",
    type = "weapons",
    category = "knifes",
    w = 200,
    skin = 3,
    weaponclass = "csgo_m9_crimsonwebs",
    hide = false,
    color = Color(220,20,20),
    cost = {
        def = 350
    },

    on_buy = function(ply)end
})

KylDonate:RegItem({
    name = "Штык-нож М9 | Дамская сталь",
    id = "m9bayonet_damascus",
    type = "weapons",
    category = "knifes",
    w = 200,
    skin = 4,
    weaponclass = "csgo_m9_damascus",
    hide = false,
    color = Color(220,20,20),
    cost = {
        def = 350
    },

    on_buy = function(ply)end
})

KylDonate:RegItem({
    name = "Штык-нож М9 | Градиент",
    id = "m9bayonet_fade",
    type = "weapons",
    category = "knifes",
    skin = 6,
    w = 200,
    weaponclass = "csgo_m9_fade",
    hide = false,
    color = Color(220,20,20),
    cost = {
        def = 350
    },

    on_buy = function(ply)end
})

KylDonate:RegItem({
    name = "Штык-нож М9 | Обычный",
    id = "m9bayonet_default",
    type = "weapons",
    category = "knifes",
    w = 200,
    weaponclass = "csgo_m9",
    hide = false,
    color = Color(220,20,20),
    cost = {
        def = 350
    },

    on_buy = function(ply)end
})

-------------------------------------------------
-- РАЗНОЕ
-------------------------------------------------

KylDonate:RegItem({
    name = "Говорилка",
    id = "govorilka",
    type = "other",
    category = "other",
    icon = govorilka,
    description = "Благодаря этому дополнения ваши сообщения в чате будут озвучиваться.",
    multibuy = false,
    hide = false,
    cost = {
        def = 50
    },

    on_buy = function(ply) ply.Govorilka = true end
})

KylDonate:RegItem({
    name = "Сумка с патронами",
    id = "sumkammo",
    type = "other",
    category = "other",
    icon = patroni,
    description = "При спавне вам будет выдаваться +500 патронов каждого типа.",
    multibuy = false,
    hide = false,
    cost = {
        def = 70
    },

    on_buy = function(ply) end
})

KylDonate:RegItem({
    name = "Пропуск в Battle Pass",
    id = "battle_pass",
    type = "other",
    category = "other",
    icon = battle_pass,
    description = "Дает доступ к сезонному пропуску на текущий сезон.",
    multibuy = false,
    hide = false,
    cost = {
        def = 1200
    },

    on_buy = function(ply) ply:SetBPPremium() end
})

KylDonate:RegItem({
    name = "+25 пропов",
    id = "props_25",
    type = "other",
    category = "other",
    icon = twentyfive,
    description = "К вашему количеству пропов прибавиться +25.",
    multibuy = false,
    hide = false,
    cost = {
        def = 75
    },

    on_buy = function(ply) KylDonate.AddProps(ply:SteamID64(), 25) ply.DonatePropLimit = 25 end
})

KylDonate:RegItem({
    name = "+50 пропов",
    id = "props_50",
    type = "other",
    category = "other",
    icon = fifty,
    description = "К вашему количеству пропов прибавиться +50.",
    multibuy = false,
    hide = false,
    cost = {
        def = 100
    },

    on_buy = function(ply) KylDonate.AddProps(ply:SteamID64(), 50) ply.DonatePropLimit = 50 end
})

KylDonate:RegItem({
    name = "+100 пропов",
    id = "props_100",
    type = "other",
    category = "other",
    icon = onehundred,
    description = "К вашему количеству пропов прибавиться +100.",
    multibuy = false,
    hide = false,
    cost = {
        def = 120
    },

    on_buy = function(ply) KylDonate.AddProps(ply:SteamID64(), 100) ply.DonatePropLimit = 100 end
})

KylDonate:RegItem({
    name = "+250 пропов",
    id = "props_250",
    type = "other",
    category = "other",
    icon = twohundredfifty,
    description = "К вашему количеству пропов прибавиться +250.",
    multibuy = false,
    hide = false,
    cost = {
        def = 170
    },

    on_buy = function(ply) KylDonate.AddProps(ply:SteamID64(), 250) ply.DonatePropLimit = 250 end
})

KylDonate:RegItem({
    name = "Щит",
    id = "balishield",
    type = "weapons",
    weaponclass = 'heavy_shield',
    category = "weapons",
    description = "При спавне будет даваться щит.",
    multibuy = false,
    hide = false,
    cost = {
        def = 300
    },

    on_buy = function(ply)end
})

KylDonate:RegItem({
    name = "Отмычка",
    id = "otmichka",
    type = "weapons",
    weaponclass = 'lockpick',
    category = "weapons",
    description = "При спавне будет даваться отмычка.",
    multibuy = false,
    hide = false,
    cost = {
        def = 120
    },

    on_buy = function(ply)end
})

KylDonate:RegItem({
    name = "Взломщик кейпада",
    id = "keypadcrak",
    type = "weapons",
    weaponclass = 'keypad_cracker',
    category = "weapons",
    description = "При спавне будет даваться взломщик кейпада.",
    multibuy = false,
    hide = false,
    cost = {
        def = 120
    },

    on_buy = function(ply)end
})

KylDonate:RegItem({
    name = "HQD яблоко",
    id = "hqdapple",
    type = "weapons",
    weaponclass = 'weapon_vape_apple',
    category = "weapons",
    description = "HQD со вкусом яблока",
    multibuy = false,
    hide = false,
    cost = {
        def = 150
    },

    on_buy = function(ply)end
})

KylDonate:RegItem({
    name = "HQD черника",
    id = "hqdblub",
    type = "weapons",
    weaponclass = 'weapon_vape_blueberry',
    category = "weapons",
    description = "HQD со вкусом черники",
    multibuy = false,
    hide = false,
    cost = {
        def = 150
    },

    on_buy = function(ply)end
})

KylDonate:RegItem({
    name = "HQD энергетик",
    id = "hqdenergy",
    type = "weapons",
    weaponclass = 'weapon_vape_energydrink',
    category = "weapons",
    description = "HQD со вкусом энергетика",
    multibuy = false,
    hide = false,
    cost = {
        def = 150
    },

    on_buy = function(ply)end
})

KylDonate:RegItem({
    name = "HQD ананас",
    id = "hqdananas",
    type = "weapons",
    weaponclass = 'weapon_vape',
    category = "weapons",
    description = "HQD со вкусом ананаса",
    multibuy = false,
    hide = false,
    cost = {
        def = 150
    },

    on_buy = function(ply)end
})

-------------------------------------------------
-- ДЕНЬГИ
-------------------------------------------------

KylDonate:RegItem({
    name = "100 000₽",
    id = "100k_money",
    type = "other",
    category = "money",
    description = "₽100 000 на ваш игровой счёт",
    icon = sto,
    multibuy = true,
    hide = false,
    color = Color(220,20,20),
    cost = {
        def = 100
    },

    on_buy = function(ply) ply:AddMoney(100000, 'Покупка доната 100.000₽') end
})

KylDonate:RegItem({
    name = "500 000₽",
    id = "500k_money",
    type = "other",
    category = "money",
    description = "₽500 000 на ваш игровой счёт",
    icon = petsot,
    multibuy = true,
    hide = false,
    color = Color(220,20,20),
    cost = {
        def = 300
    },

    on_buy = function(ply) ply:AddMoney(500000, 'Покупка доната 500.000₽') end
})

KylDonate:RegItem({
    name = "1 000 000₽",
    id = "1kk_money",
    type = "other",
    category = "money",
    description = "₽1 000 000 на ваш игровой счёт",
    icon = lyam,
    multibuy = true,
    hide = false,
    color = Color(220,20,20),
    cost = {
        def = 520
    },

    on_buy = function(ply) ply:AddMoney(1000000, 'Покупка доната 1.000.000₽') end
})

KylDonate:RegItem({
    name = "5 000 000₽",
    id = "5kk_money",
    type = "other",
    category = "money",
    description = "₽5 000 000 на ваш игровой счёт",
    icon = pyat,
    multibuy = true,
    hide = false,
    color = Color(220,20,20),
    cost = {
        def = 1000
    },

    on_buy = function(ply) ply:AddMoney(5000000, 'Покупка доната 5.000.000₽') end
})

-------------------------------------------------
-- Модели
-------------------------------------------------

-- KylDonate:RegItem({
--     name = "Рикардо Милос",
--     id = "rick_milos",
--     type = "models",
--     category = "models",
--     model = "modelka",
--     hide = false,
--     color = Color(220,20,20),
--     cost = {
--         def = 350
--     },

--     on_buy = function(ply)end
-- })

--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
