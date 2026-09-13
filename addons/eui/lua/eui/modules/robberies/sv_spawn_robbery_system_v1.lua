util.AddNetworkString('spawns:SyncPoints')

spawns = spawns or {}
spawns.list = spawns.list or {}
spawns.events = spawns.events or {}

local db = rp._Stats
local function createDataTable()
	db:Query([[CREATE TABLE IF NOT EXISTS spawn_robbery_system_v1(
		id INT,
		model TEXT NOT NULL,
		polices INT NOT NULL,
		robbers INT NOT NULL,
		name TEXT NOT NULL,
		radius INT NOT NULL,
		soundscape TEXT NOT NULL,
		position TEXT NOT NULL,
		time INT NOT NULL,
		data TEXT NOT NULL
	) COLLATE=utf8_unicode_ci;]])
end

local function insertData(id, model, polices, robbers, name, radius, soundscape, position, time, data)
	db:Query(string.format([[
		INSERT INTO spawn_robbery_system_v1(id, model, polices, robbers, name, radius, soundscape, position, time, data)
		VALUES(%i,%s,%i,%i,%s,%i,%s,%s,%i,%s);
	]], id, sql.SQLStr(model), polices, robbers, sql.SQLStr(name), radius, sql.SQLStr(soundscape), sql.SQLStr(position), time, sql.SQLStr(data)), function(result)
	end, function(error)
		print('Error inserting data: ' .. error)
	end)
end

local function deleteData(id)
	db:Query(string.format([[
		DELETE FROM spawn_robbery_system_v1 WHERE id = %i;
	]], id))
end

local function updateData(id, model, polices, robbers, name, radius, soundscape, position, time, data)
	db:Query(string.format([[
		UPDATE spawn_robbery_system_v1
		SET model = %s, polices = %i, robbers = %i, name = %s, radius = %i, soundscape = %s, position = %s, time = %i, data = %s
		WHERE id = %i;
	]], sql.SQLStr(model), polices, robbers, sql.SQLStr(name), radius, sql.SQLStr(soundscape), sql.SQLStr(position), time, sql.SQLStr(data), id))
end

local function getData()
	db:Query([[SELECT * FROM spawn_robbery_system_v1;]], function(result)
		spawns.list = result or {}

		for k, v in pairs(spawns.list) do
			local ent = ents.Create('robbery_system_v1_ent')
			ent:SetPos(Vector(v.position))
			ent:SetNWString('Model', v.model)
			ent:SetNWInt('Polices', v.polices)
			ent:SetNWInt('Robbers', v.robbers)
			ent:SetNWString('Name', v.name)
			ent:SetNWInt('Radius', v.radius)
			ent:SetNWString('Soundscape', v.soundscape)
			ent:SetNWString('Position', v.position)
			ent:SetNWInt('spawn_robbery_system_v1_id', v.id)
			ent:SetNWInt('Time', v.time)
			ent:SetNWString('Data', v.data)
			ent:Spawn()
			v.ent = ent
		end
	end)
end

local function updatespawns()
	net.Start('spawns:SyncPoints')
	net.WriteTable(spawns.list)
	net.Broadcast()
end

function spawns:Create(model, polices, robbers, name, radius, soundscape, position, time, data)
	insertData(#spawns.list + 1, model, polices, robbers, name, radius, soundscape, position, time, data)

	local ent = ents.Create('robbery_system_v1_ent')
	ent:SetPos(Vector(position))
	ent:SetNWString('Model', model)
	ent:SetNWInt('Polices', polices)
	ent:SetNWInt('Robbers', robbers)
	ent:SetNWString('Name', name)
	ent:SetNWInt('Radius', radius)
	ent:SetNWString('Soundscape', soundscape)
	ent:SetNWString('Position', position)
	ent:SetNWInt('spawn_robbery_system_v1_id', #spawns.list + 1)
	ent:SetNWInt('Time', time)
	ent:SetNWString('Data', data)
	ent:Spawn()
	spawns.list[#spawns.list + 1] = {id = #spawns.list + 1, model = model, polices = polices, robbers = robbers, name = name, radius = radius, soundscape = soundscape, position = position, ent = ent, time = time, data = data}
	updatespawns()
end

function spawns:Delete(id)
	deleteData(id)
	local ent = spawns.list[id].ent
	if IsValid(ent) then
		ent:Remove()
	end
	spawns.list[id] = nil
	updatespawns()
end

function spawns:SendPoints(owner)
	net.Start('spawns:SyncPoints')
	net.WriteTable(spawns.list)
	net.Send(owner)
end

hook.Add('spawns.CanCreate', 'SpawnsCanCreate', function(events, owner, idType, idValue, bPermanent)
	return true
end)

hook.Add('spawns.CanDelete', 'SpawnsCanDelete', function(events, owner, foundData, foundIndex)
	return true
end)

createDataTable()
getData()

hook.Add('PlayerInitialSpawn', 'spawns.SendPoints', function(ply)
	spawns:SendPoints(ply)
end)
