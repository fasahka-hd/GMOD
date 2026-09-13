if SERVER then

	util.AddNetworkString('pnet.ready');
	
	local ready = {};
	hook.Add('PlayerDisconnected','pnet', function(pl)
		ready[pl] = nil;
	end);
	
	function net.waitForPlayer(pl, func)
		if ready[pl] == true then
			func()
		else
			if not ready[pl] then
				ready[pl] = {};
			end
			table.insert(ready[pl], func);
		end
	end
	
	net.Receive('pnet.ready', function(_, pl)
		if ready[pl] == true or ready[pl] == nil 	then return end
		print('PLAYER IS READY!');
		for _, func in ipairs(ready[pl])do
			func();
		end
		ready[pl] = true;
	end);
	
else
	
	hook.Add('Think','pnet.waitForPlayer', function()
		if IsValid(LocalPlayer()) then
			hook.Remove('Think', 'pnet.waitForPlayer');
			net.Start('pnet.ready');
			net.SendToServer();
		end
	end);
	
end