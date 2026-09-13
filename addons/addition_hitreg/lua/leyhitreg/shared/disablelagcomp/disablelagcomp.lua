--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

local meta = FindMetaTable("Player")
meta.OldLagCompensation = meta.OldLagCompensation or meta.LagCompensation
function meta:LagCompensation(...)
    if (LeyHitreg.DisableLagComp and not LeyHitreg.Disabled) then
        return
    end
    return self:OldLagCompensation(...)
end

--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
