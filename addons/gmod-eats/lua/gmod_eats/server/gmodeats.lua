--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

util.AddNetworkString("GmodEats.NPCMenu")
util.AddNetworkString("GmodEats.GiveBag")
util.AddNetworkString("GmodEats.GetBackBag")
util.AddNetworkString("GmodEats.NetworkMission")
util.AddNetworkString("GmodEats.UpdateMissionStatus")
util.AddNetworkString("GmodEats.ChangeStatus")
util.AddNetworkString("GmodEats.NetworkConfig")

local spamCooldowns = {}
local interval = .1

local function spamCheck(pl, name)
    if spamCooldowns[pl:SteamID()] then
        if spamCooldowns[pl:SteamID()][name] then
            if spamCooldowns[pl:SteamID()][name] > CurTime() then
                return false
            else
                spamCooldowns[pl:SteamID()][name] = CurTime() + interval
                return true
            end
        else
            spamCooldowns[pl:SteamID()][name] = CurTime() + interval
            return true
        end
    else
        spamCooldowns[pl:SteamID()] = {}
        spamCooldowns[pl:SteamID()][name] = CurTime() + interval

        return true
    end
end

local lang = GmodEats.Config.Language
local sentences = GmodEats.Config.Lang

net.Receive("GmodEats.ChangeStatus", function(len, ply)
	
	if not spamCheck( ply, "GmodEats.ChangeStatus" ) then return end
	
	if not ply:HasWeapon("uber_eat_bag_weap") then return end
	
	if ply:GetNWBool("UberAvailable") then
		ply:SetNWBool("UberAvailable",false)
	else
		ply:SetNWBool("UberAvailable",true)
	end

end)

net.Receive("GmodEats.UpdateMissionStatus", function(len, ply)

	if not spamCheck( ply, "GmodEats.UpdateMissionStatus" ) then return end
	
	if GmodEats.Config.LimitedToJob and not table.HasValue(GmodEats.Config.Jobs, ply:Team()) then return end
	
	ply.ListMissions = ply.ListMissions or {}
	if not ply:HasWeapon("uber_eat_bag_weap") then return end
	
	local id = net.ReadInt(32)
	local type = net.ReadInt(32)

	if not ply.ListMissions[id] then return end
	
	if type == 0 then

		GmodEats.Config.ClientPos[ply.ListMissions[id].Client].NotFree = false
		ply.HasDelivery = false
		
		ply.ListMissions[id] = nil
	end
	
	if type == 1 then
		
		local ttaccepted = 0
		
		for k, v in pairs( ply.ListMissions ) do
			
			if v.Accepted then ttaccepted = ttaccepted+1 end
			
			if ttaccepted >= 3 then break end
		end
		
		if ttaccepted >= 3 then ply:UE_Notif(sentences["You can't take more than 3 missions at the same time"][lang])  return end
		
		ply.ListMissions[id].Accepted = true
		
		local cid = ply.ListMissions.Cook
		
		if GmodEats.Config.CookPos[cid] and GmodEats.Config.CookPos[cid].Entity and IsValid(GmodEats.Config.CookPos[cid].Entity) then
			ply.ListMissions[id].CookNPC = GmodEats.Config.CookPos[cid].Entity 
		end
		
	end
	
	if type == 2 then
	
		if ply:GetNWInt("Command1") == ply.ListMissions[id].Client then
			ply:SetNWInt("Command1", 0)
		elseif ply:GetNWInt("Command2") == ply.ListMissions[id].Client then
			ply:SetNWInt("Command2", 0)
		elseif ply:GetNWInt("Command3") == ply.ListMissions[id].Client then
			ply:SetNWInt("Command3", 0)
		end
		
		local ent = GmodEats.Config.ClientPos[ply.ListMissions[id].Client].Entity  or NULL
		
		if IsValid( ent ) then ent:Remove() end
		
		GmodEats.Config.ClientPos[ply.ListMissions[id].Client].NotFree = false
		ply.HasDelivery = false
		ply.ListMissions[id] = nil
	end
	
	net.Start("GmodEats.NetworkMission")
		net.WriteTable( ply.ListMissions )
	net.Send( ply )
	
end)

-- when the seller give you the bag
net.Receive("GmodEats.GiveBag", function(len,ply)
	
	if not spamCheck( ply, "GmodEats.GiveBag" ) then return end
	
	if GmodEats.Config.LimitedToJob and not table.HasValue(GmodEats.Config.Jobs, ply:Team()) then return end

	local ent = net.ReadEntity() or net.ReadEntity()
	
	if not ply:Alive() then return end
	if not ent or not IsValid( ent ) then return end
	if ent:GetPos():Distance(ply:GetPos()) > 200 then return end
	
	if ply:HasWeapon("uber_eat_bag_weap") or (ply.Bag and IsValid( ply.Bag )) then
		ply:UE_Notif(sentences["You already own a backpack"][lang]) 
		return 
	end
	
	if not ply:CanAfford(GmodEats.Config.PriceBag) then 
		ply:UE_Notif(sentences["You don't have enough money"][lang]) 
		return
	end
	
	ply:UE_Notif(sentences["You've taken a backpack"][lang]) 
	ply:AddMoney(-GmodEats.Config.PriceBag, 'Списание за покупку рюкзака')
	
	timer.Simple(0.5, function()
		ply:Give("uber_eat_bag_weap")
	end)
	
	ent.ShouldAnim = true
	
end)

-- when you give your bag to the seller
net.Receive("GmodEats.GetBackBag", function(len,ply)
	
	if not spamCheck( ply, "GmodEats.GetBackBag" ) then return end
	
	if GmodEats.Config.LimitedToJob and not table.HasValue(GmodEats.Config.Jobs, ply:Team()) then return end
	
	local ent = net.ReadEntity() or net.ReadEntity()
	
	if not ply:Alive() then return end
	if not ent or not IsValid( ent ) then return end
	if ent:GetPos():Distance(ply:GetPos()) > 200 then return end
	
	if not ply:HasWeapon("uber_eat_bag_weap") then
		return 
	end
	
	local weap = ply:GetWeapon( "uber_eat_bag_weap" )
	
	if not IsValid( weap ) then return end
	
	weap:Remove()
	
	ply:AddMoney(GmodEats.Config.PriceBag, 'Добавление за продажу рюкзака')
	
	ply.ListMissions = ply.ListMissions or {}	
		
	for k, v in pairs( ply.ListMissions ) do 
	
		local ent = GmodEats.Config.ClientPos[v.Client].Entity  or NULL
		
		if IsValid( ent ) then ent:Remove() end
		
		GmodEats.Config.ClientPos[v.Client].NotFree = false
		ply.HasDelivery = false
	end
	
	
end)

hook.Add("PlayerInitialSpawn", "PlayerInitialSpawn.UberEat", function( ply )
	
	timer.Simple(1,function()
		GmodEats.Config = GmodEats.Config or {}
		
		net.Start("GmodEats.NetworkConfig")
			net.WriteTable( GmodEats.Config  )
		net.Send(ply)
	end)
end)

function PlayerSpawn_UberEat( ply )
	if not ply:HasWeapon("uber_eat_bag_weap") or not (ply.Bag and IsValid( ply.Bag )) then return end
	
	ply:SetNWInt("Command1", 0)
	ply:SetNWInt("Command2", 0)
	ply:SetNWInt("Command3", 0)
	
	ply.ListMissions = ply.ListMissions or {}

	for k, v in pairs( ply.ListMissions ) do 
	
		local ent = GmodEats.Config.ClientPos[v.Client].Entity  or NULL
		
		if IsValid( ent ) then ent:Remove() end
		
		GmodEats.Config.ClientPos[v.Client].NotFree = false
		
	end
	
	ply.ListMissions = {}
	ply.HasDelivery = false
	
	net.Start("GmodEats.NetworkMission")
		net.WriteTable( ply.ListMissions )
	net.Send( ply )
	
	-- remove the bag
	for k , v in pairs ( ents.FindByClass("uber_eat_bag") ) do
		if v:GetPlayer() == ply then
			v:Remove()
		end
	end
end
hook.Add( "PlayerSpawn", "PlayerSpawn_UberEat", PlayerSpawn_UberEat )
hook.Add( "OnPlayerChangedTeam", "PlayerSpawn_UberEat", PlayerSpawn_UberEat )

local function InitializeTableSavedEnts()
	
	if file.Exists("gmodeats/cook"..game.GetMap()..".txt", "DATA") then
		local filecontent = file.Read("gmodeats/cook"..game.GetMap()..".txt", "DATA")
		GmodEats.Config.CookPos =  util.JSONToTable(filecontent)

		for k, v in pairs( GmodEats.Config.CookPos or {} ) do
			if not GmodEats.Config.CookPos[ k ].name then
				GmodEats.Config.CookPos[ k ].name = "Restaurant"
			end
		end
	else
		GmodEats.Config.CookPos = {} 
	end
	if file.Exists("gmodeats/worker"..game.GetMap()..".txt", "DATA") then
		local filecontent = file.Read("gmodeats/worker"..game.GetMap()..".txt", "DATA")
		GmodEats.Config.WorkerPos =  util.JSONToTable(filecontent)
	else
		GmodEats.Config.WorkerPos = {}
	end
	if file.Exists("gmodeats/client"..game.GetMap()..".txt", "DATA") then 
		local filecontent = file.Read("gmodeats/client"..game.GetMap()..".txt", "DATA")
		GmodEats.Config.ClientPos =  util.JSONToTable(filecontent)
	else
		GmodEats.Config.ClientPos = {}
	end   

end

-- Init the list of ents to spawn
hook.Add("Initialize", "Initialize.UberEat", function()
 
   InitializeTableSavedEnts()
 
end)

-- Init the list of ents to spawn
hook.Add("PlayerSay", "PlayerSay.UberEat", function(ply, text)

	if not table.HasValue(GmodEats.Config.AdminGroups, ply:GetUserGroup() ) then
		return
	end
	
	GmodEats.Config.ResetCmd = GmodEats.Config.ResetCmd or "!reset_gmodeats"
	
	if text == GmodEats.Config.ResetCmd then
	
        if file.Exists("gmodeats/client"..game.GetMap()..".txt", "DATA") then
		
            file.Delete( "gmodeats/client"..game.GetMap()..".txt" )
			
            ply:ChatPrint("[Gmod Eats] All clients have been succesfully removed from the map.")
			       
        end 
		if file.Exists("gmodeats/worker"..game.GetMap()..".txt", "DATA") then
		
            file.Delete( "gmodeats/worker"..game.GetMap()..".txt" )
			
            ply:ChatPrint("[Gmod Eats] All workers have been succesfully removed from the map.")
			       
        end 
		if file.Exists("gmodeats/cook"..game.GetMap()..".txt", "DATA") then
		
            file.Delete( "gmodeats/cook"..game.GetMap()..".txt" )
			
            ply:ChatPrint("[Gmod Eats] All cooks have been succesfully removed from the map.")			
       
        end
		
		InitializeTableSavedEnts()
    end
 
end)

-- spawn ents
hook.Add("InitPostEntity", "InitPostEntity.UberEat", function()
	
	GmodEats.Config.CookPos = GmodEats.Config.CookPos or {}
	GmodEats.Config.WorkerPos = GmodEats.Config.WorkerPos or {}
	GmodEats.Config.ClientPos = GmodEats.Config.ClientPos or {}
    
   
   timer.Simple(1, function()
   
		for k, v in pairs(GmodEats.Config.CookPos) do			
			local ent = ents.Create("uber_eat_npc")
			ent:SetPos( v.pos )
			ent:SetAngles( v.ang )
			-- ent:SetPersistent( true )
			ent.Model =  v.model
			ent:Spawn()
			-- ent:SetMoveType( MOVETYPE_NONE )
			
			GmodEats.Config.CookPos[k].Entity = ent
		end
		
		for k, v in pairs(GmodEats.Config.WorkerPos) do
			local ent = ents.Create("uber_eat_npcworker")
			ent:SetPos( v.pos )
			ent:SetAngles( v.ang )
			-- ent:SetPersistent( true )
			ent.Model =  v.model
			ent:Spawn()
			-- ent:SetMoveType( MOVETYPE_NONE )
		end
	
	end)
	
end)
 
hook.Add("PostCleanupMap", "PostCleanupMap.UberEat", function()
 
	GmodEats.Config.CookPos = GmodEats.Config.CookPos or {}
	GmodEats.Config.WorkerPos = GmodEats.Config.WorkerPos or {}
   
    for k, v in pairs(GmodEats.Config.CookPos) do
        local ent = ents.Create("uber_eat_npc")
        ent:SetPos( v.pos )
        ent:SetAngles( v.ang )
        -- ent:SetPersistent( true )
		ent.Model = v.model
        ent:Spawn()
        -- ent:SetMoveType( MOVETYPE_NONE )
		GmodEats.Config.CookPos[k].Entity = ent
    end
	
	for k, v in pairs(GmodEats.Config.WorkerPos) do
		local ent = ents.Create("uber_eat_npcworker")
		ent:SetPos( v.pos )
		ent:SetAngles( v.ang )
		-- ent:SetPersistent( true )
		ent.Model =  v.model
		ent:Spawn()
		-- ent:SetMoveType( MOVETYPE_NONE )
	end
 
end)


--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
