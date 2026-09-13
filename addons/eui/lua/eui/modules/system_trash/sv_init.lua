timer.Remove('gsr_trash_spawn')

local function PurgeTrash()
	local n = 0
	for _, v in ipairs(ents.FindByClass('ent_trash')) do
		if IsValid(v) then
			v:Remove()
			n = n + 1
		end
	end
	return n
end

PurgeTrash()

hook.Add('InitPostEntity', 'gsr_trash_disabled_cleanup', function()
	timer.Simple(10, function()
		timer.Remove('gsr_trash_spawn')
		PurgeTrash()
	end)
end)

concommand.Add('trash_purge', function(pl)
	if IsValid(pl) and not pl:IsSuperAdmin() then return end
	timer.Remove('gsr_trash_spawn')
	local msg = '[ГСР] Удалено мусора: ' .. PurgeTrash()
	if IsValid(pl) then pl:ChatPrint(msg) else print(msg) end
end)
