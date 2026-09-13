--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

konkurs_real_life = konkurs_real_life or {}

-- rp._Stats:Query("CREATE TABLE IF NOT EXISTS konkurs_real_life (id INT AUTO_INCREMENT PRIMARY KEY, sid TEXT, name TEXT, ip TEXT) ")

-- konkurs_real_life.AddToList = function(sid, name, ip)
--     rp._Stats:Query(string.format("INSERT INTO konkurs_real_life (sid, name, ip) VALUES ('%s', '%s', '%s')", sid, name, ip))
-- end

-- konkurs_real_life.CheckInList = function(sid, cb)
--     rp._Stats:Query(string.format("SELECT sid FROM konkurs_real_life WHERE sid = %s;", SQLStr(sid)), function(data)
--         cb(data[1] and data[1].sid ~= nil)
--     end)
-- end

-- timer.Create("LibFuse:Konkurs:RealLife", 160, 0, function()
--     for k, v in ipairs(player.GetAll()) do
--         if v:GetPlayTime() >= 180000 then
--             konkurs_real_life.CheckInList(v:SteamID(), function(data)
--                 if not data then
--                     konkurs_real_life.AddToList(v:SteamID(), v:Name(), v:IPAddress())
--                 end
--             end)
--         end
--     end
-- end)



--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
