local container = eui.container

container.items = {}

function container:AddItem(id, name, rarity, icon, isModel, chance, take)
    self.items[id] = self.items[id] or {}
    local tbl = self.items[id]

    tbl[#tbl + 1] = {
        name = name,
        rarity = rarity,
        icon = icon,
        isModel = isModel,
        chance = chance,
        take = take
    }
end

container:AddItem(1, '15.000 рублей', 'Обычный', 'models/props/cs_assault/money.mdl', true, 30, function(pl) pl:AddMoney(15000) end)
container:AddItem(1, '25.000 рублей', 'Обычный', 'models/props/cs_assault/money.mdl', true, 25, function(pl) pl:AddMoney(25000) end)
container:AddItem(1, '40.000 рублей', 'Редкий', 'models/props/cs_assault/money.mdl', true, 20, function(pl) pl:AddMoney(40000) end)
container:AddItem(1, '50.000 рублей', 'Редкий', 'models/props/cs_assault/money.mdl', true, 15, function(pl) pl:AddMoney(50000) end)
container:AddItem(1, '100.000 рублей', 'Эпический', 'models/props/cs_assault/money.mdl', true, 5, function(pl) pl:AddMoney(100000) end)
container:AddItem(1, '15 донат рублей', 'Мифический', 'models/props/cs_assault/money.mdl', true, 3, function(pl) KylDonate.AddDonateCoins(pl:SteamID(), 15) end)
container:AddItem(1, '25 донат рублей', 'Легендарный', 'models/props/cs_assault/money.mdl', true, 2, function(pl) KylDonate.AddDonateCoins(pl:SteamID(), 25) end)


container:AddItem(2, '40.000 рублей', 'Обычный', 'models/props/cs_assault/money.mdl', true, 25, function(pl) pl:AddMoney(40000) end)
container:AddItem(2, '50.000 рублей', 'Обычный', 'models/props/cs_assault/money.mdl', true, 20, function(pl) pl:AddMoney(50000) end)
container:AddItem(2, '70.000 рублей', 'Редкий', 'models/props/cs_assault/money.mdl', true, 15, function(pl) pl:AddMoney(70000) end)
container:AddItem(2, '100.000 рублей', 'Редкий', 'models/props/cs_assault/money.mdl', true, 12, function(pl) pl:AddMoney(100000) end)
container:AddItem(2, '150.000 рублей', 'Эпический', 'models/props/cs_assault/money.mdl', true, 8, function(pl) pl:AddMoney(150000) end)
container:AddItem(2, '200.000 рублей', 'Эпический', 'models/props/cs_assault/money.mdl', true, 7, function(pl) pl:AddMoney(200000) end)
container:AddItem(2, '250.000 рублей', 'Мифический', 'models/props/cs_assault/money.mdl', true, 5, function(pl) pl:AddMoney(250000) end)
container:AddItem(2, '500.000 рублей', 'Легендарный', 'models/props/cs_assault/money.mdl', true, 3, function(pl) pl:AddMoney(500000) end)
container:AddItem(2, '15 донат рублей', 'Редкий', 'models/props/cs_assault/money.mdl', true, 10, function(pl) KylDonate.AddDonateCoins(pl:SteamID(), 15) end)
container:AddItem(2, '25 донат рублей', 'Эпический', 'models/props/cs_assault/money.mdl', true, 7, function(pl) KylDonate.AddDonateCoins(pl:SteamID(), 25) end)
container:AddItem(2, '50 донат рублей', 'Легендарный', 'models/props/cs_assault/money.mdl', true, 3, function(pl) KylDonate.AddDonateCoins(pl:SteamID(), 50) end)



container:AddItem(3, '50.000 рублей', 'Обычный', 'models/props/cs_assault/money.mdl', true, 20, function(pl) pl:AddMoney(50000) end)
container:AddItem(3, '70.000 рублей', 'Обычный', 'models/props/cs_assault/money.mdl', true, 18, function(pl) pl:AddMoney(70000) end)
container:AddItem(3, '100.000 рублей', 'Редкий', 'models/props/cs_assault/money.mdl', true, 15, function(pl) pl:AddMoney(100000) end)
container:AddItem(3, '150.000 рублей', 'Редкий', 'models/props/cs_assault/money.mdl', true, 12, function(pl) pl:AddMoney(150000) end)
container:AddItem(3, '170.000 рублей', 'Редкий', 'models/props/cs_assault/money.mdl', true, 10, function(pl) pl:AddMoney(170000) end)
container:AddItem(3, '200.000 рублей', 'Эпический', 'models/props/cs_assault/money.mdl', true, 8, function(pl) pl:AddMoney(200000) end)
container:AddItem(3, '500.000 рублей', 'Эпический', 'models/props/cs_assault/money.mdl', true, 6, function(pl) pl:AddMoney(500000) end)
container:AddItem(3, '550.000 рублей', 'Мифический', 'models/props/cs_assault/money.mdl', true, 5, function(pl) pl:AddMoney(550000) end)
container:AddItem(3, '700.000 рублей', 'Легендарный', 'models/props/cs_assault/money.mdl', true, 3, function(pl) pl:AddMoney(700000) end)
container:AddItem(3, '15 донат рублей', 'Редкий', 'models/props/cs_assault/money.mdl', true, 10, function(pl) KylDonate.AddDonateCoins(pl:SteamID(), 15) end)
container:AddItem(3, '25 донат рублей', 'Эпический', 'models/props/cs_assault/money.mdl', true, 7, function(pl) KylDonate.AddDonateCoins(pl:SteamID(), 25) end)



container:AddItem(4, '70.000 рублей', 'Обычный', 'models/props/cs_assault/money.mdl', true, 18, function(pl) pl:AddMoney(70000) end)
container:AddItem(4, '100.000 рублей', 'Обычный', 'models/props/cs_assault/money.mdl', true, 15, function(pl) pl:AddMoney(100000) end)
container:AddItem(4, '150.000 рублей', 'Редкий', 'models/props/cs_assault/money.mdl', true, 12, function(pl) pl:AddMoney(150000) end)
container:AddItem(4, '170.000 рублей', 'Редкий', 'models/props/cs_assault/money.mdl', true, 10, function(pl) pl:AddMoney(170000) end)
container:AddItem(4, '200.000 рублей', 'Редкий', 'models/props/cs_assault/money.mdl', true, 8, function(pl) pl:AddMoney(200000) end)
container:AddItem(4, '250.000 рублей', 'Эпический', 'models/props/cs_assault/money.mdl', true, 7, function(pl) pl:AddMoney(250000) end)
container:AddItem(4, '500.000 рублей', 'Эпический', 'models/props/cs_assault/money.mdl', true, 6, function(pl) pl:AddMoney(500000) end)
container:AddItem(4, '550.000 рублей', 'Мифический', 'models/props/cs_assault/money.mdl', true, 5, function(pl) pl:AddMoney(550000) end)
container:AddItem(4, '700.000 рублей', 'Мифический', 'models/props/cs_assault/money.mdl', true, 4, function(pl) pl:AddMoney(700000) end)
container:AddItem(4, '800.000 рублей', 'Легендарный', 'models/props/cs_assault/money.mdl', true, 3, function(pl) pl:AddMoney(800000) end)
container:AddItem(4, '1.000.000 рублей', 'Легендарный', 'models/props/cs_assault/money.mdl', true, 2, function(pl) pl:AddMoney(1000000) end)
container:AddItem(4, '2.000.000 рублей', 'Легендарный', 'models/props/cs_assault/money.mdl', true, 1.5, function(pl) pl:AddMoney(2000000) end)
container:AddItem(4, '3.000.000 рублей', 'Легендарный', 'models/props/cs_assault/money.mdl', true, 1, function(pl) pl:AddMoney(3000000) end)
container:AddItem(4, '15 донат рублей', 'Редкий', 'models/props/cs_assault/money.mdl', true, 10, function(pl) KylDonate.AddDonateCoins(pl:SteamID(), 15) end)
container:AddItem(4, '25 донат рублей', 'Эпический', 'models/props/cs_assault/money.mdl', true, 7, function(pl) KylDonate.AddDonateCoins(pl:SteamID(), 25) end)
container:AddItem(4, '40 донат рублей', 'Мифический', 'models/props/cs_assault/money.mdl', true, 5, function(pl) KylDonate.AddDonateCoins(pl:SteamID(), 40) end)



container:AddItem(5, '500.000 рублей', 'Обычный', 'models/props/cs_assault/money.mdl', true, 20, function(pl) pl:AddMoney(500000) end)
container:AddItem(5, '550.000 рублей', 'Обычный', 'models/props/cs_assault/money.mdl', true, 18, function(pl) pl:AddMoney(550000) end)
container:AddItem(5, '600.000 рублей', 'Редкий', 'models/props/cs_assault/money.mdl', true, 15, function(pl) pl:AddMoney(600000) end)
container:AddItem(5, '700.000 рублей', 'Редкий', 'models/props/cs_assault/money.mdl', true, 12, function(pl) pl:AddMoney(700000) end)
container:AddItem(5, '800.000 рублей', 'Редкий', 'models/props/cs_assault/money.mdl', true, 10, function(pl) pl:AddMoney(800000) end)
container:AddItem(5, '1.000.000 рублей', 'Эпический', 'models/props/cs_assault/money.mdl', true, 8, function(pl) pl:AddMoney(1000000) end)
container:AddItem(5, '2.000.000 рублей', 'Эпический', 'models/props/cs_assault/money.mdl', true, 6, function(pl) pl:AddMoney(2000000) end)
container:AddItem(5, '3.000.000 рублей', 'Мифический', 'models/props/cs_assault/money.mdl', true, 4, function(pl) pl:AddMoney(3000000) end)
container:AddItem(5, '5.000.000 рублей', 'Мифический', 'models/props/cs_assault/money.mdl', true, 3, function(pl) pl:AddMoney(5000000) end)
container:AddItem(5, '7.000.000 рублей', 'Легендарный', 'models/props/cs_assault/money.mdl', true, 2.5, function(pl) pl:AddMoney(7000000) end)
container:AddItem(5, '10.000.000 рублей', 'Легендарный', 'models/props/cs_assault/money.mdl', true, 2, function(pl) pl:AddMoney(10000000) end)
container:AddItem(5, '15 донат рублей', 'Редкий', 'models/props/cs_assault/money.mdl', true, 10, function(pl) KylDonate.AddDonateCoins(pl:SteamID(), 15) end)
container:AddItem(5, '25 донат рублей', 'Эпический', 'models/props/cs_assault/money.mdl', true, 7, function(pl) KylDonate.AddDonateCoins(pl:SteamID(), 25) end)
container:AddItem(5, '40 донат рублей', 'Мифический', 'models/props/cs_assault/money.mdl', true, 5, function(pl) KylDonate.AddDonateCoins(pl:SteamID(), 40) end)

container:AddItem(6, '700.000 рублей', 'Обычный', 'models/props/cs_assault/money.mdl', true, 20, function(pl) pl:AddMoney(700000) end)
container:AddItem(6, '800.000 рублей', 'Обычный', 'models/props/cs_assault/money.mdl', true, 18, function(pl) pl:AddMoney(800000) end)
container:AddItem(6, '1.000.000 рублей', 'Редкий', 'models/props/cs_assault/money.mdl', true, 15, function(pl) pl:AddMoney(1000000) end)
container:AddItem(6, '1.500.000 рублей', 'Редкий', 'models/props/cs_assault/money.mdl', true, 12, function(pl) pl:AddMoney(1500000) end)
container:AddItem(6, '2.000.000 рублей', 'Редкий', 'models/props/cs_assault/money.mdl', true, 10, function(pl) pl:AddMoney(2000000) end)
container:AddItem(6, '2.500.000 рублей', 'Эпический', 'models/props/cs_assault/money.mdl', true, 8, function(pl) pl:AddMoney(2500000) end)
container:AddItem(6, '3.000.000 рублей', 'Эпический', 'models/props/cs_assault/money.mdl', true, 7, function(pl) pl:AddMoney(3000000) end)
container:AddItem(6, '3.500.000 рублей', 'Мифический', 'models/props/cs_assault/money.mdl', true, 5, function(pl) pl:AddMoney(3500000) end)
container:AddItem(6, '5.000.000 рублей', 'Мифический', 'models/props/cs_assault/money.mdl', true, 4, function(pl) pl:AddMoney(5000000) end)
container:AddItem(6, '7.000.000 рублей', 'Легендарный', 'models/props/cs_assault/money.mdl', true, 3, function(pl) pl:AddMoney(7000000) end)
container:AddItem(6, '10.000.000 рублей', 'Легендарный', 'models/props/cs_assault/money.mdl', true, 2.5, function(pl) pl:AddMoney(10000000) end)
container:AddItem(6, '20.000.000 рублей', 'Легендарный', 'models/props/cs_assault/money.mdl', true, 2, function(pl) pl:AddMoney(20000000) end)
container:AddItem(6, '15 донат рублей', 'Редкий', 'models/props/cs_assault/money.mdl', true, 10, function(pl) KylDonate.AddDonateCoins(pl:SteamID(), 15) end)
container:AddItem(6, '25 донат рублей', 'Эпический', 'models/props/cs_assault/money.mdl', true, 7, function(pl) KylDonate.AddDonateCoins(pl:SteamID(), 25) end)
container:AddItem(6, '40 донат рублей', 'Мифический', 'models/props/cs_assault/money.mdl', true, 5, function(pl) KylDonate.AddDonateCoins(pl:SteamID(), 40) end)
container:AddItem(6, '60 донат рублей', 'Легендарный', 'models/props/cs_assault/money.mdl', true, 3, function(pl) KylDonate.AddDonateCoins(pl:SteamID(), 60) end)

