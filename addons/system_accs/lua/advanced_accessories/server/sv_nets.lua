--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher


util.AddNetworkString("AAS:Main")
util.AddNetworkString("AAS:BodyGroups")
util.AddNetworkString("AAS:Inventory")
util.AddNetworkString("AAS:Models")
util.AddNetworkString("Kasanov_Menu")

net.Receive("AAS:Main", function(len, ply)
    if not IsValid(ply) or not ply:IsPlayer() then return end 
    if not AAS.AdminRank[ply:GetUserGroup()] then return end 
    
    ply.AASSpam = ply.AASSpam or 0
    if ply.AASSpam > CurTime() then return end 
    ply.AASSpam = CurTime() + 1

    local UInt = net.ReadUInt(5)

    if UInt == 1 then 
        local tableToSave = net.ReadTable()
        AAS.AddItem(tableToSave, ply)

    elseif UInt == 2 then 
        local uniqueId = net.ReadUInt(32)
        AAS.DeleteItem(uniqueId, ply)
    
    elseif UInt == 3 then 
        local tableToUpdate = net.ReadTable()
        AAS.UpdateItem(tableToUpdate, ply)

    elseif UInt == 4 then
        local length = net.ReadUInt(32)
        local data = net.ReadData(length)
        
        local tbl = AAS.UnCompressTable(data) or {}

        for k,v in pairs(tbl) do
            AAS.AddItem(v, nil, true)
        end

        AAS.SendItemInformations()
    end
end)

net.Receive("AAS:BodyGroups", function(len, ply)
    if not IsValid(ply) or not ply:IsPlayer() then return end

    ply.AASSpam = ply.AASSpam or 0
    if ply.AASSpam > CurTime() then return end 
    ply.AASSpam = CurTime() + 1
    
    if AAS.BlackListBodyGroup[team.GetName(ply:Team())] then rp.Notify(ply, 5, AAS.GetSentence("jobProblem")) return end
    if not AAS.OpenBodyGroupWithKey then
        if not ply:AASCheckDistEnt("aas_bodygroup", 150) then rp.Notify(ply, 5, AAS.GetSentence("exploitArmory")) return end
    end

    local bodyGroupString = net.ReadString()
    local bodyGroupTable = string.Explode(";", bodyGroupString) or {}
    local skinString = net.ReadString()

    local tableToSave = {}
    for k,v in ipairs(bodyGroupTable) do 
        local bodyGroupSet = string.Explode(":", v) or {}

        local bodygroup, value = (bodyGroupSet[1] or 0), (bodyGroupSet[2] or 0)
        tableToSave[bodygroup] = value

        ply:SetBodygroup(bodygroup, value)
    end

    ply:SetSkin((skinString or 0))

    rp.Notify(ply, 5, AAS.GetSentence("saveBodygroup"))
    ply:AASSaveBodygroups(tableToSave)
end)

net.Receive("AAS:Inventory", function(len, ply)
    if not IsValid(ply) or not ply:IsPlayer() then return end

    ply.AASSpam = ply.AASSpam or 0
    if ply.AASSpam > CurTime() then return end 
    ply.AASSpam = CurTime() + 1
    
    local UInt = net.ReadUInt(5)
    local checkNpc = ply:AASCheckDistEnt("npc_rp_accs", 150) 

    if AAS.BlackListItemsMenu[team.GetName(ply:Team())] then ply:Notify(1, AAS.GetSentence("jobProblem")) return end
    if not checkNpc then ply:Notify(1, AAS.GetSentence("exploitNpc")) return end

    if UInt == 4 then
        local category = net.ReadString()
        ply:AASUnEquipAccessory(category)
    else
        local uniqueId = net.ReadUInt(32)
        if not ply:AASCheckJob(uniqueId) then ply:Notify(1, AAS.GetSentence("jobProblem")) return end

        if UInt == 1 then

            if AAS.WeightActivate then
                local max = (not isnumber(AAS.WeightInventory[ply:GetUserGroup()]) and AAS.WeightInventory["all"] or AAS.WeightInventory[ply:GetUserGroup()])
                if #AAS.GetInventory(ply:SteamID64()) >= max then ply:Notify(1, AAS.GetSentence("toomany")) return end
            end
            ply:AASBuyItem(uniqueId)
            -- print('Buy', uniqueId)
            
        elseif UInt == 2 then
            ply:AASSellItem(uniqueId)
            
        elseif UInt == 3 then
            ply.AASWaitItem = ply.AASWaitItem or 0
            if ply.AASWaitItem > CurTime() then rp.Notify(ply, 5, AAS.GetSentence("waitItem")) return end

            if not checkNpc then
                if ply:HasWeapon("aas_item_menu") then
                    ply.AASWaitItem = CurTime() + AAS.WearTimeAccessory

                    rp.Notify(ply, AAS.WearTimeAccessory, AAS.GetSentence("waitEquip"))
                    timer.Create("aas_equip_item", AAS.WearTimeAccessory, 1, function()
                        if not IsValid(ply) or not ply:IsPlayer() then return end

                        ply:AASEquipAccessory(uniqueId)
                    end)
                end
            else
                ply:AASEquipAccessory(uniqueId)
            end
        elseif UInt == 5 then
            if not AAS.ModifyOffset then return end

            if not ply:AASIsBought(uniqueId) then rp.Notify(ply, 5, AAS.GetSentence("notOwned")) return end

            local pos = net.ReadVector()
            local ang = net.ReadAngle()
            local scale = net.ReadVector()

            ply:AASSaveOffsets(uniqueId, pos, ang, scale)

            net.Start("AAS:Inventory")
                net.WriteUInt(7, 5)
            net.Send(ply)
        end
    end
end)

local function checkModel(tbl, model)
    local result = false
    for k,v in pairs(tbl) do
        if v == model then result = true end
    end
    return result
end

net.Receive("AAS:Models", function(len, ply)
    if not IsValid(ply) or not ply:IsPlayer() then return end

    ply.AASSpam = ply.AASSpam or 0
    if ply.AASSpam > CurTime() then return end 
    ply.AASSpam = CurTime() + 1

    if AAS.BlackListModelsMenu[team.GetName(ply:Team())] then rp.Notify(ply, 5, AAS.GetSentence("jobProblem")) return end
    if not AAS.OpenModelChangerWithKey and not ply:AASCheckDistEnt("aas_model", 150) then rp.Notify(ply, 5, AAS.GetSentence("exploitArmory")) return end
    
    local model = net.ReadString()

    local table = (AAS.UseDarkRPModel and DarkRP) and RPExtraTeams[ply:Team()].model or AAS.CustomModelTable[team.GetName(ply:Team())]
    if not checkModel(table, model) then return end

    ply:SetModel(model)
    ply:AASLoadBodyGroup()

    rp.Notify(ply, 5, AAS.GetSentence("equipModel"))
end)


--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
