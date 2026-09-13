--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

ENT.Type 		= 'anim'
ENT.Base		= 'base_rp'
ENT.Spawnable	= false
ENT.MediaPlayer = true
ENT.NetworkPlayerUse = true

function ENT:SetupDataTables()
	self:NetworkVar('String', 0, 'URL')
	self:NetworkVar('String', 1, 'Title')
	self:NetworkVar('Int', 0, 'Start')
	self:NetworkVar('Int', 1, 'Time')
	self:NetworkVar('Int', 2, 'Frozen')
	self:NetworkVar('Int', 3, 'Paused')
	self:NetworkVar('Int', 4, 'Looping')
end

function ENT:IsFrozen()
	return (self:GetFrozen() == 1)
end


function ENT:IsPaused()
	return (self:GetPaused() == 1)
end


function ENT:IsLooping()
	return (self:GetLooping() == 1)
end

--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
