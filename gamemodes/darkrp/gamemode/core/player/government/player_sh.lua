--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

function PLAYER:IsMayor()
	return rp.teams[self:Team()].mayor or false
end

function PLAYER:IsChief()
	return rp.teams[self:Team()].PoliceChief or false
end

function PLAYER:IsCP()
	return rp.teams[self:Team()].police or false
end

function PLAYER:IsGov()
	return self:IsCP() or self:IsMayor()
end

function PLAYER:IsArrested()
	return (self:GetNetVar('ArrestedInfo') ~= nil)
end

function PLAYER:IsWanted()
	return (self:GetNetVar('IsWanted') == true)
end

function PLAYER:GetWantedReason()
	return self:GetNetVar('WantedReason')
end

function PLAYER:GetArrestInfo()
	return self:GetNetVar('ArrestedInfo')
end

function PLAYER:CloseToCPs()
	for k, v in ipairs(ents.FindInSphere(self:GetPos(), 200)) do
		if v:IsPlayer() and v:IsCP() then
			return true
		end
	end

	return false
end


--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
