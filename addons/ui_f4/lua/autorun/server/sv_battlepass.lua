AddCSLuaFile("autorun/client/cl_battlepass.lua")
AddCSLuaFile("autorun/sh_rules.lua")

local BP = {}
BP.MAX_LEVEL = 40
BP.EXP_PER_LEVEL = 10
BP.ACTIVE_TASK_COUNT = 12

util.AddNetworkString("BP_RequestData")
util.AddNetworkString("BP_SendData")
util.AddNetworkString("BP_LevelUp")
util.AddNetworkString("BP_ClaimReward")
util.AddNetworkString("BP_ClaimSuccess")
util.AddNetworkString("BP_ClaimAll")
util.AddNetworkString("BP_OpenUI")

eui = eui or {}
eui.battlepass = eui.battlepass or {}

BP.ALL_TASKS = {
    [1]  = {name = "Игровое время",   desc = "Отыграй 1 час",                     target = 60,    type = "time"},
    [2]  = {name = "Игровое время",   desc = "Отыграй 5 часов",                    target = 300,   type = "time"},
    [12] = {name = "Аресты",          desc = "Арестуй 10 человек",                 target = 10,    type = "arrest"},
    [13] = {name = "Аресты",          desc = "Арестуй 25 человек",                 target = 25,    type = "arrest"},
    [28] = {name = "Аресты",          desc = "Арестуй 50 человек",                 target = 50,    type = "arrest"},
    [35] = {name = "Аресты",          desc = "Арестуй 100 человек",                target = 100,   type = "arrest"},
    [29] = {name = "Мет",             desc = "Свари 10 кг мета",                   target = 10,    type = "meth"},
    [19] = {name = "Недвижимость",    desc = "Купи 5 дверей",                      target = 5,     type = "door"},
    [11] = {name = "Мэр",             desc = "Стань мэром хотя бы 1 раз",          target = 1,     type = "mayor"},
    [23] = {name = "Донат",           desc = "Пополни баланс на 500 рублей",       target = 500,   type = "donate"},
    [40] = {name = "Закладки",        desc = "Раскидай 5 закладок",                target = 5,     type = "stash"},
    [41] = {name = "Закладки",        desc = "Раскидай 10 закладок",               target = 10,    type = "stash"},
    [42] = {name = "Закладки",        desc = "Раскидай 20 закладок",               target = 20,    type = "stash"},
    [43] = {name = "Лечение",         desc = "Вылечи игрока на 300 хп",            target = 300,   type = "heal"},
    [44] = {name = "Лечение",         desc = "Вылечи игрока на 500 хп",            target = 500,   type = "heal"},
    [45] = {name = "Лечение",         desc = "Вылечи игрока на 1000 хп",           target = 1000,  type = "heal"},
    [46] = {name = "Казино",          desc = "Выиграй в казино 50 000$",           target = 50000, type = "casino"},
    [47] = {name = "Казино",          desc = "Выиграй в казино 100 000$",          target = 100000,type = "casino"},
    [48] = {name = "Казино",          desc = "Выиграй в казино 200 000$",          target = 200000,type = "casino"},
    [49] = {name = "Ордера",          desc = "Запроси 5 ордеров",                  target = 5,     type = "warrant"},
    [50] = {name = "Ордера",          desc = "Запроси 10 ордеров",                 target = 10,    type = "warrant"},
    [51] = {name = "Ордера",          desc = "Запроси 20 ордеров",                 target = 20,    type = "warrant"},
}

function BP.SelectRandomTasks()
    local pool = {}
    for id in pairs(BP.ALL_TASKS) do table.insert(pool, id) end
    for i = #pool, 2, -1 do
        local j = math.random(i)
        pool[i], pool[j] = pool[j], pool[i]
    end
    BP.ActiveTasks = {}
    for i = 1, math.min(BP.ACTIVE_TASK_COUNT, #pool) do
        BP.ActiveTasks[pool[i]] = true
    end
end

BP.SelectRandomTasks()

function BP.GetActiveTasks()
    local list = {}
    for id in pairs(BP.ActiveTasks or {}) do
        if BP.ALL_TASKS[id] then list[id] = BP.ALL_TASKS[id] end
    end
    return list
end

local function GetPlayerData(ply)
    if not IsValid(ply) then return end
    ply.BPData = ply.BPData or {level = 1, exp = 0, premium = false, progress = {}, claimed = {[1] = true}}
    ply.BPData.claimed = ply.BPData.claimed or {[1] = true}
    return ply.BPData
end

local plyMeta = FindMetaTable("Player")

local DONATE_LEVELS = {
    [11] = true,
    [15] = true,
    [21] = true,
    [25] = true,
    [29] = true,
    [35] = true,
    [39] = true,
}

local MONEY_REWARDS = {
    [2] = 10000,
    [3] = 20000,
    [4] = 30000,
    [5] = 40000,
    [6] = 50000,
    [7] = 65000,
    [8] = 80000,
    [9] = 100000,
}

function BP.GiveReward(ply, level)
    if not IsValid(ply) then return end
    if DONATE_LEVELS[level] then
        if isfunction(ply.AddIGSFunds) then
            ply:AddIGSFunds(200, "Награда за " .. level .. " уровень BattlePass")
        elseif IGS and isfunction(IGS.Transaction) then
            IGS.Transaction(ply:SteamID64(), 200, "Награда за " .. level .. " уровень BattlePass")
        end
        ply:ChatPrint("[BattlePass] Награда за " .. level .. " уровень: +200 рублей!")
    elseif level == 1 or level % 10 == 0 then
        ply:ChatPrint("[BattlePass] Поздравляем с достижением " .. level .. " уровня!")
    else
        local amount = MONEY_REWARDS[level] or math.min(250000, 100000 + (level - 9) * 10000)
        if ply.AddMoney then
            ply:AddMoney(amount, "Награда BattlePass (уровень " .. level .. ")")
        elseif ply.addMoney then
            ply:addMoney(amount)
        end
        local formatted = rp and rp.FormatMoney and rp.FormatMoney(amount) or DarkRP and DarkRP.formatMoney and DarkRP.formatMoney(amount) or ("$" .. amount)
        ply:ChatPrint("[BattlePass] Награда за " .. level .. " уровень: +" .. formatted .. "!")
    end
end

function plyMeta:AddBPLevel(amount)
    local data = GetPlayerData(self) or {}
    amount = amount or 1
    local oldLevel = data.level or 1
    data.level = math.min(BP.MAX_LEVEL, oldLevel + amount)
    data.claimed = data.claimed or {[1] = true}
    for l = oldLevel + 1, data.level do
        if not data.claimed[l] then
            data.claimed[l] = true
            BP.GiveReward(self, l)
        end
    end
    self:SetNWInt("BP_Level", data.level)
    self:SaveBattlePassData()
    net.Start("BP_LevelUp") net.WriteUInt(data.level, 8) net.Send(self)
    BP.SendFullData(self)
end

function plyMeta:SetBPPremium()
    local data = GetPlayerData(self) or {}
    data.premium = true
    self:SetNWBool("BP_Premium", true)
    self:SaveBattlePassData()
    self:ChatPrint("[BattlePass] Ты приобрёл Premium Pass!")
end

function plyMeta:GetBPLevel() return self:GetNWInt("BP_Level", 1) end
function plyMeta:IsBPPremium() return self:GetNWBool("BP_Premium", false) end

function eui.battlepass.AddProgress(ply, taskID, extra)
    if not IsValid(ply) or not taskID then return end
    if not BP.ActiveTasks or not BP.ActiveTasks[taskID] then return end
    local task = BP.ALL_TASKS[taskID]
    if not task then return end
    local data = GetPlayerData(ply)
    data.progress = data.progress or {}
    local current = (data.progress[taskID] or 0) + (extra or 1)
    data.progress[taskID] = current
    if current >= task.target and not data.progress[taskID .. "_done"] then
        data.progress[taskID .. "_done"] = true
        local expGain = ply:IsBPPremium() and 2 or 1
        data.exp = (data.exp or 0) + expGain
        while data.exp >= BP.EXP_PER_LEVEL and (data.level or 1) < BP.MAX_LEVEL do
            data.exp = data.exp - BP.EXP_PER_LEVEL
            data.level = (data.level or 1) + 1
            data.claimed = data.claimed or {[1] = true}
            if not data.claimed[data.level] then
                data.claimed[data.level] = true
                BP.GiveReward(ply, data.level)
            end
            ply:SetNWInt("BP_Level", data.level)
            net.Start("BP_LevelUp") net.WriteUInt(data.level, 8) net.Send(ply)
        end
        ply:SetNWInt("BP_Exp", data.exp)
        BP.SendFullData(ply)
        ply:ChatPrint("[BattlePass] Задание выполнено! +" .. expGain .. " EXP")
    end
    ply:SetNWInt("BP_Exp", data.exp or 0)
    ply:SaveBattlePassData()
end

function plyMeta:SaveBattlePassData()
    local data = GetPlayerData(self)
    if not data then return end
    file.CreateDir("battlepass")
    file.Write("battlepass/" .. self:SteamID64() .. ".txt", util.TableToJSON(data))
end

function plyMeta:LoadBattlePassData()
    local path = "battlepass/" .. self:SteamID64() .. ".txt"
    if file.Exists(path, "DATA") then
        self.BPData = util.JSONToTable(file.Read(path, "DATA")) or {}
    else
        self.BPData = {level = 1, exp = 0, premium = false, progress = {}, claimed = {[1] = true}}
    end
    local d = self.BPData
    d.claimed = d.claimed or {[1] = true}
    self:SetNWInt("BP_Level", d.level or 1)
    self:SetNWInt("BP_Exp", d.exp or 0)
    self:SetNWBool("BP_Premium", d.premium or false)
end

hook.Add("PlayerInitialSpawn", "BP.Load", function(ply)
    timer.Simple(0.8, function()
        if IsValid(ply) then ply:LoadBattlePassData() end
    end)
end)

hook.Add("Initialize", "BP.RandomTasks", function()
    BP.SelectRandomTasks()
end)

function BP.SendFullData(ply)
    if not IsValid(ply) then return end
    local data = GetPlayerData(ply) or {}
    local active = BP.GetActiveTasks()
    net.Start("BP_SendData")
        net.WriteUInt(data.level or 1, 8)
        net.WriteUInt(data.exp or 0, 16)
        net.WriteBool(data.premium or false)
        local count = table.Count(active)
        net.WriteUInt(count, 8)
        for id, task in pairs(active) do
            net.WriteUInt(id, 8)
            net.WriteString(task.name)
            net.WriteString(task.desc)
            net.WriteUInt(task.target, 16)
            local prog = data.progress and data.progress[id] or 0
            local done = data.progress and data.progress[id .. "_done"] or false
            net.WriteUInt(prog, 16)
            net.WriteBool(done)
        end
        for l = 1, BP.MAX_LEVEL do
            net.WriteBool(data.claimed and data.claimed[l] or false)
        end
    net.Send(ply)
end

net.Receive("BP_RequestData", function(_, ply)
    BP.SendFullData(ply)
end)

net.Receive("BP_ClaimReward", function(_, ply)
    if not IsValid(ply) then return end
    local level = net.ReadUInt(8)
    local data = GetPlayerData(ply)
    if not data then return end
    data.claimed = data.claimed or {[1] = true}
    if level > (data.level or 1) then
        ply:ChatPrint("[BattlePass] Этот уровень ещё не разблокирован!")
        return
    end
    if data.claimed[level] then
        ply:ChatPrint("[BattlePass] Награда за этот уровень уже получена!")
        return
    end
    data.claimed[level] = true
    BP.GiveReward(ply, level)
    ply:SaveBattlePassData()
    net.Start("BP_ClaimSuccess")
        net.WriteUInt(level, 8)
    net.Send(ply)
end)

net.Receive("BP_ClaimAll", function(_, ply)
    if not IsValid(ply) then return end
    local data = GetPlayerData(ply)
    if not data then return end
    data.claimed = data.claimed or {[1] = true}
    local count = 0
    for l = 2, (data.level or 1) do
        if not data.claimed[l] then
            data.claimed[l] = true
            BP.GiveReward(ply, l)
            count = count + 1
        end
    end
    if count > 0 then
        ply:SaveBattlePassData()
        net.Start("BP_ClaimSuccess")
            net.WriteUInt(0, 8)
        net.Send(ply)
    else
        ply:ChatPrint("[BattlePass] Нет доступных наград для получения!")
    end
end)

concommand.Add("bp_reset", function(ply, cmd, args)
    local target = ply
    if IsValid(ply) and not ply:IsSuperAdmin() then
        ply:ChatPrint("[BattlePass] Команда доступна только суперадминистраторам.")
        return
    end
    if args[1] then
        for _, p in ipairs(player.GetAll()) do
            if string.find(string.lower(p:Name()), string.lower(args[1])) or p:SteamID() == args[1] or p:SteamID64() == args[1] then
                target = p
                break
            end
        end
    end
    if not IsValid(target) then return end

    target.BPData = {level = 1, exp = 0, premium = false, progress = {}, claimed = {[1] = true}}
    target:SetNWInt("BP_Level", 1)
    target:SetNWInt("BP_Exp", 0)
    target:SetNWBool("BP_Premium", false)
    target:SaveBattlePassData()
    net.Start("BP_LevelUp") net.WriteUInt(1, 8) net.Send(target)
    BP.SendFullData(target)

    if IsValid(ply) then
        ply:ChatPrint("[BattlePass] Уровень игрока " .. target:Name() .. " успешно сброшен до 1!")
    else
        print("[BattlePass] Уровень игрока " .. target:Name() .. " сброшен до 1.")
    end
end)

concommand.Add("bp_setlevel", function(ply, cmd, args)
    if IsValid(ply) and not ply:IsSuperAdmin() then
        ply:ChatPrint("[BattlePass] Команда доступна только суперадминистраторам.")
        return
    end
    local target = ply
    local lvl = tonumber(args[1])
    if args[2] and IsValid(ply) then
        lvl = tonumber(args[2])
        for _, p in ipairs(player.GetAll()) do
            if string.find(string.lower(p:Name()), string.lower(args[1])) or p:SteamID() == args[1] or p:SteamID64() == args[1] then
                target = p
                break
            end
        end
    end
    if not lvl then
        if IsValid(ply) then ply:ChatPrint("Использование: bp_setlevel [игрок] <уровень>") end
        return
    end
    if not IsValid(target) then return end
    lvl = math.Clamp(math.floor(lvl), 1, BP.MAX_LEVEL)
    local data = GetPlayerData(target)
    if not data then return end
    local oldLevel = data.level or 1
    data.level = lvl
    data.claimed = data.claimed or {[1] = true}
    if lvl > oldLevel then
        for l = oldLevel + 1, lvl do
            if not data.claimed[l] then
                data.claimed[l] = true
                BP.GiveReward(target, l)
            end
        end
    end
    target:SetNWInt("BP_Level", lvl)
    target:SaveBattlePassData()
    net.Start("BP_LevelUp") net.WriteUInt(lvl, 8) net.Send(target)
    BP.SendFullData(target)
    if IsValid(ply) then
        ply:ChatPrint("[BattlePass] Уровень игрока " .. target:Name() .. " установлен на " .. lvl)
    end
end)

hook.Add("PlayerSay", "BP.ResetCommands", function(ply, text)
    local low = string.lower(string.Trim(text))
    if low == "/bp_reset" or low == "!bp_reset" then
        if not ply:IsSuperAdmin() then
            ply:ChatPrint("[BattlePass] Команда доступна только суперадминистраторам.")
            return ""
        end
        ply.BPData = {level = 1, exp = 0, premium = false, progress = {}, claimed = {[1] = true}}
        ply:SetNWInt("BP_Level", 1)
        ply:SetNWInt("BP_Exp", 0)
        ply:SetNWBool("BP_Premium", false)
        ply:SaveBattlePassData()
        net.Start("BP_LevelUp") net.WriteUInt(1, 8) net.Send(ply)
        BP.SendFullData(ply)
        ply:ChatPrint("[BattlePass] Ваш BattlePass успешно сброшен до 1 уровня!")
        return ""
    end
end)

concommand.Add("battlepass", function(ply)
    if IsValid(ply) then
        net.Start("BP_OpenUI")
        net.Send(ply)
    end
end)