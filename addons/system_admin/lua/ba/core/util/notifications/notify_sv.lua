--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

util.AddNetworkString 'ba.NotifyString'
util.AddNetworkString 'ba.NotifyTerm'

function ba.notify(recipients, msg, ...)
	if isstring(msg) then
		net.Start('ba.NotifyString')
			net.WriteInt(0, 8)
			ba.WriteMsg(msg, ...)
		net.Send(recipients)
	else
		net.Start('ba.NotifyTerm')
			net.WriteInt(0, 8)
			net.WriteTerm(msg, ...)
		net.Send(recipients)
	end
end

function ba.notify_err(recipients, msg, ...)
	if isstring(msg) then
		net.Start('ba.NotifyString')
			net.WriteInt(1, 8)
			ba.WriteMsg(msg, ...)
		net.Send(recipients)
	else
		net.Start('ba.NotifyTerm')
			net.WriteInt(1, 8)
			net.WriteTerm(msg, ...)
		net.Send(recipients)
	end
end

function ba.notify_all(msg, ...)
	if isstring(msg) then
		net.Start('ba.NotifyString')
			net.WriteInt(0, 8)
			ba.WriteMsg(msg, ...)
		net.Broadcast()
	else
		net.Start('ba.NotifyTerm')
			net.WriteInt(0, 8)
			net.WriteTerm(msg, ...)
		net.Broadcast()
	end
end

function ba.notify_donate(msg, ...)
	if isstring(msg) then
		net.Start('ba.NotifyString')
			net.WriteInt(2, 8)
			ba.WriteMsg(msg, ...)
		net.Broadcast()
	else
		net.Start('ba.NotifyTerm')
			net.WriteInt(2, 8)
			net.WriteTerm(msg, ...)
		net.Broadcast()
	end
end

function ba.notify_staff(msg, ...)
	if isstring(msg) then
		net.Start('ba.NotifyString')
			net.WriteInt(0, 8)
			ba.WriteMsg(msg, ...)
		net.Send(player.GetStaff())
	else
		net.Start('ba.NotifyTerm')
			net.WriteInt(0, 8)
			net.WriteTerm(msg, ...)
		net.Send(player.GetStaff())
	end
end

--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
