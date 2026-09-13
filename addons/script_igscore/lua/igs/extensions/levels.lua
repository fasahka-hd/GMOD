--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher

--[[-------------------------------------------------------------------------
	Поддержка вот этого говнокода:
	https://github.com/vrondakis/Leveling-System
---------------------------------------------------------------------------]]
local STORE_ITEM = FindMetaTable("IGSItem")

function STORE_ITEM:SetLevels(iAmount)
	return self:SetInstaller(function(pl)
		pl:addLevels(iAmount)
	end)
end

function STORE_ITEM:SetEXP(iAmount)
	return self:SetInstaller(function(pl)
		pl:addXP(iAmount)
	end)
end


--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher
