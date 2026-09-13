local WhitelistEnabled = true

local Whitelist = {
    "76561199111731031", -- Angel
    "76561198004451747", -- Gero -- Frik
    "76561199781623734", -- Angel
	"76561199085348872", -- Frik
--	"76561199088673440", -- Keix
    
--    "76561199156650709", -- newliz
--    "76561199430391633", -- bobr
--    "76561199674713380", -- paradox
--    "76561199681664660", -- kanatan
--    "76561199690259938", -- Владиславик
--   "76561199833558743", -- spicsamen
--	"76561199482229924", -- HECKBUK
}

local function GetSteamID64(ply)
    return ply:SteamID64()
end

local function IsBotSteamID64(steamID64)
    steamID64 = tostring(steamID64 or "")
    return steamID64 == "0" or steamID64 == "BOT"
end

local function IsWhitelisted(steamID64)
    if IsBotSteamID64(steamID64) then return true end

    for _, allowedID in ipairs(Whitelist) do
        if steamID64 == allowedID then
            return true
        end
    end

    return false
end

hook.Add("CheckPassword", "WhitelistCheck", function(steamID64, ipAddress, svPassword, clPassword, playerName)
    if not WhitelistEnabled then return end
    if IsWhitelisted(steamID64) then return end

    return false, "Технические работы!\nВсе новости в дискорд сервере.\n https://discord.gg/arizonaroleplay"
end)

hook.Add("PlayerInitialSpawn", "WhitelistSpawnCheck", function(ply)
    if not WhitelistEnabled then return end
    if ply:IsBot() then return end
    if IsWhitelisted(GetSteamID64(ply)) then return end

    ply:Kick("Вы не в белом списке!")
end)