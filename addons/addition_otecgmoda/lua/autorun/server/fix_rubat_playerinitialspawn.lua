--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

local second_player = false

hook.Add("InitPostEntity", "LibFuse:RubatDaun", function()
    game.ConsoleCommand("bot\n")
end)

hook.Add("PlayerInitialSpawn", "LibFuse:SecondPlayer", function(ply)

    -- if second_player then
    --     if Entity(1) and Entity(1):IsBot() then Entity(1):Kick("not need") end
    --     hook.Remove("InitPostEntity", "LibFuse:RubatDaun")
    --     hook.Remove("PlayerInitialSpawn", "LibFuse:SecondPlayer")
    -- end

    -- second_player = true
    -- print("Second player set to true")

end)

--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
