--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher

local STORE_ITEM = FindMetaTable("IGSItem")

function STORE_ITEM:SetPremiumPoints(iAmount)
	return self:SetInstaller(function(pl)
		pl:PS2_AddPremiumPoints(iAmount)
	end):SetMeta("ps2_prempoints", iAmount)
end

function STORE_ITEM:SetPoints(iAmount)
	return self:SetInstaller(function(pl)
		pl:PS2_AddStandardPoints(iAmount, "/donate")
	end):SetMeta("ps2_points", iAmount)
end


--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher
