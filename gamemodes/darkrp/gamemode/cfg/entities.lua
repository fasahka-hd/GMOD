--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

-- VIP +

rp.AddEntity("Аптечка [VIP]", {
	category = 'ВИП',
	ent = "item_healthvial",
	model = "models/Items/HealthKit.mdl",
	price = 500,
	max = 1,
	cmd = "/buyhil",
	pocket = false,
	customCheck = function(pl) return pl:IsVIP() end,
})


rp.AddEntity("Броня [VIP]", {
	category = 'ВИП',
	ent = "item_battery",
	model = "models/Items/battery.mdl",
	price = 500,
	max = 1,
	cmd = "/buyar",
	pocket = false,
	customCheck = function(pl) return pl:IsVIP() end,
})

rp.AddEntity('Горшок', {
	ent = 'weed_plant',
	model = 'models/alakran/marijuana/pot_empty.mdl',
	price = 500,
	max = 9, 
	cmd = '/buygorshok',
	catagory = "Марихуанна",
	allowed = {TEAM_DRUGMAKER},
	pocket = false
})

rp.AddEntity('Семено травки', {
	ent = 'seed_weed',
	model = 'models/Items/AR2_Grenade.mdl',
	price = 500,
	max = 9, 
	cmd = '/buysemeno',
	catagory = "Марихуанна",
	allowed = {TEAM_DRUGMAKER},
	pocket = false
})

-- rp.AddEntity('Однорукий бандит', {
-- 	category = 'Казино', 
-- 	ent = 'gambling_machine_basicslots',
-- 	model = 'models/props/cs_office/computer.mdl',
-- 	price = 3000,
-- 	max = 1, 
-- 	cmd = '/buybandit',
-- 	allowed = {TEAM_CAZINO},
-- 	pocket = false,
-- })
-- rp.AddEntity('Рулетка', {
-- 	category = 'Казино', 
-- 	ent = 'gambling_machine_spinwheel',
-- 	model = 'models/props/cs_office/computer.mdl',
-- 	price = 3000,
-- 	max = 1, 
-- 	cmd = '/buyruletka',
-- 	allowed = {TEAM_CAZINO},
-- 	pocket = false,
-- })

rp.AddEntity('Металлодетектор', {
	category = 'Разное', 
	ent = 'metal_detector',
	model = 'models/props_wasteland/interior_fence002e.mdl',
	price = 7500,
	max = 1,
	cmd = '/buymetal',
	pocket = false
})

rp.AddEntity('Радио', {
	category = 'Разное', 
	ent = 'media_radio',
	model = 'models/props_lab/citizenradio.mdl',
	price = 500,
	max = 1, 
	cmd = '/buyradioo',
	allowed = {TEAM_CINEMA},
	pocket = false
})

rp.AddEntity('Большой Экран', {
	category = 'Разное', 
	ent = 'media_tv_large',
	model = 'models/hunter/plates/plate2x3.mdl',
	price = 2500,
	max = 1, 
	cmd = '/buylargetv',
	allowed = {TEAM_CINEMA},
	pocket = false
})

-- money printer
--[[ rp.AddEntity("Денежный Принтер", {
	ent = "derma_printer",
	model = "models/phoenixprinters/dermaprinter.mdl",
	price = 15000,
	max = 3,
	cmd = "/buyprinter",
	category = "Принтеры",
	allowed = {TEAM_GANG1, TEAM_GANG2, TEAM_GUN1, TEAM_GANGSTER, TEAM_MECHANIC, TEAM_CINEMA, TEAM_TRAMVAY, TEAM_BUSDRIVER, TEAM_CAZINO, TEAM_TAXI, TEAM_WORKER, TEAM_DVORNIK, TEAM_COOK, TEAM_ZAVOD, TEAM_GUN, TEAM_DELIVERY, TEAM_MOBBOSS, TEAM_GANGSTER, TEAM_GROMILA, TEAM_METHVARSHIK, TEAM_GUN, TEAM_HITMAN, TEAM_VIPHITMAN, TEAM_DRUGMAKER, TEAM_BISNES, TEAM_BARTENDER, TEAM_GANG1, TEAM_GANG2},
	pocket = false,
	Callback = function(pl)
		eui.battlepass.AddProgress(pl, 14)
	end
})
--]]
rp.AddEntity("Денежный Принтер", {
	ent = "derma_printer",
	model = "models/phoenixprinters/dermaprinter.mdl",
	price = 15000,
	max = 3,
	cmd = "/buyprintergromila",
	category = "Принтеры",
	allowed = {TEAM_GANG1, TEAM_GANG2, TEAM_GUN1, TEAM_GANGSTER, TEAM_MECHANIC, TEAM_CINEMA, TEAM_TRAMVAY, TEAM_BUSDRIVER, TEAM_CAZINO, TEAM_TAXI, TEAM_WORKER, TEAM_DVORNIK, TEAM_COOK, TEAM_ZAVOD, TEAM_GUN, TEAM_DELIVERY, TEAM_MOBBOSS, TEAM_GANGSTER, TEAM_GROMILA, TEAM_METHVARSHIK, TEAM_GUN, TEAM_HITMAN, TEAM_VIPHITMAN, TEAM_DRUGMAKER, TEAM_BISNES, TEAM_BARTENDER, TEAM_GANG1, TEAM_GANG2},
	pocket = false,
	Callback = function(pl)
		eui.battlepass.AddProgress(pl, 14)
	end
})

-- rp.AddEntity("Денежный Принтер [+1]", {
-- 	ent = "derma_printer",
-- 	model = "models/phoenixprinters/dermaprinter.mdl",
-- 	price = 5000,
-- 	max = 1,
-- 	cmd = "/buydopprinter",
-- 	category = "Принтеры",
-- 	allowed = {TEAM_CITIZEN, TEAM_GANGSTER, TEAM_ANARCHIST, TEAM_BANK, TEAM_BISNES, TEAM_MOBBOSS, TEAM_KARATEL},
-- 	customCheck = function(ply) return rp.orgs.HaveUpgrade(ply, "printerLimit") end,
-- 	CustomCheckFailMsg = "У вашего клана нет улучшения для покупки этого принтера!",
-- 	pocket = false
-- })


-- Hobo
-- rp.AddEntity('Коробка для пожертвования', {
-- 	category = 'Разное', 
-- 	ent = 'donation_box', 
-- 	model = 'models/props/CS_militia/footlocker01_open.mdl', 
-- 	price = 500, 
-- 	max = 1, 
-- 	cmd = '/buybox',
-- 	allowed = {TEAM_HOBO},
-- 	pocket = false
-- })
-- METHAMTEN

rp.AddEntity("Кастрюля для мета", {
	category = 'Изготовка мета',
	ent = "eml_spot",
	model = "models/props_c17/metalPot001a.mdl",
	price = 400,
	max = 4,
	cmd = "/buyspot",
	pocket = false,
	allowed = {TEAM_METHVARSHIK},
})

rp.AddEntity("Кастрюля для Фосфора", {
	category = 'Изготовка мета',
	ent = "eml_pot",
	model = "models/props_c17/metalPot001a.mdl",
	price = 400,
	max = 4,
	cmd = "/buyp111212112t",
	pocket = false,
	allowed = {TEAM_METHVARSHIK},
})

rp.AddEntity("Соль", {
	category = 'Изготовка мета',
	ent = "eml_salt",
	model = "models/props_junk/garbage_milkcarton002a.mdl",
	price = 300,
	max = 4,
	cmd = "/buysalt",
	pocket = false,
	allowed = {TEAM_METHVARSHIK},
})

rp.AddEntity("Вода", {
	category = 'Изготовка мета',
	ent = "eml_water",
	model = "models/props_junk/garbage_plasticbottle003a.mdl",
	price = 300,
	max = 2,
	cmd = "/buywat",
	pocket = false,
	allowed = {TEAM_METHVARSHIK},
})
rp.AddEntity("Жидкая сера", {
	category = 'Изготовка мета',
	ent = "eml_sulfur",
	model = "models/props_lab/jar01b.mdl",
	price = 300,
	max = 2,
	cmd = "/buysul",
	pocket = false,
	allowed = {TEAM_METHVARSHIK},
})

rp.AddEntity("Жидкий Йод", {
	category = 'Изготовка мета',
	ent = "eml_iodine",
	model = "models/props_lab/jar01b.mdl",
	price = 300,
	max = 2,
	cmd = "/buysul1",
	pocket = false,
	allowed = {TEAM_METHVARSHIK},
	
})

rp.AddEntity("Кислота", {
	category = 'Изготовка мета',
	ent = "eml_macid",
	model = "models/props_junk/garbage_plasticbottle001a.mdl",
	price = 400,
	max = 4,
	cmd = "/buyacid",
	pocket = false,
	allowed = {TEAM_METHVARSHIK},
	
})

rp.AddEntity("Емкость для кристального йода", {
	category = 'Изготовка мета',
	ent = "eml_jar",
	model = "models/props_lab/jar01a.mdl",
	price = 1000,
	max = 2,
	cmd = "/buyjar",
	pocket = false,
	allowed = {TEAM_METHVARSHIK},
	
})


rp.AddEntity("Плита", {
	category = 'Изготовка мета',
	ent = "eml_stove",
	model = "models/props_c17/furnitureStove001a.mdl",
	price = 2500,
	max = 1,
	cmd = "/buystove1",
	pocket = false,
	allowed = {TEAM_METHVARSHIK},
	
})



-- rp.AddEntity("Плита", {
-- 	category = 'Изготовка мета',
-- 	ent = "eml_stove",
-- 	model = "models/props_c17/furnitureStove001a.mdl",
-- 	price = 2500,
-- 	max = 2,
-- 	cmd = "/buystove2",
-- 	pocket = false,
-- 	allowed = {TEAM_MATHMAKERVIP},
	
-- })

rp.AddEntity("Газ", {
	category = 'Изготовка мета',
	ent = "eml_gas",
	model = "models/props_c17/canister01a.mdl",
	price = 900,
	max = 1,
	cmd = "/buygas",
	pocket = false,
	allowed = {TEAM_METHVARSHIK},
	
})

rp.AddEntity("Плита", {
	ent = "hfm_stove",
	model = "models/ent/stove.mdl",
	price = 500,
	max = 1,
	cmd = "/buystove",
	category = "Оборудование",
	allowed = {TEAM_COOK},
	pocket = false
})

-- rp.AddEntity("Газ", {
-- 	category = 'Изготовка мета',
-- 	ent = "eml_gas",
-- 	model = "models/props_c17/canister01a.mdl",
-- 	price = 900,
-- 	max = 2,
-- 	cmd = "/buygas2",
-- 	pocket = false,
-- 	allowed = {TEAM_MATHMAKERVIP},
	
-- })

rp.AddEntity("Киоск", {
	ent = "ent_prilavok",
	model = "models/props_c17/display_cooler01a.mdl",
	price = 500,
	max = 3,
	cmd = "/buykiosk",
	category = "Оборудование",
	allowed = {TEAM_FERMER, TEAM_COOK, TEAM_GUN,TEAM_GUN},
	pocket = false,
    onSpawn = function(ent, pl)
        ent:CPPISetOwner(pl)
    end
})

--[[
rp.AddEntity("Плита", {
	ent = "hfm_stove",
	model = "models/ent/stove.mdl",
	price = 500,
	max = 1,
	cmd = "/buystove",
	category = "Оборудование",
	allowed = {TEAM_COOK},
	pocket = false
})
]]

-- mayor

rp.AddEntity("Лицензия", {
	category = 'Город',
	ent = "ent_licence",
	model = "models/props_lab/clipboard.mdl",
	price = 200,
	max = 4,
	cmd = "/buylic",
	pocket = false,
	allowed = {TEAM_MAYOR}
})

-- Gun Dealer
rp.AddWeapon("Пистолет TT", "models/weapons/w_pist_tt38.mdl", "rwp_tfa_pist_tt33", 19000,{TEAM_GUN})
rp.AddWeapon("Пистолет Макаров", "models/weapons/w_murd_makarov.mdl", "rwp_tfa_pist_pm", 20000,{TEAM_GUN})
rp.AddWeapon("MP-443 Грач", "models/weapons/rinfect/battlefield_3/pistols/pist_mp443.mdl", "rwp_tfa_pist_mp443", 21000, {TEAM_GUN})
rp.AddWeapon("GSH-18", "models/weapons/tfa_w_gsh18.mdl", "rwp_tfa_pist_gsh18", 22000, {TEAM_GUN})

rp.AddWeapon("M416-Rex", "models/weapons/w_bf3_mp412rex.mdl", "rwp_tfa_pist_mp416rex", 26000, {TEAM_GUN})
rp.AddWeapon("AKS-74U", "models/weapons/w_rif_ak74u.mdl", "rwp_tfa_smg_aks74u", 41000, {TEAM_GUN})
rp.AddWeapon("PP1901 Витязь", "models/weapons/w_smg_ppv.mdl", "rwp_tfa_smg_pp1901", 43000, {TEAM_GUN})
rp.AddWeapon("Vikhr", "models/weapons/w_dmg_vikhr.mdl", "rwp_tfa_assault_vikhr", 43000, {TEAM_GUN})

rp.AddWeapon("AK-74", "models/weapons/w_nao_ak74.mdl", "rwp_tfa_assault_ak74", 63000, {TEAM_GUN})
rp.AddWeapon("AK-12", "models/weapons/w_rif_ak12.mdl", "rwp_tfa_assault_ak12", 65000, {TEAM_GUN})
rp.AddWeapon("AKM", "models/weapons/w_rif_ark7.mdl", "rwp_tfa_assault_akm", 66000, {TEAM_GUN})
rp.AddWeapon("AS-VAL", "rwp_tfa_assault_val", "rwp_tfa_assault_val", 68000, {TEAM_GUN}) 
rp.AddWeapon("SVD Dragunov", "models/weapons/w_svd_dragunov.mdl", "rwp_tfa_sniper_svd", 73000, {TEAM_GUN})
rp.AddWeapon("SVT", "models/weapons/w_svt_40.mdl", "rwp_tfa_sniper_svt40", 75000, {TEAM_GUN})
rp.AddWeapon("VSS (Прицел)", "models/weapons/w_p4f_vss.mdl", "rwp_tfa_sniper_vss", 82000, {TEAM_GUN})

rp.AddWeapon("ПКМ", "models/weapons/w_mach_russ_pkm.mdl", "rwp_tfa_heavy_pkm", 130000, {TEAM_GUN})
rp.AddWeapon("PKP Печенег", "models/weapons/w_mach_pecheneg.mdl", "rwp_tfa_heavy_pkp", 150000, {TEAM_GUN})
rp.AddWeapon("Saiga 20K", "models/weapons/w_rif_az47.mdl", "rwp_tfa_shotgun_saiga20k", 120000, {TEAM_GUN})

rp.AddWeapon("SV-98", "models/weapons/w_snip_bf3_sv98.mdl", "rwp_tfa_sniper_sv98", 110000, {TEAM_GUN})


---
-- Black Market Dealer
rp.AddShipment("Взломщики", "models/weapons/w_c4.mdl", "keypad_cracker", 15000, 5, false, 1050, false, {TEAM_GUN1})
rp.AddShipment("Отмычки", "models/weapons/w_crowbar.mdl", "lockpick", 13000, 5, false, 950, false, {TEAM_GUN1})
rp.AddShipment("Броня", "models/props_junk/cardboard_box004a.mdl", "armor_piece_full", 12000, 10, false, 750, false, {TEAM_GUN1})
rp.AddShipment("Нож", "models/weapons/w_knife_t.mdl", "csgo_bayonet", 10000, 10, false, 675, false, {TEAM_GUN1})
rp.AddShipment("Щиты", "models/bshields/hshield.mdl", "heavy_shield", 100000, 5, false, 2000, false, {TEAM_GUN1})
rp.AddShipment("Фальшивое Разрешение на оружие", "models/props_lab/clipboard.mdl", "ent_licence", 1000, 10, false, 1250, false, {TEAM_GUN1})
rp.AddShipment("Маскировка", "models/props_c17/SuitCase_Passenger_Physics.mdl", "ent_disguise", 5000, 10, false, 1250, false, {TEAM_GUN1})
rp.AddEntity("Раздатчик Брони", "armor_lab", "models/props_combine/suit_charger001.mdl", 5000, 4, "/buyarmorlab", {TEAM_DOCTOR, TEAM_glDOCTOR}, false)
rp.AddEntity("Раздатчик ХП", "med_lab", "models/props_combine/health_charger001.mdl", 5000, 4, "/buymedlab", {TEAM_DOCTOR, TEAM_glDOCTOR}, false)

-- Bartender
rp.AddShipment("Грушовый сок", "models/drug_mod/alcohol_can.mdl", "durgz_alcohol", 1500, 5, false, 50, false, {TEAM_BARTENDER})
rp.AddShipment("HQD яблоко", "models/hqd_a/hqd_a.mdl", "weapon_vape_apple", 1550, 5, false, 50, false, {TEAM_BARTENDER})
rp.AddShipment("HQD черника", "models/hqd_b/hqd_b.mdl", "weapon_vape_blueberry", 1550, 5, false, 50, false, {TEAM_BARTENDER})
rp.AddShipment("HQD виноград", "models/hqd_g/hqd_g.mdl", "weapon_vape_grapery", 1550, 5, false, 50, false, {TEAM_BARTENDER})
rp.AddShipment("HQD лёд-манго", "models/hqd_i/hqd_i.mdl", "weapon_vape_icemango", 1550, 5, false, 50, false, {TEAM_BARTENDER})
rp.AddShipment("HQD ананас", "models/hqd_p/hqd_p.mdl", "weapon_vape", 1550, 5, false, 50, false, {TEAM_BARTENDER})
rp.AddShipment("Вода", "models/drug_mod/the_bottle_of_water.mdl", "durgz_water", 1000, 5, false, 30, false, {TEAM_BARTENDER})

rp.AddDrug("Трава", "durgz_weed", "models/katharsmodels/contraband/zak_wiet/zak_wiet.mdl", 10000, TEAM_GUN1)
rp.AddDrug("Героин", "durgz_heroine", "models/katharsmodels/syringe_out/syringe_out.mdl", 10000, TEAM_GUN1)
rp.AddDrug("Сигареты", "durgz_cigarette", "models/boxopencigshib.mdl", 5000, TEAM_GUN1)
rp.AddDrug("ЛСД", "durgz_lsd", "models/smile/smile.mdl", 5000, TEAM_GUN1)
rp.AddDrug("Грибы", "durgz_mushroom", "models/ipha/mushroom_small.mdl", 5000, TEAM_GUN1)
rp.AddDrug("Кокаин", "durgz_cocaine", "models/cocn.mdl", 5000, TEAM_GUN1)
rp.AddDrug("Синий мет", "durgz_meth", "models/cocn.mdl", 5000, TEAM_GUN1)
rp.AddDrug("Соли", "durgz_bathsalts", "models/props_lab/jar01a.mdl", 5000, TEAM_GUN1)

hook.Call('rp.AddEntities', GAMEMODE)

-- Ammo
-- rp.AddAmmoType('tfa_ammo_winchester', 'Винчестерные патроны', 'models/Items/sniper_round_box.mdl', 350, 25)
rp.AddAmmoType('AR2', 'Крупнокалиберные патроны', 'models/Items/BoxSRounds.mdl', 340, 60)
-- rp.AddAmmoType('ammo_asmd', 'Омега патроны', 'models/Items/BoxSRounds.mdl', 300, 60)
rp.AddAmmoType('357', 'Патроны 357', 'models/Items/BoxSRounds.mdl', 270, 18)
rp.AddAmmoType('Pistol', 'Пистолетные патроны', 'models/Items/BoxSRounds.mdl', 280, 50)
rp.AddAmmoType('Buckshot', 'Картечь для дробовика', 'models/Items/BoxBuckshot.mdl', 350, 20)
rp.AddAmmoType('SMG1', 'СМГ патроны', 'models/Items/BoxSRounds.mdl', 300, 40)
rp.AddAmmoType('AR2', 'Снайперские патроны', 'models/Items/sniper_round_box.mdl', 330, 20)

rp.AddEntity("Cнаряды rpg [RPG]", {
	category = 'Категория';
	ent = "item_rpg_round",
	model = "models/Items/AR2_Grenade.mdl",
	price = 1000,
	max = 1,
	cmd = "/buyrpg",
	pocket = false,
	customCheck = function(pl) return pl:HasWeapon("weapon_rpg") end,
})

-- Copshop
rp.AddCopItem("Щит", {
	Price = 25000,
	Weapon = "heavy_shield",
	Model = "models/bshields/hshield.mdl"
})

rp.AddCopItem("Коробка патронов", {
	Price = 500,
	Model = "models/Items/BoxSRounds.mdl",
	Callback = function(pl)
		for k, v in ipairs(rp.ammoTypes) do
			pl:GiveAmmo(120, v.ammoType, true)
		end
	end
})

-- rp.AddCopItem("C4", {
-- 	Price = 15000,
-- 	Model = "models/weapons/2_c4_planted.mdl",
-- 	Weapon = "weapon_c4"
-- })



rp.AddCopItem("Аптечка", {
	Price = 250,
	Model = "models/Items/HealthKit.mdl",
	Callback = function(pl)
		pl:SetHealth(100)
	end
})

rp.AddCopItem("Броня", {
	Price = 300,
	Model = "models/props_junk/cardboard_box004a.mdl",
	Callback = function(pl)
		pl:SetArmor(100)
	end
})


--[[
rp.AddEntity("Аккумулятор", {
	ent = "vc_pickup_fuel_electricity",
	model = "models/props_lab/reciever01c.mdl",
	price = 2700,
	max = 1,
	cmd = "/buyacum",
	category = "Механик",
	allowed = {TEAM_MECHANIC},
	pocket = false
})

rp.AddEntity("Дизель 20 литров", {
	ent = "vc_pickup_fuel_diesel",
	model = "models/props_junk/metalgascan.mdl ",
	price = 2000,
	max = 1,
	cmd = "/buydisel20",
	category = "Механик",
	allowed = {TEAM_MECHANIC},
	pocket = false
})

rp.AddEntity("Бензин 20 литров", {
	ent = "vc_pickup_fuel_petrol",
	model = "models/props_junk/metalgascan.mdl",
	price = 3000,
	max = 1,
	cmd = "/buybenzin200",
	category = "Механик",
	allowed = {TEAM_MECHANIC},
	pocket = false
})

rp.AddEntity("Рем.комплект 10%", {
	ent = "vc_pickup_healthkit_10",
	model = "models/props_c17/tools_wrench01a.mdl",
	price = 2500,
	max = 1,
	cmd = "/buyhealth10prec",
	category = "Механик",
	allowed = {TEAM_MECHANIC},
	pocket = false
})

rp.AddEntity("Рем.комплект 25%", {
	ent = "vc_pickup_healthkit_25",
	model = "models/props_c17/tools_wrench01a.mdl",
	price = 3500,
	max = 1,
	cmd = "/buyhealth25prec",
	category = "Механик",
	allowed = {TEAM_MECHANIC},
	pocket = false
})

rp.AddEntity("Рем.комплект 100%", {
	ent = "vc_pickup_healthkit_100",
	model = "models/props_c17/tools_wrench01a.mdl",
	price = 5500,
	max = 1,
	cmd = "/buyhealth100prec",
	category = "Механик",
	allowed = {TEAM_MECHANIC},
	pocket = false
})

rp.AddEntity("Двигатель", {
	ent = "vc_pickup_engine",
	model = "models/props_c17/TrapPropeller_Engine.mdl",
	price = 4500,
	max = 1,
	cmd = "/buydvizhok",
	category = "Механик",
	allowed = {TEAM_MECHANIC},
	pocket = false
})

rp.AddEntity("Выхлопная труба", {
	ent = "vc_pickup_exhaust",
	model = "models/props_c17/TrapPropeller_Blade.mdl",
	price = 200,
	max = 1,
	cmd = "/buyexhaust",
	category = "Механик",
	allowed = {TEAM_MECHANIC},
	pocket = false
})

rp.AddEntity("Фара", {
	ent = "vc_pickup_light",
	model = "models/props_c17/canister01a.mdl",
	price = 1000,
	max = 1,
	cmd = "/buyfara",
	category = "Механик",
	allowed = {TEAM_MECHANIC},
	pocket = false
})

rp.AddEntity("Колесо", {
	ent = "vc_pickup_tire",
	model = "models/props_vehicles/tire001c_car.mdl",
	price = 2700,
	max = 1,
	cmd = "/buywheel",
	category = "Механик",
	allowed = {TEAM_MECHANIC},
	pocket = false
})
--]]

--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
