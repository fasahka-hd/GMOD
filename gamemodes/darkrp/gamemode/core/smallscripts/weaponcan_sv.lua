--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

hook.Add("PlayerCanPickupWeapon", "SanitarsCode1", function(ply, weapon)
    if(weapon == nil) then return end
    local weapon_class = weapon:GetClass()
    local team_ply = ply:Team()
    local STm = rp.teams[team_ply]
    if ply:IsRoot() then return true end
    if table.HasValue(rp.cfg.Havygun, weapon_class) && !STm.canHavy then
        if !ply.noticed || ply.noticed <= CurTime() then
            rp.Notify(ply, NOTIFY_ERROR, "Вы не можете взять это оружие за эту профессию!")
        end
        ply.noticed = CurTime()+1
        return false
    elseif table.HasValue(rp.cfg.Vzri, weapon_class) && !STm.canLite then
        if !ply.noticed || ply.noticed <= CurTime() then
            rp.Notify(ply, NOTIFY_ERROR, "Вы не можете взять это оружие за эту профессию!")
        end
        ply.noticed = CurTime()+1
        return false
    elseif table.HasValue(rp.cfg.Litegun, weapon_class) && !STm.canVzri then
        if !ply.noticed || ply.noticed <= CurTime() then
            rp.Notify(ply, NOTIFY_ERROR, "Вы не можете взять это оружие за эту профессию!")
        end
        ply.noticed = CurTime()+1
        return false
    end
end)

--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
