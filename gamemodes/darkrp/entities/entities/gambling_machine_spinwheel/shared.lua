--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

--[[
gamemodes/rp_base/entities/entities/gambling_machine_spinwheel/shared.lua
--]]
ENT.Type 		= 'anim'
ENT.Base 		= 'gambling_machine_base'
ENT.PrintName 	= 'Рулетка'
ENT.Spawnable 	= true
ENT.Category 	= 'RP'
ENT.PressE 		= true

function ENT:SetupDataTables()

	self.BaseClass.SetupDataTables(self)
	
	self:NetworkVar('Entity',1,'owning_ent')
	self:NetworkVar('Int', 1, 'Roll')
end



--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
