--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

local meta = FindMetaTable("CTakeDamageInfo")
LeyHitreg.ScaleDamageBlockEntity = LeyHitreg.ScaleDamageBlockEntity or {}
meta.OldScaleDamage = meta.OldScaleDamage or meta.ScaleDamage
function meta:ScaleDamage(scale)
    if (self:IsBulletDamage() and LeyHitreg and LeyHitreg.ScaleDamageBlockEntity[self:GetAttacker()]) then
        return
    end
    return self:OldScaleDamage(scale)
end

--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
