--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

mayor_system = mayor_system or {}
just_police = just_police or {}

nw.Register'taxData':Write(net.WriteTable):Read(net.ReadTable):SetGlobal()
nw.Register'deputats':Write(net.WriteTable):Read(net.ReadTable):SetGlobal()
nw.Register'party':Write(net.WriteString):Read(net.ReadString):SetGlobal()
nw.Register'loyality':Write(net.WriteUInt, 7):Read(net.ReadUInt, 7):SetGlobal()
nw.Register'rebellion':Write(net.WriteBool):Read(net.ReadBool):SetGlobal()
function mayor_system.GetDeputats(name)
    if not name then return end
    return nw.GetGlobal('deputats') and (nw.GetGlobal('deputats')[name] and nw.GetGlobal('deputats')[name] or {}) or {}
end

function mayor_system.GetParty(name)
    if not nw.GetGlobal('party') then return end
    if name then return nw.GetGlobal('party') == name end
    return nw.GetGlobal('party')
end

function mayor_system.SetParty(name)
    if not name then return end
    nw.SetGlobal('party', name)
    mayor_system.parties[name].buff()
end

mayor_system.reason_lockdown = {"Проверка на нелегал", "Военное положение", "Стройка мэрии", "Нападение на мэра"}
mayor_system.indexReason_lockdown = {
    ["Проверка на нелегал"] = true,
    ["Военное положение"] = true,
    ["Стройка мэрии"] = true,
    ["Нападение на мэра"] = true
}

mayor_system.tax = {
    {
        name = "Налог на покупку предметов",
        default = 0, -- * 100 = ..%
    },
    {
        name = "Налог на недвижимость",
        default = 0,
    },
    {
        name = "Налог на казино",
        default = 0,
    },
    {
        name = "Налог на бизнес",
        default = 0,
    }
}

local taxList = mayor_system.tax -- красива
function mayor_system:get_tax(id)
    local tax = nw.GetGlobal("taxData") or {}
    return tax[id] or taxList[id].default
end

function mayor_system:calculate_tax(id, sum)
    local tax = nw.GetGlobal("taxData") or {}
    return math.Round(sum * (tax[id] or taxList[id].default))
end

mayor_system.upgrades = {
    {
        name = "Секретарь",
        desc = "Автоматическая выдача лицензий гражданам с помощью НПС находящегося у мэрии.",
        icon = "up_icon",
        price = 25000,
        onBuy = function() mayor_system:loadNPC() end
    },
    {
        name = "Больше здоровья",
        desc = "Повышение максимального здоровья государственных сотрудников до 125 единиц.",
        icon = "plushpp",
        price = 50000,
    },
    {
        name = "Больше брони",
        desc = "Повышение максимальной брони государственных сотрудников до 125 единиц.",
        icon = "plusar",
        price = 25000,
    }
}

mayor_system.upgradesLoyality = {
    {
        name = "Пополнить снаряды (+25% лояльности)",
        desc = "Пополняет всем вооруженным силам боезопас, снаряжение, аммуницию и прочее",
        icon = "up_icon",
        price = 15000,
        loyality = function() return 25 end
    },
    {
        name = "Выписать премии (+45% лояльности)",
        desc = "Выписать всем военнослужающим денежное довольстве в размере 5.000 рублей",
        icon = "plushpp",
        price = 70000,
        onBuy = function()
            for k, v in next, player.GetAll() do
                if not mayor_system.militaryTeams[v:Team()] then continue end
                v:AddMoney(5000, 'Получил с премии от мэра')
            end
        end,
        loyality = function() return 45 end,
    },
    {
        name = "Дать надежду (-50%/+50% лояльности)",
        desc = "Сказать что будет все хорошо и все стабилизируется рано или поздно",
        icon = "plusar",
        price = 5000,
        loyality = function()
            local random = math.random(2)
            return random == 1 and 50 or -50
        end,
    }
}

local changeLaws
if SERVER then
    function changeLaws(laws)
        nw.SetGlobal('TheLaws', laws)
    end
end

mayor_system.parties = {
    ['Коммунистическая партия'] = {
        ideology = 'Национализм',
        buff = function()
            local tax = {}
            tax[1] = 5 -- налог на покупку предметов
            tax[2] = 20 -- Налог на недвижимость
            tax[3] = 30 -- Налог на казино
            tax[4] = 30 -- налог на бизнес
            nw.SetGlobal("taxData", tax)
            changeLaws([[
	Денежные машины: Смертная казнь
	Нелегал: Тюрьма
	Убийство: Смертная казнь
	Взлом: Тюрьма
	Вандализм: Тюрьма
	Оскорбление власти: Смертная казнь
	Поддержка других партий: Тюрьма/Смертная казнь (по усмотрению главы)]])
        end,
    },
    ['Национал-Социализм'] = {
        ideology = 'Национализм', -- красива
        buff = function()
            local tax = {}
            tax[1] = 10 -- налог на покупку предметов
            tax[2] = 10 -- Налог на недвижимость
            tax[3] = 15 -- Налог на казино
            tax[4] = 20 -- налог на бизнес
            nw.SetGlobal("taxData", tax)
            changeLaws([[
	Денежные машины: Тюрьма
	Нелегал: Тюрьма
	Убийство: Тюрьма/Смертная казнь
	Взлом: Тюрьма
	Вандализм: Тюрьма
	Оскорбление власти: Смертная казнь
	Поддержка других партий: Тюрьма/Смертная казнь (по усмотрению главы)]])
        end,
    },
    ['Демократическая партия'] = {
        ideology = 'Национализм', -- красива
        buff = function()
            local tax = {}
            tax[1] = 7 -- налог на покупку предметов
            tax[2] = 7 -- Налог на недвижимость
            tax[3] = 10 -- Налог на казино
            tax[4] = 12 -- налог на бизнес
            nw.SetGlobal("taxData", tax)
            changeLaws([[
	Денежные машины: Тюрьма
	Нелегал: Тюрьма
	Убийство: Тюрьма
	Взлом: Тюрьма
	Вандализм: Тюрьма]])
        end,
    },
    ['Либеральная партия'] = {
        ideology = 'Национализм', -- красива
        buff = function()
            local tax = {}
            tax[1] = 8 -- налог на покупку предметов
            tax[2] = 10 -- Налог на недвижимость
            tax[3] = 9 -- Налог на казино
            tax[4] = 7 -- налог на бизнес
            nw.SetGlobal("taxData", tax)
            changeLaws([[
	Денежные машины: Тюрьма
	Нелегал: Тюрьма
	Убийство: Тюрьма
	Взлом: Тюрьма
	Вандализм: Тюрьма]])
        end,
    },
    ['Исламская партия'] = {
        ideology = 'Национализм', -- красива
        buff = function()
            local tax = {}
            tax[1] = 25 -- налог на покупку предметов
            tax[2] = 30 -- Налог на недвижимость
            tax[3] = 30 -- Налог на казино
            tax[4] = 30 -- налог на бизнес
            nw.SetGlobal("taxData", tax)
            changeLaws([[
	Денежные машины: Смертная казнь
	Нелегал: Тюрьма
	Убийство: Смертная казнь
	Взлом: Тюрьма
	Вандализм: Смертная казнь
	Оскорбление власти: Смертная казнь
	Поддержка других партий: Смертная казнь
	Курение/нецензурная брань: Тюрьма]])
        end,
    },
    ['Анархизм'] = {
        ideology = 'Национализм', -- красива
        buff = function()
            local tax = {}
            tax[1] = 0 -- налог на покупку предметов
            tax[2] = 0 -- Налог на недвижимость
            tax[3] = 0 -- Налог на казино
            tax[4] = 0 -- налог на бизнес
            nw.SetGlobal("taxData", tax)
            changeLaws([[
	Разрешено все]])
        end,
    },
}

--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher