rpc = {};

if SERVER then
	util.AddNetworkString('rpc_call');
	util.AddNetworkString('rpc_response');
end

local commands = {};
function rpc.register( name, func )
	commands[name] = func;
end

-- rpc response handling is universal
local callbacks = {};
local id = 0;
net.Receive( 'rpc_response', function()
	local id = net.ReadUInt(32);
	if callbacks[id] then
		callbacks[id](net.ReadTable());
		callbacks[id] = nil;
	end
end);


if SERVER then
	net.Receive( 'rpc_call', function( _, pl )
		local name = net.ReadString();
		local id = net.ReadUInt(32);
		local data = net.ReadTable();
		
		local function callback( data )
			if not IsValid(pl) then return end
			net.Start('rpc_response');
				net.WriteUInt(id,32);
				net.WriteTable(data or {});
			net.Send(pl);
		end
		
		if commands[name] then
			commands[name](pl, data, callback);
		end
	end);
	
	function rpc.call( name, data, callback )
		id = id + 1;
		callbacks[id] = callback;
		
		net.Start('rpc_call')
			net.WriteString(name);
			net.WriteUInt(id, 32);
			net.WriteTable(data);
		net.Send();
	end
	
elseif CLIENT then
	net.Receive( 'rpc_call', function( _ )
		local name = net.ReadString();
		local id = net.ReadUInt(32);
		local data = net.ReadTable();
		
		local function callback( data )
			net.Start('rpc_response');
				net.WriteUInt(id);
				net.WriteTable(data or {});
			net.Send(pl);
		end
		
		if commands[name] then
			commands[name](data, callback);
		end
	end);
	
	function rpc.call( name, data, callback )
		id = id + 1;
		callbacks[id] = callback;
		
		net.Start('rpc_call')
			net.WriteString(name);
			net.WriteUInt(id, 32);
			net.WriteTable(data);
		net.SendToServer();
	end
	
end
