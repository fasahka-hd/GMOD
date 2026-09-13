--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

function rp.WriteMsg(msg, ...)
	local replace = {...}
	local count = 0
	msg = msg:gsub('#', function()
		count = count + 1
		local v = replace[count]
		local t = type(v)
		if (t == 'Player') then 
			if (not IsValid(v)) then return 'Unknown' end
			return v:Name()
		elseif (t == 'Entity') then
			if (not IsValid(v)) then return 'Invalid Entity' end
			return (v.PrintName and v.PrintName or v:GetClass())
		end
		return v
	end)
	net.WriteString(msg)
end

rp.ReadMsg = net.ReadString

--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
