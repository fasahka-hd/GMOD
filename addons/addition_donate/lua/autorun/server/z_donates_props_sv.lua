--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

KylDonate = KylDonate or {}
sql.Query("CREATE TABLE IF NOT EXISTS KylDonate_Props (sid TEXT PRIMARY KEY, count INT)")

KylDonate.AddProps = function(sid, count)
    sql.Query(string.format("REPLACE INTO KylDonate_Props (sid, count) VALUES (%s, %s)", sql.SQLStr(sid), sql.SQLStr(KylDonate.GetProps(sid) + count)))
end

KylDonate.GetProps = function(sid)
    local proplimit = sql.QueryValue( "SELECT count FROM KylDonate_Props WHERE sid = " .. sql.SQLStr( sid ) .. ";" )
    return proplimit or 0
end

hook.Add("LibFuse:PlayerFullyLoad", "KylDonate:Props", function(ply)
    local proplimit = KylDonate.GetProps(ply:SteamID64())
    ply.DonatePropLimit = proplimit
end)

--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
