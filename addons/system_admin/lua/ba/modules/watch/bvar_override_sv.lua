--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

local PLAYER = FindMetaTable('Player')

-- function PLAYER:SetBVar(var, val)
--     -- local ba = sestlf._ba or {}
--     local ba = self._ba or {}
    
--     ba[var] = val

-- 	self._ba = ba

--     if var == 'adminmode' then
--         hook.Call('OnAdminModeStateChanged', nil, self, val)
--     end
-- end

function PLAYER:SetBVar(var, val)
	if (self._ba == nil) then
		self._ba = {}
	end
	self._ba[var] = val

    if var == 'adminmode' then
        hook.Call('OnAdminModeStateChanged', nil, self, val)
    end
end

--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
