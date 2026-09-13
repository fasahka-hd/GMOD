--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

local tag = "LibFuse:PlayerFullyLoad"
local LibFuseLoadQ = {}

hook.Add( "PlayerInitialSpawn", tag, function( ply )
	LibFuseLoadQ[ ply ] = true
end)

hook.Add( "SetupMove", tag, function( ply, _, cmd )
	if LibFuseLoadQ[ ply ] and not cmd:IsForced() then
		LibFuseLoadQ[ ply ] = nil

		hook.Run(tag, ply)
	end
end )


local Tag = "KylDonate"
local toggleweaponnetwork = "LibFuse:ToggleWeapon"

util.AddNetworkString(Tag)
util.AddNetworkString(toggleweaponnetwork)
KylDonate = KylDonate or {}

-- Все донат-рубли теперь хранятся ТОЛЬКО по SteamID64.
-- Старые записи STEAM_0:* мигрируются в backup-таблицу KylDonate_Players_old_steamid,
-- а рабочая таблица KylDonate_Players пересоздаётся как (SteamID64, Balance BIGINT).
KylDonate.NormalizeSteamID64 = function(sid)
    sid = tostring(sid or "")
    if sid == "" then return "" end
    if sid:match("^765611%d+$") then return sid end

    local converted = util.SteamIDTo64(sid)
    if converted and converted ~= "" and converted ~= "0" then return tostring(converted) end

    local ply = player.GetBySteamID(sid)
    if IsValid(ply) then return ply:SteamID64() end

    return sid
end

KylDonate.FindPlayerByAnySteamID = function(sid)
    local sid64 = KylDonate.NormalizeSteamID64(sid)
    local ply = player.GetBySteamID64(sid64)
    if IsValid(ply) then return ply end
    ply = player.GetBySteamID(tostring(sid or ""))
    if IsValid(ply) then return ply end
    return nil
end

KylDonate.MigratePlayersTableToSteamID64 = function()
    if not rp or not rp._Stats or not rp._Stats.Query then return end

    rp._Stats:Query("CREATE TABLE IF NOT EXISTS KylDonate_Players (SteamID64 VARCHAR(32) PRIMARY KEY, Balance BIGINT NOT NULL DEFAULT 0)", function()
        rp._Stats:Query("SHOW COLUMNS FROM KylDonate_Players LIKE 'SteamID64'", function(cols)
            cols = cols or {}
            if next(cols) then
                return
            end

            rp._Stats:Query("DROP TABLE IF EXISTS KylDonate_Players64_tmp", function()
                rp._Stats:Query("CREATE TABLE KylDonate_Players64_tmp (SteamID64 VARCHAR(32) PRIMARY KEY, Balance BIGINT NOT NULL DEFAULT 0)", function()
                    rp._Stats:Query("SELECT * FROM KylDonate_Players", function(data)
                        data = data or {}
                        for _, row in ipairs(data) do
                            local sid = row.SteamID64 or row.SteamID or row.steamid or row.steamid64 or ""
                            local sid64 = KylDonate.NormalizeSteamID64(sid)
                            local balance = math.floor(tonumber(row.Balance or row.balance or 0) or 0)

                            if sid64 ~= "" and sid64:match("^765611%d+$") then
                                rp._Stats:Query(string.format(
                                    "INSERT INTO KylDonate_Players64_tmp (SteamID64, Balance) VALUES (%s, %d) ON DUPLICATE KEY UPDATE Balance = GREATEST(Balance, VALUES(Balance))",
                                    sql.SQLStr(sid64), balance
                                ))
                            end
                        end

                        timer.Simple(3, function()
                            rp._Stats:Query("DROP TABLE IF EXISTS KylDonate_Players_old_steamid", function()
                                rp._Stats:Query("RENAME TABLE KylDonate_Players TO KylDonate_Players_old_steamid", function()
                                    rp._Stats:Query("RENAME TABLE KylDonate_Players64_tmp TO KylDonate_Players", function()
                                        rp._Stats:Query("DROP TABLE IF EXISTS KylDonate_Players_old_steamid")
                                    end)
                                end)
                            end)
                        end)
                    end)
                end)
            end)
        end)
    end)
end

timer.Simple(2, function()
    KylDonate.MigratePlayersTableToSteamID64()
end)



--[[ 
    КОММЕТ НЕ СНИМАТЬ
    rp._Stats:Query("DROP TABLE KylDonate_Weapons")
    rp._Stats:Query("DROP TABLE KylDonate_Players")
    rp._Stats:Query("DROP TABLE KylDonate_BuyLogs")

    rp._Stats:Query("CREATE TABLE IF NOT EXISTS KylDonate_Weapons (id INT AUTO_INCREMENT PRIMARY KEY, SteamID TEXT, DItemID TEXT, toggle BOOLEAN) ")
    rp._Stats:Query("CREATE TABLE IF NOT EXISTS KylDonate_Players (SteamID64 VARCHAR(32) PRIMARY KEY, Balance BIGINT NOT NULL DEFAULT 0)")
    rp._Stats:Query("CREATE TABLE IF NOT EXISTS KylDonate_BuyLogs (SteamID TEXT, DItemName TEXT, DItemID TEXT, DItemType TEXT, BuyTime TEXT)") 
]]--

KylDonate.BuyItem2DBWeapon = function(sid, id)
    rp._Stats:Query(string.format("INSERT INTO KylDonate_Weapons (SteamID, DItemID) VALUES ('%s', '%s')", sid, id))
end

KylDonate.AddBuyLog = function(sid, name, id, typer)
    rp._Stats:Query(string.format("INSERT INTO KylDonate_BuyLogs (SteamID, DItemName, DItemID, DItemType, BuyTime) VALUES (%s, %s, %s, %s, %s)", sql.SQLStr(sid), sql.SQLStr(name), sql.SQLStr(id), sql.SQLStr(typer), sql.SQLStr(tostring(os.time()))))
end

KylDonate.SetDonateCoins = function(sid, balance)
    local sid64 = KylDonate.NormalizeSteamID64(sid)
    local PL = KylDonate.FindPlayerByAnySteamID(sid)
    balance = math.floor(tonumber(balance) or 0)

    if sid64 == "" or not sid64:match("^765611%d+$") then return end

    rp._Stats:Query(string.format("REPLACE INTO KylDonate_Players (SteamID64, Balance) VALUES (%s, %d)", sql.SQLStr(sid64), balance))
    if IsValid(PL) and PL:IsPlayer() then
        PL:SetNWInt("kyl_balance", balance)
    end
end

KylDonate.AddDonateCoins = function(sid, balance)
    local sid64 = KylDonate.NormalizeSteamID64(sid)
    local olx = KylDonate.FindPlayerByAnySteamID(sid)
    balance = math.floor(tonumber(balance) or 0)

    if sid64 == "" or not sid64:match("^765611%d+$") then return end
    
    rp._Stats:Query("SELECT Balance FROM KylDonate_Players WHERE SteamID64 = " .. sql.SQLStr(sid64) .. ";", function(data)
        data = data or {}
        local current = 0
        if data[1] and data[1].Balance ~= nil then
            current = tonumber(data[1].Balance) or 0
        end

        local newBalance = math.floor(current + balance)
        KylDonate.SetDonateCoins(sid64, newBalance)

        if IsValid(olx) and olx:IsPlayer() then
            olx:SetNWInt("kyl_balance", newBalance)
        end
    end)
end

KylDonate.HasItem = function(ply, item, cb)
    rp._Stats:Query(string.format("SELECT DItemID FROM KylDonate_BuyLogs WHERE SteamID = %s AND DItemID = %s;", sql.SQLStr(ply:SteamID()), SQLStr(item)), function(data)
        cb(data[1] and data[1].DItemID ~= nil or false)
    end)
end

KylDonate.GiveItem = function(sid, name, id, typer)
    if typer == "weapons" then
        KylDonate.BuyItem2DBWeapon(sid, id)
    end
    KylDonate.AddBuyLog(sid, name, id, typer)
end

net.Receive(Tag, function(len, ply)
    local id = net.ReadString()
    local ppp = net.ReadBool()
    local item

    if ppp then
        item = KylDonate.GetPermanentItemByID(id)
    else
        item = KylDonate.GetItemByID(id)
    end

    if not item then return end

    if KylDonate.CantBuy(item) then return ply:ChatPrint("Этот предмет запрещен к покупке.") end
    KylDonate.HasItem(ply, item.id, function(data)
        if data and not item.multibuy then 
            return ply:ChatPrint("у тебя уже есть этот донат.")
        else
            if KylDonate.CanAfford(ply, item.cost.def) then
        
                if item.type == "weapons" then
                    if not ply.KylDonateWeap then ply.KylDonateWeap = { [item.weaponclass] = true } else ply.KylDonateWeap[item.weaponclass] = true end
        
                    ply:SetNWBool(item.weaponclass, true)
                    ply:Give(item.weaponclass)
                    
                    KylDonate.BuyItem2DBWeapon(ply:SteamID(), item.weaponclass)
        
                elseif item.type == "usergroups" then
                    
                    if KylDonate.Settings["Ranks"][item.usergroup] <= KylDonate.Settings["Ranks"][ply:GetUserGroup()] then return ply:ChatPrint("Твой ранг выше.") end
                    
                    if item.permitem then
                        game.ConsoleCommand(string.format("ba setgroup %s %s\n", ply:SteamID(), item.usergroup))
                    else
                        game.ConsoleCommand(string.format("ba setgroup %s %s %s %s\n", ply:SteamID(), item.usergroup, "1mo", ply:GetUserGroup()))
                    end
        
                end
                
                if item.on_buy then item.on_buy(ply, item) end

                KylDonate.AddBuyLog(ply:SteamID(), item.name, item.id, item.type)
                KylDonate.SetDonateCoins(ply:SteamID(), ply:GetNWInt('kyl_balance') - item.cost.def)    
                ply:ChatPrint("У вас осталось ".. tostring(ply:GetNWInt('kyl_balance')))

                for k, v in ipairs(player.GetAll()) do
                    v:ChatPrint("Игрок ".. ply:Name() .. " купил донат " .. item.name)
                end

            else

                return ply:ChatPrint("нехватка бабла на " ..tostring(item.name).. " пополняй, цена: " .. tostring(item.cost.def) .. " id: " .. tostring(item.id))
            end
        end
    end)
end)

hook.Add("LibFuse:PlayerFullyLoad", "DonateInit", function(ply)

    rp._Stats:Query("SELECT Balance FROM KylDonate_Players WHERE SteamID64 = " .. sql.SQLStr(ply:SteamID64()) .. ";", function(data)
        data = data or {}
        if data[1] then
            local coins = tonumber(data[1].Balance) or 0
            ply:SetNWInt("kyl_balance", coins)
        else
            ply:SetNWInt("kyl_balance", 0)
        end
    end)
    

    rp._Stats:Query(string.format("SELECT DItemID, toggle FROM KylDonate_Weapons WHERE SteamID = %s;", sql.SQLStr(ply:SteamID())), function(data)
        if next(data) then
            local prikolweps = data

            if not prikolweps or prikolweps == nil then return end
            if not ply.KylDonateWeap then ply.KylDonateWeap = {} end 
        
            for k, v in pairs(prikolweps) do
                ply.KylDonateWeap[v.DItemID] = tobool(v.toggle)
                ply:SetNWBool(v.DItemID, tobool(v.toggle))
            end
        end
    end)

end)


net.Receive(toggleweaponnetwork, function(len, ply)
    local weap = net.ReadString()
    local state = net.ReadBool()

    if ply.KylDonateWeap[weap] ~= nil then
        ply.KylDonateWeap[weap] = state
        rp._Stats:Query(string.format("UPDATE `KylDonate_Weapons` SET toggle = %s WHERE SteamID = %s AND DItemID = %s;", state and 1 or 0, sql.SQLStr(ply:SteamID()), sql.SQLStr(weap)))
        ply:SetNWBool(weap, state)
    end
end)

hook.Add("PlayerLoadout", "GiveDonateGuns", function(ply)
    timer.Simple(0.5, function()
        if ply.KylDonateWeap then
            for k, v in pairs(ply.KylDonateWeap) do
                if v and not ply:IsArrested() and not ply:IsBanned() and not ply:IsJailed() then ply:Give(k) end
            end
        end
    end)
end)


otec = otec or {}

util.AddNetworkString('gay_note')
function otec.SendToChatAll( ... )
    local Ar = {...} 
    net.Start"gay_note"
        net.WriteTable(Ar)
    net.Broadcast()
end


local table_donate_colors = {
    ["qiwi"] = Color(255,153,0),
    ["card"] = Color(255,245,0),
    ["SKINS"] = Color(116,179,174)
}


local function checkdonates()
    http.Fetch('http://46.174.50.240:3000/gmod/checkdatabase/justrpfunwithloveurbanichka', function(body)
        srv = util.JSONToTable(body) -- its json with info
        for k, v in pairs(srv.donators) do
            local olx = KylDonate.FindPlayerByAnySteamID(k)
                KylDonate.AddDonateCoins(k, math.floor(v.coins))
                if IsValid(olx) and olx:IsPlayer() then
                    otec.SendToChatAll(Color(255,77,119), "[DONATE] ", olx:GetJobColor(), olx:Name() , Color(255,255,255), " пополнил счёт на ", Color(0,166,17), v.coins, Color(255,255,255), " RUB с помощью ", table_donate_colors[v.pay_service] or Color(107,169,230), string.upper(v.pay_service))
                else
                    otec.SendToChatAll(Color(255,77,119), "[DONATE] ", Color(1, 89, 224), k , Color(255,255,255), " пополнил счёт на ", Color(0,166,17), v.coins, Color(255,255,255), " RUB с помощью ", table_donate_colors[v.pay_service] or Color(107,169,230), string.upper(v.pay_service))
                end
            srv.donators[k] = nil
        end
    end)
end

timer.Create('lolsmeh!!!!!', 5, 0, checkdonates)

--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
