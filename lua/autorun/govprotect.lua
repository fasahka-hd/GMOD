if SERVER then AddCSLuaFile() end

GovProtect = GovProtect or {}
GovProtect.Config = {
    BlockDamage      = true,
    NotifyInChat     = true,
    NotifyCooldown   = 3,
    Halo             = true,
    HaloRadius       = 394,
    HaloColor        = Color(0, 120, 255),
    HaloBlur         = 2,
    HaloPasses       = 2,
    HaloThroughWalls = true,
    HaloOnlyForGov   = true,
}

local GOV_CATEGORIES = { ["Гос структуры"] = true, ["SWAT"] = true }

function GovProtect.IsGovernment(ply)
    if not IsValid(ply) or not ply:IsPlayer() then return false end
    local t = ply:Team()
    if rp.CivilProtection and rp.CivilProtection[t] then return true end
    local job = rp.teams and rp.teams[t]
    if job and GOV_CATEGORIES[job.category or ""] then return true end
    return false
end

if SERVER then
    print("[GovProtect] loaded SERVER")

    hook.Add("PlayerShouldTakeDamage", "GovProtect.BlockGovDamage", function(victim, attacker)
        if not GovProtect.Config.BlockDamage then return end
        if attacker == victim then return end
        if IsValid(attacker) and attacker:IsVehicle() then
            attacker = attacker:GetDriver()
        end
        if not (IsValid(attacker) and attacker:IsPlayer()) then return end
        if GovProtect.IsGovernment(victim) and GovProtect.IsGovernment(attacker) then
            return false
        end
    end)

    hook.Add("EntityTakeDamage", "GovProtect.BlockGovDamage", function(victim, dmginfo)
        if not GovProtect.Config.BlockDamage then return end
        if not GovProtect.IsGovernment(victim) then return end
        local attacker = dmginfo:GetAttacker()
        if IsValid(attacker) and attacker:IsVehicle() then
            local driver = attacker:GetDriver()
            attacker = IsValid(driver) and driver or nil
        end
        if not (IsValid(attacker) and attacker:IsPlayer()) then
            local inflictor = dmginfo:GetInflictor()
            if IsValid(inflictor) and inflictor:IsPlayer() then
                attacker = inflictor
            end
        end
        if not (IsValid(attacker) and attacker:IsPlayer()) then return end
        if attacker == victim then return end
        if not GovProtect.IsGovernment(attacker) then return end
        if GovProtect.Config.NotifyInChat then
            local now = CurTime()
            if (attacker.GovProtect_NextNotify or 0) <= now then
                attacker.GovProtect_NextNotify = now + GovProtect.Config.NotifyCooldown
                attacker:ChatPrint("Нельзя наносить урон государственным сотрудникам!")
            end
        end
        return true
    end)

    concommand.Add("govprotect_status", function(ply)
        if IsValid(ply) and not ply:IsSuperAdmin() then return end
        local out = IsValid(ply) and function(s) ply:PrintMessage(HUD_PRINTCONSOLE, s) end or print
        out("[GovProtect] rp.CivilProtection teams:")
        local n = 0
        for t in pairs(rp.CivilProtection or {}) do
            n = n + 1
            out("  team " .. t .. " = " .. tostring(team.GetName(t)))
        end
        out("[GovProtect] total " .. n .. " teams")
        out("[GovProtect] gov players online:")
        for _, p in ipairs(player.GetAll()) do
            if GovProtect.IsGovernment(p) then
                out("  " .. p:Nick() .. " (team " .. p:Team() .. " = " .. tostring(team.GetName(p:Team())) .. ")")
            end
        end
    end)
end

if CLIENT then
    MsgC(Color(0, 120, 255), "[GovProtect] loaded CLIENT\n")

    local function ensureHaloRenderer()
        local t = hook.GetTable().PostDrawEffects
        if not t or not t.RenderHalos then
            include("includes/modules/halo.lua")
            local t2 = hook.GetTable().PostDrawEffects
            if t2 and t2.RenderHalos then
                MsgC(Color(0, 255, 120), "[GovProtect] halo renderer restored (gamemode default workaround had removed it)\n")
            else
                MsgC(Color(255, 80, 80), "[GovProtect] WARNING: halo renderer missing\n")
            end
        end
    end

    ensureHaloRenderer()
    timer.Create("GovProtect.HaloWatchdog", 2, 0, ensureHaloRenderer)

    GovProtect.TestUntil = 0

    hook.Add("PreDrawHalos", "GovProtect.Halo", function()
        if not GovProtect.Config.Halo then return end
        local lp = LocalPlayer()
        if not IsValid(lp) then return end
        local testing = GovProtect.TestUntil > CurTime()
        if not testing then
            if GovProtect.Config.HaloOnlyForGov and not GovProtect.IsGovernment(lp) then return end
        end
        local radiusSqr = GovProtect.Config.HaloRadius * GovProtect.Config.HaloRadius
        if testing then radiusSqr = 4096 * 4096 end
        local lpPos = lp:GetPos()
        local targets = {}
        for _, ply in ipairs(player.GetAll()) do
            if ply ~= lp and ply:Alive() and ply:GetPos():DistToSqr(lpPos) <= radiusSqr then
                if testing or GovProtect.IsGovernment(ply) then
                    targets[#targets + 1] = ply
                end
            end
        end
        if targets[1] == nil then return end
        halo.Add(targets, GovProtect.Config.HaloColor, GovProtect.Config.HaloBlur, GovProtect.Config.HaloBlur, GovProtect.Config.HaloPasses, true, GovProtect.Config.HaloThroughWalls)
    end)

    concommand.Add("govprotect_testhalo", function()
        GovProtect.TestUntil = CurTime() + 15
        local t = hook.GetTable().PostDrawEffects
        MsgC(Color(0, 120, 255), "[GovProtect] test halo 15 sec, renderer hooked: " .. tostring(t ~= nil and t.RenderHalos ~= nil) .. "\n")
    end)
end
