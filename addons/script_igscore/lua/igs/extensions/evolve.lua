--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher

local ITEM = FindMetaTable("IGSItem")

function ITEM:SetEvolveRank(rank)
	return self:SetInstaller(function(pl)
		evolve.PlayerInfo[pl:UniqueID()]["Rank"] = rank
	end):SetValidator(function(pl)
		return evolve.PlayerInfo[pl:UniqueID()]["Rank"] == rank
	end):SetMeta("ev_rank", rank)
end


--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher
