--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

hook.Add('PlayerNoClip', 'ba.PlayerNoClip', function(pl)
    if pl:Team() == TEAM_ADMIN then
        return true
    end
    if pl:GetBVar('adminmode') == true and (pl:HasAccess('l') or pl:IsRoot()) then
        return true
    end
    return false
end)


--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
