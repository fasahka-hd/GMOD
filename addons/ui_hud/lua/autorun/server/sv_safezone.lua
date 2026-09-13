SafeZones = SafeZones or {}

SafeZones.Zones = {
    { Vector(-3165.935303, 2732.165771, 1066.832642), Vector(-5230.831543, 344.442169, -252.818268) },
    { Vector(-1218.868530, -3133.993896, 1345.937500), Vector(-3762.846680, -6001.213867, 565.949402) },
}

function SafeZones.IsInZone(pos)
    for _, zone in ipairs(SafeZones.Zones) do
        local p1, p2 = zone[1], zone[2]
        local minX = math.min(p1.x, p2.x)
        local maxX = math.max(p1.x, p2.x)
        local minY = math.min(p1.y, p2.y)
        local maxY = math.max(p1.y, p2.y)
        local minZ = math.min(p1.z, p2.z)
        local maxZ = math.max(p1.z, p2.z)

        if pos.x >= minX and pos.x <= maxX
            and pos.y >= minY and pos.y <= maxY
            and pos.z >= minZ and pos.z <= maxZ then
            return true
        end
    end
    return false
end

util.AddNetworkString("SafeZone_Status")

local playerInZone = {}

timer.Create("SafeZone_Check", 0.25, 0, function()
    for _, ply in ipairs(player.GetAll()) do
        if IsValid(ply) and ply:Alive() then
            local inZone = SafeZones.IsInZone(ply:GetPos())
            local wasInZone = playerInZone[ply] or false

            if inZone ~= wasInZone then
                playerInZone[ply] = inZone

                net.Start("SafeZone_Status")
                net.WriteBool(inZone)
                net.Send(ply)

                if inZone then
                    ply:GodEnable()
                else
                    ply:GodDisable()
                end
            end
        end
    end
end)

hook.Add("EntityTakeDamage", "SafeZone_BlockDamage", function(target, dmginfo)
    if target:IsPlayer() and IsValid(target) and target:Alive() then
        if SafeZones.IsInZone(target:GetPos()) then
            dmginfo:SetDamage(0)
            dmginfo:ScaleDamage(0)
            return true
        end
    end
end)

hook.Add("PlayerDisconnected", "SafeZone_Cleanup", function(ply)
    playerInZone[ply] = nil
end)

hook.Add("PlayerSpawn", "SafeZone_Spawn", function(ply)
    timer.Simple(0.1, function()
        if IsValid(ply) then
            local inZone = SafeZones.IsInZone(ply:GetPos())
            playerInZone[ply] = inZone
            
            net.Start("SafeZone_Status")
            net.WriteBool(inZone)
            net.Send(ply)

            if inZone then
                ply:GodEnable()
            else
                ply:GodDisable()
            end
        end
    end)
end)

local function IsSuperAdmin(ply)
    return IsValid(ply) and ply:IsSuperAdmin()
end

hook.Add("PlayerSpawnProp", "SafeZone_BlockProp", function(ply, model)
    if IsSuperAdmin(ply) then return end
    
    local tr = ply:GetEyeTrace()
    if SafeZones.IsInZone(tr.HitPos) then
        if DarkRP and DarkRP.notify then
            DarkRP.notify(ply, 1, 4, "Нельзя спавнить пропы в зелёной зоне!")
        else
            ply:ChatPrint("Нельзя спавнить пропы в зелёной зоне!")
        end
        return false
    end
end)

hook.Add("PlayerSpawnedProp", "SafeZone_RemoveSpawnedProp", function(ply, model, ent)
    if IsSuperAdmin(ply) then return end
    if SafeZones.IsInZone(ent:GetPos()) then
        ent:Remove()
    end
end)

hook.Add("PlayerSpawnedSENT", "SafeZone_BlockSENT", function(ply, ent)
    if IsSuperAdmin(ply) then return end
    if SafeZones.IsInZone(ent:GetPos()) then
        ent:Remove()
    end
end)

hook.Add("PlayerSpawnedSWEP", "SafeZone_BlockSWEP", function(ply, ent)
    if IsSuperAdmin(ply) then return end
    if SafeZones.IsInZone(ent:GetPos()) then ent:Remove() end
end)

hook.Add("PlayerSpawnedVehicle", "SafeZone_BlockVehicle", function(ply, ent)
    if IsSuperAdmin(ply) then return end
    if SafeZones.IsInZone(ent:GetPos()) then ent:Remove() end
end)

hook.Add("PlayerSpawnedNPC", "SafeZone_BlockNPC", function(ply, ent)
    if IsSuperAdmin(ply) then return end
    if SafeZones.IsInZone(ent:GetPos()) then ent:Remove() end
end)

hook.Add("PlayerSpawnedSENT", "SafeZone_BlockTextScreen", function(ply, ent)
    if IsSuperAdmin(ply) then return end
    local class = ent:GetClass()
    if class == "gmod_textscreen" or class == "textscreen" or class == "3dtextscreen" then
        if SafeZones.IsInZone(ent:GetPos()) then
            ent:Remove()
            if DarkRP and DarkRP.notify then
                DarkRP.notify(ply, 1, 4, "Нельзя ставить Text Screen в зелёной зоне!")
            else
                ply:ChatPrint("Нельзя ставить Text Screen в зелёной зоне!")
            end
        end
    end
end)

hook.Add("CanTool", "SafeZone_BlockTools", function(ply, tr, tool)
    if SafeZones.IsInZone(ply:GetPos()) and not IsSuperAdmin(ply) then
        if tool == "creator" or tool == "duplicator" or tool == "advdupe2" or tool == "textscreen" then
            if DarkRP and DarkRP.notify then
                DarkRP.notify(ply, 1, 4, "Нельзя использовать инструменты в зелёной зоне!")
            else
                ply:ChatPrint("Нельзя использовать инструменты в зелёной зоне!")
            end
            return false
        end
    end
end)

hook.Add("PhysgunDrop", "SafeZone_BlockPhysgunDrop", function(ply, ent)
    if not IsValid(ply) or not IsValid(ent) then return end
    if IsSuperAdmin(ply) then return end
    
    if SafeZones.IsInZone(ent:GetPos()) then
        ent:Remove()
    end
end)