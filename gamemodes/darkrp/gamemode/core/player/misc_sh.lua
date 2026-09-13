--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

function PLAYER:CanAfford(amount)
	if SERVER and (not rp.data.IsLoaded(self)) then return false end

	if amount then
		amount = math.floor(amount)
		return (amount >= 0) and ((self:GetMoney() - amount) >= 0)
	end
	return false
end

--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
