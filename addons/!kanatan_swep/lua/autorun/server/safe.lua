if not SERVER then return end

LimitlessSafety = LimitlessSafety or {}

local protectedDoorClasses = {
    prop_door_rotating = true,
    func_door = true,
    func_door_rotating = true,
    func_movelinear = true,
    func_breakable = true,
    func_breakable_surf = true
}

local function classOf(ent)
    return IsValid(ent) and string.lower(ent:GetClass() or "") or ""
end

function LimitlessSafety.IsDoor(ent)
    local cls = classOf(ent)
    return protectedDoorClasses[cls] or string.find(cls, "door", 1, true) ~= nil
end

function LimitlessSafety.IsNPC(ent)
    return IsValid(ent) and (ent:IsNPC() or ent:IsNextBot())
end

function LimitlessSafety.IsProtectedEntity(ent)
    return IsValid(ent) and (LimitlessSafety.IsDoor(ent) or LimitlessSafety.IsNPC(ent))
end

function LimitlessSafety.IsFrozenPhysics(ent, phys)
    if not IsValid(ent) then return false end

    if IsValid(phys) and phys.IsMotionEnabled and not phys:IsMotionEnabled() then
        return true
    end

    local count = ent.GetPhysicsObjectCount and ent:GetPhysicsObjectCount() or 0
    if count and count > 0 then
        for i = 0, count - 1 do
            local p = ent:GetPhysicsObjectNum(i)
            if IsValid(p) and p.IsMotionEnabled and not p:IsMotionEnabled() then
                return true
            end
        end
    end

    local p = ent.GetPhysicsObject and ent:GetPhysicsObject()
    return IsValid(p) and p.IsMotionEnabled and not p:IsMotionEnabled()
end

function LimitlessSafety.IsLimitlessClass(cls)
    cls = string.lower(tostring(cls or ""))
    return cls == "limitless" or string.StartWith(cls, "lm_") or string.StartWith(cls, "jjk_")
end

function LimitlessSafety.IsLimitlessDamage(dmginfo)
    if not dmginfo then return false end

    local inf = dmginfo:GetInflictor()
    if IsValid(inf) and LimitlessSafety.IsLimitlessClass(inf:GetClass()) then
        return true
    end

    local att = dmginfo:GetAttacker()
    if IsValid(att) and LimitlessSafety.IsLimitlessClass(att:GetClass()) then
        return true
    end

    if IsValid(att) and att:IsPlayer() then
        local wep = att:GetActiveWeapon()
        if IsValid(wep) and LimitlessSafety.IsLimitlessClass(wep:GetClass()) then
            return true
        end
    end

    return false
end

function LimitlessSafety.IsAbilityCall()
    if not debug or not debug.getinfo then return false end

    for level = 3, 16 do
        local info = debug.getinfo(level, "S")
        if not info then break end

        local src = string.lower(tostring(info.short_src or info.source or ""))
        if string.find(src, "!kanatan_swep", 1, true)
            or string.find(src, "/limitless.lua", 1, true)
            or string.find(src, "\\limitless.lua", 1, true)
            or string.find(src, "/lm_", 1, true)
            or string.find(src, "\\lm_", 1, true)
            or string.find(src, "/jjk_", 1, true)
            or string.find(src, "\\jjk_", 1, true) then
            return true
        end
    end

    return false
end

function LimitlessSafety.ShouldBlockPhysics(ent, phys)
    return IsValid(ent) and (
        LimitlessSafety.IsProtectedEntity(ent)
        or LimitlessSafety.IsFrozenPhysics(ent, phys)
    )
end

function LimitlessSafety.StopEntity(ent)
    if not IsValid(ent) then return end
    ent:SetVelocity(Vector(0, 0, 0))

    local count = ent.GetPhysicsObjectCount and ent:GetPhysicsObjectCount() or 0
    if count and count > 0 then
        for i = 0, count - 1 do
            local phys = ent:GetPhysicsObjectNum(i)
            if IsValid(phys) then
                phys:SetVelocity(Vector(0, 0, 0))
                if LimitlessSafety.IsFrozenPhysics(ent, phys) then
                    phys:EnableMotion(false)
                end
            end
        end
        return
    end

    local phys = ent.GetPhysicsObject and ent:GetPhysicsObject()
    if IsValid(phys) then
        phys:SetVelocity(Vector(0, 0, 0))
        if LimitlessSafety.IsFrozenPhysics(ent, phys) then
            phys:EnableMotion(false)
        end
    end
end

hook.Add("EntityTakeDamage", "limitless_safety_block_doors_npcs_and_frozen_props", function(ent, dmginfo)
    if not IsValid(ent) or not LimitlessSafety.IsLimitlessDamage(dmginfo) then return end

    if LimitlessSafety.IsProtectedEntity(ent) or LimitlessSafety.IsFrozenPhysics(ent) then
        dmginfo:SetDamage(0)
        dmginfo:ScaleDamage(0)

        timer.Simple(0, function()
            if IsValid(ent) then LimitlessSafety.StopEntity(ent) end
        end)

        return true
    end
end)

if not LimitlessSafety.MetaGuardsInstalled then
    LimitlessSafety.MetaGuardsInstalled = true

    local entMeta = FindMetaTable("Entity")
    if entMeta then
        if entMeta.Remove and not entMeta._LimitlessSafetyRemove then
            entMeta._LimitlessSafetyRemove = entMeta.Remove
            entMeta.Remove = function(self, ...)
                if LimitlessSafety.IsAbilityCall() and LimitlessSafety.IsProtectedEntity(self) then
                    return false
                end
                return entMeta._LimitlessSafetyRemove(self, ...)
            end
        end

        if entMeta.SetVelocity and not entMeta._LimitlessSafetySetVelocity then
            entMeta._LimitlessSafetySetVelocity = entMeta.SetVelocity
            entMeta.SetVelocity = function(self, vel, ...)
                if LimitlessSafety.IsAbilityCall() and LimitlessSafety.ShouldBlockPhysics(self) then
                    return entMeta._LimitlessSafetySetVelocity(self, Vector(0, 0, 0), ...)
                end
                return entMeta._LimitlessSafetySetVelocity(self, vel, ...)
            end
        end
    end

    local physMeta = FindMetaTable("PhysObj")
    if physMeta then
        if physMeta.EnableMotion and not physMeta._LimitlessSafetyEnableMotion then
            physMeta._LimitlessSafetyEnableMotion = physMeta.EnableMotion
            physMeta.EnableMotion = function(self, enable, ...)
                if enable == true and LimitlessSafety.IsAbilityCall() then
                    local ent
                    local ok, got = pcall(function() return self:GetEntity() end)
                    if ok then ent = got end

                    if LimitlessSafety.ShouldBlockPhysics(ent, self) then
                        return physMeta._LimitlessSafetyEnableMotion(self, false, ...)
                    end
                end

                return physMeta._LimitlessSafetyEnableMotion(self, enable, ...)
            end
        end

        if physMeta.SetVelocity and not physMeta._LimitlessSafetySetVelocity then
            physMeta._LimitlessSafetySetVelocity = physMeta.SetVelocity
            physMeta.SetVelocity = function(self, vel, ...)
                if LimitlessSafety.IsAbilityCall() then
                    local ent
                    local ok, got = pcall(function() return self:GetEntity() end)
                    if ok then ent = got end

                    if LimitlessSafety.ShouldBlockPhysics(ent, self) then
                        return physMeta._LimitlessSafetySetVelocity(self, Vector(0, 0, 0), ...)
                    end
                end

                return physMeta._LimitlessSafetySetVelocity(self, vel, ...)
            end
        end
    end

    if constraint and constraint.RemoveAll and not constraint._LimitlessSafetyRemoveAll then
        constraint._LimitlessSafetyRemoveAll = constraint.RemoveAll
        constraint.RemoveAll = function(ent, ...)
            if LimitlessSafety.IsAbilityCall() and LimitlessSafety.ShouldBlockPhysics(ent) then
                return false
            end
            return constraint._LimitlessSafetyRemoveAll(ent, ...)
        end
    end
end