print"triggers"

local winter_event_poses = {
    Vector(-3150.506836, 6309.855469, -2409.674805),
    Vector(4355.3984375, -4319.7397460938, -3785.8112792969)
}

local function CreateSpawnTriggers()

    local HASH_map = game.GetMap()
    local spawns = rp.cfg.Spawns[HASH_map]

    if IsValid(trigger_spawn1) then trigger_spawn1:Remove() end
    if IsValid(trigger_winter_event) then trigger_winter_event:Remove() end

    trigger_spawn1 = ents.Create("lua_trigger")
    trigger_spawn1:Spawn()
    trigger_spawn1:SetPos(spawns[1])
    trigger_spawn1:SetTriggerName("spawnzone_1")
    trigger_spawn1:SetTriggerCollisionBox(spawns[1], spawns[2])
    trigger_spawn1:SetTriggerNetworking(true)

    trigger_winter_event = ents.Create("lua_trigger")
    trigger_winter_event:Spawn()
    trigger_winter_event:SetPos(winter_event_poses[1])
    trigger_winter_event:SetTriggerName("winter_event")
    trigger_winter_event:SetTriggerCollisionBox(winter_event_poses[1], winter_event_poses[2])
    trigger_winter_event:SetTriggerNetworking(true)

end

hook.Add("LibFuse:LuaTrigger:Join", "spawns", function(name, entity, self)

    if name == "spawnzone_1" then
        if not entity:IsPlayer() and entity:GetClass() != 'func_brush' then return entity:Remove() end // prevent spawn ent or prop
        
        if entity:IsPlayer() then
            entity:GodEnable()
            entity:SetCollisionGroup(11)
        end
    end

    if name == 'winter_event' then
        if entity:GetClass() == 'prop_physics' then return entity:Remove() end
        if entity:IsPlayer() then
            entity:GodEnable()
            entity:SetCollisionGroup(11)
        end
    end

end)

hook.Add("LibFuse:LuaTrigger:Still", "spawns", function(name, player, self)
    if name == "spawnzone_1" or name == 'winter_event' then
        if not player:IsPlayer() then return end
        if player:HasGodMode() then return end
        player:GodEnable()
        player:SetCollisionGroup(11)
    end
end)

hook.Add("LibFuse:LuaTrigger:Leave", "spawns", function(name, entity, self)

    if name == "spawnzone_1" or name == 'winter_event' then
        if not entity:IsPlayer() then return end

        entity:GodDisable()
        entity:SetCollisionGroup(5)
    end
        
end)

hook.Add("PostCleanupMap", "spawns", CreateSpawnTriggers)
hook.Add("InitPostEntity", "spawns", CreateSpawnTriggers)