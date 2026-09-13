local function HasArizona(pl)
    return pl.HasPurchase and pl:HasPurchase("arizona_plus")
end

hook.Add("PlayerPayDay", "ArizonaPlus_Salary", function(pl, amount)
    if HasArizona(pl) then return amount * 3 end
end)

local meta = FindMetaTable("Player")
local oldArrest = meta.Arrest
function meta:Arrest(actor, reason, arrestTime)
    if HasArizona(self) then
        arrestTime = math.max(math.ceil((tonumber(arrestTime) or 900) / 2), 10)
    end
    return oldArrest(self, actor, reason, arrestTime)
end

sql.Query([[
    CREATE TABLE IF NOT EXISTS arizona_case_claims (
        steamid64 VARCHAR(64) PRIMARY KEY,
        claim_time INTEGER
    );
]])

local function CanClaimCase(ply)
    local sid = ply:SteamID64()
    local last = tonumber(sql.QueryValue(string.format("SELECT claim_time FROM arizona_case_claims WHERE steamid64 = %s;", sql.SQLStr(sid)))) or 0
    return (os.time() - last) >= 86400
end

local function ClaimCase(ply)
    local sid = ply:SteamID64()
    sql.Query(string.format(
        "REPLACE INTO arizona_case_claims (steamid64, claim_time) VALUES (%s, %d);",
        sql.SQLStr(sid),
        os.time()
    ))
    if ply.ub_addItem then ply:ub_addItem("Кейс Indiana") end
end

hook.Add("PlayerInitialSpawn", "ArizonaPlus_DailyCase", function(ply)
    timer.Simple(5, function()
        if not IsValid(ply) then return end
        if not HasArizona(ply) then return end
        if CanClaimCase(ply) then
            ClaimCase(ply)
            ply:ChatPrint("[Arizona+] Ежедневный кейс выдан! Следующий через 24 часа.")
        end
    end)
end)

timer.Create("ArizonaPlus_DailyCase_Timer", 600, 0, function()
    for _, ply in ipairs(player.GetAll()) do
        if HasArizona(ply) and CanClaimCase(ply) then
            ClaimCase(ply)
            ply:ChatPrint("[Arizona+] Ежедневный кейс выдан!")
        end
    end
end)
