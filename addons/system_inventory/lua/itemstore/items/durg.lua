--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

--[[
addons/rp_itemstore/lua/itemstore/items/durg.lua
--]]
ITEM.Name = itemstore.Translate( "drug_name" )
ITEM.Description = itemstore.Translate( "drug_desc" )
ITEM.Model = "models/props_lab/jar01a.mdl"
ITEM.Base = "base_darkrp"
ITEM.Stackable = true

function ITEM:SaveData( ent )
	self:SetData( "Price", ent:Getprice() )
	self:SetData( "Owner", ent:Getowning_ent() )
end

function ITEM:LoadData( ent )
	ent:Setprice( self:GetData( "Price" ) )
	ent:Setowning_ent( self:GetData( "Owner" ) )
end



--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
