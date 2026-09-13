--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

ENT.Type = 'anim'
ENT.Base = 'base_anim'
ENT.PrintName = 'Metal Detector'
ENT.Author = 'aStonedPenguin'
ENT.Spawnable = true
ENT.Category = 'RP'
ENT.MaxHealth = 150

function ENT:SetupDataTables()
	self:NetworkVar('Int', 1, 'Mode')
end

--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
