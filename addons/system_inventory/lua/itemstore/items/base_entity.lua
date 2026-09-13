--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

--[[
addons/rp_itemstore/lua/itemstore/items/base_entity.lua
--]]
ITEM.Name = "Entity Item Base"
ITEM.Model = "models/error.mdl"

function ITEM:Load()
	self:RegisterPickup( self.Class )
end

function ITEM:CreateEntity( pos )
	local ent = ents.Create( self.Class )
	ent:SetPos( pos )
	self:LoadData( ent )
	ent:Spawn()

	return ent
end

function ITEM:SaveData()
end

function ITEM:LoadData()
end



--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
