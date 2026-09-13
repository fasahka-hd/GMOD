AAS = AAS or {}


AAS.Category = {
    ["mainMenu"] = {
        [1] = {
            ["uniqueName"] = "Все",
            ["material"] = Material("aas_materials/ass_icon_all.png", "smooth"),
            ["all"] = true,
            ["margin"] = 0,
            ["bone"] = "ValveBiped.Bip01_Head1",
        },
        [2] = {
            ["uniqueName"] = "Головной убор",
            ["material"] = Material("aas_materials/ass_icon_hat.png", "smooth"),
            ["bone"] = "ValveBiped.Bip01_Head1",
        },
        [3] = {
            ["uniqueName"] = "Шея",
            ["material"] = Material("aas_materials/aas_mask_2.png", "smooth"),
            ["bone"] = "ValveBiped.Bip01_Head1",
        },
        [4] = {
            ["uniqueName"] = "Маски",
            ["material"] = Material("aas_materials/ass_mask_1.png", "smooth"),
            ["bone"] = "ValveBiped.Bip01_Head1",
        },
        [5] = {
           ["uniqueName"] = "Спина",
           ["material"] = Material("aas_materials/ass_mask_1.png", "smooth"),
           ["bone"] = "ValveBiped.Bip01_Head1",
        },
    },

    ["adminMenu"] = {
        [1] = {
            ["uniqueName"] = "Settings",
            ["material"] = Material("aas_materials/aas_settings.png", "smooth"),
            ["sizeX"] = 0.015,
            ["sizeY"] = 0.027,
            ["callBack"] = function() end,
        },
        [2] = {
            ["uniqueName"] = "Add",
            ["material"] = Material("aas_materials/aas_plus.png", "smooth"),
            ["sizeX"] = 0.015,
            ["sizeY"] = 0.026,
            ["callBack"] = function()
                AAS.PositionSettings()
            end,
        },
    },

    ["positionMenu"] = {
        [1] = {
            ["uniqueName"] = "Add",
            ["material"] = Material("aas_materials/aas_plus.png", "smooth"),
            ["sizeX"] = 0.015,
            ["sizeY"] = 0.026,
            ["callBack"] = function()
                AAS.PositionSettings()
            end,
        },
    },
}

AAS.BaseItems = { ['3236957794'] = {} }
function rp_hats_Add( dat )
    local a = AAS.BaseItems['3236957794']
    a[#a+1] = {
        name = dat.name,
        description = '',
        category = dat.category,
        scale = dat.scale,
        options = {
            skin = dat.skin,
            activate = true,
            iconPos = Vector(0, 0, 0),
            color = Color(240, 240, 240, 255),
            vip = dat.vip or false,
            bone = dat.bone or "ValveBiped.Bip01_Head1",
            iconFov = -26.666666666667,
            new = true,
        },
        uniqueId = #a,
        model = dat.model,
        pos = dat.offpos,
        ang = dat.offang,
        job = {},
        price = dat.price
    }
end

local APPAREL_HATS, APPAREL_MASKS, APPAREL_GLASSES, APPAREL_SCARVES = 1, 2, 3, 4

rp_hats_Add {
    name     = 'Смешная обезьяна',
    category = 'Головной убор',
    price    = 366000,
    model    = 'models/roblox/funny_monkey.mdl',
    skin     = 0,
    offpos = Vector(4, -1.6, 0),
    offang = Angle(4, 20, 180),
    scale = .7,
    infooffset = 10
}

rp_hats_Add {
    name     = 'Адора шляпа',
    category = 'Головной убор',
    price    = 385000,
    model    = 'models/roblox/adorabat.mdl',
    skin     = 0,
    offpos = Vector(7, -.5, 0),
    offang = Angle(4, 20, 0),
    scale = .7,
    infooffset = 10
}

rp_hats_Add {
    name     = 'Паук',
    category = 'Головной убор',
    price    = 375000,
    model    = 'models/roblox/spider_cap.mdl',
    skin     = 0,
    offpos = Vector(7, -.5, 0),
    offang = Angle(4, 20, 0),
    scale = .6,
    infooffset = 10
}

rp_hats_Add {
    name     = 'АФРО',
    category = 'Головной убор',
    type = APPAREL_HATS,
    price    = 365000,
    model    = 'models/captainbigbutt/skeyler/hats/afro.mdl',
    skin     = 0,
    offpos = Vector(3, 0, 0),
    offang = Angle(0, 10, 0),
    scale = 0.8,
    infooffset = 10
}

rp_hats_Add {
    name     = 'Мишка',
    category = 'Головной убор',
    type = APPAREL_HATS,
    price    = 453500,
    model    = 'models/captainbigbutt/skeyler/hats/bear_hat.mdl',
    skin     = 0,
    offpos = Vector(6, 0, 0),
    offang = Angle(0, 10, 0),
    scale = 0.8,
    infooffset = 10
}

rp_hats_Add {
    name     = 'Ковбойская шляпа',
    category = 'Головной убор',
    price    = 245000,
    model    = 'models/captainbigbutt/skeyler/hats/cowboyhat.mdl',
    skin     = 0,
    offpos = Vector(8, -.5, 0),
    offang = Angle(2, 12, 0),
    scale = .6,
    infooffset = 10
}

rp_hats_Add {
    name     = 'Шапка Федора',
    category = 'Головной убор',
    price    = 265000,
    model    = 'models/captainbigbutt/skeyler/hats/fedora.mdl',
    skin     = 0,
    offpos = Vector(6, 0, 0),
    offang = Angle(2, 12, 0),
    scale = .7,
    infooffset = 10
}

rp_hats_Add {
    name     = 'Лягушка',
    category = 'Головной убор',
    type = APPAREL_HATS,
    price    = 457500,
    model    = 'models/captainbigbutt/skeyler/hats/frog_hat.mdl',
    skin     = 0,
    offpos = Vector(6, -1, 0),
    offang = Angle(0, 20, 0),
    scale = 0.6,
    infooffset = 10
}

rp_hats_Add {
    name     = 'Новогодняя шапка',
    category = 'Головной убор',
    price    = 1000,
    model    = 'models/captainbigbutt/skeyler/hats/santa.mdl',
    skin     = 0,
    offpos = Vector(4.5, 0.5, 0),
    offang = Angle(2, 18, 0),
    scale = .7,
    infooffset = 10
}

rp_hats_Add {
    name     = 'Соломенная шляпа',
    category = 'Головной убор',
    price    = 242500,
    model    = 'models/captainbigbutt/skeyler/hats/strawhat.mdl',
    skin     = 0,
    offpos = Vector(6, -.2, 0),
    offang = Angle(2, 18, 0),
    scale = .8,
    infooffset = 10
}

rp_hats_Add {
    name     = 'Сомбреро',
    category = 'Головной убор',
    price    = 357500,
    model    = 'models/gmod_tower/sombrero.mdl',
    skin     = 0,
    offpos = Vector(4, 0, 0),
    offang = Angle(2, 18, 0),
    scale = 1.0,
    infooffset = 10
}

rp_hats_Add {
    name     = 'Цилиндр',
    category = 'Головной убор',
    price    = 160000,
    model    = 'models/gmod_tower/tophat.mdl',
    skin     = 0,
    offpos = Vector(4, 0, 0),
    offang = Angle(2, 18, 0),
    scale = 1.0,
    infooffset = 10
}

rp_hats_Add {
    name     = 'Курица',
    category = 'Головной убор',
    price    = 150000,
    model    = 'models/lordvipes/billyhatcherhat/billyhatcherhat.mdl',
    skin     = 0,
    offpos = Vector(4, .5, .5),
    offang = Angle(0, 0, 0),
    scale = 1.0,
    infooffset = 5
}

rp_hats_Add {
    name     = 'Генеральская фуражка',
    category = 'Головной убор',
    price    = 200000,
    model    = 'models/lordvipes/generalpepperhat/generalpepperhat.mdl',
    skin     = 0,
    offpos = Vector(4, 0, 0),
    offang = Angle(2, 18, 0),
    scale = 0.8,
    infooffset = 10
}

rp_hats_Add {
    name     = 'Кепка Трампа',
    category = 'Головной убор',
    price    = 475000,
    model    = 'models/data_expunged/politics/maga_hat_01/maga_hat_01.mdl',
    skin     = 0,
    offpos = Vector(6, -.2, 0),
    offang = Angle(2, 18, 0),
    scale = 1,
    infooffset = 10
}

rp_hats_Add {
    name     = 'Кепка',
    category = 'Головной убор',
    price    = 125000,
    model    = 'models/gmod_tower/baseballcap.mdl',
    skin     = 0,
    offpos = Vector(6, -.2, 0),
    offang = Angle(2, 18, 0),
    scale = 1.1,
    infooffset = 10
}

rp_hats_Add {
    name     = 'Кепка "Z"',
    category = 'Головной убор',
    price    = 465000,
    model    = 'models/captainbigbutt/skeyler/hats/zhat.mdl',
    skin     = 0,
    offpos = Vector(4, -.2, 0),
    offang = Angle(2, 18, 0),
    scale = .8,
    infooffset = 10
}

rp_hats_Add {
    name     = 'Ведро KFC',
    category = 'Головной убор',
    type = APPAREL_HATS,
    price    = 325000,
    model    = 'models/gmod_tower/kfcbucket.mdl',
    skin     = 0,
    offpos = Vector(5.5, 0, 0),
    offang = Angle(0, 20, 0),
    scale = 0.6,
    infooffset = 10
}

rp_hats_Add {
    name     = 'HeadCrab',
    category = 'Головной убор',
    type = APPAREL_HATS,
    price    = 451611,
    model    = 'models/gmod_tower/headcrabhat.mdl',
    skin     = 0,
    offpos = Vector(5, 3, 0),
    offang = Angle(0, -20, 0),
    scale = 0.6,
    infooffset = 10
}

rp_hats_Add {
    name     = 'Американская шляпа',
    category = 'Головной убор',
    type = APPAREL_HATS,
    price    = 230000,
    model    = 'models/americahat/americahat.mdl',
    skin     = 0,
    offpos = Vector(5, 0, 0),
    offang = Angle(0, 0, 0),
    scale = 1,
    infooffset = 10
}

rp_hats_Add {
    name     = 'Пивная шляпа',
    category = 'Головной убор',
    type = APPAREL_HATS,
    price    = 235000,
    model    = 'models/beerhat/beerhat.mdl',
    skin     = 0,
    offpos = Vector(5, 0, 0),
    offang = Angle(0, 0, 0),
    scale = 1.2,
    infooffset = 10
}

rp_hats_Add {
    name     = 'Офицерская фуражка',
    category = 'Головной убор',
    type = APPAREL_HATS,
    price    = 340000,
    model    = 'models/captainshat/captainshat.mdl',
    skin     = 0,
    offpos = Vector(5, 0, 0),
    offang = Angle(0, 0, 0),
    scale = 1,
    infooffset = 10
}

rp_hats_Add {
    name     = 'Уши кролика',
    category = 'Головной убор',
    type = APPAREL_HATS,
    price    = 341000,
    model    = 'models/bunnyears/bunnyears.mdl',
    skin     = 0,
    offpos = Vector(5, 0, 0),
    offang = Angle(0, 0, 0),
    scale = 1,
    infooffset = 10
}

rp_hats_Add {
    name     = 'Тыква',
    category = 'Головной убор',
    type = APPAREL_HATS,
    price    = 339000,
    model    = 'models/b_cansin/hatsune miku project diva future tone/player_models/accessory/hats/general/pumpkin_head.mdl',
    skin     = 0,
    offpos = Vector(-51, 3, 0),
    offang = Angle(0, 0, 0),
    scale = .8,
    infooffset = 10
}

rp_hats_Add {
    name     = 'Белая акула',
    category = 'Головной убор',
    type = APPAREL_HATS,
    price    = 1025000,
    model    = 'models/b_cansin/hatsune miku project diva future tone/player_models/accessory/hats/general/great_white_shark.mdl',
    skin     = 0,
    offpos = Vector(-51, 3, 0),
    offang = Angle(0, 0, 0),
    scale = .8,
    infooffset = 10
}

rp_hats_Add {
    name     = 'Tako Luka',
    category = 'Головной убор',
    type = APPAREL_HATS,
    price    = 475000,
    model    = 'models/b_cansin/hatsune miku project diva future tone/player_models/accessory/hats/general/tako_luka.mdl',
    skin     = 0,
    offpos = Vector(-51, 3, 0),
    offang = Angle(0, 0, 0),
    scale = .8,
    infooffset = 10
}

rp_hats_Add {
    name     = 'Шапочка Медсестры',
    category = 'Головной убор',
    type = APPAREL_HATS,
    price    = 353500,
    model    = 'models/b_cansin/hatsune miku project diva future tone/player_models/accessory/hats/general/nurses_cap.mdl',
    skin     = 0,
    offpos = Vector(-51, 3, 0),
    offang = Angle(0, 0, 0),
    scale = .8,
    infooffset = 10
}

rp_hats_Add {
    name     = 'Ореол',
    category = 'Головной убор',
    type = APPAREL_HATS,
    price    = 377777,
    model    = 'models/b_cansin/hatsune miku project diva future tone/player_models/accessory/hats/general/halo.mdl',
    skin     = 0,
    offpos = Vector(-51, 3, 0),
    offang = Angle(0, 0, 0),
    scale = .8,
    infooffset = 10
}

rp_hats_Add {
    name     = 'Mini-Mikudayo',
    category = 'Головной убор',
    type = APPAREL_HATS,
    price    = 850000,
    model    = 'models/b_cansin/hatsune miku project diva future tone/player_models/accessory/hats/general/mini_mikudayo.mdl',
    skin     = 0,
    offpos = Vector(-51, 3, 0),
    offang = Angle(0, 0, 0),
    scale = .8,
    infooffset = 10
}

rp_hats_Add {
    name     = 'Праздничный конус',
    category = 'Головной убор',
    type = APPAREL_HATS,
    price    = 127500,
    model    = 'models/b_cansin/hatsune miku project diva future tone/player_models/accessory/hats/general/party_hat.mdl',
    skin     = 0,
    offpos = Vector(-51, 3, 0),
    offang = Angle(0, 0, 0),
    scale = .8,
    infooffset = 10
}

rp_hats_Add {
    name     = 'Золотая корона',
    category = 'Головной убор',
    type = APPAREL_HATS,
    price    = 2500000,
    model    = 'models/b_cansin/hatsune miku project diva future tone/player_models/accessory/hats/general/golden_crown.mdl',
    skin     = 0,
    offpos = Vector(-51, 3, 0),
    offang = Angle(0, 0, 0),
    scale = .8,
    infooffset = 10
}

rp_hats_Add {
    name     = 'Платиновая корона',
    category = 'Головной убор',
    type = APPAREL_HATS,
    price    = 3000000,
    model    = 'models/b_cansin/hatsune miku project diva future tone/player_models/accessory/hats/general/platinum_crown.mdl',
    skin     = 0,
    offpos = Vector(-51, 3, 0),
    offang = Angle(0, 0, 0),
    scale = .8,
    infooffset = 10
}

rp_hats_Add {
    name     = 'Бараньи рога',
    category = 'Головной убор',
    type = APPAREL_HATS,
    price    = 243500,
    model    = 'models/b_cansin/hatsune miku project diva future tone/player_models/accessory/hats/general/ram_horns.mdl',
    skin     = 0,
    offpos = Vector(-51, 3, 0),
    offang = Angle(0, 0, 0),
    scale = .8,
    infooffset = 10
}

rp_hats_Add {
    name     = 'Шляпа Марио',
    category = 'Головной убор',
    type = APPAREL_HATS,
    price    = 600000,
    model    = 'models/b_cansin/hatsune miku project diva future tone/player_models/accessory/hats/general/red_puyo_cap.mdl',
    skin     = 0,
    offpos = Vector(-51, 3, 0),
    offang = Angle(0, 0, 0),
    scale = .8,
    infooffset = 10
}

rp_hats_Add {
    name     = 'Собачьи ушки',
    category = 'Головной убор',
    type = APPAREL_HATS,
    price    = 149900,
    model    = 'models/b_cansin/hatsune miku project diva future tone/player_models/accessory/hats/general/dog_ears.mdl',
    skin     = 0,
    offpos = Vector(-51, 3, 0),
    offang = Angle(0, 0, 0),
    scale = .8,
    infooffset = 10
}

rp_hats_Add {
    name     = 'Дьявольские Рога',
    category = 'Головной убор',
    type = APPAREL_HATS,
    price    = 666666,
    model    = 'models/b_cansin/hatsune miku project diva future tone/player_models/accessory/hats/general/devil_horns.mdl',
    skin     = 0,
    offpos = Vector(-51, 3, 0),
    offang = Angle(0, 0, 0),
    scale = .8,
    infooffset = 10
}

rp_hats_Add {
    name     = 'Курицы',
    category = 'Головной убор',
    type = APPAREL_HATS,
    price    = 322222,
    model    = 'models/b_cansin/hatsune miku project diva future tone/player_models/accessory/hats/general/chicks.mdl',
    skin     = 0,
    offpos = Vector(-51, 3, 0),
    offang = Angle(0, 0, 0),
    scale = .8,
    infooffset = 10
}

rp_hats_Add {
    name     = 'Шапка Шефа',
    category = 'Головной убор',
    type = APPAREL_HATS,
    price    = 275000,
    model    = 'models/b_cansin/hatsune miku project diva future tone/player_models/accessory/hats/general/chefs_hat.mdl',
    skin     = 0,
    offpos = Vector(-51, 3, 0),
    offang = Angle(0, 0, 0),
    scale = .8,
    infooffset = 10
}

rp_hats_Add {
    name     = 'Уши кота',
    category = 'Головной убор',
    type = APPAREL_HATS,
    price    = 385500,
    model    = 'models/b_cansin/hatsune miku project diva future tone/player_models/accessory/hats/general/cat_ears.mdl',
    skin     = 0,
    offpos = Vector(-51, 3, 0),
    offang = Angle(0, 0, 0),
    scale = .8,
    infooffset = 10
}

rp_hats_Add {
    name     = 'Гнездо птицы',
    category = 'Головной убор',
    type = APPAREL_HATS,
    price    = 285500,
    model    = 'models/b_cansin/hatsune miku project diva future tone/player_models/accessory/hats/general/birds_nest.mdl',
    skin     = 0,
    offpos = Vector(-51, 3, 0),
    offang = Angle(0, 0, 0),
    scale = .8,
    infooffset = 10
}

rp_hats_Add {
    name     = 'Высокая шапка',
    category = 'Головной убор',
    type = APPAREL_HATS,
    price    = 482000,
    model    = 'models/highhat/highhat.mdl',
    skin     = 0,
    offpos = Vector(7, 0, 0),
    offang = Angle(0, 10, 0),
    scale = .8,
    infooffset = 10
}

rp_hats_Add {
    name     = 'Грибная шапка',
    category = 'Головной убор',
    type = APPAREL_HATS,
    price    = 300000,
    model    = 'models/mushroom/mushroom.mdl',
    skin     = 0,
    offpos = Vector(6, 0, 0),
    offang = Angle(0, 10, 0),
    scale = .8,
    infooffset = 10
}

rp_hats_Add {
    name     = 'Полицейская фуражка',
    category = 'Головной убор',
    type = APPAREL_HATS,
    price    = 395000,
    model    = 'models/policehat/policehat.mdl',
    skin     = 0,
    offpos = Vector(6, 0, 0),
    offang = Angle(0, 10, 0),
    scale = .8,
    infooffset = 10
}


rp_hats_Add {
    name     = 'Свирепый Кадьяк',
    category = 'Маски',
    type = APPAREL_MASKS,
    price    = 400000,
    model    = 'models/sal/bear.mdl',
    skin     = 0,
    offpos = Vector(2, 0, 0),
    offang = Angle(0, 0, 0),
    scale = 1.1,
    infooffset = 10
}

rp_hats_Add {
    name     = 'Кот Котенок',
    category = 'Маски',
    type = APPAREL_MASKS,
    price    = 400000,
    model    = 'models/sal/cat.mdl',
    skin     = 0,
    offpos = Vector(2, 0, 0),
    offang = Angle(0, 0, 0),
    scale = 1.1,
    infooffset = 10
}

rp_hats_Add {
    name     = 'Хитрый Лис',
    category = 'Маски',
    type = APPAREL_MASKS,
    price    = 400000,
    model    = 'models/sal/fox.mdl',
    skin     = 0,
    offpos = Vector(2, 0, 0),
    offang = Angle(0, 0, 0),
    scale = 1.1,
    infooffset = 10
}

rp_hats_Add {
    name     = 'Пряничный Человечек',
    category = 'Маски',
    type = APPAREL_MASKS,
    price    = 1500001,
    model    = 'models/sal/gingerbread.mdl',
    skin     = 0,
    offpos = Vector(0, 0, 0),
    offang = Angle(0, 6, 0),
    scale = 1.1,
    infooffset = 10
}

rp_hats_Add {
    name     = 'Свободный Орел',
    category = 'Маски',
    type = APPAREL_MASKS,
    price    = 400000,
    model    = 'models/sal/hawk_1.mdl',
    skin     = 0,
    offpos = Vector(-1, 0, 0),
    offang = Angle(0, 0, 0),
    scale = 1.1,
    infooffset = 10
}

rp_hats_Add {
    name     = 'Темный Орел',
    category = 'Маски',
    type = APPAREL_MASKS,
    price    = 400000,
    model    = 'models/sal/hawk_2.mdl',
    skin     = 0,
    offpos = Vector(-1, 0, 0),
    offang = Angle(0, 0, 0),
    scale = 1.1,
    infooffset = 10
}

rp_hats_Add {
    name     = 'Мистер Сова',
    category = 'Маски',
    type = APPAREL_MASKS,
    price    = 400000,
    model    = 'models/sal/owl.mdl',
    skin     = 0,
    offpos = Vector(0, 0, 0),
    offang = Angle(2, 3, 0),
    scale = 1.2,
    infooffset = 10
}

rp_hats_Add {
    name     = 'Интелегентный пингвин',
    category = 'Маски',
    type = APPAREL_MASKS,
    price    = 99999999,
    vip = true,
    model    = 'models/sal/penguin.mdl',
    skin     = 0,
    offpos = Vector(0, -0.5, -0.5),
    offang = Angle(2, 15, 0),
    scale = 1.1,
    infooffset = 10
}

rp_hats_Add {
    name     = 'Поросенок',
    category = 'Маски',
    type = APPAREL_MASKS,
    price    = 400000,
    model    = 'models/sal/pig.mdl',
    skin     = 0,
    offpos = Vector(0, 0, -0.2),
    offang = Angle(4, 0, 0),
    scale = 1.1,
    infooffset = 10
}

rp_hats_Add {
    name     = 'Кровавый Поросенок',
    category = 'Маски',
    type = APPAREL_MASKS,
    price    = 600000,
    model    = 'models/sal/pig.mdl',
    skin     = 1,
    offpos = Vector(0, 0, -0.2),
    offang = Angle(4, 0, 0),
    scale = 1.1,
    infooffset = 10
}

rp_hats_Add {
    name     = 'Злой Волк',
    category = 'Маски',
    type = APPAREL_MASKS,
    price    = 500000,
    model    = 'models/sal/wolf.mdl',
    skin     = 0,
    offpos = Vector(0, 0, 0),
    offang = Angle(4, 0, 0),
    scale = 1.1,
    infooffset = 10
}

rp_hats_Add {
    name     = 'Он был #1!',
    category = 'Головной убор',
    price    = 200000,
    model    = 'models/sal/acc/fix/beerhat.mdl',
    skin     = 0,
    offpos = Vector(3, 0, 0),
    offang = Angle(2, 5, 0),
    scale = 1.0,
    infooffset = 10
}

rp_hats_Add {
    name     = 'Он был #2!',
    category = 'Головной убор',
    price    = 200000,
    model    = 'models/sal/acc/fix/beerhat.mdl',
    skin     = 1,
    offpos = Vector(3, 0, 0),
    offang = Angle(2, 5, 0),
    scale = 1.0,
    infooffset = 10
}

rp_hats_Add {
    name     = 'Он был #3!',
    category = 'Головной убор',
    price    = 200000,
    model    = 'models/sal/acc/fix/beerhat.mdl',
    skin     = 2,
    offpos = Vector(3, 0, 0),
    offang = Angle(2, 5, 0),
    scale = 1.0,
    infooffset = 10
}

rp_hats_Add {
    name     = 'Он был #4!',
    category = 'Головной убор',
    price    = 200000,
    model    = 'models/sal/acc/fix/beerhat.mdl',
    skin     = 3,
    offpos = Vector(3, 0, 0),
    offang = Angle(2, 5, 0),
    scale = 1.0,
    infooffset = 10
}

rp_hats_Add {
    name     = 'Он был #5!',
    category = 'Головной убор',
    price    = 200000,
    model    = 'models/sal/acc/fix/beerhat.mdl',
    skin     = 4,
    offpos = Vector(3, 0, 0),
    offang = Angle(2, 5, 0),
    scale = 1.0,
    infooffset = 10
}

rp_hats_Add {
    name     = 'Он был #6!',
    category = 'Головной убор',
    price    = 200000,
    model    = 'models/sal/acc/fix/beerhat.mdl',
    skin     = 5,
    offpos = Vector(3, 0, 0),
    offang = Angle(2, 5, 0),
    scale = 1.0,
    infooffset = 10
}

rp_hats_Add {
    name     = 'Синие Лицо Милосердия',
    category = 'Маски',
    type = APPAREL_MASKS,
    price    = 500000,
    model    = 'models/sal/acc/fix/mask_2.mdl',
    skin     = 0,
    offpos = Vector(0, 0.3, 0),
    offang = Angle(5, 15, 0),
    scale = 1.0,
    infooffset = 10
}

rp_hats_Add {
    name     = 'Дикое Лицо Милосердия',
    category = 'Маски',
    type = APPAREL_MASKS,
    price    = 600000,
    model    = 'models/sal/acc/fix/mask_2.mdl',
    skin     = 1,
    offpos = Vector(0, 0.3, 0),
    offang = Angle(5, 15, 0),
    scale = 1.0,
    infooffset = 10
}

rp_hats_Add {
    name     = 'Дикое Лицо Милосердия 2',
    category = 'Маски',
    type = APPAREL_MASKS,
    price    = 600000,
    model    = 'models/sal/acc/fix/mask_2.mdl',
    skin     = 2,
    offpos = Vector(0, 0.3, 0),
    offang = Angle(5, 15, 0),
    scale = 1.0,
    infooffset = 10
}

rp_hats_Add {
    name     = 'Дикое Лицо Милосердия 3',
    category = 'Маски',
    type = APPAREL_MASKS,
    price    = 600000,
    model    = 'models/sal/acc/fix/mask_2.mdl',
    skin     = 3,
    offpos = Vector(0, 0.3, 0),
    offang = Angle(5, 15, 0),
    scale = 1.0,
    infooffset = 10
}

rp_hats_Add {
    name     = 'Дикое Лицо Милосердия 4',
    category = 'Маски',
    type = APPAREL_MASKS,
    price    = 600000,
    model    = 'models/sal/acc/fix/mask_2.mdl',
    skin     = 4,
    offpos = Vector(0, 0.3, 0),
    offang = Angle(5, 15, 0),
    scale = 1.0,
    infooffset = 10
}

rp_hats_Add {
    name     = 'Королевское Лицо Милосердия',
    category = 'Маски',
    type = APPAREL_MASKS,
    price    = 600000,
    model    = 'models/sal/acc/fix/mask_2.mdl',
    skin     = 5,
    offpos = Vector(0, 0.3, 0),
    offang = Angle(5, 15, 0),
    scale = 1.0,
    infooffset = 10
}

rp_hats_Add {
    name     = 'Мертвое Лицо Милосердия',
    category = 'Маски',
    type = APPAREL_MASKS,
    price    = 600000,
    model    = 'models/sal/acc/fix/mask_2.mdl',
    skin     = 6,
    offpos = Vector(0, 0.3, 0),
    offang = Angle(5, 15, 0),
    scale = 1.0,
    infooffset = 10
}

rp_hats_Add {
    name     = 'Мертвое Лицо Милосердия 2',
    category = 'Маски',
    type = APPAREL_MASKS,
    price    = 600000,
    model    = 'models/sal/acc/fix/mask_2.mdl',
    skin     = 7,
    offpos = Vector(0, 0.3, 0),
    offang = Angle(5, 15, 0),
    scale = 1.0,
    infooffset = 10
}

rp_hats_Add {
    name     = 'Огненное Лицо Милосердия',
    category = 'Маски',
    type = APPAREL_MASKS,
    price    = 600000,
    model    = 'models/sal/acc/fix/mask_2.mdl',
    skin     = 8,
    offpos = Vector(0, 0.3, 0),
    offang = Angle(5, 15, 0),
    scale = 1.0,
    infooffset = 10
}

rp_hats_Add {
    name     = 'Огненное Лицо Милосердия 2',
    category = 'Маски',
    type = APPAREL_MASKS,
    price    = 600000,
    model    = 'models/sal/acc/fix/mask_2.mdl',
    skin     = 9,
    offpos = Vector(0, 0.3, 0),
    offang = Angle(5, 15, 0),
    scale = 1.0,
    infooffset = 10
}

rp_hats_Add {
    name     = 'Огненное Лицо Милосердия 3',
    category = 'Маски',
    type = APPAREL_MASKS,
    price    = 600000,
    model    = 'models/sal/acc/fix/mask_2.mdl',
    skin     = 10,
    offpos = Vector(0, 0.3, 0),
    offang = Angle(5, 15, 0),
    scale = 1.0,
    infooffset = 10
}

rp_hats_Add {
    name     = 'Темное Лицо Милосердия',
    category = 'Маски',
    type = APPAREL_MASKS,
    price    = 600000,
    model    = 'models/sal/acc/fix/mask_2.mdl',
    skin     = 11,
    offpos = Vector(0, 0.3, 0),
    offang = Angle(5, 15, 0),
    scale = 1.0,
    infooffset = 10
}

rp_hats_Add {
    name     = 'Кожаное Лицо Милосердия',
    category = 'Маски',
    type = APPAREL_MASKS,
    price    = 600000,
    model    = 'models/sal/acc/fix/mask_2.mdl',
    skin     = 12,
    offpos = Vector(0, 0.3, 0),
    offang = Angle(5, 15, 0),
    scale = 1.0,
    infooffset = 10
}

rp_hats_Add {
    name     = 'Кожаное Лицо Милосердия 2',
    category = 'Маски',
    type = APPAREL_MASKS,
    price    = 600000,
    model    = 'models/sal/acc/fix/mask_2.mdl',
    skin     = 13,
    offpos = Vector(0, 0.3, 0),
    offang = Angle(5, 15, 0),
    scale = 1.0,
    infooffset = 10
}

rp_hats_Add {
    name     = 'Хоккейное Лицо Милосердия',
    category = 'Маски',
    type = APPAREL_MASKS,
    price    = 600000,
    model    = 'models/sal/acc/fix/mask_2.mdl',
    skin     = 14,
    offpos = Vector(0, 0.3, 0),
    offang = Angle(5, 15, 0),
    scale = 1.0,
    infooffset = 10
}

rp_hats_Add {
    name     = 'Лицо Гибели',
    category = 'Маски',
    type = APPAREL_MASKS,
    price    = 600000,
    model    = 'models/sal/acc/fix/mask_4.mdl',
    skin     = 0,
    offpos = Vector(-0.7, 0.4, 0),
    offang = Angle(5, 15, 0),
    scale = 1.0,
    infooffset = 10
}

rp_hats_Add {
    name     = 'Зеленая Погибель',
    category = 'Маски',
    type = APPAREL_MASKS,
    price    = 600000,
    model    = 'models/sal/acc/fix/mask_4.mdl',
    skin     = 1,
    offpos = Vector(-0.7, 0.4, 0),
    offang = Angle(5, 15, 0),
    scale = 1.0,
    infooffset = 10
}

rp_hats_Add {
    name     = 'Огненная Погибель',
    category = 'Маски',
    type = APPAREL_MASKS,
    price    = 600000,
    model    = 'models/sal/acc/fix/mask_4.mdl',
    skin     = 2,
    offpos = Vector(-0.7, 0.4, 0),
    offang = Angle(5, 15, 0),
    scale = 1.0,
    infooffset = 10
}

rp_hats_Add {
    name     = 'Зеленая Погибель',
    category = 'Маски',
    type = APPAREL_MASKS,
    price    = 400000,
    model    = 'models/sal/acc/fix/mask_4.mdl',
    skin     = 3,
    offpos = Vector(-0.7, 0.4, 0),
    offang = Angle(5, 15, 0),
    scale = 1.0,
    infooffset = 10
}

rp_hats_Add {
    name     = 'Темная Погибель',
    category = 'Маски',
    type = APPAREL_MASKS,
    price    = 400000,
    model    = 'models/sal/acc/fix/mask_4.mdl',
    skin     = 4,
    offpos = Vector(-0.7, 0.4, 0),
    offang = Angle(5, 15, 0),
    scale = 1.0,
    infooffset = 10
}

rp_hats_Add {
    name     = 'Точная Погибель',
    category = 'Маски',
    type = APPAREL_MASKS,
    price    = 400000,
    model    = 'models/sal/acc/fix/mask_4.mdl',
    skin     = 5,
    offpos = Vector(-0.7, 0.4, 0),
    offang = Angle(5, 15, 0),
    scale = 1.0,
    infooffset = 10
}

rp_hats_Add {
    name     = 'Погибель',
    category = 'Маски',
    type = APPAREL_MASKS,
    price    = 400000,
    model    = 'models/sal/acc/fix/mask_4.mdl',
    skin     = 6,
    offpos = Vector(-0.7, 0.4, 0),
    offang = Angle(5, 15, 0),
    scale = 1.0,
    infooffset = 10
}

rp_hats_Add {
    name     = 'Электрическая Погибель',
    category = 'Маски',
    type = APPAREL_MASKS,
    price    = 500000,
    model    = 'models/sal/acc/fix/mask_4.mdl',
    skin     = 7,
    offpos = Vector(-0.7, 0.4, 0),
    offang = Angle(5, 15, 0),
    scale = 1.0,
    infooffset = 10
}

rp_hats_Add {
    name     = 'Деревянная Погибель',
    category = 'Маски',
    type = APPAREL_MASKS,
    price    = 300000,
    model    = 'models/sal/acc/fix/mask_4.mdl',
    skin     = 8,
    offpos = Vector(-0.7, 0.4, 0),
    offang = Angle(5, 15, 0),
    scale = 1.0,
    infooffset = 10
}

rp_hats_Add {
    name     = 'Птица с короной',
    category = 'Шея',
    type     = APPAREL_SCARVES,
    price    = 500000,
    model    = 'models/roblox_assets/dominowl_crown.mdl',
    skin     = 0,
    offpos = Vector(0, 0, 7),
    offang = Angle(5, 15, 180),
    scale = 1.1,
    infooffset = 10
}

rp_hats_Add {
    name     = 'Кот',
    category = 'Шея',
    type     = APPAREL_SCARVES,
    price    = 400000,
    model    = 'models/roblox/business_cat.mdl',
    skin     = 0,
    offpos = Vector(12, -5, 0),
    offang = Angle(5, 15, 180),
    scale = 1.1,
    infooffset = 10
}

rp_hats_Add {
    name     = 'Кот с фуражкой',
    category = 'Шея',
    type     = APPAREL_SCARVES,
    price    = 350000,
    model    = 'models/roblox_assets/captain_kitty.mdl',
    skin     = 0,
    offpos = Vector(12, -5, 0),
    offang = Angle(5, 15, 180),
    scale = 1.1,
    infooffset = 10
}

rp_hats_Add {
    name     = 'Акула-кот',
    category = 'Шея',
    type     = APPAREL_SCARVES,
    price    = 600000,
    model    = 'models/roblox/shoulder_shark_cat.mdl',
    skin     = 0,
    offpos = Vector(12, -3, -1),
    offang = Angle(5, 15, 45),
    scale = 1.1,
    infooffset = 10
}

rp_hats_Add {
    name     = 'Лама',
    category = 'Шея',
    type     = APPAREL_SCARVES,
    price    = 900000,
    model    = 'models/roblox/from_the_vault__alpaca_plushie.mdl',
    skin     = 0,
    offpos = Vector(12, -2, 0),
    offang = Angle(0, 20, 180),
    scale = 1.1,
    infooffset = 10
}

rp_hats_Add {
    name     = 'Голубь с биноклем',
    category = 'Шея',
    type     = APPAREL_SCARVES,
    price    = 1000000,
    model    = 'models/roblox_assets/spy_bird.mdl',
    skin     = 0,
    offpos = Vector(-2, -3, 7),
    offang = Angle(5, 15, 180),
    scale = 1.1,
    infooffset = 10
}

rp_hats_Add {
    name     = 'Крокодил',
    category = 'Шея',
    type     = APPAREL_SCARVES,
    price    = 2500000,
    model    = 'models/roblox/chillin__gator.mdl',
    skin     = 0,
    offpos = Vector(0, 0, 0),
    offang = Angle(5, 15, 180),
    scale = 1.1,
    infooffset = 10
}

rp_hats_Add {
    name     = 'Белый Шарф',
    category = 'Шея',
    type     = APPAREL_SCARVES,
    price    = 100000,
    model    = 'models/sal/acc/fix/scarf01.mdl',
    skin     = 0,
    offpos = Vector(-28, 8, -0.5),
    offang = Angle(5, 15, 0),
    scale = 1.1,
    infooffset = 10
}

rp_hats_Add {
    name     = 'Серый Шарф',
    category = 'Шея',
    type     = APPAREL_SCARVES,
    price    = 100000,
    model    = 'models/sal/acc/fix/scarf01.mdl',
    skin     = 1,
    offpos = Vector(-28, 8, -0.5),
    offang = Angle(5, 15, 0),
    scale = 1.1,
    infooffset = 10
}

rp_hats_Add {
    name     = 'Черный Шарф',
    category = 'Шея',
    type     = APPAREL_SCARVES,
    price    = 100000,
    model    = 'models/sal/acc/fix/scarf01.mdl',
    skin     = 2,
    offpos = Vector(-28, 8, -0.5),
    offang = Angle(5, 15, 0),
    scale = 1.1,
    infooffset = 10
}

rp_hats_Add {
    name     = 'Темно-Синий Шарф',
    category = 'Шея',
    type     = APPAREL_SCARVES,
    price    = 100000,
    model    = 'models/sal/acc/fix/scarf01.mdl',
    skin     = 3,
    offpos = Vector(-28, 8, -0.5),
    offang = Angle(5, 15, 0),
    scale = 1.1,
    infooffset = 10
}

rp_hats_Add {
    name     = 'Красный Шарф',
    category = 'Шея',
    type     = APPAREL_SCARVES,
    price    = 100000,
    model    = 'models/sal/acc/fix/scarf01.mdl',
    skin     = 4,
    offpos = Vector(-28, 8, -0.5),
    offang = Angle(5, 15, 0),
    scale = 1.1,
    infooffset = 10
}

rp_hats_Add {
    name     = 'Зеленый Шарф',
    category = 'Шея',
    type     = APPAREL_SCARVES,
    price    = 100000,
    model    = 'models/sal/acc/fix/scarf01.mdl',
    skin     = 5,
    offpos = Vector(-28, 8, -0.5),
    offang = Angle(5, 15, 0),
    scale = 1.1,
    infooffset = 10
}

rp_hats_Add {
    name     = 'Розовый Шарф',
    category = 'Шея',
    type     = APPAREL_SCARVES,
    price    = 100000,
    model    = 'models/sal/acc/fix/scarf01.mdl',
    skin     = 6,
    offpos = Vector(-28, 8, -0.5),
    offang = Angle(5, 15, 0),
    scale = 1.1,
    infooffset = 10
}

rp_hats_Add {
    name     = 'Пакет Up-n-Atom',
    category = 'Маски',
    type = APPAREL_MASKS,
    price    = 250000,
    model    = 'models/sal/halloween/bag.mdl',
    skin     = 0,
    offpos = Vector(1, 0, -0.3),
    offang = Angle(0, 0, 0),
    scale = 1.0,
    infooffset = 10
}

rp_hats_Add {
    name     = 'Пакет Улыбок',
    category = 'Маски',
    type = APPAREL_MASKS,
    price    = 250000,
    model    = 'models/sal/halloween/bag.mdl',
    skin     = 1,
    offpos = Vector(1, 0, -0.3),
    offang = Angle(0, 0, 0),
    scale = 1.0,
    infooffset = 10
}

rp_hats_Add {
    name     = 'Грустный пакет',
    category = 'Маски',
    type = APPAREL_MASKS,
    price    = 250000,
    model    = 'models/sal/halloween/bag.mdl',
    skin     = 2,
    offpos = Vector(1, 0, -0.3),
    offang = Angle(0, 0, 0),
    scale = 1.0,
    infooffset = 10
}

rp_hats_Add {
    name     = 'Веселый пакет',
    category = 'Маски',
    type = APPAREL_MASKS,
    price    = 250000,
    model    = 'models/sal/halloween/bag.mdl',
    skin     = 3,
    offpos = Vector(1, 0, -0.3),
    offang = Angle(0, 0, 0),
    scale = 1.0,
    infooffset = 10
}

rp_hats_Add {
    name     = 'Пакет \"Погладь кота\"',
    category = 'Маски',
    type = APPAREL_MASKS,
    price    = 250000,
    model    = 'models/sal/halloween/bag.mdl',
    skin     = 4,
    offpos = Vector(1, 0, -0.3),
    offang = Angle(0, 0, 0),
    scale = 1.0,
    infooffset = 10
}

rp_hats_Add {
    name     = 'Пакет \"Пасть\"',
    category = 'Маски',
    type = APPAREL_MASKS,
    price    = 250000,
    model    = 'models/sal/halloween/bag.mdl',
    skin     = 5,
    offpos = Vector(1, 0, -0.3),
    offang = Angle(0, 0, 0),
    scale = 1.0,
    infooffset = 10
}

rp_hats_Add {
    name     = 'Застенчивый пакет',
    category = 'Маски',
    type = APPAREL_MASKS,
    price    = 250000,
    model    = 'models/sal/halloween/bag.mdl',
    skin     = 6,
    offpos = Vector(1, 0, -0.3),
    offang = Angle(0, 0, 0),
    scale = 1.0,
    infooffset = 10
}

rp_hats_Add {
    name     = 'Пакет Burger Shot',
    category = 'Маски',
    type = APPAREL_MASKS,
    price    = 250000,
    model    = 'models/sal/halloween/bag.mdl',
    skin     = 7,
    offpos = Vector(1, 0, -0.3),
    offang = Angle(0, 0, 0),
    scale = 1.0,
    infooffset = 10
}

rp_hats_Add {
    name     = 'Пакет \"КМП\"',
    category = 'Маски',
    type = APPAREL_MASKS,
    price    = 250000,
    model    = 'models/sal/halloween/bag.mdl',
    skin     = 8,
    offpos = Vector(1, 0, -0.3),
    offang = Angle(0, 0, 0),
    scale = 1.0,
    infooffset = 10
}

rp_hats_Add {
    name     = 'Дьявольский пакет',
    category = 'Маски',
    type = APPAREL_MASKS,
    price    = 250000,
    model    = 'models/sal/halloween/bag.mdl',
    skin     = 9,
    offpos = Vector(1, 0, -0.3),
    offang = Angle(0, 0, 0),
    scale = 1.0,
    infooffset = 10
}

rp_hats_Add {
    name     = 'Полицейский пакет',
    category = 'Маски',
    type = APPAREL_MASKS,
    price    = 250000,
    model    = 'models/sal/halloween/bag.mdl',
    skin     = 10,
    offpos = Vector(1, 0, -0.3),
    offang = Angle(0, 0, 0),
    scale = 1.0,
    infooffset = 10
}

rp_hats_Add {
    name     = 'Пакет \"Монстр\"',
    category = 'Маски',
    type = APPAREL_MASKS,
    price    = 250000,
    model    = 'models/sal/halloween/bag.mdl',
    skin     = 11,
    offpos = Vector(1, 0, -0.3),
    offang = Angle(0, 0, 0),
    scale = 1.0,
    infooffset = 10
}

rp_hats_Add {
    name     = 'Разъяренный пакет',
    category = 'Маски',
    type = APPAREL_MASKS,
    price    = 250000,
    model    = 'models/sal/halloween/bag.mdl',
    skin     = 12,
    offpos = Vector(1, 0, -0.3),
    offang = Angle(0, 0, 0),
    scale = 1.0,
    infooffset = 10
}

rp_hats_Add {
    name     = 'Пакет \"Зиг-Заг\"',
    category = 'Маски',
    type = APPAREL_MASKS,
    price    = 250000,
    model    = 'models/sal/halloween/bag.mdl',
    skin     = 13,
    offpos = Vector(1, 0, -0.3),
    offang = Angle(0, 0, 0),
    scale = 1.0,
    infooffset = 10
}

rp_hats_Add {
    name     = 'Пакет \"Череп\"',
    category = 'Маски',
    type = APPAREL_MASKS,
    price    = 250000,
    model    = 'models/sal/halloween/bag.mdl',
    skin     = 14,
    offpos = Vector(1, 0, -0.3),
    offang = Angle(0, 0, 0),
    scale = 1.0,
    infooffset = 10
}

rp_hats_Add {
    name     = 'Пакет \"Песик\"',
    category = 'Маски',
    type = APPAREL_MASKS,
    price    = 250000,
    model    = 'models/sal/halloween/bag.mdl',
    skin     = 15,
    offpos = Vector(1, 0, -0.3),
    offang = Angle(0, 0, 0),
    scale = 1.0,
    infooffset = 10
}

rp_hats_Add {
    name     = 'Розовый пакет',
    category = 'Маски',
    type = APPAREL_MASKS,
    price    = 250000,
    model    = 'models/sal/halloween/bag.mdl',
    skin     = 16,
    offpos = Vector(1, 0, -0.3),
    offang = Angle(0, 0, 0),
    scale = 1.0,
    infooffset = 10
}

rp_hats_Add {
    name     = 'Пакет \"НЛО\"',
    category = 'Маски',
    type = APPAREL_MASKS,
    price    = 250000,
    model    = 'models/sal/halloween/bag.mdl',
    skin     = 17,
    offpos = Vector(1, 0, -0.3),
    offang = Angle(0, 0, 0),
    scale = 1.0,
    infooffset = 10
}

rp_hats_Add {
    name     = 'Пакет \"На помощь\"',
    category = 'Маски',
    type = APPAREL_MASKS,
    price    = 250000,
    model    = 'models/sal/halloween/bag.mdl',
    skin     = 18,
    offpos = Vector(1, 0, -0.3),
    offang = Angle(0, 0, 0),
    scale = 1.0,
    infooffset = 10
}

rp_hats_Add {
    name     = 'Пакет-головоломка',
    category = 'Маски',
    type = APPAREL_MASKS,
    price    = 250000,
    model    = 'models/sal/halloween/bag.mdl',
    skin     = 19,
    offpos = Vector(1, 0, -0.3),
    offang = Angle(0, 0, 0),
    scale = 1.0,
    infooffset = 10
}

rp_hats_Add {
    name     = 'Пакет \"Фак Ю\"',
    category = 'Маски',
    type = APPAREL_MASKS,
    price    = 250000,
    model    = 'models/sal/halloween/bag.mdl',
    skin     = 20,
    offpos = Vector(1, 0, -0.3),
    offang = Angle(0, 0, 0),
    scale = 1.0,
    infooffset = 10
}

rp_hats_Add {
    name     = 'Элегантный пакет',
    category = 'Маски',
    type = APPAREL_MASKS,
    price    = 250000,
    model    = 'models/sal/halloween/bag.mdl',
    skin     = 21,
    offpos = Vector(1, 0, -0.3),
    offang = Angle(0, 0, 0),
    scale = 1.0,
    infooffset = 10
}

rp_hats_Add {
    name     = 'Пакет с наклейками',
    category = 'Маски',
    type = APPAREL_MASKS,
    price    = 250000,
    model    = 'models/sal/halloween/bag.mdl',
    skin     = 22,
    offpos = Vector(1, 0, -0.3),
    offang = Angle(0, 0, 0),
    scale = 1.0,
    infooffset = 10
}

rp_hats_Add {
    name     = 'Пакет Красота',
    category = 'Маски',
    type = APPAREL_MASKS,
    price    = 250000,
    model    = 'models/sal/halloween/bag.mdl',
    skin     = 23,
    offpos = Vector(1, 0, -0.3),
    offang = Angle(0, 0, 0),
    scale = 1.0,
    infooffset = 10
}

rp_hats_Add {
    name     = 'Романтичный пакет',
    category = 'Маски',
    type = APPAREL_MASKS,
    price    = 250000,
    model    = 'models/sal/halloween/bag.mdl',
    skin     = 24,
    offpos = Vector(1, 0, -0.3),
    offang = Angle(0, 0, 0),
    scale = 1.0,
    infooffset = 10
}

rp_hats_Add {
    name     = 'Пакет \"В отключке\"',
    category = 'Маски',
    type = APPAREL_MASKS,
    price    = 250000,
    model    = 'models/sal/halloween/bag.mdl',
    skin     = 25,
    offpos = Vector(1, 0, -0.3),
    offang = Angle(0, 0, 0),
    scale = 1.0,
    infooffset = 10
}

rp_hats_Add {
    name     = 'Бежевый клюв',
    category = 'Маски',
    type = APPAREL_GLASSES,
    price    = 1500000,
    model    = 'models/sal/halloween/doctor.mdl',
    skin     = 0,
    offpos = Vector(0.8, -1, -0.3),
    offang = Angle(0, 0, 0),
    scale = 1.0,
    infooffset = 10
}

rp_hats_Add {
    name     = 'Белый клюв',
    category = 'Маски',
    type = APPAREL_GLASSES,
    price    = 150000,
    model    = 'models/sal/halloween/doctor.mdl',
    skin     = 1,
    offpos = Vector(0.8, -1, -0.3),
    offang = Angle(0, 0, 0),
    scale = 1.0,
    infooffset = 10
}

rp_hats_Add {
    name     = 'Маскарадный клюв',
    category = 'Маски',
    type = APPAREL_GLASSES,
    price    = 150000,
    model    = 'models/sal/halloween/doctor.mdl',
    skin     = 2,
    offpos = Vector(0.8, -1, -0.3),
    offang = Angle(0, 0, 0),
    scale = 1.0,
    infooffset = 10
}

rp_hats_Add {
    name     = 'Полицейская лента',
    category = 'Маски',
    type = APPAREL_MASKS,
    price    = 7500000,
    vip = true,
    model    = 'models/sal/halloween/headwrap1.mdl',
    skin     = 0,
    offpos = Vector(-0.5, 0.6, 0),
    offang = Angle(0, 15, 0),
    scale = 1.0,
    infooffset = 10
}

rp_hats_Add {
    name     = 'Лента с черными стрелками',
    category = 'Маски',
    type = APPAREL_MASKS,
    price    = 7500000,
    vip = true,
    model    = 'models/sal/halloween/headwrap1.mdl',
    skin     = 1,
    offpos = Vector(0.9, 0, 0),
    offang = Angle(5, 0, 0),
    scale = 1.0,
    infooffset = 10
}

rp_hats_Add {
    name     = 'Лента \'Опасная Зона\'',
    category = 'Маски',
    type = APPAREL_MASKS,
    price    = 7500000,
    vip = true,
    model    = 'models/sal/halloween/headwrap1.mdl',
    skin     = 2,
    offpos = Vector(0.9, 0, 0),
    offang = Angle(5, 0, 0),
    scale = 1.0,
    infooffset = 10
}

rp_hats_Add {
    name     = 'Красно-белая лента',
    category = 'Маски',
    type = APPAREL_MASKS,
    price    = 7500000,
    vip = true,
    model    = 'models/sal/halloween/headwrap1.mdl',
    skin     = 3,
    offpos = Vector(0.9, 0, 0),
    offang = Angle(5, 0, 0),
    scale = 1.0,
    infooffset = 10
}

rp_hats_Add {
    name     = 'Серая лента',
    category = 'Маски',
    type = APPAREL_MASKS,
    price    = 7500000,
    vip = true,
    model    = 'models/sal/halloween/headwrap2.mdl',
    skin     = 0,
    offpos = Vector(0.9, 0, 0),
    offang = Angle(5, 0, 0),
    scale = 1.0,
    infooffset = 10
}

rp_hats_Add {
    name     = 'Черная лента',
    category = 'Маски',
    type = APPAREL_MASKS,
    price    = 7500000,
    vip = true,
    model    = 'models/sal/halloween/headwrap2.mdl',
    skin     = 1,
    offpos = Vector(0.9, 0, 0),
    offang = Angle(5, 0, 0),
    scale = 1.0,
    infooffset = 10
}

rp_hats_Add {
    name     = 'Светло-серая лента',
    category = 'Маски',
    type = APPAREL_MASKS,
    price    = 7500000,
    vip = true,
    model    = 'models/sal/halloween/headwrap2.mdl',
    skin     = 2,
    offpos = Vector(0.9, 0, 0),
    offang = Angle(5, 0, 0),
    scale = 1.0,
    infooffset = 10
}

rp_hats_Add {
    name     = 'Разноцветная лента',
    category = 'Маски',
    type = APPAREL_MASKS,
    price    = 7500000,
    vip = true,
    model    = 'models/sal/halloween/headwrap2.mdl',
    skin     = 3,
    offpos = Vector(0.9, 0, 0),
    offang = Angle(5, 0, 0),
    scale = 1.0,
    infooffset = 10
}

rp_hats_Add {
    name     = 'Маска обезьяны коричневая',
    category = 'Маски',
    type = APPAREL_MASKS,
    price    = 400000,
    model    = 'models/sal/halloween/monkey.mdl',
    skin     = 0,
    offpos = Vector(0.1, 0, 0),
    offang = Angle(3.5, 5, 0),
    scale = 1.0,
    infooffset = 10
}

rp_hats_Add {
    name     = 'Маска обезьяны черная',
    category = 'Маски',
    type = APPAREL_MASKS,
    price    = 400000,
    model    = 'models/sal/halloween/monkey.mdl',
    skin     = 1,
    offpos = Vector(0.1, 0, 0),
    offang = Angle(3.5, 5, 0),
    scale = 1.0,
    infooffset = 10
}

rp_hats_Add {
    name     = 'Маска обезьяны зеленая',
    category = 'Маски',
    type = APPAREL_MASKS,
    price    = 400000,
    model    = 'models/sal/halloween/monkey.mdl',
    skin     = 2,
    offpos = Vector(0.1, 0, 0),
    offang = Angle(3.5, 5, 0),
    scale = 1.0,
    infooffset = 10
}

rp_hats_Add {
    name     = 'Маска обезьяны белая',
    category = 'Маски',
    type = APPAREL_MASKS,
    price    = 400000,
    model    = 'models/sal/halloween/monkey.mdl',
    skin     = 3,
    offpos = Vector(0.1, 0, 0),
    offang = Angle(3.5, 5, 0),
    scale = 1.0,
    infooffset = 10
}

rp_hats_Add {
    name     = 'Черная плотная лента',
    category = 'Маски',
    type = APPAREL_MASKS,
    price    = 7500000,
    vip = true,
    model    = 'models/sal/halloween/ninja.mdl',
    skin     = 0,
    offpos = Vector(0.7, -0.5, -0.5),
    offang = Angle(0, 0, 0),
    scale = 1.1,
    infooffset = 10
}

rp_hats_Add {
    name     = 'Белая плотная лента',
    category = 'Маски',
    type = APPAREL_MASKS,
    price    = 7500000,
    vip = true,
    model    = 'models/sal/halloween/ninja.mdl',
    skin     = 1,
    offpos = Vector(0.7, -0.5, -0.5),
    offang = Angle(0, 0, 0),
    scale = 1.1,
    infooffset = 10
}

rp_hats_Add {
    name     = 'Бежевая плотная лента',
    category = 'Маски',
    type = APPAREL_MASKS,
    price    = 7500000,
    vip = true,
    model    = 'models/sal/halloween/ninja.mdl',
    skin     = 2,
    offpos = Vector(0.7, -0.5, -0.5),
    offang = Angle(0, 0, 0),
    scale = 1.1,
    infooffset = 10
}

rp_hats_Add {
    name     = 'Коречнево-белая плотная лента',
    category = 'Маски',
    type = APPAREL_MASKS,
    price    = 7500000,
    vip = true,
    model    = 'models/sal/halloween/ninja.mdl',
    skin     = 3,
    offpos = Vector(0.7, -0.5, -0.5),
    offang = Angle(0, 0, 0),
    scale = 1.1,
    infooffset = 10
}

rp_hats_Add {
    name     = 'Серая плотная лента',
    category = 'Маски',
    type = APPAREL_MASKS,
    price    = 7500000,
    vip = true,
    model    = 'models/sal/halloween/ninja.mdl',
    skin     = 4,
    offpos = Vector(0.7, -0.5, -0.5),
    offang = Angle(0, 0, 0),
    scale = 1.1,
    infooffset = 10
}

rp_hats_Add {
    name     = 'Камуфляжная плотная лента',
    category = 'Маски',
    type = APPAREL_MASKS,
    price    = 7500000,
    vip = true,
    model    = 'models/sal/halloween/ninja.mdl',
    skin     = 5,
    offpos = Vector(0.7, -0.5, -0.5),
    offang = Angle(0, 0, 0),
    scale = 1.1,
    infooffset = 10
}

rp_hats_Add {
    name     = 'Красно-белая плотная лента',
    category = 'Маски',
    type = APPAREL_MASKS,
    price    = 7500000,
    vip = true,
    model    = 'models/sal/halloween/ninja.mdl',
    skin     = 6,
    offpos = Vector(0.7, -0.5, -0.5),
    offang = Angle(0, 0, 0),
    scale = 1.1,
    infooffset = 10
}

rp_hats_Add {
    name     = 'Черно-белая плотная лента',
    category = 'Маски',
    type = APPAREL_MASKS,
    price    = 7500000,
    vip = true,
    model    = 'models/sal/halloween/ninja.mdl',
    skin     = 7,
    offpos = Vector(0.7, -0.5, -0.5),
    offang = Angle(0, 0, 0),
    scale = 1.1,
    infooffset = 10
}

rp_hats_Add {
    name     = 'Бело-черная плотная лента',
    category = 'Маски',
    type = APPAREL_MASKS,
    price    = 7500000,
    vip = true,
    model    = 'models/sal/halloween/ninja.mdl',
    skin     = 8,
    offpos = Vector(0.7, -0.5, -0.5),
    offang = Angle(0, 0, 0),
    scale = 1.1,
    infooffset = 10
}

rp_hats_Add {
    name     = 'Розово-камуфляжная плотная лента',
    category = 'Маски',
    type = APPAREL_MASKS,
    price    = 7500000,
    vip = true,
    model    = 'models/sal/halloween/ninja.mdl',
    skin     = 9,
    offpos = Vector(0.7, -0.5, -0.5),
    offang = Angle(0, 0, 0),
    scale = 1.1,
    infooffset = 10
}

rp_hats_Add {
    name     = 'Желто-синяя плотная лента',
    category = 'Маски',
    type = APPAREL_MASKS,
    price    = 7500000,
    vip = true,
    model    = 'models/sal/halloween/ninja.mdl',
    skin     = 10,
    offpos = Vector(0.7, -0.5, -0.5),
    offang = Angle(0, 0, 0),
    scale = 1.1,
    infooffset = 10
}

rp_hats_Add {
    name     = 'Серый череп',
    category = 'Маски',
    type = APPAREL_MASKS,
    price    = 300000,
    model    = 'models/sal/halloween/skull.mdl',
    skin     = 0,
    offpos = Vector(2, 0, 0),
    offang = Angle(0, 0, 0),
    scale = 1.1,
    infooffset = 10
}

rp_hats_Add {
    name     = 'Коричневый череп',
    category = 'Маски',
    type = APPAREL_MASKS,
    price    = 300000,
    model    = 'models/sal/halloween/skull.mdl',
    skin     = 1,
    offpos = Vector(2, 0, 0),
    offang = Angle(0, 0, 0),
    scale = 1.1,
    infooffset = 10
}

rp_hats_Add {
    name     = 'Светло-коричневый череп',
    category = 'Маски',
    type = APPAREL_MASKS,
    price    = 300000,
    model    = 'models/sal/halloween/skull.mdl',
    skin     = 2,
    offpos = Vector(2, 0, 0),
    offang = Angle(0, 0, 0),
    scale = 1.1,
    infooffset = 10
}

rp_hats_Add {
    name     = 'Черный череп',
    category = 'Маски',
    type = APPAREL_MASKS,
    price    = 300000,
    model    = 'models/sal/halloween/skull.mdl',
    skin     = 3,
    offpos = Vector(2, 0, 0),
    offang = Angle(0, 0, 0),
    scale = 1.1,
    infooffset = 10
}

rp_hats_Add {
    name     = 'Маска монстра',
    category = 'Маски',
    type = APPAREL_MASKS,
    price    = 400000,
    model    = 'models/sal/halloween/zombie.mdl',
    skin     = 0,
    offpos = Vector(0, 0, -0.3),
    offang = Angle(0, 0, 0),
    scale = 1.1,
    infooffset = 10
}

rp_hats_Add {
    name     = 'Серая маска монстра',
    category = 'Маски',
    type = APPAREL_MASKS,
    price    = 400000,
    model    = 'models/sal/halloween/zombie.mdl',
    skin     = 1,
    offpos = Vector(0, 0, -0.3),
    offang = Angle(0, 0, 0),
    scale = 1.1,
    infooffset = 10
}

rp_hats_Add {
    name     = 'Бандана',
    category = 'Маски',
    type = APPAREL_MASKS,
    price    = 12500000,
    vip = true,
    model    = 'models/modified/bandana.mdl',
    skin     = 0,
    offpos = Vector(-1, 0, 0),
    offang = Angle(0, 0, 0),
    scale = 1.1,
    infooffset = 10
}

rp_hats_Add {
    name     = 'Темные очки',
    category = 'Маски',
    type     = APPAREL_GLASSES,
    price    = 150000,
    model    = 'models/modified/glasses01.mdl',
    skin     = 0,
    offpos = Vector(3, 0, -0.2),
    offang = Angle(2, 0, 0),
    scale = 1.0,
    infooffset = 10
}

rp_hats_Add {
    name     = 'Светло-темные очки',
    category = 'Маски',
    type     = APPAREL_GLASSES,
    price    = 150000,
    model    = 'models/modified/glasses01.mdl',
    skin     = 1,
    offpos = Vector(3, 0, -0.2),
    offang = Angle(2, 0, 0),
    scale = 1.0,
    infooffset = 10
}

rp_hats_Add {
    name     = 'Зеленые очки',
    category = 'Маски',
    type     = APPAREL_GLASSES,
    price    = 150000,
    model    = 'models/modified/glasses01.mdl',
    skin     = 2,
    offpos = Vector(3, 0, -0.2),
    offang = Angle(2, 0, 0),
    scale = 1.0,
    infooffset = 10
}

rp_hats_Add {
    name     = 'Коричневые очки',
    category = 'Маски',
    type     = APPAREL_GLASSES,
    price    = 150000,
    model    = 'models/modified/glasses01.mdl',
    skin     = 3,
    offpos = Vector(3, 0, -0.2),
    offang = Angle(2, 0, 0),
    scale = 1.0,
    infooffset = 10
}

rp_hats_Add {
    name     = 'Светло-коричневые очки',
    category = 'Маски',
    type     = APPAREL_GLASSES,
    price    = 150000,
    model    = 'models/modified/glasses01.mdl',
    skin     = 4,
    offpos = Vector(3, 0, -0.2),
    offang = Angle(2, 0, 0),
    scale = 1.0,
    infooffset = 10
}

rp_hats_Add {
    name     = 'Светлые очки',
    category = 'Маски',
    type     = APPAREL_GLASSES,
    price    = 150000,
    model    = 'models/modified/glasses01.mdl',
    skin     = 5,
    offpos = Vector(3, 0, -0.2),
    offang = Angle(2, 0, 0),
    scale = 1.0,
    infooffset = 10
}

rp_hats_Add {
    name     = 'Светло-коричневые очки 2',
    category = 'Маски',
    type     = APPAREL_GLASSES,
    price    = 150000,
    model    = 'models/modified/glasses02.mdl',
    skin     = 0,
    offpos = Vector(2.5, 0, -0.2),
    offang = Angle(0, 6, 0),
    scale = 1.0,
    infooffset = 10
}

rp_hats_Add {
    name     = 'Красные очки',
    category = 'Маски',
    type     = APPAREL_GLASSES,
    price    = 150000,
    model    = 'models/modified/glasses02.mdl',
    skin     = 1,
    offpos = Vector(3, 0, -0.2),
    offang = Angle(2, 0, 0),
    scale = 1.0,
    infooffset = 10
}

rp_hats_Add {
    name     = 'Белые очки',
    category = 'Маски',
    type     = APPAREL_GLASSES,
    price    = 150000,
    model    = 'models/modified/glasses02.mdl',
    skin     = 2,
    offpos = Vector(3, 0, -0.2),
    offang = Angle(2, 0, 0),
    scale = 1.0,
    infooffset = 10
}

rp_hats_Add {
    name     = 'Черные очки',
    category = 'Маски',
    type     = APPAREL_GLASSES,
    price    = 150000,
    model    = 'models/modified/glasses02.mdl',
    skin     = 3,
    offpos = Vector(3, 0, -0.2),
    offang = Angle(2, 0, 0),
    scale = 1.0,
    infooffset = 10
}

rp_hats_Add {
    name     = 'Очки хипстера',
    category = 'Маски',
    type     = APPAREL_GLASSES,
    price    = 150000,
    model    = 'models/modified/glasses02.mdl',
    skin     = 4,
    offpos = Vector(3, 0, -0.2),
    offang = Angle(2, 0, 0),
    scale = 1.0,
    infooffset = 10
}

rp_hats_Add {
    name     = 'Серая шляпа',
    category = 'Фаза Хипстера',
    price    = 200000,
    model    = 'models/modified/hat01_fix.mdl',
    skin     = 0,
    offpos = Vector(4, 0, 0),
    offang = Angle(2, 8, 0),
    scale = 1.0,
    infooffset = 10
}

rp_hats_Add {
    name     = 'Черная шляпа',
    category = 'Фаза Хипстера',
    price    = 200000,
    model    = 'models/modified/hat01_fix.mdl',
    skin     = 1,
    offpos = Vector(4, 0, 0),
    offang = Angle(2, 8, 0),
    scale = 1.0,
    infooffset = 10
}

rp_hats_Add {
    name     = 'Белая шляпа',
    category = 'Фаза Хипстера',
    price    = 200000,
    model    = 'models/modified/hat01_fix.mdl',
    skin     = 2,
    offpos = Vector(4, 0, 0),
    offang = Angle(2, 8, 0),
    scale = 1.0,
    infooffset = 10
}

rp_hats_Add {
    name     = 'Бежевая шляпа',
    category = 'Фаза Хипстера',
    price    = 200000,
    model    = 'models/modified/hat01_fix.mdl',
    skin     = 3,
    offpos = Vector(4, 0, 0),
    offang = Angle(2, 8, 0),
    scale = 1.0,
    infooffset = 10
}

rp_hats_Add {
    name     = 'Красная шляпа',
    category = 'Фаза Хипстера',
    price    = 200000,
    model    = 'models/modified/hat01_fix.mdl',
    skin     = 4,
    offpos = Vector(4, 0, 0),
    offang = Angle(2, 8, 0),
    scale = 1.0,
    infooffset = 10
}

rp_hats_Add {
    name     = 'Черно-красная шляпа',
    category = 'Фаза Хипстера',
    price    = 200000,
    model    = 'models/modified/hat01_fix.mdl',
    skin     = 5,
    offpos = Vector(4, 0, 0),
    offang = Angle(2, 8, 0),
    scale = 1.0,
    infooffset = 10
}

rp_hats_Add {
    name     = 'Коричневая шляпа',
    category = 'Фаза Хипстера',
    price    = 200000,
    model    = 'models/modified/hat01_fix.mdl',
    skin     = 6,
    offpos = Vector(4, 0, 0),
    offang = Angle(2, 8, 0),
    scale = 1.0,
    infooffset = 10
}

rp_hats_Add {
    name     = 'Черно-синяя шляпа',
    category = 'Фаза Хипстера',
    price    = 200000,
    model    = 'models/modified/hat01_fix.mdl',
    skin     = 7,
    offpos = Vector(4, 0, 0),
    offang = Angle(2, 8, 0),
    scale = 1.0,
    infooffset = 10
}

rp_hats_Add {
    name     = 'Красная полосатая шапка',
    category = 'Фаза Хипстера',
    price    = 200000,
    model    = 'models/modified/hat03.mdl',
    skin     = 0,
    offpos = Vector(4, 0, 0),
    offang = Angle(2, 8, 0),
    scale = 1.0,
    infooffset = 10
}

rp_hats_Add {
    name     = 'Фиолетовая шапка',
    category = 'Фаза Хипстера',
    price    = 200000,
    model    = 'models/modified/hat03.mdl',
    skin     = 1,
    offpos = Vector(4, 0, 0),
    offang = Angle(2, 8, 0),
    scale = 1.0,
    infooffset = 10
}

rp_hats_Add {
    name     = 'Красная шапка',
    category = 'Фаза Хипстера',
    price    = 200000,
    model    = 'models/modified/hat03.mdl',
    skin     = 2,
    offpos = Vector(4, 0, 0),
    offang = Angle(2, 8, 0),
    scale = 1.0,
    infooffset = 10
}

rp_hats_Add {
    name     = 'Белая шапка',
    category = 'Фаза Хипстера',
    price    = 200000,
    model    = 'models/modified/hat03.mdl',
    skin     = 3,
    offpos = Vector(4, 0, 0),
    offang = Angle(2, 8, 0),
    scale = 1.0,
    infooffset = 10
}

rp_hats_Add {
    name     = 'Серая полосатая шапка',
    category = 'Фаза Хипстера',
    price    = 200000,
    model    = 'models/modified/hat03.mdl',
    skin     = 4,
    offpos = Vector(4, 0, 0),
    offang = Angle(2, 8, 0),
    scale = 1.0,
    infooffset = 10
}

rp_hats_Add {
    name     = 'Черная шапка',
    category = 'Фаза Хипстера',
    price    = 200000,
    model    = 'models/modified/hat04.mdl',
    skin     = 0,
    offpos = Vector(4, -2, 0),
    offang = Angle(2, 18, 0),
    scale = 1.0,
    infooffset = 10
}

rp_hats_Add {
    name     = 'Серая шапка',
    category = 'Фаза Хипстера',
    price    = 200000,
    model    = 'models/modified/hat04.mdl',
    skin     = 1,
    offpos = Vector(4, -2, 0),
    offang = Angle(2, 18, 0),
    scale = 1.0,
    infooffset = 10
}

rp_hats_Add {
    name     = 'Белая полосатая шапка',
    category = 'Фаза Хипстера',
    price    = 200000,
    model    = 'models/modified/hat04.mdl',
    skin     = 2,
    offpos = Vector(4, -2, 0),
    offang = Angle(2, 18, 0),
    scale = 1.0,
    infooffset = 10
}

rp_hats_Add {
    name     = 'Полосатая шапка',
    category = 'Фаза Хипстера',
    price    = 200000,
    model    = 'models/modified/hat04.mdl',
    skin     = 3,
    offpos = Vector(4, -2, 0),
    offang = Angle(2, 18, 0),
    scale = 1.0,
    infooffset = 10
}

rp_hats_Add {
    name     = 'Голубая шапка',
    category = 'Фаза Хипстера',
    price    = 200000,
    model    = 'models/modified/hat04.mdl',
    skin     = 4,
    offpos = Vector(4, -2, 0),
    offang = Angle(2, 18, 0),
    scale = 1.0,
    infooffset = 10
}

rp_hats_Add {
    name     = 'Розовая бейсболка',
    category = 'Головной убор',
    price    = 7500000,
    vip = true,
    model    = 'models/modified/hat05.mdl',
    skin     = 1,
    offpos = Vector(4, 0, 0),
    offang = Angle(2, 18, 0),
    scale = 1.0,
    infooffset = 10
}

rp_hats_Add {
    name     = 'Бейсболка Таксиста',
    category = 'Головной убор',
    price    = 7500000,
    vip = true,
    model    = 'models/modified/hat06.mdl',
    skin     = 0,
    offpos = Vector(4, 0, 0),
    offang = Angle(5, 18, 0),
    scale = 1.0,
    infooffset = 10
}

rp_hats_Add {
    name     = 'Черно-зеленая бейсболка',
    category = 'Головной убор',
    price    = 7500000,
    vip = true,
    model    = 'models/modified/hat07.mdl',
    skin     = 0,
    offpos = Vector(4, 0, 0),
    offang = Angle(2, 18, 0),
    scale = 1.0,
    infooffset = 10
}

rp_hats_Add {
    name     = 'Черно-зеленая бейсболка 2',
    category = 'Головной убор',
    price    = 7500000,
    vip = true,
    model    = 'models/modified/hat07.mdl',
    skin     = 1,
    offpos = Vector(4, 0, 0),
    offang = Angle(2, 18, 0),
    scale = 1.0,
    infooffset = 10
}

rp_hats_Add {
    name     = 'Черно-серая бейсболка',
    category = 'Головной убор',
    price    = 7500000,
    vip = true,
    model    = 'models/modified/hat07.mdl',
    skin     = 2,
    offpos = Vector(4, 0, 0),
    offang = Angle(2, 18, 0),
    scale = 1.0,
    infooffset = 10
}

rp_hats_Add {
    name     = 'Черно-белая бейсболка',
    category = 'Головной убор',
    price    = 7500000,
    vip = true,
    model    = 'models/modified/hat07.mdl',
    skin     = 3,
    offpos = Vector(4, 0, 0),
    offang = Angle(2, 18, 0),
    scale = 1.0,
    infooffset = 10
}

rp_hats_Add {
    name     = 'Бело-зеленая бейсболка',
    category = 'Головной убор',
    price    = 7500000,
    vip = true,
    model    = 'models/modified/hat07.mdl',
    skin     = 4,
    offpos = Vector(4, 0, 0),
    offang = Angle(2, 18, 0),
    scale = 1.0,
    infooffset = 10
}

rp_hats_Add {
    name     = 'Темная бело-зеленая бейсболка',
    category = 'Головной убор',
    price    = 7500000,
    vip = true,
    model    = 'models/modified/hat07.mdl',
    skin     = 5,
    offpos = Vector(4, 0, 0),
    offang = Angle(2, 18, 0),
    scale = 1.0,
    infooffset = 10
}

rp_hats_Add {
    name     = 'Бело-бордовая бейсболка',
    category = 'Головной убор',
    price    = 7500000,
    vip = true,
    model    = 'models/modified/hat07.mdl',
    skin     = 6,
    offpos = Vector(4, 0, 0),
    offang = Angle(2, 18, 0),
    scale = 1.0,
    infooffset = 10
}

rp_hats_Add {
    name     = 'Серо-голубая бейсболка',
    category = 'Головной убор',
    price    = 7500000,
    vip = true,
    model    = 'models/modified/hat07.mdl',
    skin     = 7,
    offpos = Vector(4, 0, 0),
    offang = Angle(2, 18, 0),
    scale = 1.0,
    infooffset = 10
}

rp_hats_Add {
    name     = 'Бело-коричневая бейсболка',
    category = 'Головной убор',
    price    = 7500000,
    vip = true,
    model    = 'models/modified/hat07.mdl',
    skin     = 8,
    offpos = Vector(4, 0, 0),
    offang = Angle(2, 18, 0),
    scale = 1.0,
    infooffset = 10
}

rp_hats_Add {
    name     = 'Темная бело-зеленая бейсболка 2',
    category = 'Головной убор',
    price    = 7500000,
    vip = true,
    model    = 'models/modified/hat07.mdl',
    skin     = 9,
    offpos = Vector(4, 0, 0),
    offang = Angle(2, 18, 0),
    scale = 1.0,
    infooffset = 10
}

rp_hats_Add {
    name     = 'Красно-коричневая бейсболка',
    category = 'Головной убор',
    price    = 7500000,
    vip = true,
    model    = 'models/modified/hat07.mdl',
    skin     = 100000,
    offpos = Vector(4, 0, 0),
    offang = Angle(2, 18, 0),
    scale = 1.0,
    infooffset = 10
}

rp_hats_Add {
    name     = 'Оранжевая кепка',
    category = 'Головной убор',
    price    = 2500000,
    model    = 'models/modified/hat08.mdl',
    skin     = 0,
    offpos = Vector(4, 0, 0),
    offang = Angle(2, 12, 0),
    scale = 1.0,
    infooffset = 10
}


rp_hats_Add {
    name     = 'Бело-синяя кепка',
    category = 'Головной убор',
    price    = 250000,
    model    = 'models/modified/hat08.mdl',
    skin     = 1,
    offpos = Vector(4, 0, 0),
    offang = Angle(2, 12, 0),
    scale = 1.0,
    infooffset = 10
}

rp_hats_Add {
    name     = 'Бело-коричневая кепка',
    category = 'Головной убор',
    price    = 250000,
    model    = 'models/modified/hat08.mdl',
    skin     = 2,
    offpos = Vector(4, 0, 0),
    offang = Angle(2, 12, 0),
    scale = 1.0,
    infooffset = 10
}

rp_hats_Add {
    name     = 'Бело-коричневая кепка 2',
    category = 'Головной убор',
    price    = 250000,
    model    = 'models/modified/hat08.mdl',
    skin     = 3,
    offpos = Vector(4, 0, 0),
    offang = Angle(2, 12, 0),
    scale = 1.0,
    infooffset = 10
}

rp_hats_Add {
    name     = 'Бело-красная кепка',
    category = 'Головной убор',
    price    = 250000,
    model    = 'models/modified/hat08.mdl',
    skin     = 4,
    offpos = Vector(4, 0, 0),
    offang = Angle(2, 12, 0),
    scale = 1.0,
    infooffset = 10
}

rp_hats_Add {
    name     = 'Бело-зеленая кепка',
    category = 'Головной убор',
    price    = 250000,
    model    = 'models/modified/hat08.mdl',
    skin     = 5,
    offpos = Vector(4, 0, 0),
    offang = Angle(2, 12, 0),
    scale = 1.0,
    infooffset = 10
}

rp_hats_Add {
    name     = 'Черная кепка',
    category = 'Головной убор',
    price    = 250000,
    model    = 'models/modified/hat08.mdl',
    skin     = 6,
    offpos = Vector(4, 0, 0),
    offang = Angle(2, 12, 0),
    scale = 1.0,
    infooffset = 10
}

rp_hats_Add {
    name     = 'Бело-черная кепка',
    category = 'Головной убор',
    price    = 250000,
    model    = 'models/modified/hat08.mdl',
    skin     = 7,
    offpos = Vector(4, 0, 0),
    offang = Angle(2, 12, 0),
    scale = 1.0,
    infooffset = 10
}

rp_hats_Add {
    name     = 'Бело-черная кепка 2',
    category = 'Головной убор',
    price    = 250000,
    model    = 'models/modified/hat08.mdl',
    skin     = 8,
    offpos = Vector(4, 0, 0),
    offang = Angle(2, 12, 0),
    scale = 1.0,
    infooffset = 10
}

rp_hats_Add {
    name     = 'Бело-коричневая кепка',
    category = 'Головной убор',
    price    = 250000,
    model    = 'models/modified/hat08.mdl',
    skin     = 9,
    offpos = Vector(4, 0, 0),
    offang = Angle(2, 12, 0),
    scale = 1.0,
    infooffset = 10
}

rp_hats_Add {
    name     = 'Бело-серая кепка',
    category = 'Головной убор',
    price    = 250000,
    model    = 'models/modified/hat08.mdl',
    skin     = 10,
    offpos = Vector(4, 0, 0),
    offang = Angle(2, 12, 0),
    scale = 1.0,
    infooffset = 10
}

rp_hats_Add {
    name     = 'Бело-коричневая кепка 2',
    category = 'Головной убор',
    price    = 250000,
    model    = 'models/modified/hat08.mdl',
    skin     = 11,
    offpos = Vector(4, 0, 0),
    offang = Angle(2, 12, 0),
    scale = 1.0,
    infooffset = 10
}

rp_hats_Add {
    name     = 'Красные наушники',
    category = 'Головной убор',
    price    = 200000,
    model    = 'models/modified/headphones.mdl',
    skin     = 0,
    offpos = Vector(2, 2, 0),
    offang = Angle(2, 12, 0),
    scale = 1.0,
    infooffset = 10
}

rp_hats_Add {
    name     = 'Фиолетовые наушники',
    category = 'Головной убор',
    price    = 200000,
    model    = 'models/modified/headphones.mdl',
    skin     = 1,
    offpos = Vector(2, 2, 0),
    offang = Angle(2, 12, 0),
    scale = 1.0,
    infooffset = 10
}

rp_hats_Add {
    name     = 'Зеленые наушники',
    category = 'Головной убор',
    price    = 200000,
    model    = 'models/modified/headphones.mdl',
    skin     = 2,
    offpos = Vector(2, 2, 0),
    offang = Angle(2, 12, 0),
    scale = 1.0,
    infooffset = 10
}

rp_hats_Add {
    name     = 'Желтые наушники',
    category = 'Головной убор',
    price    = 200000,
    model    = 'models/modified/headphones.mdl',
    skin     = 3,
    offpos = Vector(2, 2, 0),
    offang = Angle(2, 12, 0),
    scale = 1.0,
    infooffset = 10
}

rp_hats_Add {
    name     = 'Маска Убийц',
    category = 'Маски',
    type = APPAREL_MASKS,
    price    = 32500000,
    vip = true,
    model    = 'models/modified/mask5.mdl',
    skin     = 0,
    offpos = Vector(-0.5, 1, 0),
    offang = Angle(2, 12, 0),
    scale = 1.0,
    infooffset = 10
}

rp_hats_Add {
    name     = 'Маска теней',
    category = 'Маски',
    type = APPAREL_MASKS,
    price    = 400000,
    model    = 'models/modified/mask6.mdl',
    skin     = 0,
    offpos = Vector(-0.5, 1, 0),
    offang = Angle(2, 12, 0),
    scale = 1.0,
    infooffset = 10
}

rp_hats_Add {
    name     = 'Маска света',
    category = 'Маски',
    type = APPAREL_MASKS,
    price    = 300000,
    model    = 'models/modified/mask6.mdl',
    skin     = 1,
    offpos = Vector(-0.5, 1, 0),
    offang = Angle(2, 12, 0),
    scale = 1.0,
    infooffset = 10
}

rp_hats_Add {
    name     = 'Маска костей',
    category = 'Маски',
    type = APPAREL_MASKS,
    price    = 300000,
    model    = 'models/modified/mask6.mdl',
    skin     = 2,
    offpos = Vector(-0.5, 1, 0),
    offang = Angle(2, 12, 0),
    scale = 1.0,
    infooffset = 10
}

rp_hats_Add {
    name     = 'Маска природы',
    category = 'Маски',
    type = APPAREL_MASKS,
    price    = 300000,
    model    = 'models/modified/mask6.mdl',
    skin     = 3,
    offpos = Vector(-0.5, 1, 0),
    offang = Angle(2, 12, 0),
    scale = 1.0,
    infooffset = 10
}


rp_hats_Add {
    name     = 'Маска Majoras',
    category = 'Маски',
    type = APPAREL_MASKS,
    price    = 5000000,
    model    = 'models/gmod_tower/majorasmask.mdl',
    skin     = 0,
    offpos = Vector(2, 1, 0),
    offang = Angle(0, 0, 0),
    scale = 1.1,
    infooffset = 10
}

rp_hats_Add {
    name     = 'Маска Джейсона',
    category = 'Маски',
    type = APPAREL_MASKS,
    price    = 4500000,
    model    = 'models/gmod_tower/halloween_jasonmask.mdl',
    skin     = 0,
    offpos = Vector(-5, 0, 0),
    offang = Angle(0, 0, 0),
    scale = 1.1,
    infooffset = 10
}

rp_hats_Add {
    name     = 'Я бэтмэн',
    category = 'Маски',
    type = APPAREL_MASKS,
    price    = 6000000,
    model    = 'models/gmod_tower/batmanmask.mdl',
    skin     = 0,
    offpos = Vector(2, 2, 0),
    offang = Angle(0, 0, 0),
    scale = 1.1,
    infooffset = 10
}

rp_hats_Add {
    name     = 'Ведьма',
    category = 'Головной убор',
    type = APPAREL_HATS,
    price  =  700000,
    model    = 'models/gmod_tower/witchhat.mdl',
    skin     = 0,
    offpos = Vector(5, 0.7, 0),
    offang = Angle(0, 15, 0),
    scale = 1.1,
    infooffset = 10
}

rp_hats_Add {
    name     = 'Персиковый король',
    category = 'Головной убор',
    type = APPAREL_HATS,
    price    = 45000000,
    vip = true,
    model    = 'models/lordvipes/peachcrown/peachcrown.mdl',
    skin     = 0,
    offpos = Vector(4, 1, 0),
    offang = Angle(0, 0, 0),
    scale = 1.1,
    infooffset = 10
}

rp_hats_Add {
    name     = 'Кубик-рубик',
    category = 'Головной убор',
    type = APPAREL_HATS,
    price    = 25000000,
    vip = true,
    model    = 'models/gmod_tower/rubikscube.mdl',
    skin     = 0,
    offpos = Vector(4, 1, 0),
    offang = Angle(0, 0, 0),
    scale = 0.7,
    infooffset = 10
}

rp_hats_Add {
    name     = 'Lego Head',
    category = 'Головной убор',
    type = APPAREL_HATS,
    price    = 50000000,
    vip = true,
    model    = 'models/gmod_tower/legohead.mdl',
    skin     = 0,
    offpos = Vector(4, 1, 0),
    offang = Angle(0, 0, 0),
    scale = 1.1,
    infooffset = 10
}

rp_hats_Add {
    name     = 'Корона рубин',
    category = 'Головной убор',
    type = APPAREL_HATS,
    price    = 15000000,
    vip = true,
    model    = 'models/gmod_tower/king_boos_crown.mdl',
    skin     = 0,
    offpos = Vector(6, 1, 0),
    offang = Angle(0, 0, 0),
    scale = 1.4,
    infooffset = 10
}


rp_hats_Add {
    name     = 'DeadMau5',
    category = 'Головной убор',
    type = APPAREL_HATS,
    price    = 15000000,
    vip = true,
    model    = 'models/captainbigbutt/skeyler/hats/deadmau5.mdl',
    skin     = 0,
    offpos = Vector(5, 0.65, 0),
    offang = Angle(0, 2, 0),
    scale = 1,
    infooffset = 10
}

rp_hats_Add {
    name     = 'toeto',
    category = 'Головной убор',
    type = APPAREL_HATS,
    price    = 15000000,
    vip = true,
    model    = 'models/gmod_tower/toetohat.mdl',
    skin     = 0,
    offpos = Vector(3, 1, 0),
    offang = Angle(0, 0, 0),
    scale = 1.2,
    infooffset = 10
}


rp_hats_Add {
    name     = 'Котик',
    category = 'Головной убор',
    type = APPAREL_HATS,
    price    = 500000,
    model    = 'models/captainbigbutt/skeyler/hats/cat_hat.mdl',
    skin     = 0,
    offpos = Vector(6, 0, 0),
    offang = Angle(0, 10, 0),
    scale = 0.8,
    infooffset = 10
}

rp_hats_Add {
    name     = 'Спортивная сумка',
    category = 'Спина',
    type = APPAREL_SCARVES,
    bone     = "ValveBiped.Bip01_Pelvis",
    price    = 600000,
    model    = 'models/player/backpack_sportbag/sportbag.mdl',
    skin     = 0,
    offpos = Vector(0, 15, 0),
    offang = Angle(180, -90, 90),
    scale = 1.5,
    infooffset = 10
}

rp_hats_Add {
    name     = 'Сумка доставщика',
    category = 'Спина',
    type = APPAREL_SCARVES,
    bone     = "ValveBiped.Bip01_Pelvis",
    price    = 300000,
    model    = 'models/konnie/asapgaming/fortnite/backpacks/pizzapit.mdl',
    skin     = 0,
    offpos = Vector(0, 0, -10),
    offang = Angle(180, -90, 90),
    scale = 1.5,
    infooffset = 10
}

rp_hats_Add {
    name     = 'Тактический рюкзак',
    category = 'Спина',
    type = APPAREL_SCARVES,
    bone     = "ValveBiped.Bip01_Pelvis",
    price    = 500000,
    model    = 'models/player/backpack_blackjack/blackjack.mdl',
    skin     = 0,
    offpos = Vector(0, 0, 0),
    offang = Angle(180, -90, 90),
    scale = 1,
    infooffset = 10
}

rp_hats_Add {
    name     = 'Обычный рюкзак №1',
    category = 'Спина',
    type = APPAREL_SCARVES,
    bone     = "ValveBiped.Bip01_Pelvis",
    price    = 300000,
    model    = 'models/player/backpack_vkbo/vkbo.mdl',
    skin     = 0,
    offpos = Vector(0, 2, 0),
    offang = Angle(180, -90, 90),
    scale = 1,
    infooffset = 10
}

rp_hats_Add {
    name     = 'Обычный рюкзак №2',
    category = 'Спина',
    type = APPAREL_SCARVES,
    bone     = "ValveBiped.Bip01_Pelvis",
    price    = 300000,
    model    = 'models/player/backpack_trizip/trizip.mdl',
    skin     = 0,
    offpos = Vector(0, -2, 0),
    offang = Angle(180, -90, 90),
    scale = 1,
    infooffset = 10
}

rp_hats_Add {
    name     = 'Походный рюкзак',
    category = 'Спина',
    type = APPAREL_SCARVES,
    bone     = "ValveBiped.Bip01_Pelvis",
    price    = 400000,
    model    = 'models/player/backpack_baselardwild/scavbp.mdl',
    skin     = 0,
    offpos = Vector(0, 3, 0),
    offang = Angle(180, -90, 90),
    scale = 1,
    infooffset = 10
}

rp_hats_Add {
    name     = 'Зимний рюкзак',
    category = 'Спина',
    type = APPAREL_SCARVES,
    bone     = "ValveBiped.Bip01_Pelvis",
    price    = 400000,
    model    = 'models/konnie/asapgaming/fortnite/backpacks/winterholiday.mdl',
    skin     = 0,
    offpos = Vector(0, 0, -7),
    offang = Angle(180, -90, 90),
    scale = 1,
    infooffset = 10
}

rp_hats_Add {
    name     = 'Летний круг',
    category = 'Спина',
    type = APPAREL_SCARVES,
    bone     = "ValveBiped.Bip01_Pelvis",
    price    = 500000,
    model    = 'models/konnie/asapgaming/fortnite/backpacks/summerunicorn.mdl',
    skin     = 0,
    offpos = Vector(0, 0, -8),
    offang = Angle(180, -90, 90),
    scale = 1,
    infooffset = 10
}

rp_hats_Add {
    name     = 'Снеговик',
    category = 'Спина',
    type = APPAREL_SCARVES,
    bone     = "ValveBiped.Bip01_Pelvis",
    price    = 300000,
    model    = 'models/konnie/asapgaming/fortnite/backpacks/snowman.mdl',
    skin     = 0,
    offpos = Vector(0, 0, -8),
    offang = Angle(180, -90, 90),
    scale = 1,
    infooffset = 10
}

rp_hats_Add {
    name     = 'Специальный рюкзак',
    category = 'Спина',
    type = APPAREL_SCARVES,
    bone     = "ValveBiped.Bip01_Pelvis",
    price    = 700000,
    model    = 'models/konnie/asapgaming/fortnite/backpacks/jailbirds.mdl',
    skin     = 0,
    offpos = Vector(0, 0, -8),
    offang = Angle(180, -90, 90),
    scale = 1,
    infooffset = 10
}

rp_hats_Add {
    name     = 'Кейс',
    category = 'Спина',
    type = APPAREL_SCARVES,
    bone     = "ValveBiped.Bip01_Pelvis",
    price    = 500000,
    model    = 'models/konnie/asapgaming/fortnite/backpacks/heistbriefcase.mdl',
    skin     = 0,
    offpos = Vector(0, 0, -8),
    offang = Angle(180, -90, 90),
    scale = 1,
    infooffset = 10
}

rp_hats_Add {
    name     = 'Сумка с деньгами',
    category = 'Спина',
    type = APPAREL_SCARVES,
    bone     = "ValveBiped.Bip01_Pelvis",
    price    = 250000,
    model    = 'models/konnie/asapgaming/fortnite/backpacks/heist.mdl',
    skin     = 0,
    offpos = Vector(0, 0, -8),
    offang = Angle(180, -90, 90),
    scale = 1,
    infooffset = 10
}

rp_hats_Add {
    name     = 'Клетка хомяка',
    category = 'Спина',
    type = APPAREL_SCARVES,
    bone     = "ValveBiped.Bip01_Pelvis",
    price    = 300000,
    model    = 'models/konnie/asapgaming/fortnite/backpacks/hamster.mdl',
    skin     = 0,
    offpos = Vector(0, 0, -9),
    offang = Angle(180, -90, 90),
    scale = 1,
    infooffset = 10
}

rp_hats_Add {
    name     = 'Печенье',
    category = 'Спина',
    type = APPAREL_SCARVES,
    bone     = "ValveBiped.Bip01_Pelvis",
    price    = 900000,
    model    = 'models/konnie/asapgaming/fortnite/backpacks/gingerman.mdl',
    skin     = 0,
    offpos = Vector(0, 0, -8),
    offang = Angle(180, -90, 90),
    scale = 1,
    infooffset = 10
}

rp_hats_Add {
    name     = 'Boombox',
    category = 'Спина',
    type = APPAREL_SCARVES,
    bone     = "ValveBiped.Bip01_Pelvis",
    price    = 890000,
    model    = 'models/konnie/asapgaming/fortnite/backpacks/exercisemale.mdl',
    skin     = 0,
    offpos = Vector(0, 0, -8),
    offang = Angle(180, -90, 90),
    scale = 1,
    infooffset = 10
}

rp_hats_Add {
    name     = 'Барабан',
    category = 'Спина',
    type = APPAREL_SCARVES,
    bone     = "ValveBiped.Bip01_Pelvis",
    price    = 570000,
    model    = 'models/konnie/asapgaming/fortnite/backpacks/garagebandmale.mdl',
    skin     = 0,
    offpos = Vector(0, 0, -8),
    offang = Angle(180, -90, 90),
    scale = 1,
    infooffset = 10
}

rp_hats_Add {
    name     = 'Рюкзак Dino',
    category = 'Спина',
    type = APPAREL_SCARVES,
    bone     = "ValveBiped.Bip01_Pelvis",
    price    = 630000,
    model    = 'models/konnie/asapgaming/fortnite/backpacks/dino.mdl',
    skin     = 0,
    offpos = Vector(0, 0, -8),
    offang = Angle(180, -90, 90),
    scale = 1,
    infooffset = 10
}

rp_hats_Add {
    name     = 'Рюкзак Animal',
    category = 'Спина',
    type = APPAREL_SCARVES,
    bone     = "ValveBiped.Bip01_Pelvis",
    price    = 350000,
    model    = 'models/konnie/asapgaming/fortnite/backpacks/animalmale.mdl',
    skin     = 0,
    offpos = Vector(0, 0, -8),
    offang = Angle(180, -90, 90),
    scale = 1,
    infooffset = 10
}

rp_hats_Add {
    name     = 'Утка',
    category = 'Спина',
    type = APPAREL_SCARVES,
    bone     = "ValveBiped.Bip01_Pelvis",
    price    = 1000000,
    model    = 'models/captainbigbutt/skeyler/accessories/duck_tube.mdl',
    skin     = 0,
    offpos = Vector(0, 0, 0),
    offang = Angle(180, -90, 90),
    scale = 1.5,
    infooffset = 10
}


do return end
local male_citizens = {TEAM_CITIZEN}


rp.AddClothing('Blue Hoodie', {
    File    = 'm_hoodieblue',
    Price   = 250000,
    Teams   = male_citizens,
})

rp.AddClothing('Red Hoodie', {
    File    = 'm_hoodiered',
    Price   = 250000,
    Teams   = male_citizens,
})

rp.AddClothing('Misfits Hoodie', {
    File    = 'm_misfits',
    Price   = 100000,
    Teams   = male_citizens,
})

rp.AddClothing('Leather Jacket', {
    File    = 'm_leather',
    Price   = 200000,
    Teams   = male_citizens,
})

rp.AddClothing('Blue Plaid', {
    File    = 'm_pladblue',
    Price   = 500000,
    Teams   = male_citizens,
})

rp.AddClothing('Red Plaid', {
    File    = 'm_pladred',
    Price   = 500000,
    Teams   = male_citizens,
})
