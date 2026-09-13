--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

--[[
addons/rp_foodmode/lua/itemstore/items/base_seed.lua
--]]
ITEM.Name = "Hlife Seed"
ITEM.Description = ""
ITEM.Model = "models/error.mdl"
ITEM.Base = "base_entity"
ITEM.Stackable = false

function ITEM:CanPickup( pl, ent )
	return ent:GetDTInt(1) == 0
end

function ITEM:GetName()
	return self:GetData( "SeedTabel" )[1]
end

function ITEM:GetModel()
	return self:GetData( "Model" )
end

function ITEM:GetDescription()
	local t = self:GetData( "SeedTabel" )
	local text = " плодов"
	return text
end

function ITEM:SaveData( ent )
	self:SetData( "SeedTabel", ent:GetSeedBaseTabel())
	self:SetData( "Model", ent:GetModel())
end

function ITEM:LoadData( ent )
	ent:SetSeedBaseTabel( self:GetData( "SeedTabel" ) )
end



--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
