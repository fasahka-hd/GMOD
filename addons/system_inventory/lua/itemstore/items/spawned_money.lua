--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

--[[
addons/rp_itemstore/lua/itemstore/items/spawned_money.lua
--]]
ITEM.Name = itemstore.Translate( "money_name" )
ITEM.Description = itemstore.Translate( "money_desc" )
ITEM.Model = "models/props/cs_assault/money.mdl"
ITEM.Base = "base_darkrp"
ITEM.Stackable = true
ITEM.DropStack = true
ITEM.MaxStack = math.huge

function ITEM:Use( pl )
	itemstore.gamemodes.GiveMoney( pl, self:GetAmount() )
	return true
end

function ITEM:SaveData( ent )
	self:SetAmount( ent:Getamount() )
end

function ITEM:LoadData( ent )
	ent:Setamount( self:GetAmount() )
end




--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
