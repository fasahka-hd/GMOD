--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

cl_inv = {}
cl_sweps = {}
cl_ships = {}
cl_foods = {}

net.Receive( "clearinv", function()  
	table.Empty(cl_inv)
	table.Empty(cl_sweps)
	table.Empty(cl_ships)
	table.Empty(cl_foods)  
end)

net.Receive( "item", function()    
	local str = net.ReadString()
	local val = net.ReadFloat()
	
	if val > 0 then
		cl_inv[str] = val
	else
		cl_inv[str] = nil
	end
end)

net.Receive( "swep", function(len)   
 
	local key = net.ReadFloat()
	local class = net.ReadString()
	cl_sweps[key] = class

end)

net.Receive( "swepgone", function(len)   
 
	local key = net.ReadFloat()
	
	cl_sweps[key] = nil

end)

net.Receive( "food", function(len)   
 
	local key = net.ReadFloat()
	local tble = net.ReadTable()

	cl_foods[key] = {model = tble.model, amount = tble.amount}

end)

net.Receive( "foodgone", function(len)   
 
	local key = net.ReadFloat()
	
	cl_foods[key] = nil

end)

net.Receive( "ship", function(len)   
 
	local key = net.ReadFloat()
	local tbl = net.ReadTable()
	
	cl_ships[key] = {cont = tbl.cont, count = tbl.count}

end)

net.Receive( "shipgone", function(len)   
 
	local key = net.ReadFloat()
	
	cl_ships[key] = nil

end)

--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
