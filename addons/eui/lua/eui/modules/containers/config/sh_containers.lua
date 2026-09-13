local container = eui.container

container.containers = {}

function container:AddContainer(rarity, time, min)
    local tbl = {
        rarity = rarity,
        time = time,
        min = min
    }

    self.containers[#self.containers + 1] = tbl
end

container:AddContainer('Обычный', '12:45', 25000)
container:AddContainer('Редкий', '14:15', 50000)
container:AddContainer('Эпический', '15:45', 70000)
container:AddContainer('Мифический', '16:30', 300000)
container:AddContainer('Легендарный', '18:00', 1500000)
container:AddContainer('Неизвестный', '20:00', 4000000)
