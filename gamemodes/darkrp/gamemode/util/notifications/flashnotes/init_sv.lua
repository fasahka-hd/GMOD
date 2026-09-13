--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

util.AddNetworkString 'rp.FlashString'
util.AddNetworkString 'rp.FlashTerm'

function rp.FlashNotify(recipients, title, msg, ...)
	if isstring(msg) then
		net.Start('rp.FlashString')
			net.WriteString(title)
			rp.WriteMsg(msg, ...)
		net.Send(recipients)
	else
		net.Start('rp.FlashTerm')
			net.WriteString(title)
			net.WriteTerm(msg, ...)
		net.Send(recipients)
	end
end

function rp.FlashNotifyAll(title, msg, ...)
	if isstring(msg) then
		net.Start('rp.FlashString')
			net.WriteString(title)
			rp.WriteMsg(msg, ...)
		net.Broadcast()
	else
		net.Start('rp.FlashTerm')
			net.WriteString(title)
			net.WriteTerm(msg, ...)
		net.Broadcast()
	end
end

function PLAYER:FlashNotify(title, msg, ...)
	rp.FlashNotify(self, title, msg, ...)
end

--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
