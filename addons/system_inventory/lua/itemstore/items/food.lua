--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

--[[
addons/rp_itemstore/lua/itemstore/items/food.lua
--]]
ITEM.Name = itemstore.Translate( "food_name" )
ITEM.Description = itemstore.Translate( "microwavefood_desc" )
ITEM.Model = "models/props_junk/garbage_takeoutcarton001a.mdl"
ITEM.Base = "base_darkrp"
ITEM.Stackable = true

function ITEM:Use( pl )
	pl:setSelfDarkRPVar( "Energy", 100 )
	umsg.Start( "AteFoodIcon", pl ) umsg.End()

	return self:TakeOne()
end

function ITEM:SaveData( ent )
	self:SetData( "Owner", ent:Getowning_ent() )
end

function ITEM:LoadData( ent )
	ent:Setowning_ent( self:GetData( "Owner" ) )
end



--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
