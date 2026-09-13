--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

HFM_Config = {}

HFM_Config.MaxPlayerHealth = 100
HFM_Config.MaxPlayerHunger = 100
HFM_Config.MaxPlayerThirsty = 999999

HFM_Config.StartHunger = 0.5
HFM_Config.StartThirsty = 999999

HFM_Config.Healing = 36
HFM_Config.DropTime = 56
HFM_Config.DropHunger = 1
HFM_Config.DropThirsty = 0

HFM_Config.LowDmgHunger = 20
HFM_Config.LowDmgThirsty = 8
HFM_Config.LowHungryMessage = "Я голоден! Срочно нужно поесть!"
HFM_Config.LowThirstyMessage = "Я хочу пить! Нужно что-то выпить!"

HFM_Config.HUDDangerMin = 10
HFM_Config.HUDEntDrawDistance = 200
HFM_Config.HUDEntUseDistance = 96

HFM_Config.StovePrice = 1000
HFM_Config.StoveBurnTime = 20

HFM_Config.KioskPrice = 500

HFM_Config.Fertilizer = {}
HFM_Config.Fertilizer.Name = "Удобрение"
HFM_Config.Fertilizer.Model = "models/props_junk/garbage_bag001a.mdl"
HFM_Config.Fertilizer.Price = 50



HFM_Config.TableFoods = {
	["apple"] 	= 			{ { "Яблоко",					Color(138, 239,  95),	Vector(0, 0, 10),	"models/props/de_inferno/crate_fruit_break_gib2.mdl" },		{20,	5,		2,		4,		0,		0,		120,		150},	"Food"},
	["bananna"] = 			{ { "Банан",					Color(200, 200,   0),	Vector(0, 0, 10),	"models/props/cs_italy/bananna.mdl" },						{10,	5,		2,		4,		0,		0,		80,			110},	"Food"},
	["cabbage"] = 			{ { "Капуста",					Color(100, 130,  50),	Vector(0, 0, 10),	"models/foods/cabbage1.mdl" },								{20,	10,		0,		0,		0,		0,		90,			120},	"Food"},
	["cauliflower"] = 		{ { "Цветная капуста",			Color(150,  50, 200),	Vector(0, 0, 10),	"models/foods/cabbage2.mdl" },								{15,	10,		0,		0,		0,		0,		90,			120},	"Food"},
	["lemon"] = 			{ { "Лимон",					Color(225, 255,   0),	Vector(0, 0, 10),	"models/foods/lemon.mdl" },									{0,		0,		2,		2,		0,		0,		100,		130},	"Food"},
	["orange"] = 			{ { "Апельсин",					Color(255, 150,   0),	Vector(0, 0, 10),	"models/props/cs_italy/orange.mdl" },						{10,	2,		10,		10,		0,		0,		120,		150},	"Food"},
	["potato"] = 			{ { "Картофель",				Color(130,  80,  30),	Vector(0, 0, 10),	"models/props_phx/misc/potato.mdl" },						{20,	10,		0,		0,		0,		0,		50, 	 	 80},	"Food"},
	["tomato"] = 			{ { "Помидор",					Color(175,   0,   0),	Vector(0, 0, 10),	"models/props/cs_italy/orange.mdl" },						{5,		2,		10,		10,		0,		0,		80,			110},	"Food"},
	["watermelon"] = 		{ { "Арбуз",					Color(119, 214,  25),	Vector(0, 0, 10),	"models/props_junk/watermelon01.mdl" },						{10,	10,		30,		10,		0,		0,		40, 		 70},	"Food"},
	
	["water"] = 			{ { "Вода",						Color(  0,   0, 255),	Vector(0, 0, 10),	"models/props/cs_office/Water_bottle.mdl" },				{0,		0,		25,		5,		0,		0,		500,		600},	"ShopItem",	10	},
	["egg"] = 				{ { "Яйцо",						Color(255, 255, 255),	Vector(0, 0, 10),	"models/props_phx/misc/egg.mdl" },							{1,	 	1,		1,		1,		0,		0,		100,		130},	"ShopItem",	15	},
	["oil"] = 				{ { "Масло",					Color(255, 255,   0),	Vector(0, 0, 10),	"models/props_junk/GlassBottle01a.mdl" },					{1,		1,		1,		1,		-20,	1,		500,		600},	"ShopItem",	11	},
	["tost"] = 				{ { "Тост",						Color(194, 103,  22),	Vector(0, 0, 10),	"models/foods/toast1.mdl" },								{10,	5,		0,		0,		0,		0,		80,			110},	"ShopItem",	5	},
	["meat"] = 				{ { "Сырое мясо",				Color(189,  49,  49),	Vector(0, 0, 10),	"models/foods/backbacon.mdl" },								{7,		5,		0,		0,		-35,	5,		50,			 80},	"ShopItem",	20	},
	["sauce"] = 			{ { "Соус",						Color(189,  49,  49),	Vector(0, 0, 10),	"models/foods/lemoncleaner.mdl" },							{0,	 	0,		0,		0,		0,		0,		500,		600},	"ShopItem",	3	},
	["cucumbers"] = 		{ { "Огурцы",					Color( 58, 110,  25),	Vector(0, 0, 10),	"models/foods/picklejar.mdl" },								{5,		2,		5,		2,		0,		0,		100,		130},	"ShopItem",	9	},
	["sausage"] = 			{ { "Сырая сосиска",			Color(217, 110,  76),	Vector(0, 0, 10),	"models/foods/sausage.mdl" },								{7,		3, 		-5,		5,		-5,		0,		50,			 80},	"ShopItem",	15	},
	["dough"] = 			{ { "Тесто",					Color(235, 235, 177),	Vector(0, 0, 10),	"models/foods/twinkie.mdl" },								{5,	 	5,		-20,	5, 		0,		0,		50,			 80},	"ShopItem",	5	},
	["cereals"] = 			{ { "Хлопья",					Color(238, 186,  14),	Vector(0, 0, 10),	"models/foods/applejacks.mdl" },							{20,	10,		-20,	10,		0,		0,		500,		600},	"ShopItem",	20	},
	["milk"] = 				{ { "Молоко",					Color(255, 255, 255),	Vector(0, 0, 10),	"models/foods/milk.mdl" },									{0,		0,		20,		10,		0,		0,		500,		600},	"ShopItem",	14	},
	["pizzabase"] = 		{ { "Основа для пицы",			Color(216, 187, 151),	Vector(0, 0, 10),	"models/foods/pancakesingle.mdl" },							{5,		5,		-10,	5,		0,		0,		50,			 80},	"ShopItem",	16	},
	["rawchickenleg"] = 	{ { "Куриная ножка сырая",		Color(246, 199, 197),	Vector(0, 0, 10),	"models/foods/mcdfriedchickenleg.mdl" },	 				{5,		5,		0,		0,		-20,	5,		50,			 80},	"ShopItem",	25	},
	
	["omelette"] = 			{ { "Яичница",					Color(246, 236, 206),	Vector(0, 0, 10),	"models/foods/egg.mdl" },									{10,	20,		0,		0,		0,		0,		50,		  	 80},	"CookedItem", { 13, {"oil", 1, "egg", 1 } } },
	["grilledmeat"] = 		{ { "Жареное мясо",				Color(255, 177,  92),	Vector(0, 0, 10),	"models/foods/backbacon.mdl" },	 							{20,	10,		0,		0,		0,		0,		50,		 	 80},	"CookedItem", { 15, {"oil", 1, "meat", 1 } } },
	["sandwich"] = 			{ { "Сэндвич",					Color(132,  53,  17),	Vector(0, 0, 10),	"models/foods/bigsandwich.mdl" },	 						{45,	10,		0,		0,		0,		0,		50,		 	 80},	"CookedItem", { 25, {"friedtoast", 2, "tomato", 1, "cabbage", 1, "grilledmeat", 1 } } },
	["fries"] = 			{ { "Картофель фри",			Color(219, 160,  34),	Vector(0, 0, 10),	"models/foods/chipbunch.mdl" },								{10,	10,		0,		0,  	0,		0,		50,		 	 80},	"CookedItem", { 10, {"oil", 1, "potato", 5 } } },
	["sprite"] = 			{ { "Спрайт",					Color(246, 199, 197),	Vector(0, 0, 10),	"models/foods/sprunk1.mdl" },	 			 				{0,		0,		30,		20,		0,		0,		500,		600},	"CookedItem", { 10,	{"lemon", 5, "water", 1 } } },
	["applej"] = 			{ { "Яблочный сок",				Color(254, 199,  30),	Vector(0, 0, 10),	"models/foods/juicesmall.mdl" },	 						{0,		0,		20,		10,		0,		0,		500,		600},	"CookedItem", { 7, 	{"apple", 3, "water", 1 } } },
	["hamburger"] = 		{ { "Гамбургер",				Color(132,  53,  17),	Vector(0, 0, 10),	"models/foods/burgergtasa.mdl" },	 						{60,	30,		0,		0,		0,		0,		50,			 80},	"CookedItem", { 50, {"tost", 3, "sauce", 1, "grilledmeat", 2, "cucumbers", 1, "cabbage", 1, "tomato", 1 } } },
	["hotdog"] = 			{ { "Сосиска в тесте",			Color(217, 110,  76),	Vector(0, 0, 10),	"models/foods/hotdog.mdl" },	 							{30,	15,		0,		0,		0,		0,		50,			 80},	"CookedItem", { 30, {"dough", 1, "sausage", 1 } } },
	["milkcereals"] = 		{ { "Хлопья с молоком",			Color(238, 186,  14),	Vector(0, 0, 10),	"models/foods/cerealbowl.mdl" },	 						{20,	10,		10,		10,		0,		0,		30,			 50},	"CookedItem", { 20, {"cereals", 1, "milk", 1 } } },
	["friedtoast"] = 		{ { "Жаренный тост",			Color(194, 103,  22),	Vector(0, 0, 10),	"models/foods/toast.mdl" },							 		{5,		5,		0,		0,		0,		0,		50,			 80},	"CookedItem", { 5, 	{"tost", 1, "oil", 1 } } },
	["pizza"] = 			{ { "Пицца",					Color(246, 199, 147),	Vector(0, 0, 10),	"models/foods/pepperonipizza.mdl" },		   				{100,	50,		0,		0,		0,		0,		50,		 	 80},	"CookedItem", { 70, {"pizzabase", 1, "grilledmeat", 3, "tomato", 5, "cucumbers", 1 } } },
	["chickenlegsfried"] = 	{ { "Куриные ножки жареные",	Color(255, 177,  92),	Vector(0, 0, 10),	"models/foods/mcdfriedchickenlegs.mdl" },					{25,	15,		0,		0,		0,		0,		50,		 	 80},	"CookedItem", { 18, {"rawchickenleg", 2, "oil", 1 } } },
	["cola"] = 				{ { "Кола",						Color(  0,   0,   0),	Vector(0, 0, 10),	"models/foods/cola.mdl" },	 								{0,		0,		100,	15,		0,		0,		500,		600},	"CookedItem", { 35, {"water", 1, "apple", 3, "orange", 3, "lemon", 3 } } }
}


HFM_Config.TableSeeds = {
	["apple"] = 				{"Яблоня",				"apple",		"models/props/cs_office/plant01_p1.mdl",			Vector(0, 0, 80),	Vector(0, 0,	0),	{10, 30, 60},	{4, 8},		{7, 60, 180},	50	},
	["bananna"] =				{"Банановое дерево",	"bananna",		"models/props/de_dust/palm_tree_head_skybox.mdl",	Vector(0, 0, 60),	Vector(0, 0,	4),		{20, 15, 35},	{6, 15},	{3, 60, 180},	100	},
	["cabbage"] = 				{"Куст капусты",		"cabbage",		"models/props/de_inferno/largebush01.mdl",			Vector(0, 0, 40),	Vector(0, 0,	0),		{10, 0, 1},		{1, 3},		{4, 60, 150},	60	},
	["cauliflower"] = 			{"Куст цветной капусты","cauliflower",	"models/props/de_inferno/largebush01.mdl",			Vector(0, 0, 40),	Vector(0, 0,	0),		{10, 0, 1},		{2, 4},		{3, 60, 90},	60 	},
	["lemon"] = 				{"Лимонное дерево",		"lemon",		"models/props/cs_office/plant01_p1.mdl",			Vector(0, 0, 80),	Vector(0, 0,	0),	{10, 30, 60},	{4, 8},		{6, 60, 120},	50	},
	["orange"] = 				{"Апельсиновое дерево",	"orange",		"models/props/cs_office/plant01_p1.mdl",			Vector(0, 0, 80),	Vector(0, 0,	0),	{10, 30, 60},	{4, 8},		{6, 60, 200},	50	},
	["potato"] = 				{"Картофель",			"potato",		"models/props/de_inferno/fountain_bowl_p10.mdl",	Vector(0, 0, 30),	Vector(0, 0,	8.5),	{10, 0, 2},		{8, 12},	{5, 60, 180},	70	},
	["tomato"] = 				{"Куст помидоров",		"tomato",		"models/props/de_inferno/largebush02.mdl",			Vector(0, 0, 55),	Vector(0, 0,	0),		{25, 20, 35},	{8, 16},	{3, 60, 140},	100	},
	["watermelon"] = 			{"Куст арбуза",			"watermelon",	"models/props/de_inferno/fountain_bowl_p10.mdl",	Vector(0, 0, 30),	Vector(0, 0,	8.5),	{2.5, 0, 5},	{1, 1},		{4, 60, 180},	150	}
}

--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
