--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

--[[
addons/rp_itemstore/lua/itemstore/items/base_darkrp.lua
--]]
ITEM.Name = "DarkRP Item Base"
ITEM.Model = "models/error.mdl"
ITEM.Base = "base_entity"

function ITEM:CanPickup( pl, ent )
	if not ent.dt or not ent.dt.owning_ent then return true end

	if not itemstore.config.IgnoreOwner and ent:Getowning_ent() ~= pl then
		pl:ChatPrint( "You can't pick that up, it's not your's!" )
		return false
	end

	return true
end




--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
