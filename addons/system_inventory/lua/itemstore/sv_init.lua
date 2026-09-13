--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

include( "sv_commands.lua" )

include( "shared.lua" )

include( "sv_data.lua" )
include( "sv_player.lua" )
--include( "sv_statistics.lua" )

AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "language.lua" )
AddCSLuaFile( "cl_player.lua" )
AddCSLuaFile( "containers.lua" )
AddCSLuaFile( "items.lua" )
AddCSLuaFile( "gamemodes.lua" )
AddCSLuaFile( "config.lua" )
AddCSLuaFile( "admin.lua" )
AddCSLuaFile( "trading.lua" )

AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "cl_gui.lua" )

AddCSLuaFile( "skins/" .. itemstore.config.Skin .. ".lua" )

for _, filename in ipairs( file.Find( "itemstore/vgui/*.lua", "LUA" ) ) do
	AddCSLuaFile( "itemstore/vgui/" .. filename )
end

if itemstore.config.AntiDupe then
	local meta = FindMetaTable( "Entity" )
	local oldRemove = meta.Remove

	function meta:Remove()
		self.__Deleted = true
		oldRemove( self )
	end
end

function itemstore.Print( pl, text )
	if IsValid( pl ) then
		pl:PrintMessage( HUD_PRINTCONSOLE, text )
	else
		print( text )
	end
end

RunConsoleCommand( "lua_log_sv", 1 )

concommand.Add( "itemstore_support", function( pl, cmd, args )
	if IsValid( pl ) and not pl:IsSuperAdmin() then return end

	local function respond( str )
		if IsValid( pl ) and false then
			pl:PrintMessage( HUD_PRINTCONSOLE, str )
		else
			print( str )
		end
	end

	local token = args[ 1 ]
	if not token then
		respond( "Error: token not defined. Please create a support ticket and ask for one." )
		return
	end

	local user = IsValid( pl ) and pl:Name() .. " (" .. pl:SteamID() .. ")" or "Console"
	local ip, port = string.match( game.GetIPAddress(), "(%d.%d.%d.%d):(%d)" )
	local hostname = GetHostName()
	local ws_addons, legacy_addons = file.Find( "addons/*", "GAME" )
	local config = file.Read( "itemstore/config.lua", "LUA" ) or ""
	local errors = file.Read( "lua_errors_server.txt", "GAME" ) or ""

	respond( "Uploading support information..." )

	http.Post( "https://uselessghost.me/itemstore/support.php", {
		token = token,
		user = user,
		ip = ip,
		port = port,
		hostname = hostname,
		ws_addons = util.TableToJSON( ws_addons ),
		legacy_addons = util.TableToJSON( legacy_addons ),
		config = config,
		errors = errors,
	}, function( data )
		local json = util.JSONToTable( data )
		
		if not json then
			respond( "Error: Invalid data received." )
			respond( data )
			return
		end

		if json.success then
			respond( "Support information uploaded." )
		else
			respond( "Support information upload failed: " .. json.error )
		end
	end )
end )

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
		net.WriteFloat(self.inv[str] or 1)
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

-- function meta:AddItem(str, amt)
	
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

--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
