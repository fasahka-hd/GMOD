require("chttp")

local WEBHOOK_URL = "https://discord.com/api/webhooks/1461500412690432225/C0e6Ir00FmcZsPOxJ_0ei6vMKupzhMtPRlqvrC5poGd_iHSFz6BGzoQoTj28kmmb8h3L"

local SERVER_NAME = GetHostName and GetHostName() or "DarkRP Server"

local COLORS = {
	WEAPON     = 16747520,
	NPC        = 5763719,
	ENTITY     = 3447003,
	VEHICLE    = 15844367,
	ECONOMY    = 3066993,
	SUSPICIOUS = 16711680,
	DONATE     = 15105570,
	TRADE      = 8359034,
}

local function getPlyInfo(ply)
	if not IsValid(ply) then return "Unknown", "0", "0" end
	return ply:Nick(), ply:SteamID(), ply:SteamID64() or "0"
end

local function steamProfile(steamid64)
	if not steamid64 or steamid64 == "0" then return "" end
	return "https://steamcommunity.com/profiles/" .. steamid64
end

local function formatMoney(amount)
	if amount >= 1000000 then
		return string.format("%.1fM$", amount / 1000000)
	elseif amount >= 1000 then
		return string.format("%.1fK$", amount / 1000)
	end
	return tostring(amount) .. "$"
end

function SendDiscordLog(data)
	if not CHTTP then return end

	CHTTP({
		method = "POST",
		url = WEBHOOK_URL,
		body = util.TableToJSON(data),
		type = "application/json",
	})
end

function LogEvent(colorKey, title, fields, isAlert)
	local color = COLORS[colorKey] or COLORS.ENTITY

	if isAlert then
		SendDiscordLog({
		})
	end

	local embed = {
		author = {
			name = title,
		},
		color = color,
		fields = fields,
		footer = {
			text = SERVER_NAME,
		},
		timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ"),
	}

	SendDiscordLog({
		username = "Сервер Логи",
		embeds = { embed },
	})
end

local SPAWN_WEAPONS = {
	["keys"]           = true,
	["pocket"]         = true,
	["weapon_physgun"] = true,
	["gmod_tool"]      = true,
	["weapon_fists"]   = true,
	["weapon_physcannon"] = true,
	["weapon_bugbait"] = true,
	["weapon_crowbar"] = true,
	["weapon_stunstick"] = true,
	["weapon_pistol"]  = true,
	["weapon_357"]     = true,
	["weapon_smg1"]    = true,
	["weapon_ar2"]     = true,
	["weapon_shotgun"] = true,
	["weapon_crossbow"] = true,
	["weapon_rpg"]     = true,
	["weapon_frag"]    = true,
	["stunstick"]      = true,
	["med_kit"]        = true,
}

local lastSpawnTime = {}

hook.Add("PlayerSpawn", "AllLogs_SpawnTime", function(ply)
	lastSpawnTime[ply:SteamID64()] = CurTime()
end)

hook.Add("WeaponEquip", "AllLogs_WeaponEquip", function(wep, ply)
	if not IsValid(ply) or not IsValid(wep) then return end
	local class = wep:GetClass()

	if SPAWN_WEAPONS[class] then return end

	local spawnT = lastSpawnTime[ply:SteamID64()]
	if spawnT and (CurTime() - spawnT) < 5 then return end

	local name, steamid, steamid64 = getPlyInfo(ply)
	LogEvent("WEAPON", "Выдача оружия", {
		{ name = "Игрок", value = "**" .. name .. "**", inline = true },
		{ name = "SteamID", value = "[" .. steamid .. "](" .. steamProfile(steamid64) .. ")", inline = true },
		{ name = "Оружие", value = "`" .. class .. "`", inline = false },
	})
end)

hook.Add("PlayerSpawnedNPC", "AllLogs_NPCSpawned", function(ply, ent)
	if not IsValid(ply) or not IsValid(ent) then return end
	local name, steamid, steamid64 = getPlyInfo(ply)
	LogEvent("NPC", "Спавн NPC", {
		{ name = "Игрок", value = "**" .. name .. "**", inline = true },
		{ name = "SteamID", value = "[" .. steamid .. "](" .. steamProfile(steamid64) .. ")", inline = true },
		{ name = "Класс", value = "`" .. ent:GetClass() .. "`", inline = false },
	})
end)

hook.Add("PlayerSpawnedSENT", "AllLogs_EntitySpawned", function(ply, ent)
	if not IsValid(ply) or not IsValid(ent) then return end
	local name, steamid, steamid64 = getPlyInfo(ply)
	LogEvent("ENTITY", "Спавн Entity", {
		{ name = "Игрок", value = "**" .. name .. "**", inline = true },
		{ name = "SteamID", value = "[" .. steamid .. "](" .. steamProfile(steamid64) .. ")", inline = true },
		{ name = "Класс", value = "`" .. ent:GetClass() .. "`", inline = false },
	})
end)

local playerVehicles = {}

hook.Add("PlayerSpawnedVehicle", "AllLogs_VehicleSpawned", function(ply, ent)
	if not IsValid(ply) or not IsValid(ent) then return end
	local name, steamid, steamid64 = getPlyInfo(ply)
	local sid64 = ply:SteamID64()
	playerVehicles[sid64] = (playerVehicles[sid64] or 0) + 1

	LogEvent("VEHICLE", "Спавн транспорта", {
		{ name = "Игрок", value = "**" .. name .. "**", inline = true },
		{ name = "SteamID", value = "[" .. steamid .. "](" .. steamProfile(steamid64) .. ")", inline = true },
		{ name = "Класс", value = "`" .. ent:GetClass() .. "`", inline = true },
		{ name = "Всего машин", value = tostring(playerVehicles[sid64]), inline = true },
	})
end)

function LogMoneyTransfer(sender, receiver, amount)
	local sName, sSid, sSid64 = getPlyInfo(sender)
	local rName, rSid, rSid64 = getPlyInfo(receiver)
	local isSus = amount >= 500000

	LogEvent(isSus and "SUSPICIOUS" or "ECONOMY", isSus and "Крупная передача денег" or "Передача денег", {
		{ name = "Отправитель", value = "**" .. sName .. "** (" .. sSid .. ")", inline = true },
		{ name = "Получатель", value = "**" .. rName .. "** (" .. rSid .. ")", inline = true },
		{ name = "Сумма", value = "**" .. formatMoney(amount) .. "**", inline = false },
	}, isSus)
end

function LogMoneyDrop(ply, amount)
	local name, steamid, steamid64 = getPlyInfo(ply)
	local isSus = amount >= 500000

	LogEvent(isSus and "SUSPICIOUS" or "ECONOMY", isSus and "Крупный выброс денег" or "Выброс денег", {
		{ name = "Игрок", value = "**" .. name .. "**", inline = true },
		{ name = "SteamID", value = "[" .. steamid .. "](" .. steamProfile(steamid64) .. ")", inline = true },
		{ name = "Сумма", value = "**" .. formatMoney(amount) .. "**", inline = false },
	}, isSus)
end

function LogTradeEvent(event, data)
	local name, steamid, steamid64 = getPlyInfo(data.ply)
	local isSuccess = event == "end_success"
	local statusText = isSuccess and "Успешно" or "Отменено"

	LogEvent("TRADE", "Трейд", {
		{ name = "Игрок", value = "**" .. name .. "**", inline = true },
		{ name = "SteamID", value = "[" .. steamid .. "](" .. steamProfile(steamid64) .. ")", inline = true },
		{ name = "Статус", value = statusText, inline = true },
		{ name = "Инфо", value = data.info or "нет", inline = true },
	})
end

function LogDuelEvent(event, data)
	local p1Name, p1Sid = getPlyInfo(data.p1)
	local p2Name, p2Sid = getPlyInfo(data.p2)
	local isStart = event == "start"
	local eventText = isStart and "Начало дуэли" or "Завершение дуэли"

	LogEvent("TRADE", eventText, {
		{ name = "Участник 1", value = "**" .. p1Name .. "** (" .. p1Sid .. ")", inline = true },
		{ name = "Участник 2", value = "**" .. p2Name .. "** (" .. p2Sid .. ")", inline = true },
		{ name = "Результат", value = data.result or "—", inline = false },
	})
end

function LogDonateDrop(ply, item, amount)
	local name, steamid, steamid64 = getPlyInfo(ply)
	LogEvent("DONATE", "Выброс доната", {
		{ name = "Игрок", value = "**" .. name .. "**", inline = true },
		{ name = "SteamID", value = "[" .. steamid .. "](" .. steamProfile(steamid64) .. ")", inline = true },
		{ name = "Предмет", value = "`" .. item .. "`", inline = true },
		{ name = "Кол-во", value = tostring(amount), inline = true },
	})
end

function LogDonatePickup(ply, item, ownerName, ownerSteamid)
	local name, steamid, steamid64 = getPlyInfo(ply)
	LogEvent("DONATE", "Подбор доната", {
		{ name = "Кто поднял", value = "**" .. name .. "**", inline = true },
		{ name = "SteamID", value = "[" .. steamid .. "](" .. steamProfile(steamid64) .. ")", inline = true },
		{ name = "Предмет", value = "`" .. item .. "`", inline = true },
		{ name = "Кто выкинул", value = "**" .. ownerName .. "** (" .. ownerSteamid .. ")", inline = true },
	})
end

print("[LOGS] system loaded!")