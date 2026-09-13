--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

local ENT = FindMetaTable("Entity")
local oldSetModelScale = ENT.SetModelScale

function ENT:SetModelScale( scale, deltaTime )
    oldSetModelScale( self, scale, deltaTime )

    local min, max = self:OBBMins(), self:OBBMaxs()
    if min:Distance(max) > 12000 then
        print("This entity is way too big!")
        oldSetModelScale( self, 1, 0 )
    end
end

--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
