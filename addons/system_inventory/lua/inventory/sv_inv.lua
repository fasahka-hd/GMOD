--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

local maxitems = CreateConVar( "drp_maxitems", "15", { FCVAR_REPLICATED, FCVAR_ARCHIVE } )
local maxguns = CreateConVar( "drp_maxguns", "4", { FCVAR_REPLICATED, FCVAR_ARCHIVE } )
local maxshipments = CreateConVar( "drp_maxshipments", "2", { FCVAR_REPLICATED, FCVAR_ARCHIVE } )
local maxfood = CreateConVar( "drp_maxfood", "6", { FCVAR_REPLICATED, FCVAR_ARCHIVE } )

util.AddNetworkString("clearinv")
util.AddNetworkString("item")
util.AddNetworkString("swep")
util.AddNetworkString("swepgone")
util.AddNetworkString("food")
util.AddNetworkString("foodgone")
util.AddNetworkString("ship")
util.AddNetworkString("shipgone")
util.AddNetworkString("dropitem")
util.AddNetworkString("useitem")
util.AddNetworkString("dropswep")
util.AddNetworkString("useswep")
util.AddNetworkString("dropfood")
util.AddNetworkString("usefood")
util.AddNetworkString("dropship")

local function CreateFolder()
	if not file.IsDir("drpinv", "DATA") then
        file.CreateDir("drpinv")
    end
end
hook.Add( "Initialize", "FolderCreate", CreateFolder )

local function plyjoin(ply)
	local strSteamID = string.Replace(ply:SteamID(), ":", "_")
	local path = "drpinv/" .. strSteamID .. ".txt"
	if file.Exists( path, "DATA" ) then
		ply.inv = util.JSONToTable(file.Read(path))
		DarkRP.notify(ply, 0, 4, "Welcome back " .. ply:Nick() .. "! Your inventory has been loaded.")
	else
		ply.inv = {}
		ply.inv.maxitems = 0
		ply.inv.sweps = {}
		ply.inv.ships = {}
		ply.inv.foods = {}
		ply:SaveInv()
		DarkRP.notify(ply, 0, 4, "This server is running the DrpInv! Type !inv to show your inventory, hold alt+use to pickup a valid item.")
	end

	ply:SendInv()
	
	ply.canuse = true
	
	if not ply.maxFoods then
		ply.maxFoods = 0
	end
	
	if not ply.maxDrugs then
		ply.maxDrugs = 0
	end
end
hook.Add("PlayerInitialSpawn","DrpInvSpawn",plyjoin)

local function plydis(ply)
	ply:SaveInv()
	timer.Destroy("canuse" .. ply:UniqueID())
end
hook.Add("PlayerDisconnected","DrpPlyLeave",plydis)

local function plyuse(ply, ent)
	
	if ply:KeyDown(IN_WALK) and !ply.canuse then
		return
	end
	
	if ply:KeyDown(IN_WALK) and items[ent:GetClass()] then
		if !ply.inv[ent:GetClass()] then
			ply.inv[ent:GetClass()] = 0
		end

		if ply.inv.maxitems >= maxitems:GetInt() then
			DarkRP.notify(ply, 1, 4, "Your inventory is full!")
			
			ply.canuse = false
			timer.Create("canuse" .. ply:UniqueID(), 1, 1,function() ply.canuse = true end)
			return
		end
		
		local max = items[ent:GetClass()]["max"]
		
		if max > 0 and ply.inv[ent:GetClass()] >= max then
			DarkRP.notify(ply, 1, 4, "You have reached the maximum amount for that item!")
			ply.canuse = false
			timer.Create("canuse" .. ply:UniqueID(), 1, 1,function() ply.canuse = true end)
			return
		end
		
		ply.inv.maxitems = ply.inv.maxitems + 1
		ply:AddItem(ent:GetClass(), 1)
		
		ply:EmitSound("items/ammo_pickup.wav", 100, 100)
		
		ent:Remove()

		ply.canuse = false
		timer.Create("canuse" .. ply:UniqueID(), 1, 1,function() ply.canuse = true end)
		return
	end
	
	if ply:KeyDown(IN_WALK) and ent:GetClass() == "spawned_weapon" and weps[ent:GetWeaponClass()] and ent:Getamount() == 1 then
		if ply.inv.maxitems >= maxitems:GetInt() then
			DarkRP.notify(ply, 1, 4, "Your inventory is full!")
			ply.canuse = false
			timer.Create("canuse" .. ply:UniqueID(), 1, 1,function() ply.canuse = true end)
			return
		end
		
		if #table.ClearKeys(ply.inv.sweps) >= maxguns:GetInt() then
			DarkRP.notify(ply, 1, 4, "You have reached the maximum amount of sweps!")
			ply.canuse = false
			timer.Create("canuse" .. ply:UniqueID(), 1, 1,function() ply.canuse = true end)
			return
		end
		
		ply.inv.maxitems = ply.inv.maxitems + 1
		ply:AddSwep(ent:GetWeaponClass())

		ply:EmitSound("items/ammo_pickup.wav", 100, 100)
		
		ent:Remove()

		ply.canuse = false
		timer.Create("canuse" .. ply:UniqueID(), 1, 1,function() ply.canuse = true end)
		return
	end

	if ply:KeyDown(IN_WALK) and ent:GetClass() == "spawned_food" and foodies[ent:GetModel()] then
		if ply.inv.maxitems >= maxitems:GetInt() then
			DarkRP.notify(ply, 1, 4, "Your inventory is full!")
			ply.canuse = false
			timer.Create("canuse" .. ply:UniqueID(), 1, 1,function() ply.canuse = true end)
			return
		end
		
		if #table.ClearKeys(ply.inv.foods) >= maxfood:GetInt() then
			DarkRP.notify(ply, 1, 4, "You have reached the maximum amount of food!")
			ply.canuse = false
			timer.Create("canuse" .. ply:UniqueID(), 1, 1,function() ply.canuse = true end)
			return
		end
		
		local food = {
			model = ent:GetModel(),
			amount = ent.energy
		}
		
		ply.inv.maxitems = ply.inv.maxitems + 1
		ply:AddFood(food)

		ply:EmitSound("items/ammo_pickup.wav", 100, 100)
		
		ent:Remove()

		ply.canuse = false
		timer.Create("canuse" .. ply:UniqueID(), 1, 1,function() ply.canuse = true end)
		return
	end

	if ply:KeyDown(IN_WALK) and ent:GetClass() == "spawned_shipment" and not ent.locked then
		if ply.inv.maxitems >= maxitems:GetInt() then
			DarkRP.notify(ply, 1, 4, "Your inventory is full!")
			ply.canuse = false
			timer.Create("canuse" .. ply:UniqueID(), 1, 1,function() ply.canuse = true end)
			return
		end
		
		if #table.ClearKeys(ply.inv.ships) >= maxshipments:GetInt() then
			DarkRP.notify(ply, 1, 4, "You have reached the maximum amount of shipments!")
			ply.canuse = false
			timer.Create("canuse" .. ply:UniqueID(), 1, 1,function() ply.canuse = true end)
			return
		end
		
		local ship = {
			cont = ent.dt.contents,
			count = ent.dt.count
		}
		
		ply.inv.maxitems = ply.inv.maxitems + 1
		ply:AddShip(ship)

		ply:EmitSound("items/ammo_pickup.wav", 100, 100)
		
		ent:Remove()

		ply.canuse = false
		timer.Create("canuse" .. ply:UniqueID(), 1, 1,function() ply.canuse = true end)
		return
	end
	if ply:KeyDown(IN_WALK) then
		return
	end
	-- return true
end
hook.Add("PlayerUse","DrpPlyUse",plyuse)

local function plysay(ply, text, tm, death)
    if string.sub(text, 1, 4) == "!inv" then
		ply:ConCommand("drp_showinv")
        return ""
    end
end
hook.Add("PlayerSay","DrpPlySay",plysay)

local meta = FindMetaTable("Player")

function meta:SaveInv()
	local strSteamID = string.Replace(self:SteamID(), ":", "_")
	
	file.Write("drpinv/" .. strSteamID .. ".txt", util.TableToJSON(self.inv))
	
end

function meta:SendInv()

	net.Start("clearinv")
	net.Send(self)
	
	for k,v in pairs(self.inv) do
		if type(v) != "table" and k != "maxitems" then
		
			net.Start( "item" )
				net.WriteString(k)
				net.WriteFloat(v)
			net.Send(self)
			
		end
	end
	
	for k,v in pairs(self.inv.sweps) do
		self:SendSwep(v, k)
	end
	
	for k,v in pairs(self.inv.foods) do
		self:SendFood(v, k)
	end
	
	for k,v in pairs(self.inv.ships) do
		self:SendShip(v, k)
	end
	
end

function meta:SendItem(str)

	net.Start( "item" )
		net.WriteString(str)
		net.WriteFloat(self.inv[str])
	net.Send(self)
	
end

function meta:SetItem(str, amt)

	if items[str] then
		self.inv[str] = amt
	return
	end
	self:SaveInv()
	self:SendItem(str)
	
end

-- function meta:AddItem(str, amt) -- не надо потому что мама енкода придугодала другое колизия!!!
-- 	print("??")
-- 	if items[str] then
-- 		self.inv[str] = self.inv[str] + amt
-- 	end
-- 	self:SaveInv()
-- 	self:SendItem(str)
	
-- end

function meta:AddSwep(class)

	local key = #self.inv.sweps + 1
	self.inv.sweps[key] = class
	self:SaveInv()
	self:SendSwep(class, key)
	
end

function meta:RemoveSwep(key)
	self.inv.sweps[key] = nil
	self:SaveInv()
	self:SendSwepRemove(key)
end

function meta:SendSwep(class,key)
	net.Start( "swep" )
		net.WriteFloat(key)
		net.WriteString(class)
	net.Send(self)
end

function meta:SendSwepRemove(key)

	net.Start( "swepgone" )
	
		net.WriteFloat(key)
		
	net.Send(self)
end

function meta:AddFood(tbl)
	local key = #self.inv.foods + 1
	self.inv.foods[key] = tbl
	self:SaveInv()
	self:SendFood(tbl, key)
end

function meta:RemoveFood(key)
	self.inv.foods[key] = nil
	self:SaveInv()
	self:SendFoodRemove(key)
end

function meta:SendFood(tbl,key)

	net.Start( "food" )
	
		net.WriteFloat(key)
		net.WriteTable(tbl)
		
	net.Send(self)
	
end

function meta:SendFoodRemove(key)
	net.Start( "foodgone" )
	
		net.WriteFloat(key)
		
	net.Send(self)
end

function meta:AddShip(tbl)
	local key = #self.inv.ships + 1
	self.inv.ships[key] = tbl
	self:SaveInv()
	self:SendShip(tbl, key)
end

function meta:RemoveShip(key)
	self.inv.ships[key] = nil
	self:SaveInv()
	self:SendShipRemove(key)
end

function meta:SendShip(tbl,key)

	net.Start( "ship" )
	
		net.WriteFloat(key)
		net.WriteTable(tbl)
		
	net.Send(self)

end

function meta:SendShipRemove(key)
	net.Start( "shipgone" )
	
		net.WriteFloat(key)
		
	net.Send(self)
end

net.Receive( "dropitem", function(len, ply)  

	local item = net.ReadString()
	
	if !item or ply.inv[item] == nil then
		return
	end
	
	if ply.inv[item] < 1 then
		DarkRP.notify(ply, 1, 4, "Nice try. You dont have any of that left.")
		return
	end
	
	if ply:isArrested() then
	
	return
	end
	
	local pos = ply:EyePos()
	local tracedata = {}
	tracedata.start = pos
	tracedata.endpos = pos+(ply:GetForward()*150)
	tracedata.filter = ply
	local tr = util.TraceLine(tracedata)
	
	local ent = ents.Create(item)
	ent:SetPos(tr.HitPos + tr.HitNormal*10)
	ent.ShareGravgun = true
	ent.nodupe = true
	ent:Spawn()
	ent:Activate()

	ply.inv.maxitems = ply.inv.maxitems - 1
	ply:AddItem(item, -1)
end)

net.Receive( "useitem", function(len, ply)  

	local item = net.ReadString()
	
	if !item or ply.inv[item] == nil then
		return
	end
	
	if ply.inv[item] < 1 then
		DarkRP.notify(ply, 1, 4, "Nice try. You dont have any of that left.")
		return
	end
	
	if ply:isArrested() then
	
	return
	end
	
	local ent = ents.Create(item)
	ent:SetPos(ply:GetPos())
	if ent.dt then
		ent.dt.owning_ent = ply
	end
	ent.ShareGravgun = true
	ent.nodupe = true
	ent:Spawn()
	ent:Activate()
	
	if not ply.maxFoods then
		ply.maxFoods = 0
	end
	
	ent:Use(ply, ply, SIMPLE_USE, 0)
	
	ply.inv.maxitems = ply.inv.maxitems - 1
	ply:AddItem(item, -1)

end)

net.Receive( "dropswep", function(len, ply)
	
	local item = net.ReadFloat()
	if !item or ply.inv.sweps[item] == nil then
		return
	end
	
	if ply:isArrested() then
	
	return
	end
	
	local trace = {}
    trace.start = ply:EyePos()
	trace.endpos = trace.start + ply:GetAimVector() * 85
    trace.filter = ply

    local tr = util.TraceLine(trace)
	
	local ent = ents.Create("spawned_weapon")
	ent:SetPos(tr.HitPos)
	ent:SetModel(weps[ply.inv.sweps[item]].model)
	ent:SetWeaponClass(ply.inv.sweps[item])
	ent.ShareGravgun = true
	ent.nodupe = true
	ent:Spawn()
	ent:Activate()
	
	ply.inv.maxitems = ply.inv.maxitems - 1
	ply:RemoveSwep(item)
end)

net.Receive( "useswep", function(len, ply)
	
	local item = net.ReadFloat()
	if !item or ply.inv.sweps[item] == nil then
		return
	end
	
	if ply:isArrested() then
	
	return
	end
	
	local ent = ents.Create("spawned_weapon")
	ent:SetPos(ply:GetPos())
	ent:SetModel(weps[ply.inv.sweps[item]].model)
	ent:SetWeaponClass(ply.inv.sweps[item])
	ent.ShareGravgun = true
	ent.nodupe = true
	ent:Spawn()
	ent:Activate()
	
	ent:Use(ply, ply, SIMPLE_USE, 0)
	
	ply.inv.maxitems = ply.inv.maxitems - 1
	ply:RemoveSwep(item)
	
end)

net.Receive( "dropfood", function(len, ply)
	
	local item = net.ReadFloat()
	
	if !item or ply.inv.foods[item] == nil then
		return
	end
	
	if ply:isArrested() then
	
	return
	end
	
	local trace = {}
    trace.start = ply:EyePos()
	trace.endpos = trace.start + ply:GetAimVector() * 85
    trace.filter = ply

    local tr = util.TraceLine(trace)
	
	local food={}
	
	food.energy = ply.inv.foods[item].amount
	food.model = ply.inv.foods[item].model
	food.name = nil
	food.price = nil
	
	local ent = ents.Create("spawned_food")
	ent:SetPos(tr.HitPos)
	ent:SetModel(ply.inv.foods[item].model)
	ent.foodItem = food
	ent.ShareGravgun = true
	ent.nodupe = true
	ent:Spawn()
	ent:Activate()

	ply.inv.maxitems = ply.inv.maxitems - 1
	ply:RemoveFood(item)
	
end)

net.Receive( "usefood", function(len, ply)
	
	local item = net.ReadFloat()
	
	if !item or ply.inv.foods[item] == nil then
		return
	end
	
	if ply:isArrested() then
	
	return
	end
	
	local food={}
	
	food.energy = ply.inv.foods[item].amount
	food.model = ply.inv.foods[item].model
	food.name = nil
	food.price = nil

	local ent = ents.Create("spawned_food")
	ent:SetPos(ply:GetPos())
	ent:SetModel(ply.inv.foods[item].model)
	ent.foodItem = food
	ent.ShareGravgun = true
	ent.nodupe = true
	ent:Spawn()
	ent:Activate()
	
	ent:Use(ply, ply, SIMPLE_USE, 0)
	
	ply.inv.maxitems = ply.inv.maxitems - 1
	ply:RemoveFood(item)
	
end)

net.Receive( "dropship", function(len, ply)
	
	local item = net.ReadFloat()
	
	if !item or ply.inv.ships[item] == nil then
		return
	end
	
	if ply:isArrested() then
	
	return
	end
	
	local trace = {}
    trace.start = ply:EyePos()
	trace.endpos = trace.start + ply:GetAimVector() * 85
    trace.filter = ply

    local tr = util.TraceLine(trace)
	
	local ent = ents.Create("spawned_shipment")
	ent:SetPos(tr.HitPos)
	ent:SetContents(ply.inv.ships[item].cont, ply.inv.ships[item].count, 10)
	ent.nodupe = true
	ent:Spawn()
	ent:Activate()
	
	ply.inv.maxitems = ply.inv.maxitems - 1
	ply:RemoveShip(item)
	
end)

--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
