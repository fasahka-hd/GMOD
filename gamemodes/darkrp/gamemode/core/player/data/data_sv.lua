--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

rp.data = rp.data or {}
local db = rp._Stats

function rp.data.LoadPlayer(pl, cback)
    db:Query('SELECT * FROM player_data WHERE SteamID=' .. pl:SteamID64() .. ';', function(_data)
        local data = _data[1] or {}

        if IsValid(pl) then
            if (#_data <= 0) then
                db:Query('INSERT INTO player_data(SteamID, Name, Money, Pocket, Achs, FirstJoin) VALUES(?, ?, ?, ?, ?, ?);', pl:SteamID64(), pl:SteamName(), rp.cfg.StartMoney, '{}', '[]', os.time())
                --pl:SetRPName(rp.names.Random(), true)
            end

            if data.Name and (data.Name ~= pl:SteamName()) then
                pl:SetNetVar('Name', data.Name)
            end

            db:Query('SELECT * FROM player_hats WHERE SteamID=' .. pl:SteamID64() .. ';', function(data)
                nw.WaitForPlayer(pl, function()
                    local HatData = {}
                    for k, v in ipairs(data) do
                        HatData[k] = v.Model
                        if (tonumber(v.Active) == 1) then
                            pl:SetHat(v.Model)
                        end
                    end
                    pl:SetNetVar('HatData', HatData)
                end)
            end)

            
            nw.WaitForPlayer(pl, function()
                pl:SetNetVar('Money', data.Money or rp.cfg.StartMoney)
                -- pl:SetNetVar('Achs', (util.JSONToTable(data.Achs or '[]')) or {})
                pl:SetVar('lastpayday', CurTime() + 180, false, false)
                pl:SetVar('DataLoaded', true)
                pl:SetNetVar("FirstJoin", data.FirstJoin or os.time())
                hook.Call('PlayerDataLoaded', GAMEMODE, pl, data)
            end)
            
            
            if cback then
                cback(data)
            end
        end
    end)
end
--[[
function GM:PlayerAuthed(pl) -- PlayerAuthed before
    rp.data.LoadPlayer(pl)
end

function GM:PlayerInitialSpawn(pl) -- PlayerAuthed before
    rp.data.LoadPlayer(pl)
end
]]
function GM:PlayerAuthed(pl) end

hook.Add('PlayerInitialSpawn', 'LoadData', function(pl)
    rp.data.LoadPlayer(pl)
end)

function rp.data.SetName(pl, name, cback)
    db:Query('UPDATE player_data SET Name=? WHERE SteamID=' .. pl:SteamID64() .. ';', name, function(data)
        pl:SetNetVar('Name', name)

        if cback then
            cback(data)
        end
    end)
end

function rp.data.GetNameCount(name, cback)
    db:Query('SELECT COUNT(*) as `count` FROM player_data WHERE Name=?;', name, function(data)
        if cback then
            cback(tonumber(data[1].count) > 0)
        end
    end)
end

function rp.data.SetMoney(pl, amount, cback)
    db:Query('UPDATE player_data SET Money=? WHERE SteamID=' .. pl:SteamID64() .. ';', amount, cback)
end

function rp.data.PayPlayer(pl1, pl2, amount)
    if not IsValid(pl1) or not IsValid(pl2) then return end
    -- for i = 1, amount do
        eui.battlepass.AddProgress(pl1, 23)
        eui.battlepass.AddProgress(pl1, 25)
        eui.battlepass.AddProgress(pl1, 38)
    -- end

    pl1:TakeMoney(amount, 'Передача денег -> ' .. pl2:SteamID64() .. ' TakeMoney')
	pl2:AddMoney(amount, 'Передача денег <- ' .. pl1:SteamID64() .. ' AddMoney')
end

function rp.data.SetPocket(steamid64, data, cback)
    db:Query('UPDATE player_data SET Pocket=? WHERE SteamID=' .. steamid64 .. ';', data, cback)
end

function rp.data.SetHat(pl, mdl, cback)
    local steamid = pl:SteamID64()
    db:Query('UPDATE player_hats Set Active=0 WHERE SteamID=' .. steamid .. ';', function()
        if (mdl ~= nil) then
            db:Query('REPLACE INTO player_hats(SteamID, Model, Donate, Active) VALUES(?, ?, 0, 1);', steamid, mdl, function() -- We assume you own it
                if IsValid(pl) then
                    pl:SetHat(mdl)
                end
                if cback then cback() end
            end)
        else    
            if IsValid(pl) then
                pl:SetHat(nil)
            end
            if cback then cback() end
        end
    end)
end

function rp.data.IsLoaded(pl)
    if IsValid(pl) and (pl:GetVar('DataLoaded') ~= true) then
		local timerName = "PlayerReload:" .. pl:UniqueID()

		file.Append('data_load_err.txt', os.date() .. '\n' .. pl:Name() .. '\n' .. pl:SteamID() .. '\n' .. pl:SteamID64() .. '\n' .. debug.traceback() .. '\n\n')
		rp.Notify(pl, NOTIFY_ERROR,  'ВАШИ ДАННЫЕ НЕ ЗАГРУЖЕНЫ. ПОЖАЛУЙСТА, ПОДОЖДИТЕ. ЕСЛИ ЭТО СЛУЧИТСЯ СНОВА, ПОЖАЛУЙСТА, СООБЩИТЕ НАМ ОБ ЭТОМ!')

		if timer.Exists(timerName) then return false end

		timer.Create(timerName, 30, 5, function()
			if rp.data.IsLoaded(pl) then timer.Remove(timerName) return true end
			print("Неудачная попытка загрузить данные игрока " .. pl:NameID() .. " (" .. (5 - timer.RepsLeft(timerName)) .. "/5)")
			rp.data.LoadPlayer(pl)
		end)

		return false
	end
	return true
end

hook('InitPostEntity', 'data.InitPostEntity', function()
    db:Query('UPDATE player_data SET Money=' .. rp.cfg.StartMoney .. ' WHERE Money <' .. rp.cfg.StartMoney / 2)
end)

--
--	Meta
--
local math = math

function PLAYER:AddMoney(amount, description)
    if not rp.data.IsLoaded(self) then return end
    local total = self:GetMoney() + math.floor(amount)
    rp.data.SetMoney(self, total)
    self:SetNetVar('Money', total)

    if not description then
		description = "SERVER"
	end
	local Timestamp = os.time()
	local TimeString = os.date( "%Y-%m-%d" , Timestamp )

	db:Query('INSERT INTO player_moneylog(Name, SteamID64, Money, Description, NormalDate) VALUES(?, ?, ?, ?, ?);', self:Name(), self:SteamID64(), amount, description, TimeString)
end

function PLAYER:TakeMoney(amount, description)
    self:AddMoney(-math.abs(amount), description)
end

--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
