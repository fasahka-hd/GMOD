--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

--[[
gamemodes/rp_base/entities/entities/gambling_machine_base/shared.lua
--]]
ENT.Type 		= 'anim'
ENT.Base 		= 'base_rp'
ENT.PrintName 	= 'Gambling Machine Base'
ENT.PressKeyText 		= 'Сделать ставку'

ENT.MinPrice = 500
ENT.MaxPrice = 100000000

function ENT:SetupDataTables()
	self:NetworkVar('Int', 0, 'price')
	self:NetworkVar('Bool', 0, 'InService')
	self:NetworkVar('Bool', 1, 'IsPayingOut')
end



--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
