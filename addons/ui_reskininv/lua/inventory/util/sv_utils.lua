--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

util.AddNetworkString("enc.inv.sync")
util.AddNetworkString("enc.inv.syncent")
util.AddNetworkString("enc.inv.move")
util.AddNetworkString("enc.inv.open_crate")
util.AddNetworkString("enc.inv.refresh")
util.AddNetworkString("enc.inv.use")
util.AddNetworkString("enc.inv.drop")

sql.Query([[CREATE TABLE IF NOT EXISTS "inventory" (
	"SteamID"	INTEGER UNIQUE,
	"Inventory"	TEXT,
	PRIMARY KEY("SteamID")
);]])

concommand.Add('inventory_wipedata', function(ply)
	if IsValid(ply) then print(ply, ' tried to ran command wipe-data in inventory.') ply:ChatPrint('Эта команда доступна только в коносли.') return end

	sql.Query("DROP TABLE inventory;")
	print("Inventory was successfully dropped.")

	sql.Query([[CREATE TABLE "inventory" (
		"SteamID"	INTEGER UNIQUE,
		"Inventory"	TEXT,
		PRIMARY KEY("SteamID")
	);]])
end)

concommand.Add('inventory_wipedata_accs', function(ply)
	if IsValid(ply) then print(ply, ' tried to ran command wipe-data in inventory accs.') ply:ChatPrint('Эта команда доступна только в коносли.') return end
	sql.Query("DROP TABLE aas_inventory;")
	print("aas_inventory was successfully dropped.")

	sql.Query("CREATE TABLE IF NOT EXISTS aas_inventory (steam_id VARCHAR(64), uniqueId INT, price VARCHAR(100))")
end)

local PLAYER = FindMetaTable"Player"

function PLAYER:GetInvFreeSlot()
	local slot = false

	for i=1,5*10 do
		if !self.inventory[i] then slot = i break end
	end

	return slot
end

function PLAYER:HasItem( class )
	local has = false

	for i=1,5*10 do
		if self.inventory[i] and self.inventory[i].Class == class then has = true break end
	end

	return has
end

function PLAYER:SaveDB()
	sql.Query( ('UPDATE "inventory" SET Inventory=%s WHERE SteamID=%s;'):format( SQLStr(util.TableToJSON(self.inventory or {})), SQLStr(self:SteamID64()) ) )
end

function PLAYER:AddItem( class, data )
	local slot = self:GetInvFreeSlot()
	if !slot then return print("inventory full") end
	print('Add Item To inventory', class)

	self.inventory[slot] = {Class = class, Data = data}
	self:SyncInventoryData()
	self:SaveDB()
end

function PLAYER:AddSlotItem( class, slot, data )
	if self.inventory[class] then return print("inventory full") end

	self.inventory[slot] = {Class = class, Data = data}
	self:SyncInventoryData()
	self:SaveDB()
end

function PLAYER:HasInvAccessory( uID )
	local has = false

	for i=-4,5*10 do
		local class = self.inventory[i] or {}
		class = class.Class or ''
		if class[1] == '_' and string.TrimLeft( class, "_acc_" ) == tostring(uID) then has = true break end
	end
	return has
end

function PLAYER:SyncInventoryData()
	net.Start("enc.inv.sync")
	net.WriteTable(self.inventory or {})
	net.Send(self)
end

function PLAYER:RefreshInventory()
	net.Start('enc.inv.refresh')
	net.Send(self)
end

net.Receive("enc.inv.sync", function(_,ply)
	ply:SyncInventoryData()
end)

net.Receive("enc.inv.syncent", function(_,ply)
	local ent = net.ReadEntity()

	if !IsValid(ent) then return end
	if ent:GetClass() != "inv_dumpster" then return end
	if(ent:GetPos():Distance(ply:GetPos()) > 100) then return end

	net.Start("enc.inv.syncent")
	net.WriteEntity(ent)
	net.WriteTable(ent.inventory or {})
	net.Send(ply)
end)

local accesories = {
	[-1] = {"Головной убор"},
	[-2] = {"Маски"},
	[-3] = {"Шея"},
	[-4] = {"Спина"},
}

hook.Add("PlayerInitialSpawn", "enc.inv.load", function(ply)
	nw.WaitForPlayer(ply, function()
		local data = sql.Query( ('SELECT * FROM `inventory` WHERE SteamID=%s'):format( SQLStr(ply:SteamID64()) ) ) or {}

		if #data <= 0 then
			ply.inventory = {}
			ply:SyncInventoryData()
			sql.Query( ('INSERT INTO "inventory" ("SteamID", "Inventory") VALUES (%s, %s);'):format( SQLStr(ply:SteamID64()), SQLStr('[]') ) )
			return
		end

		ply.inventory = util.JSONToTable(data[1].Inventory)
		ply:SyncInventoryData()
		for i=-4,-1 do
			local class = ply.inventory[i] or {}
			class = class.Class
			local item = enc_inv.stored[class] or {}

			if item.uID then
				ply:AASEquipAccessory(item.uID)
			end
		end
	end)
end)


function PLAYER:OpenCrate( ent )
	net.Start("enc.inv.open_crate")
	net.WriteEntity(ent)
	net.Send(self)
end

local ENTITY = FindMetaTable"Entity"

function ENTITY:SyncItems()
	for k,v in pairs(ents.FindInSphere(self:GetPos(), 150)) do
		if !v:IsPlayer() then continue end
		net.Start("enc.inv.syncent")
		net.WriteEntity(self)
		net.WriteTable(self.inventory or {})
		net.Send(v)
	end
end

net.Receive("enc.inv.move", function(_,ply)
	local from = net.ReadInt(12)
	local to = net.ReadInt(12)
	local ent = net.ReadEntity()
	local incrate = net.ReadBool()
	local fromcrate = net.ReadBool()

	if (to < 1 and !accesories[to]) || (from < 1 and !accesories[from]) then return end
	if to > 112 || from > 112 then return end

	local item = ply.inventory[from]
	local itemto = ply.inventory[to]

	if IsValid(ent) and ent:GetClass() == 'inv_dumpster' and ent:GetPos():Distance(ply:GetPos()) < 100 then
		if(incrate and fromcrate) then
			local _item = ent.inventory[from]
			local _itemto = ent.inventory[to]
			
			if !_item then return end
			if _itemto then return end

			ent.inventory[to] = _item
			ent.inventory[from] = nil
		elseif(incrate and !fromcrate) then
			local _item = ply.inventory[from]
			local _itemto = ent.inventory[to]
			
			if !_item then return end
			if _itemto then return end

			ent.inventory[to] = _item
			ply.inventory[from] = nil
			ply:SyncInventoryData()
		elseif(fromcrate and !incrate) then
			local _item = ent.inventory[from]
			local _itemto = ply.inventory[to]
			
			if !_item then return end
			if _itemto then return end

			ply.inventory[to] = _item
			ent.inventory[from] = nil
		end

		ply:SyncInventoryData()
		ent:SyncItems()

		return
	end

	if !item then return end
	if itemto then return end

	item = item.Class
	itemto = item.Class
	if accesories[to] then
		if item[1] == "_" then 
			local id = string.TrimLeft( item, "_acc_" )
			local tb = AAS.FormatTable(id)
			local f
			for k,v in pairs(accesories[to]) do
				if tb.category == v then
					ply:AASEquipAccessory(id)
					f = true
				end
			end
			if not f then return end
		else
			return
		end
	elseif accesories[from] then
		local id = string.TrimLeft( item, "_acc_" )
		ply:AASUnEquipAccessoryById( tonumber(id) )
	end

	ply.inventory[to] = ply.inventory[from]
	ply.inventory[from] = nil
	ply:SyncInventoryData()
	ply:RefreshInventory()
	sql.Query( ('UPDATE "inventory" SET Inventory=%s WHERE SteamID=%s;'):format( SQLStr(util.TableToJSON(ply.inventory or {})), SQLStr(ply:SteamID64()) ) )
end)

--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher


local function InvNotify(ply, msg, isError)
	if rp and rp.Notify then
		rp.Notify(ply, isError and NOTIFY_ERROR or NOTIFY_SUCCESS, msg)
	elseif DarkRP and DarkRP.notify then
		DarkRP.notify(ply, isError and 1 or 0, 4, msg)
	else
		ply:ChatPrint(msg)
	end
end

local function IsAccessoryClass(class)
	return isstring(class) and class:sub(1, 5) == "_acc_"
end

local function GetAccessoryId(class)
	return tonumber(string.TrimLeft(class or "", "_acc_"))
end

local function GetAccessorySlot(id)
	if not id or not AAS or not AAS.FormatTable then return nil end

	local tb = AAS.FormatTable(id)
	if not istable(tb) then return nil end

	local category = tb.category
	if category == "Головной убор" then return -1 end
	if category == "Маски" then return -2 end
	if category == "Шея" then return -3 end
	if category == "Спина" then return -4 end
end

local function RemoveInvSlot(ply, slot)
	ply.inventory[slot] = nil
	ply:SyncInventoryData()
	ply:RefreshInventory()
	ply:SaveDB()
end

local function TakeOneInvItem(ply, slot)
	local invItem = ply.inventory[slot]
	if not invItem then return end

	invItem.Data = invItem.Data or {}
	local count = tonumber(invItem.Data.Count or 1) or 1

	if count > 1 then
		invItem.Data.Count = count - 1
	else
		ply.inventory[slot] = nil
	end

	ply:SyncInventoryData()
	ply:RefreshInventory()
	ply:SaveDB()
end

local function GetDropPos(ply)
	local tr = util.TraceLine({
		start = ply:EyePos(),
		endpos = ply:EyePos() + ply:GetAimVector() * 85,
		filter = ply
	})

	return tr.HitPos + Vector(0, 0, 8)
end

local function SpawnInventoryItem(ply, class, data)
	local pos = GetDropPos(ply)

	if itemstore and itemstore.Item and itemstore.items and itemstore.items.Exists and itemstore.items.Exists(class) then
		local item = itemstore.Item(class, table.Copy(data or {}))
		if item and item.CreateEntity then
			local ent = item:CreateEntity(pos)
			if IsValid(ent) then
				if ent.CPPISetOwner then ent:CPPISetOwner(ply) end
				return ent
			end
		end
	end

	local ent = ents.Create(class)
	if not IsValid(ent) then return nil end

	ent:SetPos(pos)
	ent:SetAngles(Angle(0, ply:EyeAngles().y, 0))
	ent:Spawn()
	ent:Activate()

	if ent.CPPISetOwner then ent:CPPISetOwner(ply) end
	if ent.Setowning_ent then ent:Setowning_ent(ply) end
	if ent.SetOwner then ent:SetOwner(ply) end

	local phys = ent:GetPhysicsObject()
	if IsValid(phys) then
		phys:Wake()
		phys:SetVelocity(ply:GetAimVector() * 90)
	end

	return ent
end

local function UseAccessory(ply, slot, class)
	local id = GetAccessoryId(class)
	local targetSlot = GetAccessorySlot(id)

	if not id or not targetSlot then
		InvNotify(ply, 'Не удалось определить слот аксессуара.', true)
		return
	end

	if slot < 0 then
		local free = ply:GetInvFreeSlot()
		if not free then InvNotify(ply, 'В инвентаре нет свободного места.', true) return end

		if ply.AASUnEquipAccessoryById then ply:AASUnEquipAccessoryById(id) end
		ply.inventory[free] = ply.inventory[slot]
		ply.inventory[slot] = nil
	else
		local current = ply.inventory[targetSlot]
		local item = ply.inventory[slot]

		if ply.AASEquipAccessory then ply:AASEquipAccessory(id) end
		ply.inventory[targetSlot] = item
		ply.inventory[slot] = current
	end

	ply:SyncInventoryData()
	ply:RefreshInventory()
	ply:SaveDB()
end

net.Receive("enc.inv.use", function(_, ply)
	local slot = net.ReadInt(12)
	if not ply.inventory then return end
	if slot > 112 or slot < -4 then return end

	local invItem = ply.inventory[slot]
	if not invItem or not invItem.Class then return end

	local class = invItem.Class
	local data = invItem.Data or {}

	if IsAccessoryClass(class) then
		UseAccessory(ply, slot, class)
		return
	end

	if weapons.Get(class) then
		if rp and rp.ArrestedPlayers and rp.ArrestedPlayers[ply:SteamID64()] then return end
		ply:Give(class)
		ply:SelectWeapon(class)
		TakeOneInvItem(ply, slot)
		return
	end

	if itemstore and itemstore.Item and itemstore.items and itemstore.items.Exists and itemstore.items.Exists(class) then
		local item = itemstore.Item(class, table.Copy(data or {}))
		if item and item.Use and item:Use(ply) then
			TakeOneInvItem(ply, slot)
			return
		end
	end

	local ent = SpawnInventoryItem(ply, class, data)
	if not IsValid(ent) then
		InvNotify(ply, 'Этот предмет нельзя использовать.', true)
		return
	end

	if ent.Use then
		ent:Use(ply, ply, SIMPLE_USE, 0)
	end

	if not IsValid(ent) then
		TakeOneInvItem(ply, slot)
	else
		TakeOneInvItem(ply, slot)
	end
end)

net.Receive("enc.inv.drop", function(_, ply)
	local slot = net.ReadInt(12)
	if not ply.inventory then return end
	if slot > 112 or slot < -4 then return end

	local invItem = ply.inventory[slot]
	if not invItem or not invItem.Class then return end

	local class = invItem.Class
	local data = invItem.Data or {}

	if IsAccessoryClass(class) then
		InvNotify(ply, 'Аксессуары нельзя выбросить. Их можно только снять/надеть.', true)
		return
	end

	local ent = SpawnInventoryItem(ply, class, data)
	if not IsValid(ent) then
		InvNotify(ply, 'Не удалось выбросить предмет.', true)
		return
	end

	TakeOneInvItem(ply, slot)
	ply:EmitSound('items/ammocrate_open.wav')
end)


local pickupBlacklist = {
	player = true,
	worldspawn = true,
	func_door = true,
	func_door_rotating = true,
	prop_door_rotating = true,
	prop_physics = true,
	derma_printer = true,
	f4_gang_flag = true,
	itemstore_bank = true,
	itemstore_box = true,
	itemstore_box_large = true,
	itemstore_box_huge = true,
	itemstore_deathloot = true,
	itemstore_item = true,
	inv_dumpster = true,
}

local function CanPickupEntityToEncInv(ply, ent)
	if not IsValid(ply) or not IsValid(ent) then return false end
	if ent:IsPlayer() or ent:IsNPC() or ent:IsVehicle() then return false end
	if ent:GetPos():DistToSqr(ply:GetPos()) > 140 * 140 then return false end

	local class = ent:GetClass()
	if pickupBlacklist[class] then
		InvNotify(ply, 'Этот предмет нельзя положить в инвентарь.', true)
		return false
	end

	if not (rp and rp.inv and rp.inv.Wl and rp.inv.Wl[class]) then
		InvNotify(ply, 'Этот предмет нельзя положить в инвентарь.', true)
		return false
	end

	return true
end

local function BuildInventoryItemFromEntity(ent)
	local class = ent:GetClass()
	local data = {}

	if itemstore and itemstore.Item and itemstore.items and itemstore.items.Pickups and itemstore.items.Pickups[class] then
		local itemClass = itemstore.items.Pickups[class]
		if itemstore.items.Exists and itemstore.items.Exists(itemClass) then
			local item = itemstore.Item(itemClass)
			if item and item.SaveData then
				item:SaveData(ent)
				return item:GetClass(), table.Copy(item.Data or {})
			end
		end
	end

	if class == 'spawned_shipment' then
		data.Contents = ent.Getcontents and ent:Getcontents() or nil
		data.Amount = ent.Getcount and ent:Getcount() or nil
		local shipment = data.Contents and rp and rp.shipments and rp.shipments[data.Contents]
		data.Class = shipment and shipment.entity or nil
		data.Ammo = ent.ammoadd
		data.Clip1 = ent.clip1
		data.Clip2 = ent.clip2
	elseif class == 'spawned_weapon' then
		class = 'spawned_weapon'
		data.Class = ent.GetWeaponClass and ent:GetWeaponClass() or ent.weaponclass
		data.Model = ent:GetModel()
		data.Ammo = ent.ammoadd
		data.Clip1 = ent.clip1
		data.Clip2 = ent.clip2
	else
		data.Model = ent:GetModel()
	end

	return class, data
end

local function PickupEntityToEncInventory(ply, ent)
	if not CanPickupEntityToEncInv(ply, ent) then return end
	if not ply.inventory then ply.inventory = {} end

	local slot = ply:GetInvFreeSlot()
	if not slot then
		InvNotify(ply, 'Инвентарь заполнен.', true)
		return false
	end

	local class, data = BuildInventoryItemFromEntity(ent)
	if not class or class == '' then return end

	ply.inventory[slot] = { Class = class, Data = data or {} }
	ply:SyncInventoryData()
	ply:RefreshInventory()
	ply:SaveDB()
	ply:EmitSound('items/ammo_pickup.wav', 75, 100)

	ent:Remove()
	return false
end

function PLAYER:EncPickupEntityToInventory(ent)
	return PickupEntityToEncInventory(self, ent)
end

local function DisableOldAltEPickup()
	hook.Remove('PlayerUse', 'DrpPlyUse')
	hook.Remove('PlayerUse', 'enc.inv.pickup_entities')
end

DisableOldAltEPickup()
timer.Simple(0, DisableOldAltEPickup)
timer.Simple(3, DisableOldAltEPickup)
hook.Add('InitPostEntity', 'enc.inv.disable_old_alt_e_pickup', DisableOldAltEPickup)