--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

--[[
addons/rp_itemstore/lua/itemstore/items/spawned_ammo.lua
--]]
ITEM.Name = itemstore.Translate( "ammo_name" )
ITEM.Description = itemstore.Translate( "ammo_desc" )
ITEM.Stackable = true
ITEM.DropStack = true
ITEM.Base = "base_darkrp"

function ITEM:GetName()
	if SERVER then
		return self:GetData( "Name", self.Name )
	else
		return self:GetData( "Name", language.GetPhrase( self:GetData( "AmmoType" ) .. "_ammo" )  )
	end
end

function ITEM:Use( pl )
	pl:GiveAmmo( self:GetAmount(), self:GetData( "AmmoType" ) )
	return true
end

function ITEM:CanMerge( item )
	return self.Stackable and self:GetClass() == item:GetClass() and
		self:GetData( "AmmoType" ) == item:GetData( "AmmoType" )
end

function ITEM:SaveData( ent )
	self:SetModel( ent:GetModel() )
	self:SetAmount( ent.amountGiven )	
	self:SetData( "AmmoType", ent.ammoType )
end

function ITEM:LoadData( ent )
	ent:SetModel( self:GetModel() )
	ent.amountGiven = self:GetAmount()	
	ent.ammoType = self:GetData( "AmmoType" )
end




--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
