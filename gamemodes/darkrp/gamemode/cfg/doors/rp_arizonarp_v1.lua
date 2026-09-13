rp.cfg.Doors = {
	-- team doors +
	{
		Name = 'Админ Зона',
		Teams = { TEAM_ADMIN },
		MapIDs = { 1273,1270,1274,1271,1272,1268,1275,1269,1276,1267 }
	},
	{
		Name = 'Полицейский участок',
		Teams = { TEAM_POLICE, TEAM_CHIEF, TEAM_MAYOR, TEAM_FBR, TEAM_SWAT, TEAM_SWATLEADER },
		Locked = true,
		MapIDs = { 2913,2912,2848,2849,2854,2855,2856,2897,2899,2900,2903,2895,2850,2862 }
	},
	{
		Name = 'Мэрия',
		Teams = { TEAM_MAYOR, TEAM_POLICE, TEAM_CHIEF, TEAM_FBR, TEAM_SWAT, TEAM_SWATLEADER },
		Locked = true,
		MapIDs = {2723,2724,2750,2745,2731,2732,2734,2733,2916,2759,2760,2773  }
	},
	{
		Name = 'Хранилище',
		Teams = { TEAM_MAYOR, TEAM_POLICE, TEAM_CHIEF, TEAM_FBR, TEAM_SWAT, TEAM_SWATLEADER },
		Locked = true,
		MapIDs = {2785,2832,2826,2794  }
	},
	-- Помещения
	{
		Name = 'Помещение #1',
		MapIDs = { 1364 }
	},
	{
		Name = 'Помещение #2',
		MapIDs = {1363 }
	},
	{
		Name = 'Помещение #3',
		MapIDs = { 1487,1488 }
	},
	{
		Name = 'Помещение #4',
		MapIDs = {1369  }
	},
	{
		Name = 'Помещение #5',
		MapIDs = { 2909,2524 }
	},
	{
		Name = 'Помещение #6',
		MapIDs = {1424  }
	},
	{
		Name = 'Помещение #7',
		MapIDs = {1876  }
	},
	{
		Name = 'Помещение #8',
		MapIDs = {1489  }
	},
	{
		Name = 'Помещение #9',
		MapIDs = {2120  }
	},
	{
		Name = 'Помещение #10',
		MapIDs = { 1877,1879,1878 }
	},
	{
		Name = 'Помещение #11',
		MapIDs = {  2119}
	},
-- ANGARI
	{
		Name = 'Ангар',
		MapIDs = {1492,1491,2291,2293}
	},
	{
		Name = 'Нижний Ангар',
		MapIDs = {1378,1362,1379}
	},
--DOMA
	{
		Name = 'Дом #1',
		MapIDs = {1380}
	},
-- BYNKER
	{
		Name = 'Бункер',
		MapIDs = {1398,1460,1461 }
	},
-- PEREYLOK
	{
		Name = 'Переулок',
		Teams = {},
		MapIDs = { 1427,1428 }
	},
	{
		Name = 'Квартира 1',
		MapIDs = {1429 }
	},
	{
		Name = 'Квартира 2',
		MapIDs = { 1430}
	},
-- KLYB
	{
		Name = 'Клуб',
		MapIDs = { 1484,1485,1486 }
	},
-- TORGOVI CENTR
	{
		Name = 'Торговый центр #1',
		MapIDs = {2278,2279}
	},
	{
		Name = 'Торговый центр #2',
		MapIDs = {2286,2288}
	},
	{
		Name = 'Торговый центр #3',
		MapIDs = {2492,2493  }
	},
	{
		Name = 'Торговый центр #4',
		MapIDs = {2490,2491  }
	},
	{
		Name = 'Торговый центр #5',
		MapIDs = {2488,2489 }
	},
-- CERKOV
	{
		Name = 'Церковь',
		Teams = {},
		MapIDs = { 2322,2321 }
	},
-- BOLNICA
	{
		Name = 'Больница',
		Teams = { TEAM_DOCTOR },
		Locked = true,
		MapIDs = { 2181,2182,2185,2194,2183,2184 }
	},
	-- hotel doors +
	{
		Name = 'Отель',
		Teams = { TEAM_HOTEL },
		MapIDs = { 1418,1419 }
	},
	{
		Name = 'Номер #1',
		MapIDs = {1420 }
	},
	{
		Name = 'Номер #2',
		MapIDs = {1421 }
	},
	-- obshaga doors +
	{
		Name = 'Общежитие',
		Teams = {},
		MapIDs = {1370,1371,2161 }
	},
	{
		Name = 'Комната #1',
		MapIDs = { 1407,1410,1411 }
	},
	{
		Name = 'Комната #2',
		MapIDs = {1408,1328,1409  }
	},
	{
		Name = 'Комната #3',
		MapIDs = {1415,1416,1417  }
	},
	{
		Name = 'Комната #4',
		MapIDs = { 1414,1413,1412 }
	},
	-- BALKON
	{
		Name = 'Дом с балконом',
		MapIDs = {1422,1423}
	},
	-- PATIETASHKA
	{
		Name = 'Пятиэтажка',
		Teams = {},
		MapIDs = { 1397,1396,1426,1425 }
	},
	{
		Name = 'Квартира #1',
		MapIDs = { 1457,1458,1459,1437 }
	},
	{
		Name = 'Квартира #2',
		MapIDs = { 1456,1454,1455,1436 }
	},
	{
		Name = 'Квартира #3',
		MapIDs = { 1439,1441,1440 }
	},
	{
		Name = 'Квартира #4',
		MapIDs = { 1451,1452,1453,1435}
	},
	{
		Name = 'Квартира #5',
		MapIDs = { 1450,1448,1449,1434 }
	},
	{
		Name = 'Квартира #6',
		MapIDs = { 1438,1405,1406 }
	},
	{
		Name = 'Квартира #7',
		MapIDs = { 1445,1446,1447,1433 }
	},
	{
		Name = 'Квартира #8',
		MapIDs = { 1444,1442,1443,1432}
	},
	{
		Name = 'Квартира #9',
		MapIDs = { 1401,1402,1404,1403 }
	},
	{
		Name = 'Квартира #10',
		MapIDs = { 1392,1394,1399,1391 }
	},
	{
		Name = 'Квартира #11',
		MapIDs = { 1393,1395,1400,1390 }
	},
-- ELITKA
	{
		Name = 'Элитный дом #1',
		MapIDs = {1387,1389,1388 }
	},
	{
		Name = 'Элитный дом #2',
		MapIDs = { 1386,1385,1384 }
	},
	{
		Name = 'Элитный дом #3',
		MapIDs = {1382,1383,1381 }
	},
	{
		Name = 'Элитный дом #4',
		MapIDs = { 1367,1368,1366}
	},
	{
		Name = 'Элитный дом #5',
		MapIDs = {1480,1479,1477,1478,1474,1476,1475}
	},
	{
		Name = 'Элитный дом #6',
		MapIDs = { 1472,1471,1469,1470,1466,1467,1468 }
	},
-- VOENKA
	{
		Name = 'Казарма',
		Teams = {},
		MapIDs = { 2494 }
	},
	{
		Name = 'Военная Вышка',
		Teams = {},
		MapIDs = { 2515,2512 }
	},
	{
		Name = 'Строение #1',
		Teams = {},
		MapIDs = { 2501,2509,2511 }
	},
-- VISHKA
	{
		Name = 'Вышка',
		MapIDs = {2465,2463 }
	},
-- DRYGOE
	{
        Name = '',
		Teams = {},
		Locked = false,
		MapIDs = {2894,2889,2884,2883,2881,2877,1881,1884,1431,1350,1344,1345,1493,2406,1875,1883,1882,1880,1874,1873}
	},
}