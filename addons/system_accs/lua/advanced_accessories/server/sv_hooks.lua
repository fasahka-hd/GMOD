--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

--[[ Initialize mysql table ]]
hook.Add("InitPostEntity", "AAS:InitPostEntity", function()
    timer.Simple(5, function()
        AAS.Query(("CREATE TABLE IF NOT EXISTS aas_item (uniqueId INTEGER PRIMARY KEY %s, name VARCHAR(64), description VARCHAR(200), model VARCHAR(200), price INTEGER, pos VARCHAR(200), ang VARCHAR(200), scale VARCHAR(200), job LONGTEXT, category VARCHAR(200), options LONGTEXT)"):format(AAS.Mysql and "AUTO_INCREMENT" or "AUTOINCREMENT"))
        AAS.Query("CREATE TABLE IF NOT EXISTS aas_inventory (steam_id VARCHAR(64), uniqueId INT, price VARCHAR(100))")
        AAS.Query("CREATE TABLE IF NOT EXISTS aas_bodygroups (steam_id VARCHAR(64), model VARCHAR(100), bodygroups_list LONGTEXT, skin VARCHAR(100))")
        AAS.Query("CREATE TABLE IF NOT EXISTS aas_player_saved (steam_id VARCHAR(64), last_model VARCHAR(100), item_saved LONGTEXT)")
        AAS.Query("CREATE TABLE IF NOT EXISTS aas_entity_saved (map VARCHAR(100), entities_table LONGTEXT)")
        AAS.Query("CREATE TABLE IF NOT EXISTS aas_loaded_workshop (workshopId VARCHAR(100), activate VARCHAR(100))")
        AAS.Query("CREATE TABLE IF NOT EXISTS aas_loaded_options (language VARCHAR(100))")
        AAS.Query("CREATE TABLE IF NOT EXISTS aas_offsets (steam_id VARCHAR(64), uniqueId INTEGER, pos VARCHAR(100), ang VARCHAR(100), scale VARCHAR(100))")

        local AASTbl = AAS.FormatTable()
        for k,v in pairs(AASTbl) do
            util.PrecacheModel(v.model)
        end 
        
        if AAS.FastDL then
            local file = file.Find("materials/aas_materials/*", "GAME")
            for k,v in ipairs(file) do
                resource.AddSingleFile("materials/aas_materials/"..v)
            end
            
            resource.AddSingleFile("resource/fonts/Segoe UI.ttf")
            resource.AddSingleFile("resource/fonts/Lato-Black.ttf")
        end
        
        AAS.SaveBasicsItems()
        AAS.ReloadEntity()
        AAS.ChangeLangage()
    end)
end)

--[[ Initialize sql/mysql table and variable on the player ]]
hook.Add("PlayerInitialSpawn", "AAS:PlayerInitialSpawn", function(ply)
    if not IsValid(ply) or not ply:IsPlayer() then return end 
    
    timer.Simple(3, function()
        if not IsValid(ply) or not ply:IsPlayer() then return end 
        if not istable(ply.AASTable) then ply.AASTable = {} end 
        
        local AASInventory = AAS.Query("SELECT * FROM `aas_player_saved` WHERE `steam_id` = '"..ply:SteamID64().."'")
        if #AASInventory == 0 then 
            AAS.Query("INSERT INTO `aas_player_saved` ( steam_id ) VALUES ('"..ply:SteamID64().."')")
        end
        
        AAS.SendItemInformations(ply)
        ply:AASSendInventory()
        ply:AASSendAllAccessory()
        ply:AASReloadModelItem()
        ply:AASSendAllOfsets()
    end)
end)

--[[ Load bodygroup of the player ]]
hook.Add("PlayerSpawn", "AAS:PlayerSpawn", function(ply)
    if not IsValid(ply) or not ply:IsPlayer() then return end 
    
    timer.Simple(3, function()
        if not IsValid(ply) or not ply:IsPlayer() then return end 
        
        ply:AASLoadBodyGroup()
    end)
end)

--[[ Reset player informations ]]
hook.Add("PlayerDisconnected", "AAS:PlayerDisconnected", function(ply)
    if not IsValid(ply) or not ply:IsPlayer() then return end 
    
    ply:AASUnEquipAllAccessory()
    ply:AASSaveModelItem()
    ply.AASAccessories = nil
end)

--[[ Open the sale menu with a key ]]
hook.Add( "PlayerButtonDown", "AAS:PlayerButtonDown", function(ply, button)
    if not IsValid(ply) or not ply:IsPlayer() then return end 

    if button == AAS.ShopKey and AAS.OpenShopWithKey then 
        net.Start("AAS:Main")
            net.WriteUInt(2, 5)
        net.Send(ply)
    elseif button == AAS.BodyGroupKey and AAS.OpenBodyGroupWithKey then
        net.Start("AAS:Main")
            net.WriteUInt(4, 5)
        net.Send(ply)
    elseif button == AAS.ModelChangerKey and AAS.OpenModelChangerWithKey then
        net.Start("AAS:Main")
            net.WriteUInt(5, 5)
        net.Send(ply)
    end
end)

hook.Add("PlayerSay", "AAS:PlayerSay", function( ply, text, team )
    if IsValid(ply) and ply:IsPlayer() then 
        if string.lower( text ) == AAS.AdminCommand then
            if not AAS.AdminRank[ply:GetUserGroup()] then return end 

            net.Start("AAS:Main")
                net.WriteUInt(6, 5)
            net.Send(ply)
            return ""
        elseif string.lower( text ) == AAS.ItemsMenuCommand and AAS.OpenItemMenuCommand then
            net.Start("AAS:Main")
                net.WriteUInt(2, 5)
            net.Send(ply)
            return ""
        end
    end
end)

hook.Add("PostCleanupMap", "AAS:PostCleanupMap", function() 
    AAS.ReloadEntity()
end)

hook.Add("OnEntityCreated", "AAS:OnEntityCreated", function(ent)
    if ent:GetClass() != "aas_bodygroup" and ent:GetClass() != "aas_model" and ent:GetClass() != "aas_npc_shop" then return end

    AAS.Entity = AAS.Entity or {}

    AAS.Entity[#AAS.Entity + 1] = ent
end)

--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
