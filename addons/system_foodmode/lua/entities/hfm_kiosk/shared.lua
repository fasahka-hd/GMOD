--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

ENT.Type = "anim"
ENT.RenderGroup = RENDERGROUP_TRANSLUCENT

ENT.PrintName = "Киоск"
ENT.Category = "Food mode"

ENT.Spawnable = false
ENT.AdminOnly = false

ENT.IsShop = true

function ENT:SetupDataTables()
	self:NetworkVar( "Entity",	0, "ShopOwner" )
	self:NetworkVar( "String",	0, "ShopName" )
	self:NetworkVar( "Int", 	0, "ConID" )
end

--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
