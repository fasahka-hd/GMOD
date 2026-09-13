--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

--[[
	Author: Koz
	Steam: http://steamcommunity.com/id/drunkenkoz
	Contact: mybbkoz@gmail.com

	License:
	You are free to use this software however you like; however,
	you cannot redistribute this code in any way without consent
	from the original author, Koz.
]]--

ENT.Type = "anim"
ENT.Base = "base_gmodentity"

ENT.PrintName = "Coffe Machine"
ENT.Author = "miguel93041"
ENT.Category = "RP"

ENT.Spawnable			= true
ENT.AdminOnly			= true

function ENT:SetupDataTables()
	self:NetworkVar( "Int", 0 , "price" )
	self:NetworkVar( "Entity", 1, "owning_ent" )
end

--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
