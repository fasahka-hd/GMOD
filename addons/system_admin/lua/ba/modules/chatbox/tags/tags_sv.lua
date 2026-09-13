--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

util.AddNetworkString("badmin.chat.SetTag")
util.AddNetworkString("badmin.chat.ClearTag")

net.Receive("badmin.chat.SetTag", function(_,ply)
	ply:SetNetVar("ChatTag",net.ReadString())
end)

net.Receive("badmin.chat.ClearTag", function(_,ply)
	ply:SetNetVar("ChatTag",nil)
end)

--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
