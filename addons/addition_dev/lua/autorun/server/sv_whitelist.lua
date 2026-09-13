--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

local allowed = {
    ["STEAM_0:1:59499199"] = true, -- Kuchiki
    ["STEAM_0:1:393528659"] = true, -- Mongol
    ["STEAM_0:1:556404949"] = true, -- Calvin Brauer
    ["STEAM_0:1:511090883"] = false, -- Patrick В Дурке
    ["STEAM_0:1:533967088"] = false, -- Нарды онлайн
    ["STEAM_0:1:459341597"] = false, -- Николай Ежов
    ["STEAM_0:0:176981071"] = true, -- Хацкер
    ["STEAM_0:1:622106554"] = false, -- Maer
    ["STEAM_0:0:704579191"] = false, -- Rorono Zoro
    ["STEAM_0:0:539697513"] = true, -- Evloution
    ["STEAM_0:1:551275381"] = false, -- Иван Станков
    ["STEAM_0:1:153424982"] = false, -- Dante
    ["STEAM_0:0:593688241"] = false, -- Terl
    ["STEAM_1:0:565092064"] = false, -- exclusive
    ["STEAM_0:0:100133833"] = true, -- Kredo_durke
    ["STEAM_0:1:583122205"] = false, -- impulse
    ["STEAM_0:1:533701298"] = false, -- Lowe
	["STEAM_1:0:452832317"] = false,
	["STEAM_0:1:632733340"] = false,
	["STEAM_0:1:635827856"] = false,
	['STEAM_0:1:22093009'] = true, // владелец сервера, гений, плейбой миллионер
	['STEAM_0:0:571095000'] = true, // твинк этого гения
	['STEAM_0:1:555628590'] = true, // еще один твинк
	['STEAM_0:1:504096009'] = true,
	['STEAM_0:1:162691116'] = true,
}

local tempallowed = {}

-- for i, v in player.Iterator() do
-- 	if not allowed[v:SteamID()] then
-- 		RunConsoleCommand('disconnect')
-- 	end
-- end

local whitelist = false
local message = [[

Технические Работы!

-------------------------------------
Время входа: %s
SteamID: %s
-------------------------------------

DISCORD: https://discord.gg/arizonaroleplay

]]

concommand.Add("whitelist_tempadd", function(ply, cmd, args)
	if IsValid(ply) then
		if ply:IsRoot() then
			--local _, endpos, sid = args:find("^(STEAM_%d:%d:%d+) (%d+)")
			local steamid = args[1]
			if !steamid and steamid == '' then
				ply:SendLua([[
					chat.AddText(Color(255, 140, 0), "[ARIZONARP] ", color_white, "Формат должен быть whitelist_tempadd STEAM_0:1:2345678!")
				]])
				return
			end

			allowed[steamid] = true
			tempallowed[steamid] = true
			ply:SendLua([[
				chat.AddText(Color(255, 140, 0), "[ARIZONARP] ", color_white, "Успешно!")
			]])
		end
	end
end)

concommand.Add("whitelist_start", function(pl, cmd, args)
	if ply:IsRoot() then
		if !whitelist then
			whitelist = true
			-- chat.AddText
		else
			if IsValid(ply) then
				ply:SendLua([[
					chat.AddText(Color(255, 140, 0), "[ARIZONARP] ", color_white, "WhiteList уже включен!")
				]])
			end
		end
	end
end)

hook.Add("CheckPassword", "Just_WhiteList", function(steamid)
	if whitelist then
		if not allowed[util.SteamIDFrom64(steamid)] then
			local time = os.date('%d/%m/%y - %H:%M', os.time())
			return false, string.format(message, time, util.SteamIDFrom64(steamid))
		end
		if tempallowed[util.SteamIDFrom64(steamid)] then
			tempallowed[util.SteamIDFrom64(steamid)] = nil
			allowed[steamid] = nil
		end
	end
end)



--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
