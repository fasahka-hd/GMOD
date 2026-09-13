include("unbox_config_2.lua")

Backspin = {}
 
AddCSLuaFile( "unbox/spinner.lua" )
AddCSLuaFile( "unbox/modelpanel.lua" )
AddCSLuaFile( "unbox/upgrade.lua" )
AddCSLuaFile( "unbox/crate.lua" )
 
BUC2.History = BUC2.History or {}
BUC2.HistoryAppend = function( self, id )
	if table.Count( self.History ) > 10 then
		table.remove( self.History ) // remove last id
	end
	table.insert( self.History, 1, id ) // append
end
 
local p = FindMetaTable("Player")
util.AddNetworkString('DonMenu') 
util.AddNetworkString("ub_inventory_update")
util.AddNetworkString("ub_purchase") 
util.AddNetworkString("BeginSpin")
util.AddNetworkString("StartClientSpinAnimation")
util.AddNetworkString("SpinEnded")
util.AddNetworkString("ub_equipweapon") 
util.AddNetworkString("ub_deleteItem")
util.AddNetworkString("ub_spawnEntity")
util.AddNetworkString("ub_giftitem")
util.AddNetworkString("ub_openui")
util.AddNetworkString("unboxadmin")
util.AddNetworkString("ub_admingiveitems")
util.AddNetworkString("ub_annouceunbox")
util.AddNetworkString("ub_history_update")
util.AddNetworkString("StartClientUpgradeAnimation")
util.AddNetworkString('donOpen')
local function igsCanAfford( ply, money, callback )
	IGS.GetBalance( ply:SteamID64( ), function( balance )
		if !IsValid( ply ) then return end
		if callback then
			callback( balance >= money )
		end
	end )
end


local RTP = {}
RTP.BetweenPlayers = 0.98 

RTP.Profit = cookie.GetNumber( "unboxing_rtp", 0 )

function RTP:Append( profit, shouldNotSave )
	self.Profit = self.Profit + profit

	if not shouldNotSave then
		cookie.Set( "unboxing_rtp", self.Profit )
	end
end

local function GetItem( uid )
	local item = IGS.GetItemByUID( uid )
	if item.isnull or item.price <= 0 then return false end
 
	return item
end

local function IsUpgradeableWeapon(uid, allowed)
	if allowed[uid] then return true end

	local item = IGS.GetItemByUID(uid)
	if not item or item.isnull or not item.Name then return false end
	local itemName = string.lower(tostring(item:Name() or ""))
	if itemName == "" then return false end

	for name, cfg in pairs(BUC2.ITEMS or {}) do
		if cfg.itemType == "Weapon" and string.lower(tostring(cfg.name1 or name)) == itemName then
			return true
		end
	end
	return false
end
local function GiveAway( uid, target, callback )
	if isentity( target ) then
		target.ub_upgrading = uid
		IGS.AddToInventory(target, uid, callback)
	else
		IGS.StoreInventoryItem(callback or function()end, target, uid)
	end
end

function RTP:GenerateItem( boxID, shouldNotSave, backspin )

	local Box = BUC2.ITEMS[ boxID ]
	if not Box then return end

	local Prices = {}

	
	for k , item_id in pairs(BUC2.ITEMS[boxID].items) do
		local item = BUC2.ITEMS[ item_id ]
		local itemType = item.itemType
		local igsID = itemType == "IGS" and item.amount or itemType == "Weapon" and item.weaponName
		
		local IGS_ITEM = GetItem( igsID )
		if not IGS_ITEM then print( item_id, 'invalid IGS id: ', igsID ) continue end
		Prices[ item_id ] = IGS_ITEM:Price( )
	end
	
	local increase_chance = 1 + (self.Profit < 0 and 0 or math.random( -0.3, 50 ))

	print(increase_chance)

	local lowest
	
	local allowed_items = {}
	for k, v in pairs( Prices ) do
		if not lowest or lowest[ 2 ] > v then
			lowest = {k, v}
		end

		if backspin then
			if v <= Box.price then continue end
		else

			if Box.price + (self.Profit < 0 and 0 or self.Profit) * increase_chance < v then continue end
		end

		allowed_items[ k ] = v
	end

	if !lowest then
		ErrorNoHaltWithStack( "INVALID CASE: " .. boxID )
		return nil
	end

	if table.Count( allowed_items ) == 0 then
		allowed_items[ lowest[ 1 ] ] = lowest[ 2 ]
	end

	local won_price, item_id = table.Random( allowed_items )

	if !backspin then
		local clean_profit = Box.price - won_price  // Clean profit
		RTP:Append( clean_profit > 0 and clean_profit * ( RTP.BetweenPlayers ) or clean_profit, shouldNotSave )
	end

	return item_id
end


 
net.Receive("ub_admingiveitems" , function(len , ply)
 
	local isAllowed = false
 
	for k , v in pairs(BUC2.RanksThatCanGiveItems) do
 
		if ply:GetUserGroup() == v then
 
			isAllowed = true
 
		end
 
	end
 
	if isAllowed then
 
		local item = net.ReadString()
		local target = net.ReadEntity()
		local amount = net.ReadInt(8)
 
		if BUC2.ITEMS[item] == nil then return end
		if IsValid(target) ~= true then return end
		if amount < 1 or amount > 1000 then return end
 
		if BUC2.ITEMS[item].itemType ~= "Money" and BUC2.ITEMS[item].itemType ~= "Points" and BUC2.ITEMS[item].itemType ~= "PSItem" and BUC2.ITEMS[item].itemType ~= "PSItem2"then
 
			for i = 1 , amount do
 
				target:ub_addItem(item)
 
			end
 
		end 
 
		target:ChatPrint(ply:Name().." Gave you "..amount.." "..BUC2.ITEMS[item].name1.."('s)!")
		ply:ChatPrint("You gave "..target:Name().." "..amount.." "..BUC2.ITEMS[item].name1.."('s)!")
 
	else
 
		ply:ChatPrint("[UNBOXING] You do not have the permission to do that!")
 
	end
end)
 
net.Receive("ub_giftitem", function(len , ply)
 
	local itemID = net.ReadString()
	local target = net.ReadEntity()
 
	if BUC2.ITEMS[itemID] ~= nil and ply:ub_hasItem(itemID) then
 
		if BUC2.CanTradePermaWeapons == false and BUC2.ITEMS[itemID].permanent == true then
 
			 ply:ChatPrint("[UNBOXING] This server does not allow you to trade permanent weapons.")
 
			 return
 
		end
 
		if target ~= nil then
 
			ply:ub_removeItem(itemID)
			target:ub_addItem(itemID)
 
		end
 
	end
 
 
end)
 
local function Callback( ply, int )
	net.Start( "StartClientUpgradeAnimation" )
		net.WriteUInt( int, 3 )
	net.Send( ply )
end
local function CalculateChance( toPrice, fromPrice, rightUID )
	toPrice = tonumber( toPrice ) or 0
	fromPrice = tonumber( fromPrice ) or 0

	if toPrice <= 0 or fromPrice <= 0 then
		return false
	end

	if toPrice <= fromPrice then
		return true
	end
	
	local chance = math.Clamp(fromPrice / toPrice, 0, 1)
	
	if chance < 0.9 then
		chance = math.min( chance, 0.80 )
	end

	if RTP.Profit >= toPrice - fromPrice then
		return math.random( ) < chance
	else
		return false
	end
end
net.Receive( "StartClientUpgradeAnimation", function( len, ply )
	local rightItem = net.ReadString( )
 
	if GetGlobalBool( "IGS_DISABLED" ) == true || (not IGS.REPEATER:IsEmpty()) then
		ply:ChatPrint("Автодонат временно отключен")
		Callback( ply, 0 )
		return
	end
 
	if not IsUpgradeableWeapon(rightItem, BUC2.UpgradeToItems or {}) then return end
 
	local RIGHT_ITEM = GetItem( rightItem )
	if not RIGHT_ITEM then Callback( ply, 0 ) return end // config issues
 
 
	local sid64 = ply:SteamID64( )
 
	if net.ReadBool( ) then // isItem
		local leftItem = net.ReadString( )
		local leftItemID = tonumber( net.ReadString( ) )
		local isInventory = net.ReadBool( )
 
		if rightItem == leftItem then Callback( ply, 0 ) return end
 
		if not IsUpgradeableWeapon(leftItem, BUC2.UpgradeFromItems or {}) then Callback( ply, 0 ) return end // lier?
 
		local LEFT_ITEM = GetItem( leftItem )
		if not LEFT_ITEM then Callback( ply, 0 ) return end // config issues
 
		local isWin = Backspin[ ply:SteamID( ) ] or CalculateChance( RIGHT_ITEM.price, LEFT_ITEM.price, rightItem )
 
		if isInventory then
			// IGS.LoadInventory( ply )
			local inventory = IGS.Inventory( ply, false )
			for k,v in pairs( inventory ) do
				if v.Item ~= leftItem then continue end
				if v.ID ~= leftItemID then continue end
 
				// force to delete locally
				local deleted = IGS.DeletePlayerInventoryItemLocally( ply, v.ID )
				if not deleted then Callback( ply, 0 ) return end // item not found, lier?
 
				// delete from database;
				IGS.DeleteInventoryItem(function(sucess)
			        if not sucess then
			        	if IsValid( ply ) then
			        		Callback( ply, 0 )
			        	end
				        return
				    end
 
			        if isWin then
						if LEFT_ITEM.price <= RIGHT_ITEM.price then
							local clean_profit = LEFT_ITEM.price - RIGHT_ITEM.price
							RTP:Append( clean_profit > 0 and clean_profit * ( RTP.BetweenPlayers ) or clean_profit )
						end
			        	GiveAway( rightItem, IsValid( ply ) and ply or sid64, function( idk )
							if !IsValid( ply ) then return end
							Callback( ply, 1 )
							IGS.LoadInventory( ply )
						end )
			        else
						RTP:Append( LEFT_ITEM.price ) // yay, ez money for server )
			        	Callback( ply, 2 )
			        end
 
			    end, v.ID)
 
				break
			end
 
		else
 
 
			if true then
				error( "Upgrade:Purchases are disabled! Somebody tried to use it. " .. ply:SteamID( ) )
				return
			end
 
			local purchases = IGS.PlayerPurchases( ply )
			local count = purchases[ leftItem ]
			if not count then Callback( ply, 0 ) return end // lier?
 
 
			local ServerID = IGS.SERVERS:ID( )
			IGS.GetPlayerPurchases( sid64, function( data )
				if !IsValid( ply ) then print('invalid player') return end
				if not data then return end
 
				for k,v in pairs( data ) do
					if v.Item ~= leftItem then continue end
					if v.ID ~= leftItemID then continue end
					if v.Server ~= ServerID then continue end
					IGS.DisablePurchase( v.ID, function( bUpdated )
						if bUpdated then
							if isWin then
								GiveAway( rightItem, IsValid( ply ) and ply or sid64, function( idk )
									if IsValid( ply ) then
										Callback( ply, 1 )
										IGS.LoadPlayerPurchases( ply )
										IGS.LoadInventory( ply )
									end
								end )
							else
								if IsValid( ply ) then
									Callback( ply, 2 )
									IGS.LoadPlayerPurchases( ply )
								end
							end
							if LEFT_ITEM.swep and count == 1 and IsValid( ply ) then
								timer.Simple( 1, function()
									if IsValid( ply ) then
										ply:StripWeapon( LEFT_ITEM.swep ) // take away
									end
								end )
							end
						end
					end )
 
					break
				end
			end )
 
		end
	else
		local money = net.ReadUInt( 32 )
 
		if money <= 0 then return end // lier?
		//if not IGS.CanAfford( ply, money ) then return end // CanAfford может неправильно работать если потеряно подключение к IGS. Так что лучше спрашивать напрямую
		igsCanAfford( ply, money, function( bool )
			if !bool then
				Callback( ply, 0 )
				return
			end

			ply:AddIGSFunds( -money, "Unbox | Рулетка" )
	 
			local isWin = Backspin[ ply:SteamID( ) ] or CalculateChance( RIGHT_ITEM.price, money, rightItem )
	 
			if isWin then
				GiveAway( rightItem, ply, function( idk )
					if IsValid( ply ) then
						Callback( ply, 1 )
						IGS.LoadInventory( ply )
					end
				end )
			else
				Callback( ply, 2 )
			end
		end )
	end
 
end )
 
net.Receive("ub_spawnEntity",function (len , ply)
 
	local itemID = net.ReadString()
 
	if ply:ub_hasItem(itemID) then
 
		ply:ub_removeItem(itemID)
 
		trace = ply:GetEyeTrace()
		posToSpawn = Vector(0,0,0)
 
		if trace.HitPos:Distance(ply:GetPos()) > 200 then
 
			posToSpawn = (ply:GetPos() + Vector(0,0,50)) + (ply:GetAimVector() * 100 )
 
		else
 
			posToSpawn = trace.HitPos
 
		end
 
		local temp = ents.Create(BUC2.ITEMS[itemID].entityClass)
		temp:SetPos(posToSpawn)
		temp:Spawn()
 
		if temp.Setowning_ent ~= nil then
			temp:Setowning_ent(ply)
		end
 
	end
 
end)
 
net.Receive("ub_deleteItem" , function(len, ply)
 
	local itemID = net.ReadString()
 
	if BUC2.ITEMS[itemID] == nil then print("nil") return end
	if ply:ub_hasItem(itemID) then
		ply:ub_removeItem(itemID)
 
	end
 
end)
 
net.Receive("ub_equipweapon",function(len , ply)
	local weaponID = net.ReadString()
 
	if BUC2.ITEMS[weaponID] == nil then return end
 
	if ply:ub_hasItem(weaponID) then
 
		if ply:HasWeapon(BUC2.ITEMS[weaponID].weaponName) ~= true then
 
			ply:Give(BUC2.ITEMS[weaponID].weaponName)
 
			if BUC2.ITEMS[weaponID].permanent == false then
 
				ply:ub_removeItem(weaponID)
 
			end
 
		end
 
	else
 
		print("[UNBOXING ERROR] Player "..ply:Name().." tried to equip a weapon the user does not own, This users may be trying to cheat.")
 
	end
 
 
end)
 
net.Receive("ub_purchase",function(len , ply)
 
	local item = net.ReadString()
	local amount = net.ReadInt(8) 
 
	if GetGlobalBool( "IGS_DISABLED" ) == true || (not IGS.REPEATER:IsEmpty()) then
		ply:ChatPrint("Автодонат временно отключен")
		return
	end
 
	if item ~= nil and amount ~= nil then
 
		if BUC2.ITEMS[item] == nil then return end
 
		if amount < 1 or amount > 16 then return end

		if BUC2.BuyItemsWithPoints == false and BUC2.BuyItemsWithPoints2 == false then
 
			if IGS.CanAfford(ply,BUC2.ITEMS[item].price * amount) then
 
				ply:AddIGSFunds((BUC2.ITEMS[item].price * amount) * -1,"Покупка кейса")
 
				for i = 1 , amount do 
					ply:ub_addItem(item, true)
				end
				ply:ub_saveInventory()
				ply:ub_update_client()
			end
		else 
			if BUC2.BuyItemsWithPoints then
				if ply:PS_HasPoints(BUC2.ITEMS[item].price * amount) then
 
					ply:PS_TakePoints(BUC2.ITEMS[item].price * amount)
 
					for i = 1 , amount do 
						ply:ub_addItem(item, true)
					end
					ply:ub_saveInventory()
					ply:ub_update_client()
				end
			elseif BUC2.BuyItemsWithPoints2 then
				if ply.PS2_Wallet.points then				
					ply:PS2_AddStandardPoints(BUC2.ITEMS[item].price * amount * -1)
					for i = 1 , amount do 
						ply:ub_addItem(item, true)
					end
					ply:ub_saveInventory()
					ply:ub_update_client()
				end
			end
 
		end
 
	end
 
end)
 
function p:ub_addItem(itemID, supressSave)
	if supressSave == nil then
		supressSave = false
	end
 
	if self.ubinv[itemID] ~= nil then
		self.ubinv[itemID] = self.ubinv[itemID] + 1
	else
		self.ubinv[itemID] = 1
	end
 
	if not supressSave then
		self:ub_saveInventory()
		self:ub_update_client()
	end
end
 
function p:ub_update_client()
	local i = self.ubinv
	local inv = util.TableToJSON(i)
	local compressedInv = util.Compress(inv)
 
	net.Start("ub_inventory_update") 
		net.WriteDouble(string.len(compressedInv))
		net.WriteData(compressedInv, string.len(compressedInv))  
	net.Send(self)
 
 
	local msg = util.Compress( util.TableToJSON( BUC2.History ) )
	local len = string.len( msg )
	net.Start( "ub_history_update" )
		net.WriteUInt( len, 16 )
		net.WriteData( msg, len )
	net.Send( self )
 
end
 
net.Receive('donOpen',function(_,ply)
	ply:ub_update_client()
end)

function p:ub_removeItem(itemID)
 
	print("Before remove!", itemID)
	PrintTable(self.ubinv)
 
	if self.ubinv[itemID] ~= nil and self.ubinv[itemID] > 0 then
		self.ubinv[itemID] = self.ubinv[itemID] - 1
		if self.ubinv[itemID] == 0 then
			self.ubinv[itemID] = nil
		end
		self:ub_saveInventory()
		self:ub_update_client()
		return true
	else
		self:ub_saveInventory()
		self:ub_update_client()
		return false
	end
end
 
 
function p:ub_saveInventory()
	if not IsValid(self) then return false end
 
	local i = {}

	for k ,v in pairs(self.ubinv) do
		i[BUC2.ItemToID[k]] = v
	end
 
	i["new"] = true
 
	file.CreateDir("blues_unboxing_2")
	file.Write("blues_unboxing_2/"..self:SteamID64().."_inventory.txt" , util.TableToJSON(i))

	return true
end
 
function p:ub_loadInventory()
	if not IsValid(self) then return false end
	local filename = "blues_unboxing_2/"..self:SteamID64().."_inventory.txt"
	if not file.Exists(filename , "DATA") then
 		self.ubinv = {} 
		self:ub_saveInventory()
	else 
		local i = util.JSONToTable(file.Read("blues_unboxing_2/"..self:SteamID64().."_inventory.txt", "DATA")) 
		self.ubinv = {}
		if i.new == true then
			local newInv = {}
			for k , v in pairs(i) do
				if k ~= "new" then
					if not BUC2.IDToItem[k] then continue end
					if newInv[BUC2.IDToItem[k]] == nil then newInv[BUC2.IDToItem[k]] = 0 end
					newInv[BUC2.IDToItem[k]] = newInv[BUC2.IDToItem[k]] + v
 
					self.ubinv = newInv
				end
			end 
		else
			local newInv = {}
			for k , v in pairs(i) do
				if k ~= "new" then
					if not BUC2.IDToItem[k] then continue end

					if newInv[BUC2.IDToItem[v]] == nil then newInv[BUC2.IDToItem[v]] = 0 end
					newInv[BUC2.IDToItem[v]] = newInv[BUC2.IDToItem[v]] + 1
				end
			end 
			self.ubinv = newInv		
		end
	end
end
 
function p:ub_hasItem(itemID)
	if self.ubinv[itemID] ~= nil and self.ubinv[itemID] > 0 then
		return true
	else
		return false
	end
end
 
local function GiveItemByPrintName( ply, printName )
    local itemClass = Pointshop2.GetItemClassByPrintName( printName )
    if not itemClass then
            error( "Invalid item " .. tostring( printName ) )
    end
    return ply:PS2_EasyAddItem( itemClass.className )
end
 
net.Receive("BeginSpin",function(len, ply) // start unboxing( spinner )
 
 
	local crateID = net.ReadString()
	local amount = net.ReadUInt( 4 )
	local count = ply.ubinv[ crateID ]
 
	if not count or amount == 0 or count < amount then
		print("[UNBOXING] "..ply:Nick().." sent a bad request. This could just be a mistake but he may be trying to cheat. (CODE 4)")
		return
	end
 
	if BUC2.ITEMS[crateID] == nil or BUC2.ITEMS[crateID].itemType ~= "Crate"  then
		print("[UNBOXING] "..ply:Name().." sent a bad request. This could just be a mistake but he may be trying to cheat. (CODE 1)")
		return
	end
 
	ply.ubinv[ crateID ] = ply.ubinv[ crateID ] - amount
 
	ply.ubpendingitems = {}

	local backspin = Backspin[ ply:SteamID( ) ]
	for i = 1, amount do
		ply.ubpendingitems[ i ] = RTP:GenerateItem( crateID, nil, backspin )
		if !ply.ubpendingitems[ i ] then
		Callback( ply, 0 )
			return
		end
	end
 
	// force to save, don't wait for drop ( due to possible errors )
	ply:ub_saveInventory()
	ply:ub_update_client()
 
	for i, id in next, ply.ubpendingitems do
		local item = BUC2.ITEMS[ id ]
		local itemType = item.itemType
		local igsID = item.itemType == "IGS" and item.amount or item.itemType == "Weapon" and item.weaponName
 
		IGS.AddToInventory( ply, igsID )
	end
	IGS.Notify( ply, "Предмет помещен в /donate инвентарь" )
 
	ply.spinPending = true
 
	net.Start "StartClientSpinAnimation"
		net.WriteTable( ply.ubpendingitems )
	net.Send( ply )
 
end)
 
net.Receive("SpinEnded" , function(len , ply) // unbox notify
 
	if net.ReadBool( ) then
		if ply.spinPending == true then
			ply.spinPending = false // only once
 
			for i, id in next, ply.ubpendingitems do
				local item = BUC2.ITEMS[ id ]
				local itemType = item.itemType
				local igsID = item.itemType == "IGS" and item.amount or item.itemType == "Weapon" and item.weaponName
 
				BUC2:HistoryAppend( igsID )
			end
 
			if BUC2.AnnounceUnboxings then
				net.Start "ub_annouceunbox"
				net.WriteEntity( ply ) 
				net.WriteTable( ply.ubpendingitems )
				net.Broadcast( )
			end
 
			ply:ub_update_client()
		end
	else
		if ply.ub_upgrading then
			local uid = ply.ub_upgrading
			BUC2:HistoryAppend( uid )
			ply:ub_update_client()
			ply.ub_upgrading = nil
		end
	end
 
end) 
 
hook.Add("PlayerInitialSpawn" , "LoadUBPlayerInventory" , function(ply)
	timer.Simple( 2, function()
		if not IsValid(ply) then return end
		ply:ub_loadInventory( )
	end )
end)
 
function generateItem(itemID)
 
	local totalChance = 0
 
	for k , v in pairs(BUC2.ITEMS[itemID].items) do
 
			v = BUC2.ITEMS[v]
 
			totalChance = totalChance + v.chance
 
	end
 
	local itemList = {}
 
	local num = math.random(1 , totalChance)
 
	local prevCheck = 0
	local curCheck = 0
 
	local item = nil
 
	for k ,v in pairs(BUC2.ITEMS[itemID].items) do
 
		v = BUC2.ITEMS[v]
 
		if v.itemType ~= "Key" and v.itemType ~= "Crate" then
 
			if num >= prevCheck and num <= prevCheck + v.chance then
 
				item = v.name1
 
			end
 
			prevCheck = prevCheck + v.chance
 
		end
 
	end
 
	return item
 
end
 
local function getCrates( )
	local crates = {}
	for crateID,v in pairs( BUC2.ITEMS ) do
		if v.itemType ~= "Crate" then continue end
		table.insert( crates, crateID )
	end
	return crates
end
function BUC2:RandomizeHistory( )
	local crates = getCrates( )
	for i = 1, 10 do
		local crateID = table.Random( crates )
		local crate = BUC2.ITEMS[ crateID ]
		if not crate or crate.itemType ~= "Crate" then continue end // invalid?
 
		local item = BUC2.ITEMS[ generateItem( crateID ) ]
		if not item then print('no item') return end
		local igsID = item.itemType == "IGS" and item.amount or item.itemType == "Weapon" and item.weaponName
 
		BUC2:HistoryAppend( igsID )
	end
end
BUC2:RandomizeHistory( )

local function openMenu( ply )
	if GetGlobalBool( "IGS_DISABLED" ) == true || (not IGS.REPEATER:IsEmpty()) then
		ply:ChatPrint("Автодонат временно отключен")
		return
	end

	ply:ub_update_client()

	net.Start("ub_openui")
	net.Send(ply)
end

local function initCommand( )
	if rp and rp.AddCommand then

		hook.Remove( "PlayerSay" , "OpenTextCommand" )
	end
end


hook.Add("PlayerSay" , "OpenTextCommand" , function(ply , text)
end)

hook.Add("PlayerSay" , "OpenDonateCm" , function(ply , text)
	if string.lower(text) == "!donate" or string.lower(text) == "/donate" then
		ply:ub_update_client()

		net.Start('DonMenu')
		net.Send(ply)
	end
end)

hook.Add( "InitPostEntity", "unbox command", initCommand )
initCommand( )
 
concommand.Add( "unboxing2_open", function(ply, cmd, args)
	ply:ub_update_client()
 
	net.Start("ub_openui")
	net.Send(ply)
end)

concommand.Add( "unboxing2_give", function(_, __, args)
	print("Giving item to ")
	local sid = args[1]
	local itemIDToGive = args[2]
 
	if IsValid(_) then
		if not table.HasValue(BUC2.RanksThatCanGiveItems, _:GetUserGroup()) then
			_:ChatPrint("Invalid Rank!")
			return false
		end
	end
 
	if sid == nil or sid == "" then
		print("Invalid SteamID64")
		print("The command works like this : unboxing2_give 7723672367262737 'Weapon Crate'")
 
		return 
	end
 
	local ply = player.GetBySteamID64(sid)
 
	if ply == nil or not IsValid(ply) then
		print("[UNBOXING 2] Failed to add item, either the player is not in the server or the steamid64 is wrong!")
		print("The command works like this : unboxing2_give 7723672367262737 'Weapon Crate'")
		return
	end

	if BUC2.ItemToID[itemIDToGive] == nil then
		print("[UNBOXING 2] Tried to give an invalid item! The item '"..itemIDToGive.."' is not a valid item")
		print("The command works like this : unboxing2_give 7723672367262737 'Weapon Crate'")
		return 
	end

	ply:ub_addItem(itemIDToGive)
 
	print( "[UNBOXING 2] Give '" .. ply:Name() .. "' item '" .. itemIDToGive .. "'" )
 
end )

concommand.Add( "unbox_chance_checker", function( ply, _, args, args_str )
	if game.IsDedicated( ) and IsValid( ply ) then
		return
	end

	local num = args[ 1 ]
	local caseID = table.concat( args, " ", 2 )

	num = tonumber( num or "false" )
	if not num then
		print( "Вы ввели число:", num )
		print( "Неправильный формат!" )
		print( "Используйте: " )
		print( "unbox_chance_checker <кол-во тестов> <название кейса>" )
		print( "или" )
		print( "unbox_chance_checker <кол-во тестов> \"<название кейса>\"" )
		return
	end

	local case = BUC2.ITEMS[ caseID ]
	if not case then
		caseID = "Кейс Gubke"
	end
	case = BUC2.ITEMS[ caseID ]
	if not case or case.itemType ~= "Crate" then
		print("Неправильный ID кейса: \"" .. caseID .. "\"")
		print(" Список доступных: ")
		for k, v in pairs( BUC2.ITEMS ) do
			if v.itemType == "Crate" then
				print( "\t\"" .. v.name1 .. "\"" )
			end
		end
		return
	end

	local prices = {}
	for k, v in pairs( IGS.GetItems( ) ) do
		prices[ v.uid ] = v.price
	end

	local result = {}
	local profit = 0
	local function isProfit( uid )
		if not uid then return end
 
		local price = prices[ uid ]
		if not price then return end
 
		if price >= case.price then
			profit = profit + 1
			return true
		end
		return false
	end
	for k, id in pairs( case.items ) do
		result[ id ] = 0
	end

	local backupProfit = RTP.Profit
	RTP.Profit = 0
	
		for i = 1, num do
			local generated = RTP:GenerateItem( caseID, true )
			if !generated then
				error("invalid case")
				return
			end
			local item = BUC2.ITEMS[ generated ]
			if item.weaponName then
				isProfit( item.weaponName )
			elseif item.amount then
				isProfit( item.amount )
			else
				print("unknown")
			end
			result[ generated ] = (result[ generated ] or 0) + 1
		end

	RTP.Profit = backupProfit

	for generatedID, count in SortedPairsByValue( result, true ) do
		print( count, ' = ', generatedID )
	end
 
	print(" ")
	print( "Процент окупа", " = ", (profit == 0 and 0 or math.Round((profit / num) * 100, 2)) .. "%" )

end )

concommand.Add( "unbox_chance_checker2", function( ply, _, args, args_str )
	if game.IsDedicated( ) and IsValid( ply ) then
		return
	end
 
	local num = args[ 1 ]
	local caseID = table.concat( args, " ", 2 )

	num = tonumber( num or "false" )
	if not num then
		print( "Вы ввели число:", num )
		print( "Неправильный формат!" )
		print( "Используйте: " )
		print( "unbox_chance_checker <кол-во тестов> <название кейса>" )
		print( "или" )
		print( "unbox_chance_checker <кол-во тестов> \"<название кейса>\"" )
		return
	end

	local case = BUC2.ITEMS[ caseID ]
	if not case or case.itemType ~= "Crate" then
		print("Неправильный ID кейса: \"" .. caseID .. "\"")
		print(" Список доступных: ")
		for k, v in pairs( BUC2.ITEMS ) do
			if v.itemType == "Crate" then
				print( "\t\"" .. v.name1 .. "\"" )
			end
		end
		return
	end
	
	local prices = {}
	for k, v in pairs( IGS.GetItems( ) ) do
		if v.swep then
			prices[ v.uid ] = v.price
		end
	end
 
	local result = {}
	local profit = 0
	local function isProfit( uid )
		if not uid then return end
 
		local price = prices[ uid ]
		if not price then return end
 
		if price >= case.price then
			profit = profit + 1
			return true
		end
		return false
	end
	for k, id in pairs( case.items ) do
		result[ id ] = 0
	end
	for i = 1, num do
		local generated = generateItem( caseID )
		local item = BUC2.ITEMS[ generated ]
		if item.weaponName then
			isProfit( item.weaponName )
		elseif item.amount then
			isProfit( item.amount )
		end
		result[ generated ] = (result[ generated ] or 0) + 1
	end
	for generatedID, count in SortedPairsByValue( result, true ) do
		print( count, ' = ', generatedID )
	end
 
	print(" ")
	print( "Процент окупа", " = ", (profit == 0 and 0 or math.Round((profit / num) * 100, 2)) .. "%" )
 
end )


file.CreateDir( "unbox_deleted" )
concommand.Add( "unbox_delete", function( ply, _, args, args_str )
	if !IsValid( ply ) or !ply:IsRoot() then
		return
	end
	
	local sid64 = util.SteamIDTo64( args_str )
	if !sid64 or !isstring( sid64 ) then ply:ChatPrint( "Invalid steamid!" ) return end

	local inv = util.JSONToTable( file.Read("blues_unboxing_2/"..sid64.."_inventory.txt", "DATA") ) 

	local empty = true
	for k, v in pairs( inv or {} ) do
		if k == "new" then continue end
		empty = false
		break
	end

	if empty then ply:ChatPrint( "This inventory is empty!" ) return end

	local target = player.GetBySteamID64( sid64 )	
	file.Write( "unbox_deleted/" .. sid64 .. ".txt", file.Read("blues_unboxing_2/"..sid64.."_inventory.txt", "DATA") )
	file.Delete( "blues_unboxing_2/" .. sid64 .. "_inventory.txt" )

	ply:ChatPrint( "Success!!" )

	if IsValid( target ) then
		target.ubinv = {}
		target:ub_update_client( )
	end
end )