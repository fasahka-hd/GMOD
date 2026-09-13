--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

util.AddNetworkString('just_models.OpenMenu')
util.AddNetworkString('just_models_equip')
util.AddNetworkString('just_models_buy')

local db = rp._Stats
-- db:Query('CREATE TABLE IF NOT EXISTS `just_models` (steamid TEXT, models TEXT, toggle TEXT) ')

hook.Add('PlayerInitialSpawn', 'just_rp_register_player', function(ply)
    if IsValid(ply) and ply:IsPlayer() then
        local steamid64 = ply:SteamID64()
        db:Query('SELECT * FROM `just_models` WHERE steamid = ?', steamid64, function(data)
            if data and data[1] then
                return
            end
            db:Query('INSERT INTO `just_models` VALUES(?, ?, ?)', steamid64, util.TableToJSON({}), nil)
        end)
    end
end)

local PLAYER = FindMetaTable('Player')

function PLAYER:AddModelAdmin(mdl_id)
    if just_models.selling[mdl_id] == nil then self:ChatPrint('Произошла ошибка [Не найден ID]') return end
    db:Query('SELECT * FROM `just_models` WHERE steamid = ?', self:SteamID64(), function(data)
        local tbl = data[1].models
        tbl = util.JSONToTable(tbl)
        tbl[#tbl + 1] = mdl_id
        db:Query('UPDATE `just_models` SET models = ? WHERE steamid = ?', util.TableToJSON(tbl), self:SteamID64())
    end)
end

function PLAYER:AddModelToDB(mdl_id)
    if just_models.selling[mdl_id] == nil then 
        self:ChatPrint('Произошла ошибка [Не найден ID]') 
        return false
    end

    db:Query('SELECT * FROM `just_models` WHERE steamid = ?', self:SteamID64(), function(data)
        local tbl = data[1].models
        tbl = util.JSONToTable(tbl)
        tbl[#tbl + 1] = mdl_id
        db:Query('UPDATE `just_models` SET models = ? WHERE steamid = ?', util.TableToJSON(tbl), self:SteamID64())
    end)
    return true
end

function meta:ToggleModel(mdl_id, bool)
    if self:IsArrested() then self:ChatPrint('Вы не можете взаимодействовать с моделью в данный момент') return end

    db:Query('SELECT * FROM `just_models` WHERE steamid = ?', self:SteamID64(), function(data)
        local tbl = data[1].models
        tbl = util.JSONToTable(tbl)

        if not table.HasValue(tbl, mdl_id) then self:ChatPrint('У вас не приобретена данная модель!') return end

        if bool == false then
            db:Query('UPDATE `just_models` SET toggle = ? WHERE steamid = ?', nil, self:SteamID64())
            self:ChatPrint('Вы сняли экипированную модель')
            self:SetModel(team.GetModel(self:GetJob() or 1))
        else
            db:Query('UPDATE `just_models` SET toggle = ? WHERE steamid = ?', mdl_id, self:SteamID64())
            self:SetModel(just_models.selling[mdl_id].model)
            self:ChatPrint('Вы экипировали модель ' .. just_models.selling[mdl_id].name)
        end
    end)
end

net.Receive('just_models_equip', function(_, ply)
    if not IsValid(ply) then return end
    local mdl_id = net.ReadString()
    local bool = net.ReadBool()

    ply:ToggleModel(mdl_id, bool)
end)

do
    local function models_open(ply)
        db:Query('SELECT * FROM `just_models` WHERE steamid = ?', ply:SteamID64(), function(data)
            net.Start('just_models.OpenMenu')
                net.WriteTable(util.JSONToTable(data[1].models))
                net.WriteString(data[1].toggle or 'nil')
            net.Send(ply)
        end)
    end

    concommand.Add('justmodels', models_open)
end

-- ============================================
-- УНИВЕРСАЛЬНАЯ ФУНКЦИЯ СПИСАНИЯ СРЕДСТВ IGS
-- ============================================
local function TakeMoneyFromIGS(ply, amount, reason)
    local steamid = ply:SteamID64()
    local sid64 = steamid
    local sid = ply:SteamID()
    
    -- Способ 1: Стандартная функция AddIGSFunds с минусом
    local success = pcall(function()
        return ply:AddIGSFunds(-amount, reason)
    end)
    if success then
        print('[JustModels] Списание через AddIGSFunds успешно')
        return true
    end
    
    -- Способ 2: Прямой вызов IGS.TakeMoney
    if IGS and IGS.TakeMoney then
        local result = IGS.TakeMoney(ply, amount)
        if result then
            print('[JustModels] Списание через IGS.TakeMoney успешно')
            return true
        end
    end
    
    -- Способ 3: Поиск таблицы IGS в БД и прямой SQL
    local tables = sql.Query("SELECT name FROM sqlite_master WHERE type='table'")
    if tables then
        for _, t in ipairs(tables) do
            local name = t.name
            -- Ищем таблицы, похожие на IGS
            if string.find(string.lower(name), 'igs') or string.find(string.lower(name), 'donat') then
                -- Пробуем найти столбец с балансом
                local info = sql.Query("PRAGMA table_info(" .. name .. ")")
                if info then
                    local hasBalance = false
                    local hasSteamID = false
                    local balanceCol = nil
                    local steamCol = nil
                    
                    for _, col in ipairs(info) do
                        local colName = string.lower(col.name)
                        if colName == 'balance' or colName == 'money' or colName == 'coins' or colName == 'funds' then
                            hasBalance = true
                            balanceCol = col.name
                        end
                        if colName == 'steamid' or colName == 'steam_id' or colName == 'sid' or colName == 'sid64' then
                            hasSteamID = true
                            steamCol = col.name
                        end
                    end
                    
                    if hasBalance and hasSteamID then
                        -- Пробуем разные форматы SteamID
                        local ids = {steamid, sid64, sid}
                        for _, id in ipairs(ids) do
                            if id then
                                local getQuery = "SELECT " .. balanceCol .. " FROM " .. name .. " WHERE " .. steamCol .. " = '" .. id .. "'"
                                local current = sql.Query(getQuery)
                                if current and current[1] and current[1][balanceCol] then
                                    local curBalance = tonumber(current[1][balanceCol]) or 0
                                    if curBalance >= amount then
                                        local newBalance = curBalance - amount
                                        local updateQuery = "UPDATE " .. name .. " SET " .. balanceCol .. " = " .. newBalance .. " WHERE " .. steamCol .. " = '" .. id .. "'"
                                        local updateResult = sql.Query(updateQuery)
                                        if updateResult ~= false then
                                            print('[JustModels] Списание через SQL (' .. name .. ') успешно')
                                            ply:SetNW2Int('igs_balance', newBalance)
                                            return true
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end
    
    -- Способ 4: IGS.Purchase (если есть предмет с таким UID, но нам нужен просто предмет)
    -- Не используем, так как нам нужно просто списание
    
    -- Способ 5: Прямой вызов хука IGS
    local hookResult = hook.Run("IGS.TakePlayerMoney", ply, amount, reason)
    if hookResult == true then
        print('[JustModels] Списание через хук IGS.TakePlayerMoney успешно')
        return true
    end
    
    return false
end

-- ============================================
-- ОБРАБОТЧИК ПОКУПКИ (УНИВЕРСАЛЬНЫЙ)
-- ============================================
net.Receive('just_models_buy', function(_, ply)
    if not IsValid(ply) then return end
    local mdl_id = net.ReadString()
    local price = just_models.selling[mdl_id].cost

    db:Query('SELECT * FROM `just_models` WHERE steamid = ?', ply:SteamID64(), function(data)
        local tbl = data[1].models
        tbl = util.JSONToTable(tbl)

        -- Проверка: не куплена ли уже модель
        if table.HasValue(tbl, mdl_id) then 
            ply:ChatPrint('❌ У вас уже приобретена данная модель!') 
            return 
        end
        
        -- Получаем баланс через IGSFunds
        local balance = ply:IGSFunds()
        
        print('[JustModels] Баланс ' .. ply:Nick() .. ': ' .. balance .. ', цена: ' .. price)
        
        -- Проверяем, хватает ли средств
        if balance < price then
            ply:ChatPrint('❌ Недостаточно донат монет! Ваш баланс: ' .. balance .. ' (нужно: ' .. price .. ')')
            return
        end
        
        -- Пробуем списать средства универсальной функцией
        local success = TakeMoneyFromIGS(ply, price, 'Покупка модели: ' .. just_models.selling[mdl_id].name)
        
        if not success then
            ply:ChatPrint('❌ Ошибка списания средств. Сообщите администратору.')
            print('[JustModels] ВСЕ СПОСОБЫ СПИСАНИЯ НЕ СРАБОТАЛИ для ' .. ply:Nick())
            return
        end
        
        -- Всё успешно - выдаём модель
        ply:AddModelToDB(mdl_id)
        ply:ChatPrint('✅ Успешная покупка модели ' .. just_models.selling[mdl_id].name .. ' за ' .. price .. ' донат монет!')
        
        local newBalance = ply:IGSFunds()
        ply:ChatPrint('💰 Ваш новый баланс: ' .. newBalance .. ' донат монет')
        
        print('[JustModels] Игрок ' .. ply:Nick() .. ' купил модель ' .. mdl_id .. ' за ' .. price)
    end)
end)

local arrest_models = {
    'models/gulag/male_011.mdl',
    'models/gulag/male_012.mdl',
    'models/gulag/male_013.mdl',
    'models/gulag/male_014.mdl',
    'models/gulag/male_015.mdl'
}

hook.Add('PlayerSetModel', 'Change_PM', function(ply)
    if IsValid(ply) and ply:IsPlayer() then
        if ply:IsArrested() then
            ply:SetModel(arrest_models[math.random(#arrest_models)])
            return false
        end
        db:Query('SELECT * FROM `just_models` WHERE steamid = ?', ply:SteamID64(), function(data)
            if data[1] and data[1].toggle != nil then
                if just_models.selling[data[1].toggle] == nil then ply:ChatPrint('Произошла ошибка [Не найден ID]') return end
                ply:SetModel(just_models.selling[data[1].toggle].model)
            end
        end)
    end
end)

hook.Add('PlayerInitialSpawn', 'JM_SpawnModel', function(ply)
    if IsValid(ply) and ply:IsPlayer() then
        db:Query('SELECT * FROM `just_models` WHERE steamid = ?', ply:SteamID64(), function(data)
            if data[1] and data[1].toggle != nil then
                if just_models.selling[data[1].toggle] == nil then ply:ChatPrint('Произошла ошибка [Не найден ID]') return end
                ply:SetModel(just_models.selling[data[1].toggle].model)
            end
        end)
    end
end)

-- ============================================
-- ДИАГНОСТИКА (ОСТАВЛЯЕМ ДЛЯ ОТЛАДКИ)
-- ============================================
hook.Add('Initialize', 'just_models_find_igs_table', function()
    timer.Simple(5, function()
        print('========== [JustModels] Поиск таблиц IGS ==========')
        
        local tables = sql.Query("SELECT name FROM sqlite_master WHERE type='table' ORDER BY name")
        
        if tables then
            print('[JustModels] Всего таблиц в БД: ' .. #tables)
            for _, t in ipairs(tables) do
                local name = t.name
                
                if string.find(string.lower(name), 'ig') or 
                   string.find(string.lower(name), 'donat') or 
                   string.find(string.lower(name), 'balance') then
                    
                    print('[JustModels] Найдена таблица IGS: ' .. name)
                    
                    local info = sql.Query("PRAGMA table_info(" .. name .. ")")
                    if info then
                        local columns = {}
                        for _, col in ipairs(info) do
                            table.insert(columns, col.name)
                        end
                        print('  └─ Столбцы: ' .. table.concat(columns, ', '))
                    end
                end
            end
        else
            print('[JustModels] ОШИБКА: Не удалось получить список таблиц!')
        end
        
        print('=====================================================')
    end)
end)

--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher