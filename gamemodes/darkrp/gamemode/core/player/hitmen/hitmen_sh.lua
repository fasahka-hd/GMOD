--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

function PLAYER:HasHit()
	return (self:GetNetVar('HitPrice') ~= nil)
end

function PLAYER:GetHitPrice()
	return self:GetNetVar('HitPrice')
end

nw.Register 'HitPrice'
	:Write(net.WriteUInt, 32)
	:Read(net.ReadUInt, 32)

--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
