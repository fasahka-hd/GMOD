--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

ITEM.Name = "Hlife Fertilizer"
ITEM.Description = "Ускаряет зацветания в 2 раза"
ITEM.Model = "models/error.mdl"
ITEM.Base = "base_entity"
ITEM.Stackable = false

function ITEM:GetName()
	return self:GetData( "Name" )
end

function ITEM:GetModel()
	return self:GetData( "Model" )
end

function ITEM:SaveData( ent )
	self:SetData( "Name", ent.PrintName)
	self:SetData( "Model", ent:GetModel())
end

--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
