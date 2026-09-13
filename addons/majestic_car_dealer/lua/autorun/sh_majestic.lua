Majestic = Majestic or {}
Majestic.vehicleTable = Majestic.vehicleTable or {}
Majestic.dealerSpawns = Majestic.dealerSpawns or {}

Majestic.cfg = {
	-- Автоматическая посадка игрока за руль
    AutoEnter = false; -- НЕ МЕНЯЛ by GERO
	-- Проверять занято ли место машиной/энтити или нет
    CheckSpawn = true; -- НЕ МЕНЯЛ by GERO
	-- Дистанция для которой требуется, чтобы вернуть машину в гараж
    StoreDistance = 120; -- НЕ МЕНЯЛ by GERO
	-- Вкл/Выкл тестдрайв
	TestDrive = true; -- НЕ МЕНЯЛ by GERO
	-- Время тестдрайва
    TestDriveTime = 60; -- НЕ МЕНЯЛ by GERO
	-- После тестдрайва нужно ли его телепортировать на точку указанную ниже
	TestDriveTP = true;
	-- Позиция на которую отправится игрок после конца тестдрайва
	TestDrivePos = Vector(-1945.1134033203, -5006.3935546875, -195.96875);
	-- Позиция от нпс, чтобы делать какие-лтбо дейтсвия с ним
	RangeDistance = 264; -- НЕ МЕНЯЛ by GERO

	-- Местоположение машины в менюшке
	CarVector = Vector(-3380, -800, -13871); -- НЕ МЕНЯЛ by GERO
	-- Угол машины в менюшке
	CarAngle = Angle(0, -120, 0); -- НЕ МЕНЯЛ by GERO
	
	-- Местоположение камеры в менюшке
	CameraPos = Vector( -3250, -900, -13890 ); -- НЕ МЕНЯЛ by GERO
	-- Угол камеры в менюшке
	CameraAng = Angle( 0, 145, 0 ); -- НЕ МЕНЯЛ by GERO

	-- Ранги, которые имеют доступ к премиум покупке тачке
	Ranks = {
		['*'] = true;
		['vip'] = true;
	};
}

-- Перевод текста
Majestic.Language = {
    ChangeJob = 'Вы больше не имеете права на свой автомобиль. ';
    CustomCheck = 'Этот автомобиль в настоящее время недоступен для вас.';
    Range = 'Вы находитесь вне зоны действия автосалона!';
    NoCar = 'Запрошенного автомобиля нет в вашем гараже.';
    Stored = 'Ваш автомобиль припаркован в гараж.';
    NextDrive = 'Вы можете протестировать этот автомобиль в течении: ';
    RanOut = 'Ваш тест-драйв закончился!';
	NoSell = 'Запрошенный автомобиль не продается.';
	FailMsg = 'Этот автомобиль в настоящее время недоступен для вас.';
	CantAfford = 'Вы не можете позволить себе этот автомобиль.';
	Spawned = 'Ваш транспорт доставлен на парковку.';
	IsVip = 'У вас нет доступа к премиум машинам.';
}

-- Цветовая палитра, материалы
Majestic.Scheme = {
    Colors = {
        white = Color(255,255,255);
        black = Color(20, 20, 20);
        rose = Color(223, 0, 91);
		txt = Color(139, 139, 139);
		outline = Color(0,255,128);
		grey = Color(32, 32, 32);
		grey_hover = Color(42, 42, 42);
    };

	VehicleColors = {
		Color(255, 255, 255); -- white
		Color(153, 157, 160); -- grey
		Color(218, 25, 24); -- red
		Color(247, 134, 22); -- orange
		Color(255, 207, 32); -- yellow
		Color(21, 92, 45); -- green
		Color(66, 113, 225); -- blue
		Color(98, 18, 118); -- viol
		Color(119, 92, 62); -- brown
	};

    Mats = {
        logo = Material('sincopa/majestic/logo2.png', 'smooth mips');
		def = Material('sincopa/majestic/dollar.png', 'smooth mips');
		prem = Material('sincopa/majestic/prem.png', 'smooth mips');
		srch = Material('sincopa/majestic/search.png', 'smooth mips');
		exit = Material('sincopa/majestic/arrow.png', 'smooth mips');
		check = Material('sincopa/majestic/check.png', 'smooth mips');
    };
}

-- Таблицы с машинами
Majestic.vehicleTable['bmw1mtdm'] = { -- класс машины
    price = 1000000; -- цена
	speed = 267; -- скорость
	boost = 80; -- ускорение
	brake = 90; -- торможение
	control = 60; -- управляемость
    vip = false; -- Премиум машина или нет
}

Majestic.vehicleTable['bmw_340itdm'] = {
    price = 500;
	speed = 267;
	boost = 80;
	brake = 90;
	control = 60;
}

Majestic.vehicleTable['bmwm5e60tdm'] = {
    price = 500;
	speed = 267;
	boost = 80;
	brake = 90;
	control = 60;
}

Majestic.vehicleTable['bmwm613tdm'] = {
    price = 500;
	speed = 267;
	boost = 80;
	brake = 90;
	control = 60;
}

Majestic.vehicleTable['bmwm3gtrtdm'] = {
    price = 500;
	speed = 267;
	boost = 80;
	brake = 90;
	control = 60;
}

Majestic.vehicleTable['m3e92tdm'] = {
    price = 500;
	speed = 267;
	boost = 80;
	brake = 90;
	control = 60;
}

Majestic.vehicleTable['m1tdm'] = {
    price = 500;
	speed = 267;
	boost = 80;
	brake = 90;
	control = 60;
}

Majestic.vehicleTable['che_camarozl1tdm'] = {
    price = 500;
	speed = 267;
	boost = 80;
	brake = 90;
	control = 60;
}

Majestic.vehicleTable['focusrstdm'] = {
    price = 500;
	speed = 267;
	boost = 80;
	brake = 90;
	control = 60;
	vip = true;
}

Majestic.vehicleTable['for_focus_rs16tdm'] = {
    price = 500;
	speed = 267;
	boost = 80;
	brake = 90;
	control = 60;
	vip = true;
}

Majestic.vehicleTable['gt05tdm'] = {
    price = 500;
	speed = 267;
	boost = 80;
	brake = 90;
	control = 60;
}

Majestic.vehicleTable['mustanggttdm'] = {
    price = 500;
	speed = 267;
	boost = 80;
	brake = 90;
	control = 60;
	vip = true;
}

Majestic.vehicleTable['raptorsvttdm'] = {
    price = 500;
	speed = 267;
	boost = 80;
	brake = 90;
	control = 60;
	vip = true;
}

Majestic.vehicleTable['for_she_gt500tdm'] = {
    price = 500;
	speed = 267;
	boost = 80;
	brake = 90;
	control = 60;
}

Majestic.vehicleTable['r34tdm'] = {
    price = 500;
	speed = 267;
	boost = 80;
	brake = 90;
	control = 60;
}

Majestic.vehicleTable['gtrtdm'] = {
    price = 500;
	speed = 267;
	boost = 80;
	brake = 90;
	control = 60;
	vip = true;
}

Majestic.vehicleTable['supratdm'] = {
    price = 500;
	speed = 267;
	boost = 80;
	brake = 90;
	control = 60;
}

Majestic.vehicleTable['997gt3tdm'] = {
    price = 500;
	speed = 267;
	boost = 80;
	brake = 90;
	control = 60;
}

Majestic.vehicleTable['cayennetdm'] = {
    price = 500;
	speed = 267;
	boost = 80;
	brake = 90;
	control = 60;
	vip = true;
}

Majestic.dealerSpawns['rp_downtown_tits_v2'] = { -- название карты
	{
		pos = Vector(-2293.666015625, -4979.865234375, -195.96875); -- позиция диллера
		ang = Angle(0, 90, 0); -- угол диллера
		mdl = 'models/breen.mdl'; -- модель диллера

		spawns = { -- позиции спавна машин этого диллера
			{
				pos = Vector(-2196.1220703125, -5294.41015625, -195.96875);
				ang = Angle(1, -0.5, 0);
			};
			{
				pos = Vector(-2188.8142089844, -5562.5625, -195.96875);
				ang = Angle(1, -0.5, 0);
			};																	
		};
	};

	{
		pos = Vector(-2293.666015625, -4979.865234375, -195.96875),
		ang = Angle(0, 90, 0),
		mdl = 'models/player/breen.mdl',

		spawns = { -- позиции спавна машин этого диллера
			{
				pos = Vector(-2196.1220703125, -5294.41015625, -195.96875);
				ang = Angle(1, -0.5, 0);
			};
			{
				pos = Vector(-2188.8142089844, -5562.5625, -195.96875);
				ang = Angle(1, -0.5, 0);
			},																							
		},
	},
}