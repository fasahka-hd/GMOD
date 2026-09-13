--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

net.Receive('ba.LogData', function(len) --
	local name = net.ReadString()
	local size = net.ReadUInt(16)
	local data = ba.logs.Decode(net.ReadData(size))

	local log = ba.logs.Get(name)
	
	for k, v in ipairs(data) do
		v.Time = os.date('%I:%M:%S', v.Time)

		local count = 0
		local term = ba.logs.GetTerm(v.Term)
		
		v.Copy = {}
		for k, copy in pairs(term.Copy) do
			v.Copy[copy] = v[k]
		end
		
		v.Data = term.Message:gsub('#', function()
			count = count + 1

			return v[count]
		end)
	end
	
	ba.logs.Data[name] = data

	ba.ui.OpenNewLogMenu()
end)

--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
