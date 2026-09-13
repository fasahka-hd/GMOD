--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

--[[
addons/rp_itemstore/lua/itemstore/items/sent_drug_bag.lua
--]]
ITEM.Name = "Наркотики"
ITEM.Description = "Наркотики можно продать или использовать."
ITEM.Model = "models/gonzo/weedb/bag/bag.mdl"
ITEM.Base = "base_entity"

function ITEM:SaveData( ent )
	self:SetData( "Consumable", ent:GetNWInt("Consumable") )
	self:SetData( "Quality", ent:GetNWInt("Quality") )
	self:SetData( "Level", ent:GetLevel() )
end

function ITEM:LoadData( ent )
	
	timer.Simple( 0, function() 
		ent:SetLevel(self:GetData( "Level" )) 
		ent:SetNWInt("Consumable", self:GetData( "Consumable" ) )
		ent:SetNWInt("Quality", self:GetData( "Quality" ) )
	end )
end


function ITEM:GetDescription()
	local text  = "Качество: "..self:GetData( "Quality" )
	return text
end



--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
