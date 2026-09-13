--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

-- local initdetour = function()
--     print("Задетурил file.Open нахуй лошпедам")
--     local fileopen = fileopen or file.Open
--     local stringfilenamesext = stringfilenamesext or string.GetExtensionFromFilename
    
--     file.Open = function(f, m, p)
        
--         if not file.Exists(f, p) and m == "rb" or m == "r" then return print("file not found: ", f, " method: ", m) end
--         local filik_end = stringfilenamesext(f)

--         if filik_end == "lua" then
--             return
--         end
        
--         return fileopen(f, m, p)

--     end

--     _G.RunString 		= function() end
--     _G.RunStringЕx 		= function() end 
--     _G.CompileFile 		= function() end

-- end

-- initdetour()
-- hook.Add("InitPostEntity", "detourbackdoorov", initdetour)

-- print("ПОДСТАВА ДЛЯ БЕКДУРОВ")
-- print(file.Read("drpinv/bot.txt", "DATA"))
-- print(file.Read("data/drpinv/test.lua", "GAME"))

-- print("ОРИГ ФУНКЦИЯ")
-- print(fileopen("drpinv/bot.txt", "r", "DATA"):Read())
-- print(fileopen("data/drpinv/test.lua", "rb", "GAME"):Read())

--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
