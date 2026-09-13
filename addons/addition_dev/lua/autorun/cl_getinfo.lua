--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

concommand.Add('get_info', function(pl)
    local prop = pl:GetEyeTrace().Entity
    if IsValid(prop) then
        pl:PrintMessage(HUD_PRINTCONSOLE, prop:GetClass())
        pl:PrintMessage(HUD_PRINTCONSOLE, 'mdl = \''..prop:GetModel()..'\',')
        pl:PrintMessage(HUD_PRINTCONSOLE, 'pos = Vector('..string.gsub(tostring(prop:GetPos()), ' ', ', ')..'),')
        pl:PrintMessage(HUD_PRINTCONSOLE, 'ang = Angle('..string.gsub(tostring(prop:GetAngles()), ' ', ', ')..'),')
        pl:PrintMessage(HUD_PRINTCONSOLE, 'mat = \'' .. prop:GetMaterial() .. '\',')
    end
end)

--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
