--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

rp.cfg.StartMoney 		= 15000
rp.cfg.OrgCost 			= 100000

rp.cfg.AdvertCost		= 100

rp.cfg.HungerRate 		= 2050

rp.cfg.DoorTaxMin		= 10
rp.cfg.DoorTaxMax		= 500
rp.cfg.DoorCostMin		= 100
rp.cfg.DoorCostMax 		= 2000

rp.cfg.PropLimit 		= 85

rp.cfg.RagdollDelete	= 60

rp.cfg.ChangeJobTime	= 5

-- Speed
rp.cfg.WalkSpeed 		= 180
rp.cfg.RunSpeed 		= 280

-- Printers
rp.cfg.PrintDelay 		= 200
rp.cfg.PrintAmount 		= 2500
rp.cfg.InkCost 			= 250

-- Hits
rp.cfg.HitExpire		= 600
rp.cfg.HitCoolDown 		= 300
rp.cfg.HitMinCost 		= 1000
rp.cfg.HitMaxCost 		= 50000

-- Afk
rp.cfg.AfkDemote 		= (60*60)*1
rp.cfg.AfkPropRemove 	= (60*60)*3
rp.cfg.AfkDoorSell 		= (60*60)*3

-- Lotto
rp.cfg.MinLotto 		= 1000
rp.cfg.MaxLotto 		= 1000000


-- Item Lab

rp.cfg.ItemLabMaxMetal		= 3

rp.cfg.ItemLabMetalPrice 	= 500

rp.cfg.ItemLabTimeFactor 	= 14

rp.cfg.CreditSale 		= ''
rp.cfg.CreditsURL 		= ''

rp.cfg.GroupURL 		= ''
rp.cfg.SteamURL         = ''
rp.cfg.SiteURL          = ''

rp.cfg.LockdownTime 	= 600

rp.cfg.DefaultLaws 		= [[
Денежные Принтеры: Тюрьма
Нелегал: Тюрьма
Убийство, Взлом: Тюрьма
Оружие: Тюрьма
Оскорбление госов: Тюрьма
]]

rp.cfg.LockdownSounds = 'npc/overwatch/cityvoice/f_confirmcivilstatus_1_spkr.wav'

rp.cfg.DisallowDrop = {
	arrest_stick 	     = true,
	door_ram 		     = true,
	gmod_camera 	     = true,
	gmod_tool 		     = true,
	keys 			     = true,
	med_kit 		     = true,
	pocket 			     = true,
	stunstick 		     = false,
	unarrest_stick 	     = false,
	weapon_keypadchecker = true,
	phone                = true,
	weapon_physcannon    = true,
	weapon_physgun 	     = true,
	weaponchecker 	     = true,
	weapon_fists 	     = true,
	itemstore_pickup     = true,
	heavy_shield		 = true,
	riot_shield  		 = true,
	passport_default = true
} 

rp.cfg.AdminWeapons = {
	'weapon_keypadchecker'
}

rp.cfg.DefaultWeapons = {
	'weapon_physcannon',
	'weapon_physgun',
	'gmod_tool',
	'phone',
	'keys',
	'itemstore_pickup',
	'weapon_fists',
}

rp.cfg.TextSrceenFonts = {
	"Tahoma"
}

if (CLIENT) then
	rp.cfg.AnnouncementDelay = 10
	rp.cfg.Announcements = {
		{ui.col.Gold, ' ARIZONA Быстрое меню команд на "C".'},
        {ui.col.Brown, ' ARIZONA Скидки до -70% на весь Спец Донат!'},
		{ui.col.Brown, ' ARIZONA На сервере действует акция X8 пополнения'},
		{ui.col.Blue, ' ARIZONA Есть жалоба или вопрос? Напишите в чате @ и текст вашего сообщения.'},
		{ui.col.Green, ' ARIZONA Авто-рестарт в 6:00 по Московскому времени.'},
        {ui.col.Green, ' ARIZONA Администрация желает вам приятной игры на сервере.'},
		{ui.col.Purple, ' ARIZONA Discord сервера -> https://discord.gg/arizonaroleplay'},
	}
end 

-- Spawn
rp.cfg.SpawnDisallow = {
	prop_physics		= true,
	ent_textscreen 		= true,
	metal_detector		= true,
	gmod_light 			= true,
	gmod_lamp 			= true,
	keypad 				= true,
	gmod_button 		= true,
	gmod_cameraprop 	= true
}

rp.cfg.Spawns = {
	rp_downtown_tits_v2 = {
		Vector(-1864.357544, -1310.157227, -131.968750),
		Vector(-2176.210938, -1318.577026, -131.968750),
	},
}

rp.cfg.Spawns2 = {
	rp_downtown_tits_v2 = {
		Vector(-2177.879639, -1630.258911, -131.968750),
		Vector(-1910.447388, -1819.910522, -131.968750),
	},
}

rp.cfg.TeamSpawns = rp.cfg.TeamSpawns or {
	[game.GetMap()]	= {}
}

rp.cfg.SpawnPos = rp.cfg.SpawnPos or {
	rp_bangclaw = {Vector(0, 0, 0)},
	rp_downtown_tits_v2 = {
		Vector(-2177.879639, -1630.258911, -131.968750),
		Vector(-1910.447388, -1819.910522, -131.968750),
	},
}
rp.cfg.SpawnPos['rp_downtown_sup_b5c_night'] = rp.cfg.SpawnPos['rp_bangclaw']

-- Jail
rp.cfg.WantedTime		= 180
rp.cfg.WarrantTime		= 180
rp.cfg.ArrestTime	 	= 900

rp.cfg.Jails = {
	rp_bangclaw = {Vector(0, 0, 0)},
	rp_russiacity_v1 = {
		Vector(12300.076171875, -11666.83203125, 47.939960479736),
		Vector(7750.4956054688, -8448.583984375, 804.45123291016)
	},
}
rp.cfg.Jails['rp_downtown_sup_b5c_night'] = rp.cfg.Jails['rp_bangclaw']

rp.cfg.JailPos = {
	 rp_arizonarp_v1 = {
		Vector(3364.435791, 3085.696777, 76.031250),
		Vector(3367.874512, 2875.924316, 76.031250),
		Vector(3367.198730, 2665.685791, 76.031250),
		Vector(3357.440918, 2455.335205, 76.031250),
	}
}

-- Dumpsters 
rp.cfg.Dumpsters = {
	rp_downtown_sup_b5c = {
		{Vector(-1078.358643, 2029.177124, -169.767410), Angle(0, 0, 0)},
		{Vector(-3173.637207, -1692.055420, -170.330276), Angle(0, 0, 0)},
		{Vector(-780.621826, -1970.168945, -170.088562), Angle(0, -90, 0)},
		{Vector(100.398178, -537.862976, -294.299866), Angle(0, 90, 0)},
		{Vector(1837.878784, -2176.435791, -137.308685), Angle(0, 180, 0)},
		{Vector(3692.299561, -3298.900146, -105.411743), Angle(0, 90, 0)},
		{Vector(3044.721924, 2677.100098, -169.308685), Angle(0, 90, 0)},
		{Vector(1700.366333, 309.102722, -169.308685), Angle(0, 90, 0)},
		{Vector(2149.900146, 2078.684326, -169.308685), Angle(0, -180, 0)},
	},
	rp_c18_sup_b1 = {
		{Vector(1234.892334, -2138.017822, 690.691284), Angle(0, -90, 0)},
		{Vector(3357.300049, -113.900002, 690.691284), Angle(0, 0, 0)},
		{Vector(-970.200012, 5169.500000, 882.691284), Angle(0, 90, 0)},
		{Vector(-1480.983154, 1957.133911, 874.691284), Angle(0, 90, 0)},
		{Vector(1469.599976, 3333.699951, 1170.691284), Angle(0, -90, 0)},
	},
	rp_bangclaw = {
		{Vector(-1222, -528, 100), Angle(0, -90, 0)},
		{Vector(981, -1590, 100), Angle(0, -90, 0)},
		{Vector(720, 1222, 100), Angle(0, 0, 0)},
		{Vector(2583, 920, 90), Angle(0, 90, 0)},
		{Vector(5488, -2539, 100), Angle(0, 180, 0)},
		{Vector(3536, -4120, 100), Angle(0, 0, 0)},
	},
	rp_downtown_v4c_v2 = {
		{Vector(3385.900146, 542.071350, -169.308685), Angle(0, 180, 0)},
		{Vector(3948.614014, 2021.133911, -169.308685), Angle(0, 90, 0)},
		{Vector(-461.800018, 3205.134033, -168.699997), Angle(0, 90, 0)},
		{Vector(-1077.597534, 2079.100098, -169.308685), Angle(0, 0, 0)},
		{Vector(-4476.597656, 2812.528809, -177.308685), Angle(0, 0, 0)},
	}
}
rp.cfg.Dumpsters['rp_downtown_sup_b5c_night'] = rp.cfg.Dumpsters['rp_bangclaw']

rp.cfg.Theaters = {
rp_downtown_tits_v1 = {
		Screen = {
			Pos = Vector(-1925, 2128, 100),
			Ang = Angle(0,0,90),
			Scale = 0.25
		},
		Projector = {
			Pos = Vector(-1833.575562, 1707, -131),
			Ang = Angle(-0.000, 185, -0.000),
		},
	}
}


local hour = (60 * 60)
rp.cfg.PlayTimeRanks = {

	{'Новичок', 0},
	{'Новичок v2', (hour * 5)},
	{'Как туда пройти', (hour * 10)},
	{'Учащийся', (hour * 15)},
	{'Ботан', (hour * 20)},
	{'Подросток', (hour * 25)},
	{'Скоро стану крутым', (hour * 30)},
	{'Знающий', (hour * 35)},
	{'Someone', (hour * 40)},
	{'Партизан', (hour * 45)},
	{'Сертифицированный', (hour * 50)},
	{'Любитель пистолетов', (hour * 55)},
	{'Бандитофобик', (hour * 60)},
	{'Солдат', (hour * 65)},
	{'Капо', (hour * 70)},
	{'Деловой', (hour * 75)},
	{'Консильере', (hour * 80)},
	{'Студент', (hour * 85)},
	{'мэн', (hour * 90)},
	{'Острый человек', (hour * 95)},
	{'Бамбукоед', (hour * 100)},
	{'Всезнайка', (hour * 150)},
	{'Профессионал', (hour * 200)},
	{'Активич', (hour * 250)},
	{'Токсик кид', (hour * 300)},
	{'С4 enjoyner', (hour * 350)},
	{'Олененок бэмби', (hour * 400)},
	{'Неваляшка', (hour * 420)},
	{'Плохой ездок', (hour * 450)},
	{'Большой кэш в кошельке', (hour * 500)},
	{'Легальный', (hour * 550)},
	{'Интелегентный интелегент', (hour * 600)},
	{'Бани хопэр', (hour * 650)},
	{'Читаюзер', (hour * 700)},
	{'Питомец наборных', (hour * 750)},
	{'Строитель', (hour * 800)},
	{'Сбитый кэмпер', (hour * 850)},
	{'нигар', (hour * 900)},
	{'Горевший', (hour * 950)},
	{'400 IQ', (hour * 1000)},
	{'Я пришел из небытья', (hour * 1100)},
	{'Опалоумевший', (hour * 1200)},
	{'Дабл фак', (hour * 1300)},
	{'Трай хардер', (hour * 1400)},
	{'Чем я занимаюсь в свой жизни', (hour * 1500)},
	{'Пикапер', (hour * 1600)},
	{'Детектив', (hour * 1700)},
	{'Мощный', (hour * 1800)},
	{'Ламборджини', (hour * 1900)},
	{'Дарк рпшкер', (hour * 2000)},
	{'Тёлка дрейн', (hour * 2500), ':heart:'},
	{'Педик', (hour * 3000)},
	{'Много времени', (hour * 3500)},
	{'Меня много кто знает', (hour * 4500)},
	{'Кто-нибудь остановите меня', (hour * 5000), ':star:'},
	{'Гоняю.', (hour * 5500)},
	{'Бигнейм', (hour * 6000)},
	{'Типичный гарисмодер', (hour * 6500)},
	{'Мистер роблокс', (hour * 7000)},
	{'Инженер', (hour * 7500)},
	{'Мистер пепси', (hour * 8000)},
	{'Это илон мэск?', (hour * 8500)},
	{'Про 9000!', (hour * 9000)},
	{'Вротердам', (hour * 9500)},
	{'эу вася че за аппарат', (hour * 10000), ':crown:'},
	{'дет инсайт', (hour * 11000)},
	{'афк мастер', (hour * 12000)},
	{'Corndogger', (hour * 13000)},
	{'обезьяна', (hour * 14000)},
	{'бананоед', (hour * 15000), ':gem:'},
	{'Сугар дэди', (hour * 16000)},
	{'Шалабол', (hour * 17000)},
	{'Плахой парниша', (hour * 18000)},
	{'глобал', (hour * 19000)},
	{'я натурал а вы геи', (hour * 25000), ':dumb:'},
	{'у меня нет личной жизни', (hour * 35000), ':smarked:'},

}

rp.cfg.Havygun = {"tfa_model3russian","m9k_m1918bar","m9k_winchester73","m9k_acr","m9k_scar","m9k_m416","m9k_vikhr","m9k_auga3","m9k_tar21","m9k_amd65","m9k_ak74", "m9k_val","m9k_f2000","m9k_fal","m9k_jackhammer","m9k_remington7615p","m9k_psg1","m9k_ares_shrike","m9k_fg42","m9k_m249lmg","m9k_m3","m9k_browningauto5","m9k_spas12","m9k_m24","m9k_sl8","m9k_aw50","m9k_m60","m9k_pkm","m9k_svu","m9k_intervention","m9k_m98b","m9k_barret_m82","m9k_dragunov","m9k_svt40","m9k_1887winchester","m9k_usas","m9k_1897winchester","m9k_striker12","m9k_remington870","m9k_mossberg590","m9k_dbarrel","swb_ak47","swb_awp","swb_famas","swb_g3sg1","swb_galil","swb_m249","swb_m3super90","swb_m4a1","swb_sg550","swb_sg552","swb_aug","swb_scout","swb_xm1014","m9k_ak47","m9k_m4a1","m9k_g36","m9k_l85","m9k_m14sp","m9k_m16a4_acog","m9k_an94","m9k_g3a3","m9k_famas","swb_ak47","swb_awp","swb_famas", "swb_p90", "swb_g3sg1", "swb_galil", "swb_m249", "swb_m3super90", "swb_m4a1", "swb_sg550", "swb_sg552", "swb_aug", "swb_scout", "swb_xm1014"}
rp.cfg.Litegun = {"tfa_model3russian","m9k_bizonp19","m9k_smgp90","m9k_mp5","m9k_mp7","m9k_ump45","m9k_usc","m9k_kac_pdw","m9k_vector","m9k_magpulpdr","m9k_mp40","m9k_mp5sd","m9k_mp9","m9k_sten","m9k_thompson","m9k_uzi"}
rp.cfg.Vzri = {"weapon_c4","weapon_hegrenade"}

rp.cfg.WeaponsLimit = {
    [1] = {"csgo_bayonet_tiger", "weapon_physcannon", "m9k_ak47", "m9k_an94", "m9k_famas", "m9k_g36", "m9k_g3a3", "m9k_l85", "m9k_m14sp", "m9k_ares_shrike", "m9k_fg42", "m9k_m249lmg", "m9k_colt1911", "m9k_coltpython", "m9k_usp", "m9k_m92beretta", "m9k_m3", "m9k_browningauto5", "m9k_aw50", "m9k_sl8", "m9k_m24", "m9k_bizonp19", "m9k_smgp90", "m9k_ump45", "m9k_tec9", "weapon_vape", "swb_357", "swb_ak47", "swb_awp", "swb_deagle", "swb_famas", "swb_fiveseven", "swb_p90", "swb_g3sg1", "swb_glock18", "swb_mp5", "swb_galil", "swb_knife", "swb_m249", "swb_m3super90", "swb_m4a1", "swb_mac10", "swb_p228", "swb_sg550", "swb_sg552", "swb_aug", "swb_scout", "swb_tmp", "swb_usp", "swb_xm1014"},
	[2] = {"m9k_m3","m9k_browningauto5","csgo_bayonet_tiger","weapon_bugbait","weapon_physcannon","csgo_butterfly_crimsonwebs","csgo_butterfly_damascus","csgo_butterfly_tiger","csgo_huntsman_damascus","csgo_huntsman_slaughter","csgo_huntsman_tiger","csgo_karambit_crimsonwebs","csgo_karambit_fade","csgo_karambit_tiger","csgo_m9","csgo_m9_crimsonwebs","csgo_m9_damascus","csgo_m9_fade","m9k_1887winchester","m9k_1897winchester","m9k_acr","m9k_ak74","m9k_amd65","m9k_val","m9k_f2000","m9k_fal","m9k_m416","m9k_m16a4_acog","m9k_m4a1","m9k_scar","m9k_vikhr","m9k_tar21","m9k_auga3","m9k_m24","m9k_sl8","m9k_m1918bar","m9k_m60","m9k_pkm","m9k_ithacam37","m9k_mossberg590","m9k_jackhammer","m9k_remington870","m9k_striker12","m9k_winchester73","m9k_psg1","m9k_ares_shrike","m9k_fg42","m9k_m249lmg","m9k_aw50","m9k_m98b","m9k_svu","m9k_intervention","m9k_remington7615p","m9k_dragunov","m9k_svt40","m9k_contender","m9k_honeybadger","m9k_mp5","m9k_mp7","m9k_usc","m9k_kac_pdw","m9k_vector","m9k_magpulpdr","m9k_mp40","m9k_mp5sd","m9k_mp9","m9k_sten","m9k_thompson","m9k_uzi","weapon_medkit","itemstore_checker","itemstore_pickup","weaponchecker","weapon_shield","grabej","weapon_radio","weapon_taser","moneychecker","weapon_hegrenade","swb_ump","m9k_deagle","m9k_glock","m9k_hk45","m9k_m29satan","m9k_luger","m9k_ragingbull","m9k_scoped_taurus","m9k_model3russian","m9k_model500","m9k_model627","m9k_sig_p229r", "weapon_vape", "swb_357", "swb_ak47", "swb_awp", "swb_deagle", "swb_famas", "swb_fiveseven", "swb_p90", "swb_g3sg1", "swb_glock18", "swb_mp5", "swb_galil", "swb_knife", "swb_m249", "swb_m3super90", "swb_m4a1", "swb_mac10", "swb_p228", "swb_sg550", "swb_sg552", "swb_aug", "swb_scout", "swb_tmp", "swb_usp", "swb_xm1014"}
}

rp.cfg.RankWeapons = {
    ['globaladmin'] = rp.cfg.WeaponsLimit[2],
	['gl-admin'] = rp.cfg.WeaponsLimit[2],
    ['curator'] = rp.cfg.WeaponsLimit[2],
    ['zam-curator'] = rp.cfg.WeaponsLimit[2],
    ['st-admin'] = rp.cfg.WeaponsLimit[2],
   	['admin'] = rp.cfg.WeaponsLimit[1],

    ['d-sponsor'] = rp.cfg.WeaponsLimit[2],
    ['d-owner'] = rp.cfg.WeaponsLimit[2],
    ['d-hadmin'] = rp.cfg.WeaponsLimit[1],
    ['d-sadmin'] = rp.cfg.WeaponsLimit[1]
}
rp.cfg.ShopItems = {
	[1] = {
		["CustomCheck"] = {1},
		["pos"] = 	Vector(-12674.012695313, -8801.8203125, 76.03125),
		["ang"] = 	Angle(0, -90, 0),
		["name"] = 	"Продавец продуктов",
		["items"] = {
					["Вода"] = {				["Model"] = "models/props/cs_office/Water_bottle.mdl",		["ent"] = "water",				["type"] = "food",	["Cost"] = 600},
					["Яйцо"] = {				["Model"] = "models/props_phx/misc/egg.mdl",				["ent"] = "egg",				["type"] = "food",	["Cost"] = 130},
					["Масло"] = {				["Model"] = "models/props_junk/GlassBottle01a.mdl",			["ent"] = "oil",				["type"] = "food",	["Cost"] = 600},
					["Тост"] = {				["Model"] = "models/foods/toast1.mdl",						["ent"] = "tost",				["type"] = "food",	["Cost"] = 110},
					["Сырое мясо"] = {			["Model"] = "models/foods/backbacon.mdl",					["ent"] = "meat",				["type"] = "food",	["Cost"] = 80},
					["Соус"] = {				["Model"] = "models/foods/lemoncleaner.mdl",				["ent"] = "sauce",				["type"] = "food",	["Cost"] = 80},
					["Огурцы"] = {				["Model"] = "models/foods/picklejar.mdl",					["ent"] = "cucumbers",			["type"] = "food",	["Cost"] = 600},
					["Сырая сосиска"] = {		["Model"] = "models/foods/sausage.mdl",						["ent"] = "sausage",			["type"] = "food",	["Cost"] = 130},
					["Тесто"] = {				["Model"] = "models/foods/twinkie.mdl",						["ent"] = "dough",				["type"] = "food",	["Cost"] = 80},
					["Хлопья"] = {				["Model"] = "models/foods/applejacks.mdl",					["ent"] = "cereals",			["type"] = "food",	["Cost"] = 80},
					["Молоко"] = {				["Model"] = "models/foods/milk.mdl",						["ent"] = "milk",				["type"] = "food",	["Cost"] = 600},
					["Основа для пицы"] = {		["Model"] = "models/foods/pancakesingle.mdl",				["ent"] = "pizzabase",			["type"] = "food",	["Cost"] = 90},
					["Куриная ножка сырая"] = {	["Model"] = "models/foods/mcdfriedchickenleg.mdl",			["ent"] = "rawchickenleg",		["type"] = "food",	["Cost"] = 110},
		},
	},
	-- [2] = {
	-- 	["CustomCheck"] = {2},
	-- 	["pos"] = 	Vector(4695, 4942, 10),
	-- 	["ang"] = 	Angle(0, 90, 0),
	-- 	["name"] = 	"Продавец семян",
	-- 	["items"] = {
	-- 				["Яблоня"] = {					["Model"] = "models/props/cs_office/plant01_p1.mdl",			["ent"] = "apple",			["type"] = "seed",	["Cost"] = 50},
	-- 				["Банановое дерево"] = {		["Model"] = "models/props/de_dust/palm_tree_head_skybox.mdl",	["ent"] = "bananna",		["type"] = "seed",	["Cost"] = 100},
	-- 				["Куст капусты"] = {			["Model"] = "models/props/de_inferno/largebush01.mdl",			["ent"] = "cabbage",		["type"] = "seed",	["Cost"] = 60},
	-- 				["Куст цветной капусты"] = {	["Model"] = "models/props/de_inferno/largebush01.mdl",			["ent"] = "cauliflower",	["type"] = "seed",	["Cost"] = 60},
	-- 				["Лимонное дерево"] = {			["Model"] = "models/props/cs_office/plant01_p1.mdl",			["ent"] = "lemon",			["type"] = "seed",	["Cost"] = 50},
	-- 				["Апельсиновое дерево"] = {		["Model"] = "models/props/cs_office/plant01_p1.mdl",			["ent"] = "orange",			["type"] = "seed",	["Cost"] = 50},
	-- 				["Картофель"] = {				["Model"] = "models/props/de_inferno/fountain_bowl_p10.mdl",	["ent"] = "potato",			["type"] = "seed",	["Cost"] = 70},
	-- 				["Куст помидоров"] = {			["Model"] = "models/props/de_inferno/largebush02.mdl",			["ent"] = "tomato",			["type"] = "seed",	["Cost"] = 100},
	-- 				["Куст арбуза"] = {				["Model"] = "models/props/de_inferno/fountain_bowl_p10.mdl",	["ent"] = "watermelon",		["type"] = "seed",	["Cost"] = 150},
	-- 	},
	-- },
}

--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
