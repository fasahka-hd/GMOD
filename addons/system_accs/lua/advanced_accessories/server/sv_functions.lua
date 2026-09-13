--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher


-- [[ Mysql database connection system ]] --
local mysqlDB
if AAS.Mysql then
    require("mysqloo")
    if not mysqloo then
        for lol = 1, 50 do
            print("[AAS] Cannot require mysqloo module :\n"..requireError)
        end
        return
    end

    mysqlDB = mysqloo.connect(AAS.MysqlInformations["host"], AAS.MysqlInformations["username"], AAS.MysqlInformations["password"], AAS.MysqlInformations["database"], {["port"] = AAS.MysqlInformations["port"]})
    function mysqlDB:onConnected()
        print("[AAS] Succesfuly connected to the mysql database !")
    end
    
    function mysqlDB:onConnectionFailed(connectionError)
        print("[AAS] Cannot etablish database connection :\n"..connectionError)
    end
    mysqlDB:connect()
end

--[[ SQL Query function ]] --
function AAS.Query(query)
    --print("AAS.Query Start: ", query)

    if not isstring(query) then return end

    local result = {}
    if AAS.Mysql then
        query = mysqlDB:query(query)
        query:start()
        query:wait()

        local err = query:error()
        if not err then 
            print("AAS.Query Finish")
            return query:getData()
        end
        if err == "" then        
            return query:getData()
        else
            return {false, err}
        end
    else
        result = sql.Query(query)
    end
    return (result or {})
end

-- [[ Escape the string ]] --
function AAS.Escape(str)
    return AAS.Mysql and ("'%s'"):format(mysqlDB:escape(tostring(str))) or SQLStr(str)    
end

--[[ Convert a string to a vector or an angle ]]
local function toVectorOrAngle(toConvert, typeToSet)
    if not isstring(toConvert) or (typeToSet != Vector and typeToSet != Angle) then return end

    local convertArgs = string.Explode(" ", toConvert)
    local x, y, z = (tonumber(convertArgs[1]) or 0), (tonumber(convertArgs[2]) or 0), (tonumber(convertArgs[3]) or 0)
    
    return typeToSet == Vector and Vector(x, y, z) or Angle(x, y, z)
end

--[[ Make sure that all information are correct ]]
function AAS.FormatItemTable(informations, save, edit)
    informations = informations or {}

    informations["name"] = isstring(informations["name"]) and informations["name"] or (edit and nil or "Name")
    informations["description"] = isstring(informations["description"]) and informations["description"] or (edit and nil or "Description")
    informations["model"] = isstring(informations["model"]) and informations["model"] or "models/props_junk/TrafficCone001a.mdl"

    informations["category"] = (isstring(informations["category"]) and AAS.CheckCategory(informations["category"])) and informations["category"] or (edit and nil or "AllItems") 
    informations["price"] = isnumber(tonumber(informations["price"])) and tonumber(informations["price"]) or (edit and nil or 0)
    informations["uniqueId"] = isnumber(tonumber(informations["uniqueId"])) and tonumber(informations["uniqueId"]) or (edit and nil or 0)

    informations["pos"] = (isvector(informations["pos"]) and save and tostring(informations["pos"])) or (edit and nil or (save and "0, 0, 0" or toVectorOrAngle(informations["pos"], Vector)))
    informations["scale"] = (isvector(informations["scale"]) and save and tostring(informations["scale"])) or (edit and nil or (save and "0, 0, 0" or toVectorOrAngle(informations["scale"], Vector)))
    informations["ang"] = (isangle(informations["ang"]) and save and tostring(informations["ang"])) or (edit and nil or (save and "0, 0, 0" or toVectorOrAngle(informations["ang"], Angle)))

    informations["job"] = istable(informations["job"]) and (save and util.TableToJSON(informations["job"])) or (not save and isstring(informations["job"]) and util.JSONToTable(informations["job"])) or (edit and nil or (save and "{}" or {}))
    informations["options"] = istable(informations["options"]) and (informations["options"]) or {}

    return informations
end

--[[ Check if the workshop is already loaded ]]
function AAS.WorkshopIsLoaded(workshopId)
    local AASTbl = AAS.Query("SELECT * FROM `aas_loaded_workshop` WHERE `workshopId` = '"..workshopId.."'")
    local result = istable(AASTbl[1]) and tobool(AASTbl[1]["activate"]) or false

    return result
end

--[[ Add workshop into the sql database ]]
function AAS.AddWorkshopId(workshopId, activate)
    local AASTbl = AAS.Query("SELECT * FROM `aas_loaded_workshop` WHERE `workshopId` = '"..workshopId.."'")

    if not istable(AASTbl) or #AASTbl == 0 then
        AAS.Query(("INSERT INTO `aas_loaded_workshop` (`workshopId`, `activate`) VALUES(%s, %s)"):format(AAS.Escape(workshopId), AAS.Escape(activate)))
    else 
        AAS.Query("UPDATE `aas_loaded_workshop` SET `activate` = "..AAS.Escape(activate).." WHERE `workshopId` = '"..workshopId.."'")
    end

    return result
end
-- local testmod = 'models/sal/gingerbread.mdl'
-- local AASTbl = AAS.Query("SELECT * FROM `aas_item` WHERE `model` = '"..testmod.."'") or {}
-- --printTable(AASTbl)

--[[ Check if the item exist into the database ]]
function AAS.ItemExist(model, skin)
    local result, id = false, nil
    for k,v in pairs(AAS.BaseItems['3236957794'])do
        if(v.model == model && (v.options && v.options.skin == skin || true)) then
            result, id = true, v.uniqueId
        end
    end
    return result, id
end

--[[ Save basics items saved into the sh_advanced_config.lua ]]
function AAS.SaveBasicsItems(checkWorkshop)
    for workshopId, bool in pairs(AAS.LoadWorkshop) do
        if not istable(AAS.BaseItems[workshopId]) then continue end
        if not bool then continue end
        if not checkWorkshop and AAS.WorkshopIsLoaded(workshopId) then continue end

        for k,v in pairs(AAS.BaseItems[workshopId]) do
            if AAS.ItemExist(v.model, v.options.skin) then continue end
            local tbl = table.Copy(v)
            
            AAS.AddItem(tbl, nil, true, true, true)
        end

        AAS.AddWorkshopId(workshopId, true)
    end

    AAS.SendItemInformations()
end

--[[ Format all information in the item table ]]
function AAS.FormatTable(uniqueId)
    local uniqueId = tonumber(uniqueId)
    local AASTbl = AAS.GetTableById(uniqueId)
    
    local returnTable = {}
    if isnumber(uniqueId) then
        returnTable = AAS.FormatItemTable(AASTbl)
    else
        for k,v in ipairs(AASTbl) do
            returnTable[#returnTable + 1] = AAS.FormatItemTable(v)
        end
    end

    return returnTable 
end

--[[ Add an item and broadcast or send information to the player ]]
function AAS.AddItem(informations, ply, noSendItem, checkIfExist, baseItem)
    local AASTbl = AAS.FormatItemTable(informations, true)
    
    local options = util.JSONToTable((AASTbl["options"] or "")) or {}

    if checkIfExist then 
        if AAS.ItemExist(AASTbl["model"], options["skin"]) then return end 
    end

    if baseItem then
        options.baseItem = true 
    end

    options.date = os.time()

    options = util.TableToJSON(options)

    AAS.Query(("INSERT INTO `aas_item` (`name`, `description`, `model`, `price`, `pos`, `ang`, `scale`, `job`, `category`, `options`) VALUES(%s, %s, %s, %s, %s, %s, %s, %s, %s, %s)"):format(AAS.Escape(AASTbl["name"]), AAS.Escape(AASTbl["description"]), AAS.Escape(AASTbl["model"]), AAS.Escape(AASTbl["price"]), AAS.Escape(AASTbl["pos"]), AAS.Escape(AASTbl["ang"]), AAS.Escape(AASTbl["scale"]), AAS.Escape(AASTbl["job"]), AAS.Escape(AASTbl["category"]), AAS.Escape(options)))

    if IsValid(ply) then
        rp.Notify(ply, 5, AAS.GetSentence("addItem").." "..AASTbl["name"])
    end

    util.PrecacheModel(AASTbl["model"])

    timer.Simple(0, function()
        if noSendItem then return end

        AAS.SendItemInformations()
    end)

    hook.Run("AAS:OnItemAdded", AASTbl)
end

--[[ Edit an item and broadcast or send information to the player ]]
function AAS.UpdateItem(informations, ply)
    local AASTbl = AAS.FormatItemTable(informations, true, true)
    if not isnumber(AASTbl["uniqueId"]) or AASTbl["uniqueId"] == nil then return end 

    local firstQuery = true
    local query = "UPDATE aas_item SET "

    for k,v in pairs(AASTbl) do 
        query = query..(firstQuery and "" or ", ")..k.." = "..AAS.Escape(v) 
        firstQuery = false 
    end 

    query = query.." WHERE uniqueId = "..AASTbl["uniqueId"]

    AAS.Query(query)
    util.PrecacheModel(AASTbl["model"])

    timer.Simple(0, function()
        AAS.SendItemInformations()
    end)

    if IsValid(ply) then
        rp.Notify(ply, 5, AAS.GetSentence("updateItem").." "..AASTbl["name"])
    end

    hook.Run("AAS:OnItemModified", AASTbl)
end

--[[ Delete an item and brodcast or send information to the player ]]
function AAS.DeleteItem(uniqueId, ply)
    local AASTbl = AAS.Query("SELECT * FROM `aas_item` WHERE `uniqueId` = '"..uniqueId.."'")
    if not istable(AASTbl) or #AASTbl == 0 then return end 

    AAS.Query(("DELETE FROM `aas_item` WHERE `uniqueId` = %s"):format(AAS.Escape(uniqueId)))

    timer.Simple(0, function()
        AAS.SendItemInformations()
    end)

    if IsValid(ply) then
        rp.Notify(ply, 5, AAS.GetSentence("deleteItem").." "..AASTbl[1]["name"])
    end
    
    hook.Run("AAS:OnItemDeleted", AASTbl[1])
end

--[[ Send informaton about the item ]]
function AAS.SendItemInformations(ply)
    local AASTbl = AAS.FormatTable()
    local CompressTbl = AAS.CompressTable(AASTbl)

    net.Start("AAS:Main")
        net.WriteUInt(1, 5)
        net.WriteUInt(#CompressTbl, 32)
        net.WriteData(CompressTbl, #CompressTbl)
        net.WriteBool(false)
    if IsValid(ply) then net.Send(ply) else net.Broadcast() end 

    hook.Run("AAS:InformationSended", AASTbl)
end

local PLAYER = FindMetaTable("Player")

--[[ Send to the player his inventory ]]
function PLAYER:AASSendInventory()
    local inventoryTable = AAS.Query("SELECT * FROM `aas_inventory` WHERE `steam_id` = '"..self:SteamID64().."'")

    local CompressTbl = AAS.CompressTable(inventoryTable)
    net.Start("AAS:Inventory")
        net.WriteUInt(1, 5)
        net.WriteUInt(#CompressTbl, 32)
        net.WriteData(CompressTbl, #CompressTbl)
    net.Send(self)
end

--[[ Load selected bodygroup linked to the model of the player ]]
function PLAYER:AASLoadBodyGroup()
    if AAS.BlackListBodyGroup[team.GetName(self:Team())] then rp.Notify(self, 5, AAS.GetSentence("jobProblem")) return end

    local AASTbl = AAS.Query("SELECT * FROM `aas_bodygroups` WHERE `steam_id` = '"..self:SteamID64().."'".." AND `model` = '"..self:GetModel().."'")
    
    if not istable(AASTbl[1]) then return end
    local bodyGroups = util.JSONToTable(AASTbl[1]["bodygroups_list"]) or {}

    for k,v in ipairs(bodyGroups) do
        self:SetBodygroup(k, 0)
        self:SetBodygroup((k or 0), (v or 0))
    end

    local skin = AASTbl[1]["skin"] or 0

    self:SetSkin(0)
    self:SetSkin(skin)

    hook.Run("AAS:BodyGroupLoaded", self, bodyGroups)
end

--[[ Save selected bodygroup linked to the model of the player ]]
function PLAYER:AASSaveBodygroups(bodyGroupTable)
    local AASTbl = AAS.Query("SELECT * FROM `aas_bodygroups` WHERE `steam_id` = '"..self:SteamID64().."'".." AND `model` = '"..self:GetModel().."'")
 
    local bodyGroups = util.TableToJSON((bodyGroupTable or {}))
    local skin = self:GetSkin()
    
    if istable(AASTbl) and #AASTbl != 0 then
        AAS.Query("UPDATE `aas_bodygroups` SET `bodygroups_list` = "..AAS.Escape(bodyGroups)..", `skin` = "..AAS.Escape(skin).." WHERE `steam_id` = '"..self:SteamID64().."'".." AND `model` = '"..self:GetModel().."'")
    else 
        AAS.Query(("INSERT INTO `aas_bodygroups` (`steam_id`, `model`, `bodygroups_list`, `skin`) VALUES(%s, %s, %s, %s)"):format(AAS.Escape(self:SteamID64()), AAS.Escape(self:GetModel()), AAS.Escape(bodyGroups), AAS.Escape(skin)))
    end

    hook.Run("AAS:BodyGroupSaved", self, bodyGroups)
end

--[[ Save last model and all item equiped by the player ]]
function PLAYER:AASSaveModelItem()
    local model = self:GetModel()
    local items = self.AASAccessories or {}
    local tableToSave = util.TableToJSON(items)

    AAS.Query("UPDATE `aas_player_saved` SET `last_model` = "..AAS.Escape(model)..", `item_saved` = "..AAS.Escape(tableToSave).." WHERE `steam_id` = '"..self:SteamID64().."'")
end

--[[ Reload last model and all item equiped by the player ]]
function PLAYER:AASReloadModelItem()
    local AASTbl = AAS.Query("SELECT * FROM `aas_player_saved` WHERE `steam_id` = '"..self:SteamID64().."'")
    if not istable(AASTbl[1]) then return end

    local itemJson = AASTbl[1]["item_saved"] or ""
    local itemTable = util.JSONToTable(itemJson) or {}

    if AAS.LoadItemsSaved then
        for k,v in pairs(itemTable) do
            self:AASEquipAccessory(v)
        end
    end
    
    local model = AASTbl[1]["last_model"]
    if AAS.LoadModelSaved and isstring(model) then
        self:SetModel(model)
        self:AASLoadBodyGroup()
    end

    hook.Run("AAS:ItemModelReloaded", self, itemTable, model)
end

--[[ Check if a certain entity class is near the player ]]
function PLAYER:AASCheckDistEnt(class, radius)
    local result = false
    for k,v in ipairs(ents.FindByClass(class)) do
        if not IsValid(v) then continue end

        if v:GetPos():DistToSqr(self:GetPos()) < radius^2 then 
            result = true
            break
        end 
    end 
    return result
end

--[[ Buy the item and store it into the inventory of the player ]]
function PLAYER:AASBuyItem(uniqueId)
    local AASTbl = AAS.FormatTable(uniqueId)
    if not istable(AASTbl) or table.Count(AASTbl) == 0 then return end
    local itemTable = AASTbl
    local price = (itemTable["price"] or 0)
    if self:AASIsBought(uniqueId) then self:Notify(1, AAS.GetSentence("ownedItem")) return end
    if self:AASGetMoney() < price then self:Notify(1, AAS.GetSentence("notEnoughtMoney")) return end
    
    if itemTable["options"]["usergroups"] and (itemTable["options"]["usergroups"][self:GetUserGroup()] or false) then rp.Notify(self, 5, AAS.GetSentence("notRank")) return end
    
    if not itemTable["options"]["activate"] then rp.Notify(self, 5, AAS.GetSentence("itemDesactivate")) return end
    
    local str = string.format('%s добавлен в ваш инвентарь', itemTable.name or 'Cannot Find Item Name')
    self:Notify(0, str)
    self:AddItem("_acc_"..uniqueId)
    AAS.GiveItem(self:SteamID64(), uniqueId, price)

    self:AASAddMoney(-price, 'Покупка аксессуара: ' .. itemTable.name .. ' код _acc_' .. uniqueId)
    eui.battlepass.AddProgress(self, 20)
    rp.Notify(self, 5, AAS.GetSentence("buyItem").." "..itemTable["name"].." "..AAS.GetSentence("for").." "..AAS.formatMoney(price))

    hook.Run("AAS:BoughtItem", self, AASTbl)
end

--[[ Check if the item is bought by the player ]]
function PLAYER:AASIsBought(uniqueId)
    local inventoryQuery = AAS.Query("SELECT * FROM `aas_inventory` WHERE `steam_id` = '"..self:SteamID64().."' AND `uniqueId` = '"..uniqueId.."'")

    local result = (istable(inventoryQuery) and #inventoryQuery != 0)

    return result
end

--[[ Give an item with the steamId64 ]]
function AAS.GiveItem(steamId64, uniqueId, price)
    --print("AAS.GiveItem Start")
    local uniqueId = tonumber(uniqueId)

    if not isnumber(uniqueId) then return end
    if not isnumber(price) then price = 0 end

    AAS.Query(("INSERT INTO `aas_inventory` (`steam_id`, `uniqueId`, `price`) VALUES(%s, %s, %s)"):format(AAS.Escape(steamId64), AAS.Escape(uniqueId), AAS.Escape(price)))
    local player = player.GetBySteamID64(steamId64)

    if IsValid(player) then
        player:AASSendInventory()
    end
    --print("AAS.GiveItem Finish")
end

--[[ This function permite to add compatibility with other gamemode ]]
function PLAYER:AASAddMoney(price)
    self:AddMoney(price, 'AAS')
end

--[[ Sell the item and remove it into the inventory of the player ]]
function PLAYER:AASSellItem(uniqueId)
    local inventoryQuery = AAS.Query("SELECT * FROM `aas_inventory` WHERE `steam_id` = '"..self:SteamID64().."' AND `uniqueId` = '"..uniqueId.."'")
    if not self:AASIsBought(uniqueId) then return end
    
    local price = (inventoryQuery[1]["price"]*AAS.SellValue/100 or 0)
    self:AASAddMoney(price, 'Продажа аксессуара: ' .. '_acc_' .. uniqueId )
    rp.Notify(self, 5, AAS.GetSentence("sellItem").." "..AAS.formatMoney(price))

    hook.Run("AAS:SoldItem", self, inventoryQuery[1])

    AAS.Query(("DELETE FROM `aas_inventory` WHERE `uniqueId` = %s AND `steam_id` = %s"):format(AAS.Escape(uniqueId), AAS.Escape(self:SteamID64())))

    self:AASSendInventory()
    self:AASUnEquipAccessoryById(uniqueId)
end

--[[ Equip an accessory with his uniqueId ]]
function PLAYER:AASEquipAccessory(uniqueId, noNotify)
    if not istable(self.AASAccessories) then self.AASAccessories = {} end
    local ItemsEquiped = AAS.FormatTable(uniqueId)
    if not istable(ItemsEquiped) then return end
    local uniqueId = ItemsEquiped.uniqueId
    local category = ItemsEquiped.category
    if not isnumber(uniqueId) or not isstring(category) then return end
    print(uniqueId, self:AASIsBought(uniqueId))
    if not self:AASIsBought(uniqueId) then rp.Notify(self, 5, AAS.GetSentence("cantEquip")) return end
    
    if ItemsEquiped.options["usergroups"] and (ItemsEquiped.options["usergroups"][self:GetUserGroup()] or false) then rp.Notify(self, 5, AAS.GetSentence("itemVip")) return end
    
    self.AASAccessories[category] = uniqueId

    if not noNotify then
        rp.Notify(self, 5, AAS.GetSentence("equipItem"))
    end

    local offsetTable = self:AASGetOffsets(uniqueId)
    if not istable(offsetTable) then offsetTable = {} end
    
    net.Start("AAS:Inventory")
        net.WriteUInt(2, 5)
        net.WriteUInt(uniqueId, 32)
        net.WriteString(self:SteamID64())
        net.WriteTable(offsetTable)
        net.WriteString(category)
    net.Broadcast()

    hook.Run("AAS:AccessoryEquiped", self, ItemsEquiped)
end

--[[ UnEquip an accessory with his uniqueId ]]
function PLAYER:AASUnEquipAccessoryById(uniqueId)
    if not istable(self.AASAccessories) then self.AASAccessories = {} end
    
    for k,v in pairs(self.AASAccessories) do
        if v != uniqueId then continue end

        self:AASUnEquipAccessory(k)

        hook.Run("AAS:AccessoryUnEquiped", self)
        break
    end
end

--[[ UnEquip an accessory with his category ]]
function PLAYER:AASUnEquipAccessory(category)
    if not istable(self.AASAccessories) then self.AASAccessories = {} end
    if not isnumber(self.AASAccessories[category]) then return end

    self.AASAccessories[category] = nil

    net.Start("AAS:Inventory")
        net.WriteUInt(3, 5)
        net.WriteString(category)
        net.WriteString(self:SteamID64())
    net.Broadcast()

    rp.Notify(self, 5, AAS.GetSentence("deequipedItem"))

    hook.Run("AAS:AccessoryUnEquiped", self)
end

--[[ Reset all accessory of the player and broadcast information ]]
function PLAYER:AASUnEquipAllAccessory()
    net.Start("AAS:Inventory")
        net.WriteUInt(4, 5)
        net.WriteString(self:SteamID64())
    net.Broadcast()

    hook.Run("AAS:RemoveAllAccessory", self)
end

--[[ Send all accessory of all player ]]
function PLAYER:AASSendAllAccessory()
    local tableToSend = {}
    for k,v in ipairs(player.GetAll()) do
        if not istable(v.AASAccessories) then v.AASAccessories = {} end
        
        tableToSend[v:SteamID()] = v.AASAccessories
        
        if not istable(tableToSend[v:SteamID()]["offsets"]) then tableToSend[v:SteamID()]["offsets"] = {} end

        for cat, uniqueId in pairs(v.AASAccessories) do
            if not isnumber(uniqueId) then continue end
            
            local offsetTable = v:AASGetOffsets(uniqueId)
            if istable(offsetTable) then
                tableToSend[v:SteamID()]["offsets"][uniqueId] = offsetTable
            end
        end
    end    
    
    local CompressTbl = AAS.CompressTable(tableToSend)
    net.Start("AAS:Inventory")
        net.WriteUInt(5, 5)
        net.WriteUInt(#CompressTbl, 32)
        net.WriteData(CompressTbl, #CompressTbl)
    net.Send(self)
end

--[[ Make sure that the offset is not upper than the max ]]
local function checkOffsetsNumber(toCheck, typeArg)
    if not isvector(toCheck) and not isangle(toCheck) then return end

    local max = (typeArg == Vector) and AAS.MaxVectorOffset or AAS.MaxAngleOffset

    for i=1, 3 do
        if toCheck[i] > max then
            toCheck[i] = max
        elseif toCheck[i] < -max then
            toCheck[i] = -max
        end
    end

    return toCheck
end

--[[ Save offset on a specific uniqueId ]]
function PLAYER:AASSaveOffsets(uniqueId, pos, ang, scale)
    local AASTbl = AAS.Query("SELECT * FROM `aas_offsets` WHERE `steam_id` = '"..self:SteamID64().."' AND `uniqueId` = '"..uniqueId.."'")

    if not isvector(pos) then pos = Vector(0,0,0) end
    if not isangle(ang) then ang = Angle(0,0,0) end
    if not isvector(scale) then scale = Vector(0,0,0) end

    pos = checkOffsetsNumber(pos, Vector)
    ang = checkOffsetsNumber(ang, Angle)
    scale = checkOffsetsNumber(scale, Vector)

    if istable(AASTbl) and #AASTbl != 0 then
        AAS.Query("UPDATE `aas_offsets` SET `pos` = "..AAS.Escape(pos)..", `ang` = "..AAS.Escape(ang)..", `scale` = "..AAS.Escape(scale).." WHERE `uniqueId` = '"..uniqueId.."'".." AND `steam_id` = '"..self:SteamID64().."'")
    else 
        AAS.Query(("INSERT INTO `aas_offsets` (`steam_id`, `uniqueId`, `pos`, `ang`, `scale`) VALUES(%s, %s, %s, %s, %s)"):format(AAS.Escape(self:SteamID64()), AAS.Escape(uniqueId), AAS.Escape(pos), AAS.Escape(ang), AAS.Escape(scale)))
    end

    self:AASEquipAccessory(uniqueId, true)
    self:AASSendAllOfsets()
end

--[[ Get offset on a specific uniqueId ]]
function PLAYER:AASGetOffsets(uniqueId)
    --local offsetTable = AASTbl[1] or {}

    local tblToSend
    --if istable(AASTbl) and #AASTbl != 0 then
    --    pos = toVectorOrAngle(offsetTable["pos"], Vector)
    --    ang = toVectorOrAngle(offsetTable["ang"], Angle)
    --    scale = toVectorOrAngle(offsetTable["scale"], Vector)
    --
    --    tblToSend = {
    --        ["pos"] = pos, 
    --        ["ang"] = ang, 
    --        ["scale"] = scale,
    --    }
    --end

    return tblToSend
end

--[[ Send all ofsets configuration ]]
function PLAYER:AASSendAllOfsets()
    local AASTbl = AAS.Query("SELECT * FROM `aas_offsets` WHERE `steam_id` = '"..self:SteamID64().."'")

    local returnTable = {}
    for k,v in ipairs(AASTbl) do
        returnTable[v.uniqueId] = {
            ["pos"] = toVectorOrAngle(v.pos, Vector),
            ["ang"] = toVectorOrAngle(v.ang, Angle),
            ["scale"] = toVectorOrAngle(v.scale, Vector),
        }
    end

    net.Start("AAS:Inventory")
        net.WriteUInt(6, 5)
        net.WriteTable(returnTable)
    net.Send(self)
end

--[[ Check if the player is on the correct job for equip/buyitem/sellitem ]]
function PLAYER:AASCheckJob(uniqueId)
    local AASTbl = AAS.FormatTable(uniqueId)
    if not istable(AASTbl) or table.Count(AASTbl) == 0 then return false end
    
    if not istable(AASTbl[1]) or not istable(AASTbl[1]["job"]) or #AASTbl[1]["job"] == 0 then return true end
    if not AASTbl[1]["job"][team.GetName(self:Team())] then return false end

    return true
end

function AAS.SHInventoryToAAS()
    SH_ACC:Query("SELECT * FROM :db", {}, function(result)
        for i=1, #result do
            local explodeTable = string.Explode("|", result[i].inventory)
            local steamId64 = util.SteamIDTo64("STEAM_"..(result[i].id):Replace("_", ":"))

            local AASInventory = AAS.Query("SELECT * FROM `aas_player_saved` WHERE `steam_id` = '"..steamId64.."'")
            if #AASInventory == 0 then 
                AAS.Query("INSERT INTO `aas_player_saved` ( `steam_id` ) VALUES ('"..steamId64.."')")
            end

            for i=1, #explodeTable do
                local itemTable = SH_ACC.List[explodeTable[i]]

                if not istable(itemTable) then continue end
                local exist, uniqueId = AAS.ItemExist(itemTable.mdl, itemTable.skin)

                AAS.GiveItem(steamId64, uniqueId, 0)
            end
        end
    end)
end

--[[ Check if the unique Id Exist ]]
function AAS.GetTableById(uniqueId)
    uniqueId = tonumber(uniqueId)

    local tbl = {}
    for k,v in pairs(AAS.BaseItems['3236957794']) do
        if tonumber(v.uniqueId) == uniqueId then
            tbl = v
            break
        end
    end
    return tbl
end

--[[ Save all entity on the server ]]
local AASMap = string.lower(game.GetMap())
function AAS.SaveEntity()
    AAS.Entity = AAS.Entity or {}

    local EntityTable = {}

    for k,v in ipairs(AAS.Entity) do
        if not IsValid(v) then continue end

        EntityTable[#EntityTable + 1] = {
            ["class"] = v:GetClass(),
            ["pos"] = tostring(v:GetPos()),
            ["ang"] = tostring(v:GetAngles()),
            ["model"] = v:GetModel(),
        }
    end

    local tableToSave = util.TableToJSON(EntityTable)
    local AASTbl = AAS.Query("SELECT * FROM `aas_entity_saved` WHERE `map` = '"..AASMap.."'")
    
    if istable(AASTbl) and #AASTbl != 0 then
        AAS.Query("UPDATE `aas_entity_saved` SET `entities_table` = "..AAS.Escape(tableToSave).." WHERE `map` = '"..AASMap.."'")
    else 
        AAS.Query(("INSERT INTO `aas_entity_saved` (`map`, `entities_table`) VALUES(%s, %s)"):format(AAS.Escape(AASMap), AAS.Escape(tableToSave)))
    end
end

--[[ Reload all entity on the server ]]
function AAS.ReloadEntity()
    AAS.RemoveEntity()

    local jsonTable = AAS.Query("SELECT * FROM `aas_entity_saved` WHERE `map` = '"..AASMap.."'") or ""
    if not istable(jsonTable) or not istable(jsonTable[1]) then return end
    
    local AASTable = util.JSONToTable(jsonTable[1].entities_table) or {}

    for k,v in ipairs(AASTable) do
        local AASEnt = ents.Create(v.class)
        if not IsValid(AASEnt) then return end
        AASEnt:SetModel(v.model)
        AASEnt:SetPos(toVectorOrAngle(v.pos, Vector))
        AASEnt:SetAngles(toVectorOrAngle(v.ang, Angle))
        AASEnt:Spawn()
        AASEnt:Activate()
    end
end

--[[ Remove all entity on the server ]]
function AAS.RemoveEntity()
    AAS.Entity = AAS.Entity or {}

    for k,v in ipairs(AAS.Entity) do
        if not IsValid(v) then continue end

        v:Remove()
    end
end
 
--[[ Get into the base items table the description and the name translated ]]
local function getDescNameItem(model, skin)
    for workshopId, bool in pairs(AAS.LoadWorkshop) do
        if not istable(AAS.BaseItems[workshopId]) then continue end

        for k,v in pairs(AAS.BaseItems[workshopId]) do
            if v.model != model or v.options.skin != skin then continue end

            return v.name, v.description
        end
    end
end

--[[ Change item description / name when the langage change ]]
function AAS.ChangeLangage()
    local AASTbl = AAS.Query("SELECT * FROM `aas_loaded_options`")
    local lang = istable(AASTbl[1]) and AASTbl[1]["language"] or ""

    if lang != AAS.Lang then

        if istable(AASTbl) and #AASTbl != 0 then
            AAS.Query("UPDATE `aas_loaded_options` SET `language` = "..AAS.Escape(AAS.Lang))
        else 
            AAS.Query(("INSERT INTO `aas_loaded_options` (`language`) VALUES(%s)"):format(AAS.Escape(AAS.Lang)))
        end

        local itemsTable = AAS.Query("SELECT * FROM `aas_item`")

        for k,v in pairs(itemsTable) do
            local options = util.JSONToTable(v.options)

            if tobool(options.baseItem) then
                local name, description = getDescNameItem(v.model, options.skin)
                if not isstring(name) then name = v.name end
                if not isstring(description) then description = v.description end

                AAS.Query("UPDATE `aas_item` SET `name` = "..AAS.Escape(name)..", `description` = "..AAS.Escape(description).." WHERE `uniqueId` = '"..v.uniqueId.."'")
            end
        end
        
        AAS.SendItemInformations()

        --[[ Resize fonts when language change ]]
        net.Start("AAS:Main")
            net.WriteUInt(7, 5)
        net.Broadcast()
    end
end

--[[ Remove all entity saved ]]
function AAS.RemoveEntitySql()
    AAS.Query(("DELETE FROM `aas_entity_saved` WHERE `map` = %s"):format(AAS.Escape(AASMap)))

    AAS.RemoveEntity()
end

--[[ Convert your Sql to a Table ]]
/*  user_id sha256 p7t1788oo56ago4r3k1j61v5vz5iqotdddyhn932 */
function AAS.ConvertSqlToDataTable()
    local spaceSize = "    "
    local currentTab = ""

    local function tableToString(tbl)
        if not istable(tbl) then return "{}" end

        currentTab = currentTab..spaceSize
        local content = "{"
        for k,v in pairs(tbl) do
            local value

            if isvector(v) then
                
                value = ("Vector(%s, %s, %s)"):format(v.x, v.y, v.z)
                
            elseif isangle(v) then

                value = ("Angle(%s, %s, %s)"):format(v.p, v.y, v.r)
            
            elseif isstring(v) then

                value = ("\"%s\""):format(v)

            elseif istable(v) then
                if isnumber(v.r) and isnumber(v.g) and isnumber(v.b) and isnumber(v.a) then

                    value = ("Color(%s, %s, %s, %s)"):format(v.r, v.g, v.b, v.a)
                else
                    
                    value = tableToString(v)
                end
            
            else
                value = v
            end

            content = content.."\n"..currentTab..("[\"%s\"] = %s,"):format(k, value)
        end

        currentTab = table.concat(string.Explode("", currentTab), "", 1, #currentTab - #spaceSize)
        return content ~= "{" and content.."\n"..currentTab.."}" or "{}"
    end

    local function generateConfigFile()
        local content = "return {"

        local items = AAS.FormatTable()
        currentTab = spaceSize
        for k,v in ipairs(items) do

            content = content.."\n"..currentTab..tableToString(v)..","
        end
        
        return content.."\n}"
    end

    --print("[AAS] Data Saved")

    file.Write("aas_item_table.txt", generateConfigFile())
end

local function CheckConsole(ply)
    local canAccess = false

    if ply == NULL then 
        canAccess = true
    elseif IsValid(ply) then
        if AAS.AdminRank[ply:GetUserGroup()] then
            canAccess = true
        end
    end

    return canAccess
end

concommand.Add("aas_save_entity", function(ply, cmd, args)
    if not CheckConsole(ply) then return end
    AAS.SaveEntity()
end)

concommand.Add("aas_reload_entity", function(ply, cmd, args)
    if not CheckConsole(ply) then return end
    AAS.ReloadEntity()
end)

concommand.Add("aas_remove_entity", function(ply, cmd, args)
    if not CheckConsole(ply) then return end
    AAS.RemoveEntity()
end)

concommand.Add("aas_remove_entitysql", function(ply, cmd, args)
    if ply != NULL && not AAS.AdminRank[ply:GetUserGroup()] then return end
    AAS.RemoveEntitySql()
end)

concommand.Add("aas_reload_basicitem", function(ply, cmd, args)
    if not CheckConsole(ply) then return end
    AAS.SaveBasicsItems(true)
end)

concommand.Add("aas_give_items_steamid64", function(ply, cmd, args)
    if not CheckConsole(ply) then return end
    AAS.GiveItem(args[1], tonumber(args[2]), 0)
end)

concommand.Add("aas_save_item_data", function(ply, cmd, args)
    if not CheckConsole(ply) then return end
    AAS.ConvertSqlToDataTable()
end)

concommand.Add("aas_sh_inventory_to_aas", function(ply, cmd, args)
    if not CheckConsole(ply) then return end
    AAS.SHInventoryToAAS()
end)


--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
