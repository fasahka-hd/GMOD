--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

--
-- Spawns
--

local citizen_spawns = {
     rp_arizonarp_v1 = {
        Vector(-4455.291016, 1187.142822, 72.031250), 
        Vector(-4007.301758, 1191.624756, 72.031250), 
        Vector(-3773.133057, 1578.254395, 72.031250), 
        Vector(-3773.164551, 1865.737671, 72.031250), 
        Vector(-4225.238770, 1867.810913, 72.031250),
        Vector(-4550.037109, 1869.050903, 72.031250)
    },
}

local police_spawns = {
     rp_arizonarp_v1 = {
        Vector(2502.831787, 2608.621094, 76.031250),
        Vector(2358.789551, 2609.353271, 76.031250),
        Vector(2440.733398, 3062.401367, 76.031250),
        Vector(2438.827393, 2830.758789, 76.031250)
    },
}

local banned_spawns = {
     rp_arizonarp_v1 = {
        Vector(-327.957581, -3503.589600, 747.311279),
        Vector(-326.686096, -4023.422119, 747.311279)
    },
}

--
-- Legacy dummy fallback constants
--
TEAM_JURNALIST = -1
TEAM_CINEMA = -1
TEAM_WORKER = -1
TEAM_DVORNIK = -1
TEAM_ZAVOD = -1
TEAM_DELIVERY = -1
TEAM_SUD = -1
TEAM_DEP = -1
TEAM_SFBI = -1
TEAM_NFBI = -1
TEAM_SERGPOLICE = -1
TEAM_LEYPOLICE = -1
TEAM_KAPPOLICE = -1
TEAM_FSB = -1
TEAM_HELGA = -1
TEAM_SWATOPER = -1
TEAM_SWATLEAD = -1
TEAM_GANG1 = -1
TEAM_CLADMEN = -1
TEAM_BISNES = -1
TEAM_glDOCTOR = -1
TEAM_EFRETIOR = -1
TEAM_VOENKOM = -1
TEAM_SERZHANT = -1
TEAM_STARSHINA = -1
TEAM_PRAPOR = -1
TEAM_KAPI = -1
TEAM_PRIGOZHINZHENYA = -1
TEAM_VPOLICE = -1
TEAM_NACH = -1

--
-- Гражданские
--

TEAM_CITIZEN = rp.addTeam('Гражданский', {
    color = Color(20, 150, 20),
    model = {'models/player/clanof05/male_06.mdl', 'models/player/clanof05/male_05.mdl', 'models/player/clanof05/male_04.mdl', 'models/player/clanof05/male_08.mdl', 'models/player/clanof05/male_09.mdl'},
    weapons = {},
    command = 'citizen',
    max = 0,
    salary = 550,
    spawns = citizen_spawns,
    admin = 0,
    user = true,
    hasLicense = false,
    category = "Гражданские",
    description = 'Это человек, обладающий правами и обязанностями в рамках определенного государства. Эта профессия включает в себя активное участие в жизни общества, соблюдение законов и норм, а также вовлеченность в политические, экономические и социальные процессы.',
    candemote = false,
})

TEAM_CAZINO = rp.addTeam('Владелец Казино', {
    color = Color(147, 112, 219),
    model = {'models/player/tuxmale_01player.mdl', 'models/player/tuxmale_02player.mdl', 'models/player/tuxmale_03player.mdl', 'models/player/tuxmale_04player.mdl', 'models/player/tuxmale_05player.mdl', 'models/player/tuxmale_06player.mdl', 'models/player/tuxmale_07player.mdl', 'models/player/tuxmale_08player.mdl', 'models/player/tuxmale_09player.mdl'},
    weapons = {},
    command = 'cazino',
    category = "Гражданские",
    max = 3,
    salary = 1150,
    admin = 0,
    description = 'Ты владеешь казино, ты можешь открыть самую крупную сеть казино в городе, где ты будешь выигрывать, ведь казино никогда не проигрывает.',
    hasLicense = false,
    candemote = false,
    vip = true
})

TEAM_HOBOKING = rp.addTeam('Предводитель бездомных', {
    color = Color(80, 45, 10),
    model = 'models/jessev92/player/l4d/m9-hunter.mdl',
    weapons = {},
    command = 'hoboking',
    max = 1,
    salary = 200,
    hobo = true,
    spawns = citizen_spawns,
    admin = 0,
    hasLicense = false,
    category = "Гражданские",
    candemote = false,
})

TEAM_HOBO = rp.addTeam('Бездомный', {
    color = Color(80, 45, 10),
    model = 'models/jessev92/player/l4d/m9-hunter.mdl',
    weapons = {},
    command = 'hobo',
    max = 0,
    salary = 100,
    spawns = citizen_spawns,
    admin = 0,
    hobo = true,
    hasLicense = false,
    category = "Гражданские",
    candemote = false,
})

TEAM_BITMINER = rp.addTeam('Битмайнер', {
    color = Color(255, 215, 0),
    model = 'models/player/group01/reflect.mdl',
    weapons = {},
    command = 'bitminer',
    max = 4,
    salary = 500,
    spawns = citizen_spawns,
    admin = 0,
    hasLicense = false,
    category = "Гражданские",
    candemote = false,
})

TEAM_DOCTOR = rp.addTeam('Доктор', {
    color = Color(0, 128, 128),
    model = 'models/player/sanitar_male_02.mdl',
    weapons = {'med_kit', 'durka_baton'},
    command = 'medic',
    max = 5,
    salary = 1250,
    admin = 0,
    spawns = citizen_spawns,
    category = "Гражданские",
    description = 'Ты Доктор, лечи людей и при необходимости приводи буйных пациентов в порядок.',
    user = true,
    candemote = true,
    hasLicense = false,
    medic = true
})

TEAM_PROSTITUTE = rp.addTeam('Проститутка', {
    color = Color(255, 105, 180),
    model = 'models/player/group01/dahlia0o0.mdl',
    weapons = {},
    command = 'prostitute',
    max = 4,
    salary = 500,
    spawns = citizen_spawns,
    admin = 0,
    hasLicense = false,
    category = "Гражданские",
    candemote = false,
})

TEAM_GUN = rp.addTeam('Продавец Оружия', {
    color = Color(255, 165, 0),
    model = 'models/player/mechanic.mdl',
    weapons = {},
    command = 'gundealer',
    max = 3,
    salary = 1050,
    admin = 0,
    spawns = citizen_spawns,
    user = true,
    category = "Гражданские",
    description = 'Ты ответственен за безопасность города. Владей лучшим ассортиментом огнестрельного и холодного оружия.',
    canLite = true,
    candemote = true,
    hasLicense = false
})

TEAM_BANKER = rp.addTeam('Банкир', {
    color = Color(34, 139, 34),
    model = 'models/player/valley/pennyworth.mdl',
    weapons = {},
    command = 'banker',
    max = 2,
    salary = 1200,
    spawns = citizen_spawns,
    admin = 0,
    hasLicense = false,
    category = "Гражданские",
    candemote = false,
})

TEAM_GUARD = rp.addTeam('Охраник', {
    color = Color(70, 80, 95),
    model = {'models/kerry/player/merriweather/male_01.mdl', 'models/kerry/player/merriweather/male_02.mdl', 'models/kerry/player/merriweather/male_03.mdl', 'models/kerry/player/merriweather/male_04.mdl', 'models/kerry/player/merriweather/male_05.mdl', 'models/kerry/player/merriweather/male_06.mdl', 'models/kerry/player/merriweather/male_07.mdl', 'models/kerry/player/merriweather/male_08.mdl', 'models/kerry/player/merriweather/male_09.mdl'},
    weapons = {},
    command = 'guard',
    max = 5,
    salary = 800,
    spawns = citizen_spawns,
    admin = 0,
    hasLicense = false,
    category = "Гражданские",
    candemote = false,
})

TEAM_BARTENDER = rp.addTeam('Бармен', {
    color = Color(153, 102, 51, 255),
    model = {'models/player/clanof05/male_06.mdl', 'models/player/clanof05/male_05.mdl', 'models/player/clanof05/male_04.mdl', 'models/player/clanof05/male_08.mdl', 'models/player/clanof05/male_09.mdl'},
    weapons = {},
    command = 'bartender',
    max = 5,
    spawns = citizen_spawns,
    salary = 550,
    canLite = true,
    description = 'Открой свое уютное заведение и место встречи для многих граждан.',
    category = "Гражданские",
    admin = 0,
    user = true,
    candemote = true
})

TEAM_COOK = rp.addTeam('Повар', {
    color = Color(255, 192, 203),
    model = 'models/ecott/chefcitizen.mdl',
    weapons = {},
    command = 'cook',
    max = 3,
    category = "Гражданские",
    salary = 745,
    admin = 0,
    spawns = citizen_spawns,
    description = 'Открой для себя мир вкуса, стань Шефом своей личной кухни.',
    candemote = true,
    cook = true
})

TEAM_MINER = rp.addTeam('Шахтёр', {
    color = Color(112, 128, 144),
    model = 'models/cultist/miner_f.mdl',
    weapons = {},
    command = 'miner',
    max = 5,
    salary = 700,
    spawns = citizen_spawns,
    admin = 0,
    hasLicense = false,
    category = "Гражданские",
    candemote = false,
})

TEAM_FISHER = rp.addTeam('Рыболов', {
    color = Color(65, 105, 225),
    model = 'models/player/vitalya.mdl',
    weapons = {},
    command = 'fisher',
    max = 5,
    salary = 600,
    spawns = citizen_spawns,
    admin = 0,
    hasLicense = false,
    category = "Гражданские",
    candemote = false,
})

--
-- Гос структуры
--

TEAM_POLICE = rp.addTeam('Полиция', {
    color = Color(60, 80, 255),
    model = {"models/player/santosrp/Male_02_santosrp.mdl", "models/player/santosrp/Male_04_santosrp.mdl", "models/player/santosrp/Male_05_santosrp.mdl", "models/player/santosrp/Male_06_santosrp.mdl", "models/player/santosrp/Male_07_santosrp.mdl", "models/player/santosrp/Male_08_santosrp.mdl", "models/player/santosrp/Male_09_santosrp.mdl"},
    CanRaid = 'Рейдить',
    weapons = {'weapon_taser', 'weapon_finebook', 'arrest_baton', 'rwp_tfa_pist_mp443', 'stun_baton', 'door_ram', 'handcuffs', 'weaponchecker'},
    spawns = police_spawns,
    command = 'police',
    max = 10,
    salary = 1100,
    admin = 0,
    user = true,
    candemote = true,
    canHavy = true,
    canLite = true,
    category = "Гос структуры",
    canVzri = true,
    description = 'Служитель правоохранительных органов, выполняющий обязанности по обеспечению общественного порядка, безопасности граждан и борьбе с преступностью.',
    CannotOwnDoors = true,
    hasLicense = true,
    selldoors = true,
})

TEAM_CHIEF = rp.addTeam('Начальник полиции', {
    color = Color(60, 80, 255),
    model = {"models/player/santosrp/Male_02_santosrp.mdl", "models/player/santosrp/Male_04_santosrp.mdl", "models/player/santosrp/Male_05_santosrp.mdl", "models/player/santosrp/Male_06_santosrp.mdl", "models/player/santosrp/Male_07_santosrp.mdl", "models/player/santosrp/Male_08_santosrp.mdl", "models/player/santosrp/Male_09_santosrp.mdl"},
    CanRaid = 'Рейдить',
    weapons = {'weapon_taser', 'weapon_finebook', 'arrest_baton', 'unarrest_baton', 'rwp_tfa_pist_mp416rex', 'rwp_tfa_assault_ak74', 'rwp_tfa_shotgun_becas12m', 'stun_baton', 'door_ram', 'handcuffs', 'weaponchecker'},
    spawns = police_spawns,
    command = 'chief',
    max = 1,
    salary = 1600,
    admin = 0,
    user = true,
    category = "Гос структуры",
    candemote = true,
    canHavy = true,
    canVzri = true,
    description = 'Начальствующий офицер, отвечающий за организацию и контроль работы подразделений полиции.',
    canLite = true,
    CannotOwnDoors = true,
    hasLicense = true,
    selldoors = true,
})

TEAM_JAGGEROMON = rp.addTeam('Джагернаут', {
    color = Color(0, 0, 139),
    model = "models/mark2580/payday2/pd2_bulldozer_player.mdl",
    CanRaid = 'Рейдить',
    weapons = {'weapon_taser', 'rwp_tfa_pist_ot33', 'rwp_tfa_heavy_pkp', 'rwp_tfa_heavy_rpk74', 'arrest_baton', 'stun_baton', 'door_ram', 'handcuffs', 'weaponchecker'},
    spawns = police_spawns,
    command = 'jagger',
    max = 1,
    salary = 1850,
    admin = 0,
    user = true,
    candemote = true,
    category = "Гос структуры",
    canHavy = true,
    canVzri = true,
    description = 'Джаггернаут — бронированный боец спецподразделения для подавления особо опасных угроз.',
    canLite = true,
    hasLicense = true,
    CannotOwnDoors = true,
    police = true,
    selldoors = true,
})
TEAM_JAGGER = TEAM_JAGGEROMON

TEAM_FBI = rp.addTeam('FBI', {
    color = Color(83,83,242),
    model = {'models/fbi_pack/fbi_01.mdl', 'models/fbi_pack/fbi_02.mdl', 'models/fbi_pack/fbi_03.mdl', 'models/fbi_pack/fbi_04.mdl', 'models/fbi_pack/fbi_05.mdl', 'models/fbi_pack/fbi_06.mdl', 'models/fbi_pack/fbi_07.mdl', 'models/fbi_pack/fbi_08.mdl', 'models/fbi_pack/fbi_09.mdl'},
    CanRaid = 'Рейдить',
    weapons = {'weapon_taser', 'arrest_baton', 'unarrest_baton', 'rwp_tfa_pist_gsh18', 'rwp_tfa_assault_vikhr', 'stun_baton', 'door_ram', 'handcuffs', 'weapon_radio', 'weaponchecker'},
    spawns = police_spawns,
    command = 'fbi',
    max = 6,
    salary = 1500,
    admin = 0,
    candemote = true,
    canHavy = true,
    canLite = true,
    canVzri = true,
    category = "Гос структуры",
    hasLicense = true,
    description = 'Спецагент Федерального Бюро Расследований по борьбе с федеральными преступлениями.',
    CannotOwnDoors = true,
    candisguise = true,
    selldoors = true,
})

TEAM_MAYORGUARD = rp.addTeam('Телахранитель Мэра', {
    color = Color(30, 30, 150),
    model = 'models/player/vitalya.mdl',
    weapons = {},
    command = 'mayorguard',
    max = 2,
    salary = 1400,
    spawns = police_spawns,
    admin = 0,
    hasLicense = true,
    category = "Гос структуры",
    candemote = false,
})

TEAM_MAYOR = rp.addTeam('Мэр', {
    color = Color(240, 0, 0, 255),
    model = 'models/youtubers/supersus/super_sus.mdl',
    weapons = {},
    spawns = {
        rp_arizonarp_v1 = {Vector(-208.546524, 5839.016113, 451.031250) }
    },
    command = 'mayor',
    max = 1,
    salary = 2500,
    vote = true,
    category = "Гос структуры",
    candemote = false,
    CannotOwnDoors = true,
    selldoors = true,
    description = 'Глава города. Управляй, пиши законы, следи за порядком.',
    hasLicense = true,
    user = true,
    mayor = true,
    admin = 0
})

--
-- Криминал
--

TEAM_PIMP = rp.addTeam('Сутенер', {
    color = Color(180, 50, 180),
    model = 'models/Lenoax/CaveJohnson_PM.mdl',
    weapons = {},
    command = 'pimp',
    max = 2,
    salary = 700,
    spawns = citizen_spawns,
    admin = 0,
    hasLicense = false,
    category = "Криминал",
    candemote = false,
})

TEAM_GANGSTER = rp.addTeam('Бандит', {
    color = Color(105, 105, 105),
    model = 'models/half-dead/gopniks/extra/playermodelonly.mdl',
    CanRaid = 'Рейдить',
    CanMug = 'Грабить',
    CanHostage = 'Брать в заложники',
    weapons = {'moneychecker'},
    command = 'bandit',
    max = 15,
    salary = 550,
    spawns = citizen_spawns,
    admin = 0,
    category = "Криминал",
    description = 'Обычный криминальный элемент этого города. Участвуй в грабежах и делах банды.',
    user = true,
    canVzri = true,
    canHavy = true,
    canLite = true,
    candemote = true
})

TEAM_EXPGANGSTER = rp.addTeam('Опытный Бандит', {
    color = Color(85, 85, 85),
    model = 'models/player/Suits/male_01_closed_coat_tie.mdl', 'models/player/Suits/male_01_closed_tie.mdl', 'models/player/Suits/male_01_open.mdl', 'models/player/Suits/male_01_open_tie.mdl', 'models/player/Suits/male_01_open_waistcoat.mdl', 'models/player/Suits/male_01_shirt.mdl', 'models/player/Suits/male_01_shirt_tie.mdl', 'models/player/Suits/male_02_closed_coat_tie.mdl', 'models/player/Suits/male_02_closed_tie.mdl', 'models/player/Suits/male_02_open.mdl', 'models/player/Suits/male_02_open_tie.mdl', 'models/player/Suits/male_02_open_waistcoat.mdl', 'models/player/Suits/male_02_shirt.mdl', 'models/player/Suits/male_02_shirt_tie.mdl', 'models/player/Suits/male_03_closed_coat_tie.mdl', 'models/player/Suits/male_03_closed_tie.mdl', 'models/player/Suits/male_03_open.mdl', 'models/player/Suits/male_03_open_tie.mdl', 'models/player/Suits/male_03_open_waistcoat.mdl', 'models/player/Suits/male_03_shirt.mdl', 'models/player/Suits/male_03_shirt_tie.mdl', 'models/player/Suits/male_04_closed_coat_tie.mdl', 'models/player/Suits/male_04_closed_tie.mdl', 'models/player/Suits/male_04_open.mdl', 'models/player/Suits/male_04_open_tie.mdl', 'models/player/Suits/male_04_open_waistcoat.mdl', 'models/player/Suits/male_04_shirt.mdl', 'models/player/Suits/male_04_shirt_tie.mdl', 'models/player/Suits/male_05_closed_coat_tie.mdl', 'models/player/Suits/male_05_closed_tie.mdl', 'models/player/Suits/male_05_open.mdl', 'models/player/Suits/male_05_open_tie.mdl', 'models/player/Suits/male_05_open_waistcoat.mdl', 'models/player/Suits/male_05_shirt_tie.mdl', 'models/player/Suits/male_06_closed_coat_tie.mdl', 'models/player/Suits/male_06_closed_tie.mdl', 'models/player/Suits/male_06_open.mdl', 'models/player/Suits/male_06_open_tie.mdl', 'models/player/Suits/male_06_open_waistcoat.mdl', 'models/player/Suits/male_06_shirt.mdl', 'models/player/Suits/male_06_shirt_tie.mdl', 'models/player/Suits/male_07_closed_coat_tie.mdl', 'models/player/Suits/male_07_closed_tie.mdl', 'models/player/Suits/male_07_open.mdl', 'models/player/Suits/male_07_open_tie.mdl', 'models/player/Suits/male_07_open_waistcoat.mdl', 'models/player/Suits/male_07_shirt.mdl', 'models/player/Suits/male_07_shirt_tie.mdl', 'models/player/Suits/male_08_closed_coat_tie.mdl', 'models/player/Suits/male_08_closed_tie.mdl', 'models/player/Suits/male_08_open.mdl', 'models/player/Suits/male_08_open_tie.mdl', 'models/player/Suits/male_08_open_waistcoat.mdl', 'models/player/Suits/male_08_shirt.mdl', 'models/player/Suits/male_08_shirt_tie.mdl', 'models/player/Suits/male_09_closed_coat_tie.mdl', 'models/player/Suits/male_09_closed_tie.mdl', 'models/player/Suits/male_09_open.mdl', 'models/player/Suits/male_09_open_tie.mdl', 'models/player/Suits/male_09_open_waistcoat.mdl', 'models/player/Suits/male_09_shirt.mdl', 'models/player/Suits/male_09_shirt_tie.mdl', 'models/player/Suits/robber_open.mdl', 'models/player/Suits/robber_shirt.mdl', 'models/player/Suits/robber_shirt_2.mdl', 'models/player/Suits/robber_tie.mdl', 'models/player/Suits/robber_tuckedtie.mdl',
    weapons = {},
    command = 'expbandit',
    max = 6,
    salary = 800,
    spawns = citizen_spawns,
    admin = 0,
    hasLicense = false,
    category = "Криминал",
    candemote = false,
})

TEAM_TERRORIST = rp.addTeam('Террорист', {
    color = Color(150, 20, 20),
    model = 'models/player/ninjuerilla.mdl',
    weapons = {},
    command = 'terrorist',
    max = 3,
    salary = 900,
    spawns = citizen_spawns,
    admin = 0,
    hasLicense = false,
    category = "Криминал",
    candemote = false,
})
TEAM_TERROR = TEAM_TERRORIST

TEAM_GANG2 = rp.addTeam('Наемный Убийца', {
    color = Color(128, 128, 128),
    model = 'models/code_gs/robber/robberplayer.mdl',
    CanRaid = 'Рейдить',
    CanMug = 'Грабить',
    CanHostage = 'Брать в заложники',
    weapons = {'moneychecker', 'rwp_tfa_pist_pb', 'rwp_tfa_assault_mosin9130'},
    command = 'hitman',
    max = 2,
    salary = 1050,
    admin = 0,
    spawns = citizen_spawns,
    category = "Криминал",
    description = 'Выполняй крупные заказы на устранение целей.',
    user = true,
    canVzri = true,
    canHavy = true,
    canLite = true,
    hitman = true,
    vip = true,
    candemote = true,
})
TEAM_HITMAN = TEAM_GANG2

TEAM_VIPHITMAN = rp.addTeam('Опытный Убийца', {
    color = Color(112, 128, 144),
    model = 'models/wick_chapter2/wick_chapter2.mdl',
    weapons = {'rwp_tfa_pist_tt33'},
    command = 'exphitman',
    max = 3,
    salary = 1250,																		
    admin = 0,
    spawns = citizen_spawns,
    candemote = false,
    category = "Криминал",
    description = 'Профессиональный киллер высшего класса.',
    canHavy = true,
    canVzri = true,
    canLite = true,
    hitman = true,
    candisguise = true,
    vip = false,
    PlayerSpawn = function(pl) pl:SetArmor(100) pl:GiveAmmos(200) end
})

TEAM_MOBBOSS = rp.addTeam('Глава Бандитов', {
    color = Color(128, 128, 128),
    model = 'models/player/tuxmale_01player.mdl', 'models/player/tuxmale_02player.mdl', 'models/player/tuxmale_03player.mdl', 'models/player/tuxmale_04player.mdl', 'models/player/tuxmale_05player.mdl', 'models/player/tuxmale_06player.mdl', 'models/player/tuxmale_07player.mdl', 'models/player/tuxmale_08player.mdl', 'models/player/tuxmale_09player.mdl',
    CanRaid = 'Рейдить',
    CanMug = 'Грабить',
    CanHostage = 'Брать в заложники',
    weapons = {'moneychecker', 'rwp_tfa_pist_mp416rex', 'rwp_tfa_smg_ppsh41'},
    command = 'mobboss',
    max = 1,
    spawns = citizen_spawns,
    salary = 1500,
    admin = 0,
    user = true,
    canHavy = true,
    category = "Криминал",
    description = 'Главный авторитет преступного мира. Создавай синдикат и руководи бандой.',
    canVzri = true,
    canLite = true,
    candemote = false,
    PlayerSpawn = function(pl) pl:SetArmor(250) pl:SetHealth(200) end
})
--[[
TEAM_MANIAC = rp.addTeam('Маньяк', {
    color = Color(130, 10, 10),
    model = '',
    weapons = {},
    command = 'maniac',
    max = 1,
    salary = 600,
    spawns = citizen_spawns,
    admin = 0,
    hasLicense = false,
    category = "Криминал",
    candemote = false,
})
-- ]]
TEAM_METHVARSHIK = rp.addTeam('Метоварщик', {
    color = Color(32, 178, 170),
    model = 'models/player/scientist.mdl',
    weapons = {},
    command = 'varshik',
    max = 3,
    salary = 750,
    admin = 0,
    spawns = citizen_spawns,
    category = "Криминал",
    description = 'Химик нелегальных препаратов.',
    user = true,
    canVzri = true,
    canHavy = true,
    canLite = true,
    candemote = true,
    vip = false,
})

TEAM_GUN1 = rp.addTeam('Нелегальный торговец', {
    color = Color(160, 82, 45),
    model = 'models/player/sanya.mdl',
    weapons = {},
    command = 'blackmarket',
    max = 2,
    salary = 850,
    admin = 0,
    spawns = citizen_spawns,
    canLite = true,
    category = "Криминал",
    description = 'Продавец взрывчатки, отмычек и запрещенного снаряжения.',
    candemote = true,
    hasLicense = false
})

TEAM_CLADMEN = rp.addTeam("Кладмен", {
    color = Color(100, 50, 150),
    model = {"models/player/sanya.mdl"},
    description = [[Вы кладмен. Вам периодически приходят заказы. Заберите посылку в точке выдачи, затем разложите закладки по городу за 5 минут. Награда: $2000 за успешный круг.]],
    weapons = {},
    command = "cladmen",
    max = 4,
    salary = 450,
    admin = 0,
    spawns = citizen_spawns,
    vote = false,
    hasLicense = false,
    candemote = false,
    category = "Криминал",
    PlayerSpawn = function(ply)
        ply:SetMaxHealth(100)
        ply:SetHealth(100)
        ply:SetArmor(0)
    end
})

TEAM_THIEF = rp.addTeam('Взломщик', {
    color = Color(100, 100, 100),
    model = 'models/deepalley/alley_thug.mdl',
    weapons = {},
    command = 'thief',
    max = 4,
    salary = 600,
    spawns = citizen_spawns,
    admin = 0,
    hasLicense = false,
    category = "Криминал",
    candemote = false,
})

TEAM_PROTHIEF = rp.addTeam('Проф Взломщик', {
    color = Color(80, 80, 80),
    model = 'models/deepalley/alley_thug.mdl',
    weapons = {},
    command = 'prothief',
    max = 2,
    salary = 900,
    spawns = citizen_spawns,
    admin = 0,
    hasLicense = false,
    category = "Криминал",
    candemote = false,
})

TEAM_DRUGMAKER = rp.addTeam('Гровер', {
    color = Color(128, 128, 128),
    model = 'models/player/voikanaa/snoop_dogg.mdl',
    weapons = {},
    command = 'grover',
    max = 4,
    category = "Криминал",
    salary = 700,
    spawns = citizen_spawns,
    admin = 0,
    description = 'Специалист по выращиванию запрещенных растений.',
    user = true,
    candemote = true,
})

TEAM_PICKPOCKET = rp.addTeam('Карманик', {
    color = Color(110, 90, 80),
    model = 'models/gatorcreek/el_gator.mdl',
    weapons = {},
    command = 'pickpocket',
    max = 3,
    salary = 500,
    spawns = citizen_spawns,
    admin = 0,
    hasLicense = false,
    category = "Криминал",
    candemote = false,
})

TEAM_HOOLIGAN = rp.addTeam('Хулиган', {
    color = Color(140, 100, 70),
    model = 'models/player/Bala_pm.mdl',
    weapons = {},
    command = 'hooligan',
    max = 5,
    salary = 450,
    spawns = citizen_spawns,
    admin = 0,
    hasLicense = false,
    category = "Криминал",
    candemote = false,
})

--
    -- SWAT
--

TEAM_SWATM = rp.addTeam('Com SWAT', {
    color = Color(139, 0, 0),
    model = "models/payday2/units/blue_swat_player.mdl",
    CanRaid = 'Рейдить',
    weapons = {'weapon_taser', 'rwp_tfa_pist_mp443', 'rwp_tfa_smg_aks74u', 'rwp_tfa_shotgun_ks23', 'arrest_baton', 'stun_baton', 'med_kit', 'door_ram', 'handcuffs', 'weaponchecker'},
    spawns = police_spawns,
    command = 'comswat',
    max = 1,
    salary = 1850,
    admin = 0,
    user = true,
    candemote = true,
    canHavy = true,
    canLite = true,
    canVzri = true,
    category = "SWAT",
    description = 'Командир спецподразделения SWAT. Руководит штурмами и тактическими операциями.',
    hasLicense = true,
    CannotOwnDoors = true,
    police = true,
    selldoors = true,
    vip = false,
    PlayerSpawn = function(pl) pl:SetArmor(250) pl:GiveAmmos(200) pl:SetBodygroup(0, 0) pl:SetBodygroup(1, 5) end
})
TEAM_COMSWAT = TEAM_SWATM

TEAM_SWAT = rp.addTeam('Shturm SWAT', {
    color = Color(139, 0, 0),
    model = "models/payday2/units/blue_swat_player.mdl",
    CanRaid = 'Рейдить',
    weapons = {'weapon_taser', 'rwp_tfa_pist_pm', 'rwp_tfa_smg_aks74u', 'arrest_baton', 'stun_baton', 'door_ram', 'handcuffs', 'weaponchecker'},
    spawns = police_spawns,
    command = 'shturmswat',
    max = 6,
    salary = 1300,
    admin = 0,
    user = true,
    candemote = true,
    canHavy = true,
    canVzri = true,
    description = 'Боец штурмовой группы SWAT.',
    category = "SWAT",
    canLite = true,
    hasLicense = true,
    CannotOwnDoors = true,
    police = true,
    selldoors = true,
    vip = false,
    PlayerSpawn = function(pl) pl:SetArmor(120) pl:GiveAmmos(200) pl:SetBodygroup(0, 0) pl:SetBodygroup(1, 6) end
})
TEAM_SHTURMSWAT = TEAM_SWAT

TEAM_MEDICSWAT = rp.addTeam('Medic SWAT', {
    color = Color(150, 20, 20),
    model = 'models/payday2/units/blue_swat_player.mdl',
    weapons = {},
    command = 'medicswat',
    max = 2,
    salary = 1400,
    spawns = police_spawns,
    admin = 0,
    hasLicense = true,
    category = "SWAT",
    candemote = true,
})

TEAM_SNIPERSWAT = rp.addTeam('Sniper SWAT', {
    color = Color(100, 20, 20),
    model = 'models/payday2/units/blue_swat_player.mdl',
    weapons = {},
    command = 'sniperswat',
    max = 2,
    salary = 1500,
    spawns = police_spawns,
    admin = 0,
    hasLicense = true,
    category = "SWAT",
    candemote = true,
})

--
-- Administration
--

TEAM_ADMIN = rp.addTeam('Администрация', {
    color = Color(51, 128, 255),
    model = 'models/cyanblue/fortnite/perfect_shadow/perfect_shadow.mdl',
    weapons = {'weapon_keypadchecker'},
    command = 'staff',
    max = 0,
    salary = 0,
    spawns = {
        rp_arizonarp_v1 = {Vector(-2269.569824, -5090.061523, 691.781250)}
    },
    admin = 1,
    canHavy = true,
    category = "Разное",
    canLite = true,
    canVzri = true,
    candemote = false,
    CannotOwnDoors = true,
    mayorCanSetSary = false,
    selldoors = false,
    customCheck = function(pl) return pl:HasAccess('M') end,
    CustomCheckFailMsg = 'JobNeedsAdmin',
    PlayerSpawn = function(pl) pl:SetArmor(100) pl:GodEnable() pl:SetHealth(10000) pl:GiveAmmos(200) end
})

TEAM_BANNED = rp.addTeam('Забанен', {
    color = Color(255, 0, 0),
    model = 'models/player/soldier_stripped.mdl',
    weapons = {},
    command = 'banned124',
    max = 0,
    salary = 0,
    CannotOwnDoors = true,
    admin = 0,
    hasLicense = false,
    candemote = false,
    category = '',
    customCheck = function(pl) return pl:IsBanned() end,
    CustomCheckFailMsg = 'JobNeedsBanned',
    spawns = banned_spawns
})

-- ██████╗░░█████╗░███╗░░██╗███╗░░██╗███████╗██████╗░
-- ██╔══██╗██╔══██╗████╗░██║████╗░██║██╔════╝██╔══██╗
-- ██████╦╝███████║██╔██╗██║██╔██╗██║█████╗░░██║░░██║
-- ██╔══██╗██╔══██║██║╚████║██║╚████║██╔══╝░░██║░░██║
-- ██████╦╝██║░░██║██║░╚███║██║░╚███║███████╗██████╔╝
-- ╚═════╝░╚═╝░░╚═╝╚═╝░░╚══╝╚═╝░░╚══╝╚══════╝╚═════╝░

TEAM_SOPMOD = rp.addTeam('SOPMOD', {
    color = Color(219, 47, 26),
    model = {"models/player/dewobedil/girls_frontline/m4_sopmod_ii/default_p.mdl"},
    weapons = {'blink', 'weapon_ziptie', 'm9k_m4a1_sopmod', 'lockpick', 'keypad_cracker', 'slappers', 'swep_vmaxgun'},
    command = 'sopmod',
    max = 1,
    salary = 10000,
    admin = 0,
    spawns = citizen_spawns,
    hasLicense = true,
    candemote = false,
    category = "Личные профессии",
    keypadcracktime = 10,
    lockpicktime = 10,
    canRob = true,
    PlayerSpawn = function(ply)
        ply:SetMaxHealth(500)
        ply:SetMaxArmor(200)
        ply:SetArmor(200)
        ply:SetHealth(500)
    end
  })

TEAM_BERSERK = rp.addTeam('Берсерк', {
    color = Color(15, 6, 5),
    model = {"models/kerosenn/apex_legends/legends/wraith/playermodel/voidwalker_pm.mdl"},
    weapons = {'weapon_ziptie', 'weapon_shield', 'weapon_mad_dragonslayer'},
    command = 'berserk',
    max = 2,
    salary = 2500,
    admin = 0,
    spawns = citizen_spawns,
    hasLicense = false,
    candemote = false,
    category = "Личные профессии",
    keypadcracktime = 5,
    lockpicktime = 5,
    canRob = true,
    PlayerSpawn = function(ply)
        ply:SetMaxHealth(125)
        ply:SetMaxArmor(150)
        ply:SetArmor(150)
        ply:SetHealth(125)
    end
  })

TEAM_SATORU = rp.addTeam('Сатору Годжо', {
    color = Color(0, 255, 238),
    model = {"models/jjk_falko/satoru_gojo_fortnite.mdl"},
    weapons = {'limitless'},
    command = 'satoru',
    max = 0,
    salary = 5000,
    admin = 0,
    spawns = citizen_spawns,
    hasLicense = true,
    candemote = false,
    category = "Личные профессии",
    PlayerSpawn = function(ply)
        ply:SetMaxHealth(150)
        ply:SetMaxArmor(150)
        ply:SetArmor(150)
        ply:SetHealth(150)
    end
  })



TEAM_TOBI = rp.addTeam('Тоби', {
    color = Color(82, 82, 82),
    model = {"models/player/snowki/tobi.mdl"},
    weapons = {'mangekyou_sharingan_obito', 'weapon_ziptie', 'lockpick', 'keypad_cracker'},
    command = 'tobi',
    max = 2,
    salary = 5000,
    admin = 0,
    hasLicense = false,
    candemote = false,
    spawns = citizen_spawns,
    category = "Личные профессии",
    keypadcracktime = 10,
    lockpicktime = 10,
    canRob = true,
    PlayerSpawn = function(ply)
        ply:SetMaxHealth(250)
        ply:SetMaxArmor(250)
        ply:SetArmor(250)
        ply:SetHealth(250)
    end
  })

TEAM_FURINA = rp.addTeam('Фурина', {
    color = Color(0, 255, 255),
    model = {"models/hoyoverse/Furina.mdl"},
    weapons = {'m9k_minigun', 'orbital_friendship_cannon', 'lockpick', 'keypad_cracker'},
    command = 'furina',
    max = 1,
    salary = 7500,
    admin = 0,
    hasLicense = false,
    candemote = false,
    spawns = citizen_spawns,
    category = "Личные профессии",
	description = 'Фурина: божественная дива и главная звезда города, для которой весь мир является огромным театром. В её задачи входит вершение правосудия и наказание нечестивцев с помощью сокрушительного Орбитального Удара за дерзость или «плохую актерскую игру». Данная роль требует артистизма, соблюдения высоких принципов (исключающих мелкий криминал) и готовности выступать судьей в любых конфликтах. Фурина играет ключевую роль в создании грандиозного спектакля на улицах города, не подчиняясь никому, кроме собственных капризов.',
    keypadcracktime = 10,
    lockpicktime = 10,
    canRob = true,
    PlayerSpawn = function(ply)
        ply:SetMaxHealth(500)
        ply:SetMaxArmor(500)
        ply:SetArmor(150)
        ply:SetHealth(150)
		ply:SetRunSpeed(540)
    end
  })

TEAM_TOJI = rp.addTeam('Toji Zenin', {
    color = Color(103, 97, 81),
    model = {"models/jjk_falko/toji_fushiguro.mdl"},
    weapons = {'heavenlyrestriction', 'weapon_ziptie', 'lockpick', 'keypad_cracker', 'm9k_m92beretta_toji'},
    command = 'toji',
    max = 1,
    salary = 5000,
    admin = 0,
    spawns = citizen_spawns,
    hasLicense = false,
    candemote = false,
    category = "Личные профессии",
    keypadcracktime = 10,
    lockpicktime = 10,
    canRob = true,
    PlayerSpawn = function(ply)
        ply:SetMaxHealth(450)
        ply:SetMaxArmor(150)
        ply:SetArmor(150)
        ply:SetHealth(450)
    end
  })

TEAM_SUKUNA = rp.addTeam('Ryomen Sukuna', {
    color = Color(77, 19, 15),
    model = {"models/moon/Ryomen_Sukuna/Ryomen_Sukuna.mdl"},
    weapons = {'vessel', 'weapon_ziptie', 'lockpick', 'keypad_cracker'},
    command = 'sukuna',
    max = 1,
    salary = 5000,
    admin = 0,
    spawns = citizen_spawns,
    hasLicense = false,
    candemote = false,
    category = "Личные профессии",
    keypadcracktime = 10,
    lockpicktime = 10,
    canRob = true,
    PlayerSpawn = function(ply)
        ply:SetMaxHealth(500)
        ply:SetMaxArmor(200)
        ply:SetArmor(200)
        ply:SetHealth(500)
    end
  })
 
TEAM_BULLDOZER = rp.addTeam('Бульдозер', {
    color = Color(24, 38, 255),
    model = {"models/Killzone Mercenary/Helghast_Police_Trooper/Police_Trooper.mdl"},
    weapons = {'m9k_minigun', 'handcuffs','weaponchecker','arrest_baton','door_ram','salute','stungun','stun_baton','unarrest_baton','weapon_shield','weapon_c4',  'm9k_exile', 'weapon_radio'},
    command = 'bulldoz',
    max = 2,
    salary = 3000,
    admin = 0,
    spawns = police_spawns,
    hasLicense = true,
    candemote = false,
    category = "Личные профессии",
    description = [[Вы лучший солдат полиции, можете действовать в одиночку, так и с отрядом. Вам не страшно огромное количество врагов.]],
    PlayerSpawn = function(ply)
        ply:SetMaxHealth(200)
        ply:SetMaxArmor(250)
        ply:SetArmor(250)
        ply:SetHealth(200)
        ply:SetRunSpeed(200)
    end
    
  })

TEAM_ELZA = rp.addTeam('Агент Эльза', {
    color = Color(0, 191, 255),
    model = {"models/player/ElizaCop.mdl"},
    weapons = {'weapon_frag', 'handcuffs','weaponchecker','arrest_baton','door_ram','salute','stungun','stun_baton','unarrest_baton','weapon_shield', 'csgo_talon', 'avenger_xr2', 'weapon_radio'},
    command = 'elza',
    max = 1,
    salary = 1500,
    admin = 0,
    spawns = police_spawns,
    hasLicense = true,
    candemote = false,
    description = [[Вы агент полиции, который занимается расследованием преступлений.]],
    category = "Личные профессии",
    PlayerSpawn = function(ply)
        ply:SetMaxHealth(125)
        ply:SetMaxArmor(125)
        ply:SetArmor(125)
        ply:SetHealth(125)
    end
    
  })



TEAM_MUFFLER = rp.addTeam('Muffler', {
    color = Color(102, 0, 255),
    model = {"models/jazzmcfly/muffler/muffler.mdl"},
    weapons = {'weapon_ziptie', 'weapon_shield', 'weapon_c4', 'awp_asiimov', 'csgo_fade_xm1014', 'usual_blink'},
    command = 'muffler',
    max = 3,
    salary = 3000,
    admin = 0,
    hasLicense = false,
    candemote = false,
    canRob = true,
    category = "Личные профессии",
    spawns = citizen_spawns,
    description = [[Вы часть криминального мира. Низкий рост дает преимущество в беге, а телепорт помогает избежать опасности.]],
    PlayerSpawn = function(ply)
        ply:SetMaxHealth(150)
        ply:SetMaxArmor(125)
        ply:SetArmor(125)
        ply:SetHealth(150)
        ply:SetRunSpeed(330)
    end
    
  })

TEAM_HAKU = rp.addTeam('Агент Хаку', {
    color = Color(24, 255, 213),
    model = {"models/mmd/Haku Police.mdl"},
    weapons = {'weapon_frag', 'handcuffs','weaponchecker','arrest_baton','door_ram','salute','stungun','stun_baton','unarrest_baton','weapon_shield', 'csgo_ursus', 'ryry_m9k_ak12', 'weapon_radio'},
    command = 'haku',
    max = 1,
    salary = 1500,
    admin = 0,
    spawns = police_spawns,
    hasLicense = true,
    candemote = false,
    description = [[Вы агент полиции, который занимается расследованием преступлений.]],
    category = "Личные профессии",
    PlayerSpawn = function(ply)
        ply:SetMaxHealth(125)
        ply:SetMaxArmor(125)
        ply:SetArmor(125)
        ply:SetHealth(125)
        ply:SetRunSpeed(320)
    end
    
  })

TEAM_ROXY = rp.addTeam('Roxy', {
    color = Color(70, 24, 255),
    model = {"models/mad_roxy.mdl"},
    weapons = {'weapon_ziptie', 'weapon_shield', 'weapon_c4', 'm9k_jackhammer', 'm9k_svu', 'usual_blink'},
    command = 'roxy',
    max = 3,
    salary = 3000,
    admin = 0,
    hasLicense = false,
    candemote = false,
    canRob = true,
    spawns = citizen_spawns,
    description = [[Вы часть криминального мира. Ограбления, рейды, все это вам кажется родным и неотъемлимой частью вашей жизни.]],
    category = "Личные профессии",
    PlayerSpawn = function(ply)
        ply:SetMaxHealth(125)
        ply:SetMaxArmor(150)
        ply:SetArmor(150)
        ply:SetHealth(125)
    end

  })

TEAM_AKOLIT = rp.addTeam('Аколит', {
    color = Color(184, 138, 0),
    model = {"models/indiarp/gang/reper5.mdl"},
    weapons = {'wiz_wizard_pistol'},
    command = 'akolit',
    max = 3,
    salary = 1500,
    admin = 0,
    spawns = citizen_spawns,
    candemote = false,
    category = "Личные профессии",
    PlayerSpawn = function(ply)
        ply:SetMaxHealth(100)
        ply:SetMaxArmor(100)
        ply:SetArmor(100)
        ply:SetHealth(100)
    end
  })

TEAM_KOLDUN = rp.addTeam('Колдун', {
    color = Color(0, 93, 184),
    model = {"models/indiarp/gang/reper4.mdl"},
    weapons = {'wiz_wizard_pistol', 'wiz_bloodhound'},
    command = 'koldun',
    max = 3,
    salary = 2000,
    admin = 0,
    spawns = citizen_spawns,
    candemote = false,
    category = "Личные профессии",
    PlayerSpawn = function(ply)
        ply:SetMaxHealth(150)
        ply:SetMaxArmor(150)
        ply:SetArmor(150)
        ply:SetHealth(150)
    end
  })

TEAM_CHARODEI = rp.addTeam('Чародей', {
    color = Color(179, 26, 0),
    model = {"models/indiarp/gang/reper.mdl"},
    weapons = {'wiz_wizard_pistol', 'wiz_bloodhound'},
    command = 'charodei',
    max = 2,
    salary = 3000,
    admin = 0,
    spawns = citizen_spawns,
    candemote = false,
    category = "Личные профессии",
    PlayerSpawn = function(ply)
        ply:SetMaxHealth(150)
        ply:SetMaxArmor(150)
        ply:SetArmor(150)
        ply:SetHealth(150)
    end
  })

TEAM_CHERNOKNIZH = rp.addTeam('Чернокнижник', {
    color = Color(141, 0, 179),
    model = {"models/indiarp/gang/reper3.mdl"},
    weapons = {'wiz_wizard_pistol', 'wiz_bloodhound', 'wiz_wizard_shotgun'},
    command = 'chernok',
    max = 1,
    salary = 5000,
    admin = 0,
    spawns = citizen_spawns,
    candemote = false,
    category = "Личные профессии",
    PlayerSpawn = function(ply)
        ply:SetMaxHealth(200)
        ply:SetMaxArmor(200)
        ply:SetArmor(200)
        ply:SetHealth(200)
    end
  })

TEAM_ARCHIMAG = rp.addTeam('Архимаг', {
    color = Color(230, 230, 250),
    model = {"models/indiarp/gang/reper2.mdl"},
    weapons = {'wiz_wizard_pistol', 'wiz_bloodhound', 'wiz_wizard_shotgun', 'wiz_lightning_caller', 'wiz_dying_neutron_star'},
    command = 'archimag',
    max = 1,
    salary = 10000,
    admin = 0,
    spawns = citizen_spawns,
    candemote = false,
    category = "Личные профессии",
    PlayerSpawn = function(ply)
        ply:SetMaxHealth(250)
        ply:SetMaxArmor(250)
        ply:SetArmor(250)
        ply:SetHealth(250)
    end
  })

TEAM_SHADOW = rp.addTeam('Тень', {
    color = Color(94, 94, 94),
    model = {"models/garden/shadow.mdl"},
    weapons = {'blink', 'weapon_ziptie', 'lockpick', 'keypad_cracker', 'weapon_shield'},
    command = 'shadow',
    max = 2,
    salary = 5000,
    admin = 0,
    hasLicense = false,
    candemote = false,
    spawns = citizen_spawns,
    category = "Личные профессии",
    keypadcracktime = 10,
    lockpicktime = 10,
    canRob = true,
    PlayerSpawn = function(ply)
        ply:SetMaxHealth(175)
        ply:SetMaxArmor(175)
        ply:SetArmor(175)
        ply:SetHealth(175)
    end
  })

TEAM_SEGUN = rp.addTeam("Сёгун", {
    color = Color(255, 24, 92),
    model = 'models/alejenus/genshinimpact/raidenshogun/shogun.mdl',
    description = [[Вы профессионал своего дела - Сёгун, лучший мечник родом из Японии. Вам пришлось покинуть родные края и переехать в штат Вайб, но тяга к деньгам за убийства людей осталась с вами.]],
    weapons = {'lockpick', 'weapon_c4', 'keypad_cracker', 'weapon_shield', 'climb_swep', 'weapon_irisheartsword', 'weapon_ziptie', 'usual_blink'},
    command = "segun",
    max = 2,
    salary = 0,
    admin = 0,
    spawns = citizen_spawns,
    vote = false,
    hasLicense = false,
    candemote = true,
    category = "Личные профессии",
    PlayerSpawn = function(ply)
        ply:SetMaxHealth(200)
        ply:SetMaxArmor(200)
        ply:SetArmor(200)
        ply:SetHealth(200)
        ply:SetRunSpeed(330)
        ply:SetJumpPower(150)
        ply:SetGravity(0.7)
    end
 })

TEAM_HRANITEL = rp.addTeam("Хранитель", {
    color = Color(206, 255, 29),
    model = 'models/player/dewobedil/undertale/ff_frisk/default_p.mdl',
    description = [[Вы хранитель этого штата. Можете заниматься криминалом, а можете помогать полиции. Выбирайте свой род деятельности и охраняйте то, что вам дорого!]],
    weapons = {'lockpick', 'weapon_c4', 'keypad_cracker', 'weapon_shield', 'climb_swep', 'weapon_overlord_beam', 'weapon_ziptie', 'usual_blink', 'handcuffs','weaponchecker','arrest_baton','salute', 'door_ram', 'stungun','stun_baton','unarrest_baton', 'weapon_radio'},
    command = "hran",
    max = 2,
    salary = 0,
    admin = 0,
    spawns = citizen_spawns,
    vote = false,
    hasLicense = false,
    candemote = true,
    category = "Личные профессии",
    PlayerSpawn = function(ply)
        ply:SetMaxHealth(175)
        ply:SetMaxArmor(175)
        ply:SetArmor(175)
        ply:SetHealth(175)
        ply:SetRunSpeed(330)
    end
 })

TEAM_MOTOMOTO = rp.addTeam("Мото мото", {
    color = Color(150, 75, 0),
    model = 'models/a_thing/madagascar/motomoto_pm.mdl',
    description = [[Вы хранитель этого штата. Можете заниматься криминалом, а можете помогать полиции. Выбирайте свой род деятельности и охраняйте то, что вам дорого!]],
    weapons = {'lockpick'},
    command = "motomoto",
    max = 2,
    salary = 0,
    admin = 0,
    spawns = citizen_spawns,
    vote = false,
    hasLicense = false,
    candemote = true,
    category = "Личные профессии",
    PlayerSpawn = function(ply)
        ply:SetMaxHealth(200)
        ply:SetMaxArmor(100)
        ply:SetArmor(100)
        ply:SetHealth(200)
    end
 })

--
-- Configs
--
-- Group Chat
if TEAM_GANGSTER and TEAM_PROTHIEF then
    rp.addGroupChat(TEAM_GANGSTER, TEAM_EXPGANGSTER, TEAM_MOBBOSS, TEAM_THIEF, TEAM_PROTHIEF)
end
rp.addGroupChat(
    TEAM_CHIEF,
    TEAM_POLICE,
    TEAM_MAYOR,
    TEAM_JAGGEROMON,
    TEAM_FBI,
    TEAM_MAYORGUARD,
    TEAM_SWAT,
    TEAM_SWATM,
    TEAM_MEDICSWAT,
    TEAM_SNIPERSWAT
)
if TEAM_HOBO and TEAM_HOBOKING then
    rp.addGroupChat(TEAM_HOBO, TEAM_HOBOKING)
end

-- Default Team
rp.DefaultTeam = TEAM_CITIZEN

-- Police classes
rp.CivilProtection = {}

local civilProtectionTeams = {
    TEAM_CHIEF,
    TEAM_POLICE,
    TEAM_SUPERVISOR,
    TEAM_JAGGEROMON,
    TEAM_FBI,
    TEAM_MAYORGUARD,
    TEAM_SWATM,
    TEAM_SWAT,
    TEAM_MEDICSWAT,
    TEAM_SNIPERSWAT,
    TEAM_MAYOR
}

for _, teamId in ipairs(civilProtectionTeams) do
    if teamId then
        rp.CivilProtection[teamId] = true
    end
end

-- Mayor
rp.MayorTeam = TEAM_MAYOR

-- Gov classes
rp.Government = {}

if TEAM_MAYOR then
    rp.Government[TEAM_MAYOR] = true
end

--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher