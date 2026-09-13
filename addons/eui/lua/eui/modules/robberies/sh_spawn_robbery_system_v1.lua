spawns = spawns or {}
spawns.list = spawns.list or {}
spawns.events = spawns.events or {}

function spawns.HasAccess(ply)
	if ply:GetUserGroup() == 'root' then
		return true
	end

	return false
end
