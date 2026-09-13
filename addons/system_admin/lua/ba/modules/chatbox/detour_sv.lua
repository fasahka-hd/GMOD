--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

util.AddNetworkString('badmin.ToggleChat')
util.AddNetworkString('badmin.DeToggleChat')

net.Receive('badmin.ToggleChat', function(len, pl)
	pl:SetNetVar('IsTyping', not pl:GetNetVar('IsTyping'))
end)

net.Receive('badmin.DeToggleChat', function(len, pl)
	pl:SetNetVar('IsTyping', false)
end)

function PLAYER:ChatPrint(...)
	ba.notify(self, ...)
end

--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
