--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

gmrp = {}

local multpokls = 7
local mutlfirff = 5

gmrp.tablekiosk = {}
gmrp.ShopItems = {
	[1] = {
		["CustomCheck"] = {1},
		["pos"] = 	Vector(-1710, -1162, -195),
		["ang"] = 	Angle(0,-90,0),
		["name"] = 	"Магазин продовольствия",
		["items"] = {
					["Вода"] = {				["Model"] = "models/props/cs_office/Water_bottle.mdl",		["ent"] = "water", 			["type"] = "food",	["Cost"] = 600 * .8 * multpokls},
					["Яйцо"] = {				["Model"] = "models/props_phx/misc/egg.mdl",				["ent"] = "egg",			["type"] = "food",	["Cost"] = 130 * .8  * multpokls},
					["Масло"] = {				["Model"] = "models/props_junk/GlassBottle01a.mdl",			["ent"] = "oil",			["type"] = "food",	["Cost"] = 600 * .8  * multpokls},
					["Тост"] = {				["Model"] = "models/foods/toast1.mdl",						["ent"] = "tost",			["type"] = "food",	["Cost"] = 110 * .8  * multpokls},
					["Сырое мясо"] = {			["Model"] = "models/foods/backbacon.mdl",					["ent"] = "meat",			["type"] = "food",	["Cost"] = 80 * .8  * multpokls},
					["Соус"] = {				["Model"] = "models/foods/lemoncleaner.mdl",				["ent"] = "sauce",			["type"] = "food",	["Cost"] = 80 * .8  * multpokls},
					["Огурцы"] = {				["Model"] = "models/foods/picklejar.mdl",					["ent"] = "cucumbers",		["type"] = "food",	["Cost"] = 600 * .8  * multpokls},
					["Сырая сосиска"] = {		["Model"] = "models/foods/sausage.mdl",						["ent"] = "sausage",		["type"] = "food",	["Cost"] = 130 * .8  * multpokls},
					["Тесто"] = {				["Model"] = "models/foods/twinkie.mdl",						["ent"] = "dough",			["type"] = "food",	["Cost"] = 80 * .8  * multpokls},
					["Хлопья"] = {				["Model"] = "models/foods/applejacks.mdl",					["ent"] = "cereals",		["type"] = "food",	["Cost"] = 80 * .8  * multpokls},
					["Молоко"] = {				["Model"] = "models/foods/milk.mdl",						["ent"] = "milk",			["type"] = "food",	["Cost"] = 600 * .8  * multpokls},
					["Основа для пицы"] = {		["Model"] = "models/foods/pancakesingle.mdl",				["ent"] = "pizzabase",		["type"] = "food",	["Cost"] = 90 * .8  * multpokls},
					["Куриная ножка сырая"] = {	["Model"] = "models/foods/mcdfriedchickenleg.mdl",			["ent"] = "rawchickenleg",	["type"] = "food",	["Cost"] = 110 * .8  * multpokls},
		},
	},
	[2] = {
		["CustomCheck"] = {2},
		["pos"] = 	Vector(-1653, -1162, -195),
		["ang"] = 	Angle(0,-90,0),
		["name"] = 	"Магазин семян",
		["items"] = {
					["Яблоня"] = {					["Model"] = "models/props/cs_office/plant01_p1.mdl",			["ent"] = "apple",			["type"] = "seed",	["Cost"] = 50 * mutlfirff},
					["Банановое дерево"] = {		["Model"] = "models/props/de_dust/palm_tree_head_skybox.mdl",	["ent"] = "bananna",		["type"] = "seed",	["Cost"] = 100 * mutlfirff},
					["Куст капусты"] = {			["Model"] = "models/props/de_inferno/largebush01.mdl",			["ent"] = "cabbage",		["type"] = "seed",	["Cost"] = 60 * mutlfirff},
					["Куст цветной капусты"] = {	["Model"] = "models/props/de_inferno/largebush01.mdl",			["ent"] = "cauliflower",	["type"] = "seed",	["Cost"] = 60 * mutlfirff},
					["Лимонное дерево"] = {			["Model"] = "models/props/cs_office/plant01_p1.mdl",			["ent"] = "lemon",			["type"] = "seed",	["Cost"] = 50 * mutlfirff},
					["Апельсиновое дерево"] = {		["Model"] = "models/props/cs_office/plant01_p1.mdl",			["ent"] = "orange",			["type"] = "seed",	["Cost"] = 50 * mutlfirff},
					["Картофель"] = {				["Model"] = "models/props/de_inferno/fountain_bowl_p10.mdl",	["ent"] = "potato",			["type"] = "seed",	["Cost"] = 70 * mutlfirff},
					["Куст помидоров"] = {			["Model"] = "models/props/de_inferno/largebush02.mdl",			["ent"] = "tomato",			["type"] = "seed",	["Cost"] = 100 * mutlfirff},
					["Куст арбуза"] = {				["Model"] = "models/props/de_inferno/fountain_bowl_p10.mdl",	["ent"] = "watermelon",		["type"] = "seed",	["Cost"] = 150 * mutlfirff},
		},
	},
}

gmrp.NaemnikShop = {			
	["pos"] = Vector(-1287, -1453, 136-64),
	["ang"] = Angle(0, 0, 0),
	["Name"]= "Создать организацию",	
}

gmrp.CopShop = {
	["pos"] = Vector(4128, -646, 136-64),
	["ang"] = Angle(0, 0, 0),
	["Name"]= "Выдача арсенала",	
}
gmrp.CopShopItems = {
	["Helth"] = {
		["func"] = function(pl) pl:SetHealth(100) end,
		["model"] = "models/Items/HealthKit.mdl",
		["name"] = "Пополнить здоровье",
	},
	["Armor"] = {
		["func"] = function(pl) pl:SetArmor(100) end,
		["model"] = "models/Items/battery.mdl",
		["name"] = "Пополнить броню",
	},
	["Ammo1"] = {
		["func"] = function(pl)  pl:GiveAmmo( 200, "Pistol", true ) end,
		["model"] = "models/Items/BoxSRounds.mdl",
		["name"] = "Пистолетные патроны",
	},
	["Ammo2"] = {
		["func"] = function(pl) pl:GiveAmmo( 200, "Buckshot", true ) end,
		["model"] = "models/Items/BoxBuckshot.mdl",
		["name"] = "Картечь для дробавика",
	},
	["Ammo3"] = {
		["func"] = function(pl) pl:GiveAmmo( 200, "smg1", true ) end,
		["model"] = "models/Items/BoxSRounds.mdl",
		["name"] = "СМГ Патроны",
	},
	["Ammo4"] = {
		["func"] = function(pl) pl:GiveAmmo( 200, "Rifle", true ) end,
		["model"] = "models/Items/BoxSRounds.mdl",
		["name"] = "Крупнокалиберные патроны",
	},
}

--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
