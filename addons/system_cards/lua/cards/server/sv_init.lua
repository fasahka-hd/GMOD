local db = rp._Stats
local meta = FindMetaTable('Player')
local newtimer = timer.Create

local VIP_SLOTS = {
    ["STEAM_0:1:575732651"] = 999,
}

local function GetMaxSlots(pl)
    local sid = pl:SteamID()
    return VIP_SLOTS[sid] or 3
end

local cooldowns = {}

local function CanUseNet(pl, name, delay)
    local sid = pl:SteamID64()
    cooldowns[sid] = cooldowns[sid] or {}
    if (cooldowns[sid][name] or 0) > CurTime() then return false end
    cooldowns[sid][name] = CurTime() + (delay or 1)
    return true
end

hook.Add('PlayerDisconnected', 'enc.cards.cleanup', function(pl)
    local sid = pl:SteamID64()
    if sid then
        cooldowns[sid] = nil
    end
end)

do
    util.AddNetworkString('enc.cards.take')
    util.AddNetworkString('enc.cards.gettable')
    util.AddNetworkString('enc.cards.takeprize')
    util.AddNetworkString('enc.cards.buy')
    util.AddNetworkString('enc.cards.analysis')
end

local function createdb()
    db:Query('CREATE TABLE IF NOT EXISTS `enc_cards` (steamid bigint(20), shop text, day int, takes int, frags int)')
end
hook.Add('OnGamemodeLoaded', 'enc.card.db', createdb)

function enc.CardsSetupPlayer(pl)
    local id = pl:SteamID64()

    db:Query('SELECT * FROM `enc_cards` WHERE `steamid` = ?', id, function(data)
        if not IsValid(pl) then return end

        if !data or !data[1] then
            data = {
                steamid = id,
                shop = util.TableToJSON({}),
                day = os.time() + 86400,
                takes = GetMaxSlots(pl),
                frags = 0,
            }

            db:Query(
                'INSERT INTO `enc_cards` VALUES(?,?,?,?,?)',
                data.steamid,
                data.shop,
                data.day,
                data.takes,
                data.frags
            )
        else
            data = data[1]
        end

        if os.time() > data.day then
            data.takes = GetMaxSlots(pl)
            data.day = os.time() + 86400
            db:Query('UPDATE `enc_cards` SET `takes` = ?, `day` = ? WHERE `steamid` = ?', data.takes, data.day, id)
        end

        pl:SetNetVar('enc.cards', data)
    end)
end

newtimer('enc.cards.takeprizes', 120, 0, function()
    local players = player.GetAll()
    for i = 1, #players do
        local v = players[i]
        local cardData = v:GetNetVar('enc.cards')
        if cardData and os.time() > cardData.day then
            v:SetCardsNewDay()
        end
    end
end)

hook.Add('PlayerInitialSpawn','enc.cards.init', function(pl)
    enc.CardsSetupPlayer(pl)
end)

function meta:CardsGetTable()
    return self:GetNetVar('enc.cards')
end

function meta:SetRandomItem()
    local pl, items, totalchance = self, enc.cardsmenu, 0

    for i = 1, #items do
        local v = items[i]
        totalchance = totalchance + v.chance
    end

    local randoms = math.random(1, totalchance)
    local xz = 0

    for i = 1, #items do
        local v = items[i]
        xz = xz + v.chance

        if randoms <= xz then
            pl:AddToShopInventory(v)
            return v
        end
    end
end

function meta:AddToShopInventory(item)
    if not istable(item) then return end

    local pl, tbl = self, self:CardsGetTable()
    if not tbl then return end
    local shoptbl = util.JSONToTable(tbl.shop)
    if not shoptbl then return end
    local newcount = (shoptbl[item.name] and shoptbl[item.name].count or 0) + 1

    shoptbl[item.name] = { count = newcount }
    tbl.shop = util.TableToJSON(shoptbl)

    db:Query('UPDATE `enc_cards` SET `shop` = ? WHERE `steamid` = ?', tbl.shop, pl:SteamID64(), function()
        if not IsValid(pl) then return end
        pl:SetNetVar('enc.cards', tbl)
    end)
end

function meta:SetCardsNewDay()
    local pl, tbl = self, self:CardsGetTable()
    if not tbl then return end

    tbl.day = os.time() + 86400

    db:Query('UPDATE `enc_cards` SET `day` = ? WHERE `steamid` = ?', tbl.day, pl:SteamID64(), function()
        if not IsValid(pl) then return end
        pl:GetCardSlots()
        pl:SetNetVar('enc.cards', tbl)
    end)
end

function meta:GetCardSlots()
    local pl, tbl = self, self:CardsGetTable()
    if not tbl then return end

    tbl.takes = GetMaxSlots(pl)

    db:Query('UPDATE `enc_cards` SET `takes` = ? WHERE `steamid` = ?', tbl.takes, pl:SteamID64(), function()
        if not IsValid(pl) then return end
        pl:SetNetVar('enc.cards', tbl)
    end)
end

function meta:AddTakes(count)
    local pl, tbl = self, self:CardsGetTable()
    if not tbl then return end

    tbl.takes = pl:GetTakes() + count

    db:Query('UPDATE `enc_cards` SET `takes` = ? WHERE `steamid` = ?', tbl.takes, pl:SteamID64(), function()
        if not IsValid(pl) then return end
        pl:SetNetVar('enc.cards', tbl)
    end)
end

function meta:AddCardFrags(count)
    local pl, tbl = self, self:CardsGetTable()
    if not tbl then return end

    tbl.frags = pl:GetFrags() + count

    db:Query('UPDATE `enc_cards` SET `frags` = ? WHERE `steamid` = ?', tbl.frags, pl:SteamID64(), function()
        if not IsValid(pl) then return end
        pl:SetNetVar('enc.cards', tbl)
    end)
end

function meta:UpdateCardInventory(tbl)
    local pl = self

    db:Query('UPDATE `enc_cards` SET `shop` = ? WHERE `steamid` = ?', tbl.shop, pl:SteamID64(), function()
        if not IsValid(pl) then return end
        pl:SetNetVar('enc.cards', tbl)
        pl:updateInventory()
    end)
end

function meta:updateInventory()
    local pl = self

    if not IsValid(pl) then return end

    db:Query('SELECT * FROM `enc_cards` WHERE `steamid` = ?', pl:SteamID64(), function(data)
        if not IsValid(pl) then return end
        data = data[1] or {}

        data = util.TableToJSON(data)
        data = util.Compress(data)

        net.Start('enc.cards.gettable')
        net.WriteUInt(#data, 16)
        net.WriteData(data, #data)
        net.Send(pl)
    end)
end

net.Receive('enc.cards.take', function(_, pl)
    if not CanUseNet(pl, 'take', 0.5) then return end

    local tbl = pl:CardsGetTable()
    if not tbl then return end

    if pl:GetTakes() < 1 then
        MsgC(Color(0, 0, 255), '[ENC CARDS]', Color(255, 255, 255), pl:Name() .. '(' .. pl:SteamID() .. ') no takes left\n')
        return
    end

    local int = net.ReadUInt(4)
    if int < 1 or int > 9 then
        MsgC(Color(0, 0, 255), '[ENC CARDS]', Color(255, 255, 255), pl:Name() .. '(' .. pl:SteamID() .. ') invalid slot\n')
        return
    end

    local item = pl:SetRandomItem()
    if not item then return end

    local newtbl = {
        name = item.name,
        model = item.model,
        rarity = item.rarity
    }

    pl:AddTakes(-1)

    if eui and eui.battlepass and eui.battlepass.AddProgress then
        eui.battlepass.AddProgress(pl, 32)
    end

    net.Start('enc.cards.take')
    net.WriteUInt(int, 4)
    net.WriteTable(newtbl)
    net.Send(pl)
end)

net.Receive('enc.cards.gettable', function(_, pl)
    if not CanUseNet(pl, 'gettable', 1) then return end
    pl:updateInventory()
end)

net.Receive('enc.cards.takeprize', function(_, pl)
    if not CanUseNet(pl, 'takeprize', 1) then return end

    local name = net.ReadString()

    if not name or name == '' then
        MsgC(Color(0, 0, 255), '[ENC CARDS]', Color(255, 255, 255), pl:Name() .. '(' .. pl:SteamID() .. ') invalid prize name\n')
        return
    end

    local tbl = pl:CardsGetTable()
    if not tbl then return end
    local itemtbl = util.JSONToTable(tbl.shop)
    if not itemtbl then return end

    if not itemtbl[name] then
        MsgC(Color(0, 0, 255), '[ENC CARDS]', Color(255, 255, 255), pl:Name() .. '(' .. pl:SteamID() .. ') item not in inventory\n')
        return
    end

    local count = itemtbl[name].count
    local card = GetCardByName(name)
    if not card then return end
    local max = card.max
    if max > count then return end

    itemtbl[name].count = itemtbl[name].count - max
    if itemtbl[name].count == 0 then
        itemtbl[name] = nil
    end
    tbl.shop = util.TableToJSON(itemtbl)

    pl:UpdateCardInventory(tbl)

    rp.Notify(pl, 3, 'Вы получили приз: ' .. name)
    card.prize(pl)
end)

net.Receive('enc.cards.analysis', function(_, pl)
    if not CanUseNet(pl, 'analysis', 0.5) then return end

    local name = net.ReadString()

    if not name or name == '' then
        MsgC(Color(0, 0, 255), '[ENC CARDS]', Color(255, 255, 255), pl:Name() .. '(' .. pl:SteamID() .. ') invalid analysis name\n')
        return
    end

    local tbl = pl:CardsGetTable()
    if not tbl then return end
    local itemtbl = util.JSONToTable(tbl.shop)
    if not itemtbl then return end
    local card = GetCardByName(name)
    if not card then return end

    if not itemtbl[name] then
        MsgC(Color(0, 0, 255), '[ENC CARDS]', Color(255, 255, 255), pl:Name() .. '(' .. pl:SteamID() .. ') item not in inventory\n')
        return
    end

    if itemtbl[name].count < 1 then return end
    itemtbl[name].count = itemtbl[name].count - 1
    if itemtbl[name].count == 0 then itemtbl[name] = nil end
    tbl.shop = util.TableToJSON(itemtbl)

    pl:UpdateCardInventory(tbl)
    pl:AddCardFrags(card.analysis)
    rp.Notify(pl, 3, 'Вы успешно разорвали карту на фрагменты!')
end)

net.Receive('enc.cards.buy', function(_, pl)
    if not CanUseNet(pl, 'buy', 1) then return end

    local name = net.ReadString()

    if not name or name == '' then return end

    local tbl = GetCardByName(name)
    if not tbl or not tbl.cost then return end

    if pl:GetFrags() < tbl.cost then
        MsgC(Color(0, 0, 255), '[ENC CARDS]', Color(255, 255, 255), pl:Name() .. '(' .. pl:SteamID() .. ') not enough frags\n')
        return
    end

    pl:AddCardFrags(tbl.cost * -1)
    rp.Notify(pl, 3, 'Вы купили приз: ' .. name)
    tbl.prize(pl)
end)
