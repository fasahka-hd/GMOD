--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

local IsValid = IsValid
local ipairs = ipairs

timer.Destroy('HostnameThink')

ENTITY._SetHealth = ENTITY._SetHealth or ENTITY.SetHealth
ENTITY.SetHealth = function(self, amt)
	if IsValid(self) and self:IsPlayer() and (amt > 500) then
		return self:_SetHealth(500)
	end
	return self:_SetHealth(amt)
end

function ENTITY:IsConstrained()
	local c = self.Constraints
	if c then
		for k, v in ipairs(c) do
			if v:IsValid() then 
				return true 
			end
			c[k] = nil
		end
	end
	return false
end

-- _G.RunString 		= function() end -- We dont use these.
-- _G.RunStringЕx 		= function() end 
-- _G.CompileString 	= function() end 
-- _G.CompileFile 		= function() end 

--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
