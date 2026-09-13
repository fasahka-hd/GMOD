local MAX_EFFECTS = 8 

util.AddNetworkString("Orbit_UpdateEffect")
util.AddNetworkString("Orbit_DoCraft")

net.Receive("Orbit_UpdateEffect", function(len, ply)
    local effectID = net.ReadUInt(4) 

    if effectID < 0 or effectID > MAX_EFFECTS then 
        return 
    end

    local hasEffect = (effectID == 0) or ply:GetNWBool("Orbit_Has_" .. effectID, false)

    if hasEffect then
        ply:SetNWInt("OrbitFX", effectID)
        ply:SetPData("Orbit_Current_FX", effectID)
    else
        ply:ChatPrint("[ORBIT] У вас нет этого эффекта!")
    end
end)

concommand.Add("orbit_give", function(ply, cmd, args)
    if IsValid(ply) and not ply:IsSuperAdmin() then 
        ply:ChatPrint("[ORBIT] У вас нет прав!")
        return 
    end
    
    local targetIdent = args[1]
    local effectID = tonumber(args[2])
    
    if not targetIdent or not effectID then 
        if IsValid(ply) then ply:ChatPrint("[ORBIT] Использование: orbit_give <Игрок/SteamID> <ID Эффекта>") end
        return 
    end

    if effectID < 1 or effectID > MAX_EFFECTS then
        if IsValid(ply) then ply:ChatPrint("[ORBIT] Неверный ID эффекта (1-" .. MAX_EFFECTS .. ")") end
        return
    end

    local target = nil

    target = player.GetBySteamID(targetIdent)
    if not target then target = player.GetBySteamID64(targetIdent) end

    if not target then
        local lowerIdent = string.lower(targetIdent)
        for _, p in ipairs(player.GetAll()) do
            if string.find(string.lower(p:Nick()), lowerIdent) then
                target = p
                break
            end
        end
    end

    if IsValid(target) then
        target:SetNWBool("Orbit_Has_" .. effectID, true)
        target:SetPData("Orbit_Unlocked_" .. effectID, "1")
        
        target:ChatPrint("[ORBIT] Вам открыли новый эффект: " .. effectID)

        if IsValid(ply) and ply ~= target then
            ply:ChatPrint("[ORBIT] Вы открыли эффект " .. effectID .. " для " .. target:Nick())
        elseif not IsValid(ply) then
            Msg("[ORBIT] Эффект " .. effectID .. " открыт для " .. target:Nick() .. "\n")
        end
    else
        if IsValid(ply) then ply:ChatPrint("[ORBIT] Игрок не найден!") end
    end
end)

hook.Add("PlayerInitialSpawn", "Orbit_RestoreData", function(ply)
    for i = 1, MAX_EFFECTS do
        if ply:GetPData("Orbit_Unlocked_" .. i) == "1" then
            ply:SetNWBool("Orbit_Has_" .. i, true)
        end
    end

    local lastFX = tonumber(ply:GetPData("Orbit_Current_FX")) or 0

    if lastFX >= 0 and lastFX <= MAX_EFFECTS then
        ply:SetNWInt("OrbitFX", lastFX)
    else
        ply:SetNWInt("OrbitFX", 0) 
    end
end)