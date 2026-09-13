--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

just_models = just_models or {}

--[[
    Кароче редкости:
        500-599 = Необычный
        600-699 = Редкий
        700-899 = Эпический
        900-1200 = Легендарный
        >12000 = Невероятный

    ['id'] = {
        name = 'Name',
        model = 'model',
        cost = 500,
        type = 'Type',
        color = colors['color']
    },

    id не должен повторяться, на все остальное похуй!
]]

local colors = {
    ['uncommon'] = Color(29, 155, 54),
    ['rare'] = Color(52, 155, 196),
    ['epic'] = Color(187, 44, 192),
    ['legendary'] = Color(241, 193, 63),
    ['mythic'] = Color(170, 54, 158),
    ['impossible'] =  Color(239, 37, 148),
}

just_models.selling = {
    ['barneypivozavr'] = {
        name = 'Барни пивозавр',
        model = 'models/addons/barney_pivozavr_pm.mdl',
        cost = 425,
        type = 'Эпический',
        color = colors['epic']
    },
    ['grinch'] = {
        name = 'Гринч',
        model = 'models/polycapn/grinch.mdl',
        cost = 999999,
        type = 'Ивентовый',
        color = colors['impossible']
    },
    ['snegurochka'] = {
        name = 'Снегурочка',
        model = 'models/cso2/ct_helga01xmas/ct_helga01.mdl',
        cost = 999999,
        type = 'Ивентовый',
        color = colors['impossible']
    },
    ['dedmoroz'] = {
        name = 'Дед Мороз',
        model = 'models/player/christmas/santa.mdl',
        cost = 999999,
        type = 'Ивентовый',
        color = colors['impossible']
    },
    ['bad_santa'] = {
        name = 'Плохой санта',
        model = 'models/player/santa/santa.mdl',
        cost = 500,
        type = 'Необычный',
        color = colors['uncommon']
    },
    -- ['minyon'] = {
    --     name = 'Миньон СВО',
    --     model = 'models/player/minyon.mdl',
    --     cost = 850,
    --     type = 'Легендарный',
    --     color = colors['legendary']
    -- },
    -- ['rina'] = {
    --     name = 'Рина Паленкова ',
    --     model = 'models/rinapalenkova/yariktriplesix/rinapalenkova.mdl',
    --     cost = 575,
    --     type = 'Легендарный',
    --     color = colors['legendary']
    -- },
    ['tyler'] = {
        name = 'Тайлер Дерден',
        model = 'models/player/tyler.mdl',
        cost = 590,
        type = 'Легендарный',
        color = colors['legendary']
    },
    -- ['harli'] = {
    --     name = 'Харли',
    --     model = 'models/kryptonite/inj2_harley_quinn/inj2_harley_quinn.mdl',
    --     cost = 520,
    --     type = 'Эпический',
    --     color = colors['epic']
    -- },
    ['leon'] = {
        name = 'Леон',
        model = 'models/1000shells/professional/professional.mdl',
        cost = 520,
        type = 'Необычный',
        color = colors['uncommon']
    },
    ['vdvshnik'] = {
        name = 'ВДВшник',
        model = 'models/ded_vdv/ded_vdv.mdl',
        cost = 570,
        type = 'Необычный',
        color = colors['uncommon']
    },
    -- ['griffit'] = {
    --     name = 'Гриффит',
    --     model = 'models/sazuma/griffith.mdl',
    --     cost = 750,
    --     type = 'Эпический',
    --     color = colors['epic']
    -- },
    -- ['gats'] = {
    --     name = 'Гатс',
    --     model = 'models/tnrp/player/berserk/guts.mdl',
    --     cost = 750,
    --     type = 'Эпический',
    --     color = colors['epic']
    -- },
    ['ricardo_milos'] = {
        name = 'Рикардо Милос',
        model = 'models/player/ricardo.mdl',
        cost = 350,
        type = 'Необычный',
        color = colors['uncommon']
    },
    -- ['imperor'] = {
    --     name = 'Император',
    --     model = 'models/emperor_of_mankind_pm.mdl',
    --     cost = 2000,
    --     type = 'Невероятный',
    --     color = colors['impossible']
    -- },
    -- ['freeman_gopnik'] = {
    --     name = 'Гопник Freeman',
    --     model = 'models/thebigcube/pm_gopnik_freeman/gopnik_freeman.mdl',
    --     cost = 600,
    --     type = 'Легендарный',
    --     color = Color(255, 48, 48)
    -- },
    -- ['techies'] = {
    --     name = 'Techies',
    --     model = 'models/player/techies_squee.mdl',
    --     cost = 620,
    --     type = 'Редкий',
    --     color = colors['rare']
    -- },
    -- ['pudge'] = {
    --     name = 'Пудж',
    --     model = 'models/player/pudge.mdl',
    --     cost = 1000,
    --     type = 'Легендарный',
    --     color = colors['legendary']
    -- },
    -- ['death'] = {
    --     name = 'Смерть',
    --     model = 'models/death_a_grim_bundle/player_models/death_painted/death_painted_01.mdl',
    --     cost = 666,
    --     type = 'Редкий',
    --     color = colors['rare']
    -- },
    ['kim_jong_un'] = {
        name = 'Ким',
        model = 'models/player/hhp227/kim_jong_un.mdl',
        cost = 370,
        type = 'Необычный',
        color = colors['uncommon']
    },
    ['stone_man'] = {
        name = 'Человек Камень',
        model = 'models/dawson/stoned_men/stone_man/stone_man.mdl',
        cost = 310,
        type = 'Необычный',
        color = colors['uncommon']
    },
    -- ['passporter'] = {
    --     name = 'Паспортёр',
    --     model = 'models/panman/passporter_pm.mdl',
    --     cost = 522,
    --     type = 'Необычный',
    --     color = colors['uncommon']
    -- },
    -- ['satan'] = {
    --     name = 'Сатан',
    --     model = 'models/sirris/playermodels/sirris_base.mdl',
    --     cost = 555,
    --     type = 'Необычный',
    --     color = colors['uncommon']
    -- },
    ['combine'] = {
        name = 'Комбайн',
        model = 'models/adidas_combine/playermodel/adidas_combine.mdl',
        cost = 298,
        type = 'Необычный',
        color = colors['uncommon']
    },
    ['bbt'] = {
        name = 'BBT',
        model = 'models/player/big_baby_tape.mdl',
        cost = 350,
        type = 'Редкий',
        color = colors['rare']
    },
    ['ingoagent'] = {
        name = 'Иностранный агент',
        model = 'models/player/sunsh1ne/morgenstern.mdl',
        cost = 666,
        type = 'Легенадрный',
        color = colors['legendary']
    },
    -- ['rzhunimagu'] = {
    --     name = 'Ржунимагу',
    --     model = 'models/player/ganimator/emotiguy_requiem.mdl',
    --     cost = 777,
    --     type = 'Легендарный',
    --     color = Color(255, 48, 48)
    -- },
    ['punkevi'] = {
        name = 'Панк Эви',
        model = 'models/sienna/sienna_playermodel/sienna_pm.mdl',
        cost = 400,
        type = 'Редкий',
        color = colors['rare']
    },
    -- ['thanos'] = {
    --     name = 'Танос',
    --     model = 'models/kryptonite/thanos_endgame/thanos_endgame.mdl',
    --     cost = 520,
    --     type = 'Необычный',
    --     color = colors['uncommon']
    -- },
    ['altushka'] = {
        name = 'Альтушка',
        model = 'models/gruchk/oc/female_02.mdl',
        cost = 370,
        type = 'Необычный',
        color = colors['uncommon']
    },
    -- ['prisyazhnik'] = {
    --     name = 'Присяжник',
    --     model = 'models/sirris_custom12/custom12.mdl',
    --     cost = 650,
    --     type = 'Редкий',
    --     color = colors['rare']
    -- },
    -- ['lust'] = {
    --     name = 'Lust',
    --     model = 'models/sirris/lust_sirris.mdl',
    --     cost = 400,
    --     type = 'Редкий',
    --     color = colors['rare']
    -- },
}

do
    local cmd = ba.cmd.Create('models_panel')
    cmd:RunOnClient(function(args)
        RunConsoleCommand('just_models_openmenu')
    end)
    cmd:SetHelp('Открыть Models меню')
end

--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
