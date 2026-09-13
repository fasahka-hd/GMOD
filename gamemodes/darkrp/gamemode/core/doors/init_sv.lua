--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

-- Доведите до ума ети двери, а то так лень ето все делать
util.AddNetworkString('rp.keysMenu')

function ENTITY:DoorIndex()
	return (self:EntIndex() - game.MaxPlayers())
end

function ENTITY:DoorLock(locked)
	self.Locked = locked
	if (locked == true) then
		self:SetNWBool("IsLocked", true)
		self:SetNetVar('DoorLocked', true)
		self:Fire('lock', '', 0)
	elseif (locked == false) then
		self:SetNWBool("IsLocked", false)
		self:SetNetVar('DoorLocked', false)
		self:Fire('unlock', '', 0)
	end
end

local function DoorGetByID(id) 
	local t = {}
	for k, v in pairs(ents.GetAll()) do 
		if IsValid(v) and v:IsDoor() and v:GetDoorID() == id then 
			table.insert(t,v)
		end
	end
	return t
end

local function DoorGetSingleByID(id) 
	for k, v in pairs(ents.GetAll()) do 
		if IsValid(v) and v:IsDoor() and v:GetDoorID() == id then 
			return v
		end
	end
end

hook.Add("InitPostEntity","DoorsSetPriceMultiplier",function() 
for k, v in pairs( ents.GetAll() ) do 
	if IsValid(v) and v:IsDoor() then 
		for _, z in pairs(rp.cfg.Doors) do 
			if table.HasValue( z.MapIDs,v:GetDoorID() ) then 
				v:SetNWInt("PriceMultiplier",#z.MapIDs)
			end
		end
	end
end
end)

function ENTITY:DoorOwn(pl)
	self:SetNWEntity("ownor",pl)
	pl:SetVar('doorCount', (pl:GetVar('doorCount') or 0) + 1, false, false)
	self:SetNetVar('DoorData', {Owner = pl})
	eui.battlepass.AddProgress(pl, 19)
	
	for k, v in pairs(rp.cfg.Doors) do 
		if table.HasValue(v.MapIDs,self:GetDoorID()) then 
			BuyDoorWithIndex(v.MapIDs,pl)
		end
	end
end

function ENTITY:DoorAddCoOwners(pl)
	local id = self:GetDoorID()
	for k, v in pairs( rp.cfg.Doors ) do 
		if table.HasValue( v.MapIDs,id ) then 
			for zk, zv in pairs(v.MapIDs) do 
				if not DoorGetSingleByID(zv):DoorCoOwnedBy(pl) then 
					DoorGetSingleByID(zv):DoorCoOwn( pl ) 
				end
			end
		end
	end
end

function ENTITY:DoorRemoveCoOwners(pl)
	local id = self:GetDoorID()
	for k, v in pairs( rp.cfg.Doors ) do 
		if table.HasValue( v.MapIDs,id ) then 
			for zk, zv in pairs(v.MapIDs) do 
				DoorGetSingleByID(zv):DoorUnCoOwn(pl)
			end
		end
	end
end

function ENTITY:OwnAsHotel(pl)
	self:SetNWEntity( "hotel_owner",pl )
	for k, v in pairs( rp.cfg.Doors ) do 
		if table.HasValue( v.MapIDs,self:GetDoorID() ) then 
			if (v.Hotel ~= nil and v.Hotel == true) then 
				for _, d in pairs( v.MapIDs ) do 
					DoorGetByID(d)[1]:SetNWEntity("hotel_owner",pl)
				end
			end
		end
	end
end

function ENTITY:UnOwnAsHotel(pl)
	self:SetNWEntity( "hotel_owner",pl )
	for k, v in pairs( rp.cfg.Doors ) do 
		if table.HasValue( v.MapIDs,self:GetDoorID() ) then 
			if (v.Hotel == true) then 
				for _, d in pairs( v.MapIDs ) do 
					for __, z in pairs(DoorGetByID(d)) do 
						z:SetNWEntity("hotel_owner",Entity(-1))
					end
				end
			end
		end
	end
end

function BuyDoorWithIndex(tbl,pl)
	for k, v in pairs(tbl) do 
		local suc, err = pcall(function()
			local d = DoorGetByID(v)[1]
			if d== nil then return end
			d:SetNWEntity("ownor",pl)
			d:SetNetVar("DoorData",{Owner=pl})

		end)
	end
end

function ENTITY:DoorUnOwn()
	if IsValid(self:DoorGetOwner()) then
		self:DoorGetOwner():SetVar('doorCount', (self:DoorGetOwner():GetVar('doorCount') or 0) - 1, false, false)
	end
	self:DoorLock(false)
	self:SetNWEntity("ownor",0)
	self:SetNetVar('DoorData', nil)
	for k, v in pairs(rp.cfg.Doors) do 
		if table.HasValue(v.MapIDs,self:GetDoorID()) then 
			SellDoorWithIndex(v.MapIDs,pl)
		end
	end
end

function SellDoorWithIndex(tbl)
	for k, v in pairs(tbl) do 
		local suc, err = pcall(function()
			local d = DoorGetByID(v)[1]
			if d== nil then return end
			d:SetNWEntity("ownor",0)
			d:SetNetVar("DoorData",nil)

		end)
	end
end



function ENTITY:DoorCoOwn(pl)
	local data = self:GetNetVar('DoorData') or {}
	data.CoOwners =  data.CoOwners or {}
	data.CoOwners[#data.CoOwners + 1] = pl
	self:SetNetVar('DoorData', data)
end

function ENTITY:DoorUnCoOwn(pl)
	local data = self:GetNetVar('DoorData') or {}
	table.RemoveByValue(data.CoOwners or {}, pl)
	self:SetNetVar('DoorData', data)
end

function ENTITY:DoorSetTitle(title)
	local data = self:GetNetVar('DoorData') or {}
	data.Title = title
	self:SetNetVar('DoorData', data)
end

function PLAYER:DoorUnOwnAll()
	for k, v in ipairs(ents.GetAll()) do
		if IsValid(v) and v:IsDoor() then 
			if v:DoorOwnedBy(self) then
				v:DoorUnOwn()
			elseif v:DoorCoOwnedBy(self) then
				v:DoorUnCoOwn(self)
			end
		end
	end
end


//
// Commands
//

rp.AddCommand('buydoor', function(pl, text, args)
	if rp.teams[pl:Team()].CannotOwnDoors then
		rp.Notify(pl, NOTIFY_ERROR, term.Get('TeamCannotOwnDoor'))
 		return
 	end

	if (pl:GetVar('doorCount') or 0) >= 8 then
		rp.Notify(pl, NOTIFY_ERROR, term.Get('MaxDoors'))
		return
	end

	local ent = pl:GetEyeTrace().Entity
	if not IsValid(ent) or not ent:IsDoor() or (ent:GetPos():DistToSqr(pl:GetPos()) >= 13225) then return end

	local info = ent:GetPropertyInfo()
	if not info then return end
	if info.Teams then
		return rp.Notify(pl, 1, 'Вы не можете купить эту дверь!')
	end

	local cost = ent:GetPropertyPrice(pl)
	if not pl:CanAfford(cost) then
		rp.Notify(pl, NOTIFY_ERROR, term.Get('CannotAfford'))
		return
	end

	if ent:DoorIsOwnable() then
		pl:TakeMoney(cost, 'Купил дверь')
		
		local percentPrice = mayor_system:calculate_tax(2, cost)
		mayor_system:add_balance( percentPrice )

		rp.Notify(pl, NOTIFY_SUCCESS, term.Get('DoorBought'), ent:GetPropertyName(), rp.FormatMoney(cost)) 
		ent:DoorOwn(pl)
	end
end)


rp.AddCommand('addcoowner', function(pl, targ, text)
	local ent = pl:GetEyeTrace().Entity

	if IsValid(ent) and ent:IsDoor() and ent:DoorOwnedBy(pl) and (targ ~= nil) and (targ ~= pl) and not ent:DoorCoOwnedBy(targ) and (ent:GetPos():DistToSqr(pl:GetPos()) < 13225) then
		if rp.teams[targ:Team()].CannotOwnDoors then
			rp.Notify(pl, NOTIFY_ERROR, term.Get('TeamCannotOwnDoor'))
		else
			rp.Notify(pl, NOTIFY_SUCCESS, term.Get('DoorOwnerAdded'), targ)
			rp.Notify(targ, NOTIFY_SUCCESS, term.Get('DoorOwnerAddedYou'), pl)
			ent:DoorCoOwn(targ)
		end
	end
end)
:AddParam(cmd.PLAYER_ENTITY)

rp.AddCommand('removecoowner', function(pl, targ, text)
	local ent = pl:GetEyeTrace().Entity

	if IsValid(ent) and ent:IsDoor() and ent:DoorOwnedBy(pl) and (targ ~= nil) and ent:DoorCoOwnedBy(targ) and (ent:GetPos():DistToSqr(pl:GetPos()) < 13225) then
		rp.Notify(pl, NOTIFY_SUCCESS, term.Get('DoorOwnerRemoved'), targ)
		rp.Notify(targ, NOTIFY_SUCCESS, term.Get('DoorOwnerRemovedYou'), pl)
		ent:DoorUnCoOwn(targ)
	end
end)
:AddParam(cmd.PLAYER_ENTITY)

rp.AddCommand('selldoor', function(pl, text, args)
	local ent = pl:GetEyeTrace().Entity
	if IsValid(ent) and ent:IsDoor() and ent:DoorOwnedBy(pl) and (ent:GetPos():DistToSqr(pl:GetPos()) < 13225) then
		local amount = math.floor(ent:GetPropertyPrice(pl) * 0.7)
		pl:AddMoney(amount, 'Продажа двери')
		rp.Notify(pl, NOTIFY_SUCCESS, term.Get('DoorSold'), ent:GetPropertyName(), rp.FormatMoney(amount))
		ent:DoorUnOwn(pl)
	end
end)

rp.AddCommand('addtennant',function(pl,text,args) 

end)

concommand.Add("addtennant",function(pl,text,args) 
	local door = pl:GetEyeTrace().Entity 
	if not door:IsDoor() or not IsValid(door) then return end
	if not pl:Team() == TEAM_HOTEL then return end
	local temp = {}
	table.insert( temp,player.GetBySteamID( args[1] ))
	door:DoorAddCoOwners( player.GetBySteamID( args[1] ) )

	rp.Notify(pl, NOTIFY_SUCCESS, 'Вы заселили '..player.GetBySteamID(args[1]):Name()..' в отель')
	rp.Notify(temp, NOTIFY_SUCCESS, 'Вас заселили'..' в отель')
end)

concommand.Add("buy_hotel",function(pl,text,args) 
	local door = pl:GetEyeTrace().Entity 
	if not door:IsDoor() or not IsValid(door) then return end
end)

function GetHotelManager()
	for k, v in pairs(player.GetAll()) do 
		if v:Team() == TEAM_HOTEL then 
			return v
		end
	end
end

concommand.Add("sell_hotel",function(pl,text,args) 
	local door = pl:GetEyeTrace().Entity 
	if not door:IsDoor() or not IsValid(door) then return end
	if not door:DoorCoOwnedBy(pl) then return end
	if GetHotelManager() == nil then return end
	door:DoorUnCoOwn(pl)
	door:DoorRemoveCoOwners( pl )
	rp.Notify(pl, NOTIFY_ERROR, 'Вы съехали с отеля')
	rp.Notify( GetHotelManager(),NOTIFY_ERROR,pl:Name().." съехал с отеля" )
end)

concommand.Add("idi_nax",function(pl,text,args) 
	local door = pl:GetEyeTrace().Entity 
	if not door:IsDoor() or not IsValid(door) then return end
	if not pl:Team() == TEAM_HOTEL then return end

	door:DoorUnCoOwn( player.GetBySteamID(args[1]) )
	door:DoorRemoveCoOwners(player.GetBySteamID(args[1]))
	rp.Notify(pl, NOTIFY_SUCCESS, 'Вы выселили из отель')
	rp.Notify(temp, NOTIFY_ERROR, 'Вас выселили из отель')
end)

concommand.Add("addcoowner",function(pl,text,args) 
	local ent = pl:GetEyeTrace().Entity

	if not IsValid(ent) or not ent:IsDoor() then return end
	if ent:DoorCoOwnedBy(player.GetBySteamID( args[1] )) then return end 
	if not rp.teams[ player.GetBySteamID( args[1] ):Team() ].CannotOwnDoors then 
		rp.Notify(pl, NOTIFY_SUCCESS, term.Get('DoorOwnerAdded'), targ)
		rp.Notify(player.GetBySteamID( args[1] ), NOTIFY_SUCCESS, term.Get('DoorOwnerAddedYou'), pl)
		ent:DoorAddCoOwners( player.GetBySteamID( args[1] ) )
	end

end)

concommand.Add('settitle', function(pl, text, args)
	if (text == '') then return end
	local ent = pl:GetEyeTrace().Entity
	if IsValid(ent) and ent:IsDoor() and ent:DoorOwnedBy(pl) then
		rp.Notify(pl, NOTIFY_SUCCESS, term.Add('DoorTitleSet'))
		ent:DoorSetTitle(string.sub(text, 1, 25))
	end
end)

concommand.Add("removecoowner",function(pl,text,args) 
	local ent = pl:GetEyeTrace().Entity

	if not IsValid(ent) or not ent:IsDoor() then return end
	if not ent:DoorCoOwnedBy(player.GetBySteamID( args[1] )) then return end 
	if not rp.teams[ player.GetBySteamID( args[1] ):Team() ].CannotOwnDoors then 
		rp.Notify(pl, NOTIFY_SUCCESS, "Вы удалили "..player.GetBySteamID( args[1] ):Name().." из двери.")
		rp.Notify(player.GetBySteamID( args[1] ), NOTIFY_SUCCESS, "Вас удалили из двери, сочуствуем")
		ent:DoorRemoveCoOwners( player.GetBySteamID( args[1] ) )
	end

end)

rp.AddCommand('sellall', function(pl, text, args)
	if (pl:GetVar('doorCount') or 0) <= 0 then
		rp.Notify(pl, NOTIFY_ERROR, term.Get('NoDoors'))
		return
	end
	local count = pl:GetVar('doorCount')
	local amt = (count * rp.doors.GetUniformPrice(pl))
	pl:DoorUnOwnAll()
	pl:AddMoney(amt, 'Продажа всех дверей')
	rp.Notify(pl, NOTIFY_SUCCESS, term.Get('DoorsSold'), count, rp.FormatMoney(amt))
end)

--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher