--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

--[[
addons/rp_itemstore/lua/itemstore/items/microwave.lua
--]]
ITEM.Name = itemstore.Translate( "microwave_name" )
ITEM.Description = itemstore.Translate( "microwave_desc" )
ITEM.Model = "models/props/cs_office/microwave.mdl"
ITEM.Base = "base_darkrp"

function ITEM:SaveData( ent )
	self:SetData( "Price", ent:Getprice() )
	self:SetData( "Owner", ent:Getowning_ent() )
end

function ITEM:LoadData( ent )
	ent:Setprice( self:GetData( "Price" ) )

	local owner = self:GetData( "Owner" )
	if not IsValid( owner ) then
		owner = player.GetAll()[ 1 ]
	end

	ent:Setowning_ent( owner )
end



--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
