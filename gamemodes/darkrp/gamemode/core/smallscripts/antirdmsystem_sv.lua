--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

local RDM_KILLS = 3
local RDM_TIME = 30

hook.Add("PlayerDeath", "RDM_Detection", function(vic, _, att)
    if not IsValid(att) or not att:IsPlayer() or att == vic then return end

    att.RDMKills = att.RDMKills or {}
    table.insert(att.RDMKills, CurTime())

    for i = #att.RDMKills, 1, -1 do
        if CurTime() - att.RDMKills[i] > RDM_TIME then
            table.remove(att.RDMKills, i)
        end
    end

    if #att.RDMKills >= RDM_KILLS then
        ba.notify_staff("Подозрение на RDM: " .. att:Name() .. " (" .. att:SteamID() .. ") — " .. #att.RDMKills .. " убийств за 30 сек")
        att.RDMKills = {}
    end
end)

hook.Add("PlayerDisconnected", "RDM_Cleanup", function(ply)
    ply.RDMKills = nil
end)

--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher