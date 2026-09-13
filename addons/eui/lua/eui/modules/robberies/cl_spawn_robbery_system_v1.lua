spawns = spawns or {}
spawns.list = spawns.list or {}

net.Receive('spawns:SyncPoints', function(len, ply)
	local unprocessedData = net.ReadTable()
	spawns.list = unprocessedData
end)
