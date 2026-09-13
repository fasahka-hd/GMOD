--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

hook.Add("PlayerInitialSpawn", "AntiSteamIDSpoof", function(ply)
    if game.SinglePlayer() then return end

    timer.Simple(0, function()
        if IsValid(ply) == false or ply:IsBot() or ply:IsListenServerHost() or ply.IsFullyAuthenticated == nil or ply:IsFullyAuthenticated() then return end

        ply:Kick("Ваш SteamID не был полностью аутентифицирован, попробуйте перезапустить steam.")
    end)
end)

--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
