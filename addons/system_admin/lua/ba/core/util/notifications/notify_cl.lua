--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

local notify_types = {
	[0] = ui.col.SUP,
	[1] = ui.col.SUP,
	[2] = ui.col.SUP,
}

net.Receive('ba.NotifyString', function(len)
	if (not IsValid(LocalPlayer())) then return end
	chat.AddText(notify_types[net.ReadInt(8)], ' ARIZONARP ', unpack(ba.ReadMsg()))
end)

net.Receive('ba.NotifyTerm', function(len)
	if (not IsValid(LocalPlayer())) then return end
	chat.AddText(notify_types[net.ReadInt(8)], ' ARIZONARP ', unpack(ba.ReadTerm()))
end)