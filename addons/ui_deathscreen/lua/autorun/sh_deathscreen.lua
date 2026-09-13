if SERVER then
    AddCSLuaFile()

    util.AddNetworkString("ArizonaRP.DeathScreen.Show")
    util.AddNetworkString("ArizonaRP.DeathScreen.Hide")
    util.AddNetworkString("ArizonaRP.DeathScreen.Spawn")

    local function getWeaponPrintName(ent)
        if not IsValid(ent) then return nil end
        if ent:IsPlayer() then return nil end

        if ent:IsWeapon() then
            local printName = ent.GetPrintName and ent:GetPrintName()
            if printName and printName ~= "" then return printName end
        end

        local class = ent:GetClass()
        if class and class ~= "" then return class end
    end

    local function getDeathReason(victim, inflictor, attacker)
        local dmg = victim.ArizonaRP_LastDeathDamage
        local dmgType = dmg and dmg.type or 0
        local dmgInflictor = dmg and dmg.inflictor

        if bit.band(dmgType, DMG_FALL) ~= 0 then return "Падение" end
        if bit.band(dmgType, DMG_DROWN) ~= 0 then return "Утопление" end
        if bit.band(dmgType, DMG_BURN) ~= 0 or bit.band(dmgType, DMG_SLOWBURN) ~= 0 then return "Огонь" end
        if bit.band(dmgType, DMG_BLAST) ~= 0 then return "Взрыв" end
        if bit.band(dmgType, DMG_SHOCK) ~= 0 then return "Электричество" end
        if bit.band(dmgType, DMG_POISON) ~= 0 or bit.band(dmgType, DMG_NERVEGAS) ~= 0 or bit.band(dmgType, DMG_RADIATION) ~= 0 then return "Отравление" end
        if bit.band(dmgType, DMG_CRUSH) ~= 0 or bit.band(dmgType, DMG_VEHICLE) ~= 0 then return "Столкновение" end
        if bit.band(dmgType, DMG_CLUB) ~= 0 then return "Удар" end
        if bit.band(dmgType, DMG_SLASH) ~= 0 then return "Порез" end

        local weaponName = getWeaponPrintName(inflictor) or getWeaponPrintName(dmgInflictor)

        if IsValid(attacker) and attacker:IsPlayer() then
            local activeWeapon = attacker:GetActiveWeapon()
            weaponName = weaponName or getWeaponPrintName(activeWeapon)
        end

        if weaponName then
            return "Оружие: " .. weaponName
        end

        return "Неизвестно"
    end

    hook.Add("EntityTakeDamage", "ArizonaRP.DeathScreen.SaveLastDamage", function(ent, dmginfo)
        if not IsValid(ent) or not ent:IsPlayer() then return end

        ent.ArizonaRP_LastDeathDamage = {
            type = dmginfo:GetDamageType(),
            inflictor = dmginfo:GetInflictor(),
            attacker = dmginfo:GetAttacker(),
            time = CurTime()
        }
    end)

    local function isDuelDeath(victim, attacker)
        if victim.ArizonaRP_HideDeathScreenUntil and victim.ArizonaRP_HideDeathScreenUntil > CurTime() then return true end
        if victim.dueltarget then return true end
        if IsValid(attacker) and attacker:IsPlayer() and attacker.dueltarget == victim then return true end
        return false
    end

    hook.Add("PlayerDeath", "ArizonaRP.DeathScreen.Show", function(victim, inflictor, attacker)
        if not IsValid(victim) or not victim:IsPlayer() then return end
        if isDuelDeath(victim, attacker) then return end

        timer.Simple(0, function()
            if not IsValid(victim) then return end
            if isDuelDeath(victim, attacker) then return end

            local killerName = "Неизвестно"
            local killerSteamID = ""

            if IsValid(attacker) and attacker:IsPlayer() then
                if attacker == victim then
                    killerName = "Самоубийство"
                else
                    killerName = attacker:Name()
                    killerSteamID = attacker:SteamID()
                end
            elseif IsValid(attacker) then
                killerName = attacker:GetClass() or "Неизвестно"
            end

            local deathReason = getDeathReason(victim, inflictor, attacker)

            victim.ArizonaRP_DeathScreenActive = true
            victim.ArizonaRP_DeathTime = CurTime()
            victim.NextReSpawn = CurTime() + 999999

            net.Start("ArizonaRP.DeathScreen.Show")
                net.WriteString(killerName)
                net.WriteString(killerSteamID)
                net.WriteString(os.date("%d.%m.%Y в %H:%M:%S"))
                net.WriteString(deathReason)
            net.Send(victim)
        end)
    end)

    hook.Add("PlayerSpawn", "ArizonaRP.DeathScreen.Hide", function(ply)
        ply.ArizonaRP_DeathScreenActive = false
        ply.ArizonaRP_DeathTime = nil

        net.Start("ArizonaRP.DeathScreen.Hide")
        net.Send(ply)
    end)

    hook.Add("PlayerDeathThink", "ArizonaRP.DeathScreen.BlockKeyRespawn", function(ply)
        if ply.ArizonaRP_DeathScreenActive then
            if ply.ArizonaRP_DeathTime and (CurTime() - ply.ArizonaRP_DeathTime > 40) then
                ply.ArizonaRP_DeathScreenActive = false
                ply.NextReSpawn = 0
                return
            end
            return false
        end
    end)

    net.Receive("ArizonaRP.DeathScreen.Spawn", function(_, ply)
        if not IsValid(ply) or ply:Alive() then return end
        if ply.ArizonaRP_HideDeathScreenUntil and ply.ArizonaRP_HideDeathScreenUntil > CurTime() then return end

        ply.ArizonaRP_DeathScreenActive = false
        ply.ArizonaRP_DeathTime = nil
        ply.NextReSpawn = 0
        ply:Spawn()

        net.Start("ArizonaRP.DeathScreen.Hide")
        net.Send(ply)
    end)

    return
end

local deathFrame
local deathInfo = {
    killerName = "Неизвестно",
    killerSteamID = "",
    timeText = "",
    reason = "Неизвестно"
}

local function sx(v)
    return ScrW() * v / 1921
end

local function sy(v)
    return ScrH() * v / 1080
end

local function ss(v)
    return math.Round(v * math.min(ScrW(), ScrH()) / 1080)
end

local function createDeathFonts()
    surface.CreateFont("ArizonaRP.DeathScreen.Title", {
        font = "Exo 2",
        size = ss(100),
        weight = 600,
        italic = true,
        antialias = true,
        extended = true
    })

    surface.CreateFont("ArizonaRP.DeathScreen.Info", {
        font = "Exo 2",
        size = ss(25),
        weight = 600,
        antialias = true,
        extended = true
    })

    surface.CreateFont("ArizonaRP.DeathScreen.Button", {
        font = "Exo 2",
        size = ss(16),
        weight = 600,
        antialias = true,
        extended = true
    })
end

createDeathFonts()
hook.Add("OnScreenSizeChanged", "ArizonaRP.DeathScreen.Fonts", createDeathFonts)

local radialGradientMat = CreateMaterial("arizonarp_deathscreen_radialgradient", "UnlitGeneric", {
    ["$basetexture"] = "color/white",
    ["$vertexcolor"] = "1",
    ["$vertexalpha"] = "1",
    ["$translucent"] = "1"
})

local function addGradientVertex(x, y, col)
    mesh.Position(Vector(x, y, 0))
    mesh.Color(col.r, col.g, col.b, col.a)
    mesh.AdvanceVertex()
end

local function paintRadialBackground(w, h)
    surface.SetDrawColor(0, 0, 0, 220)
    surface.DrawRect(0, 0, w, h)

    local cx, cy = w * 0.5, h * 0.5
    local radius = math.min(w, h) * 0.58
    local segments = 160

    local centerCol = Color(109, 109, 109, 92)
    local edgeCol = Color(0, 0, 0, 0)

    render.SetMaterial(radialGradientMat)
    mesh.Begin(MATERIAL_TRIANGLES, segments * 3)

    for i = 0, segments - 1 do
        local a1 = (i / segments) * math.pi * 2
        local a2 = ((i + 1) / segments) * math.pi * 2

        addGradientVertex(cx, cy, centerCol)
        addGradientVertex(cx + math.cos(a1) * radius, cy + math.sin(a1) * radius, edgeCol)
        addGradientVertex(cx + math.cos(a2) * radius, cy + math.sin(a2) * radius, edgeCol)
    end

    mesh.End()
end

local function closeDeathScreen()
    if IsValid(deathFrame) then
        deathFrame:Remove()
    end
    deathFrame = nil
    gui.EnableScreenClicker(false)
end

local function openDeathScreen()
    closeDeathScreen()

    local fr = vgui.Create("DFrame")
    deathFrame = fr

    fr:SetSize(ScrW(), ScrH())
    fr:SetPos(0, 0)
    fr:SetTitle("")
    fr:SetDraggable(false)
    fr:ShowCloseButton(false)
    fr:SetSizable(false)
    fr:SetDeleteOnClose(true)
    fr:MakePopup()
    fr:SetKeyboardInputEnabled(false)
    fr:SetMouseInputEnabled(true)

    fr.Paint = function(_, w, h)
        paintRadialBackground(w, h)

        draw.SimpleText("ВЫ УМЕРЛИ", "ArizonaRP.DeathScreen.Title", sx(961), sy(451), color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

        surface.SetDrawColor(243, 45, 45, 255)
        surface.DrawRect(sx(676), sy(511), sx(570), math.max(2, sy(5)))

        local killer = deathInfo.killerName or "Неизвестно"
        local steamID = deathInfo.killerSteamID or ""
        local killerLine = steamID ~= "" and (killer .. " (" .. steamID .. ")") or killer

        draw.SimpleText("Убийца:", "ArizonaRP.DeathScreen.Info", sx(676), sy(529), color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
        draw.SimpleText(killerLine, "ArizonaRP.DeathScreen.Info", sx(676), sy(559), color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)

        draw.SimpleText("Время:", "ArizonaRP.DeathScreen.Info", sx(676), sy(593), color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
        draw.SimpleText(deathInfo.timeText or "", "ArizonaRP.DeathScreen.Info", sx(676), sy(623), color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)

        draw.SimpleText("Причина:", "ArizonaRP.DeathScreen.Info", sx(676), sy(657), color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
        draw.SimpleText(deathInfo.reason or "Неизвестно", "ArizonaRP.DeathScreen.Info", sx(676), sy(687), color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
    end

    local btn = vgui.Create("DButton", fr)
    btn:SetPos(sx(676), sy(745))
    btn:SetSize(sx(214), sy(37))
    btn:SetText("")
    btn.Paint = function(self, w, h)
        local col = self:IsHovered() and Color(235, 70, 76) or Color(218, 62, 68)
        draw.RoundedBox(ss(5), 0, 0, w, h, col)
        draw.SimpleText("Заспавниться", "ArizonaRP.DeathScreen.Button", w * 0.5, h * 0.5, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end
    btn.DoClick = function()
        net.Start("ArizonaRP.DeathScreen.Spawn")
        net.SendToServer()
    end

    local copyBtn = vgui.Create("DButton", fr)
    copyBtn:SetPos(sx(904), sy(745))
    copyBtn:SetSize(sx(214), sy(37))
    copyBtn:SetText("")
    copyBtn:SetVisible((deathInfo.killerSteamID or "") ~= "")
    copyBtn.Paint = function(self, w, h)
        if (deathInfo.killerSteamID or "") == "" then return end

        local col = self:IsHovered() and Color(70, 145, 235) or Color(62, 124, 218)
        draw.RoundedBox(ss(5), 0, 0, w, h, col)
        draw.SimpleText("Скопировать SteamID", "ArizonaRP.DeathScreen.Button", w * 0.5, h * 0.5, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end
    copyBtn.DoClick = function()
        local steamID = deathInfo.killerSteamID or ""
        if steamID == "" then return end

        SetClipboardText(steamID)
        surface.PlaySound("buttons/button14.wav")

        if notification and notification.AddLegacy then
            notification.AddLegacy("SteamID скопирован: " .. steamID, NOTIFY_GENERIC, 3)
        end
    end
end

net.Receive("ArizonaRP.DeathScreen.Show", function()
    deathInfo.killerName = net.ReadString()
    deathInfo.killerSteamID = net.ReadString()
    deathInfo.timeText = net.ReadString()
    deathInfo.reason = net.ReadString()

    openDeathScreen()
end)

net.Receive("ArizonaRP.DeathScreen.Hide", closeDeathScreen)

hook.Add("Think", "ArizonaRP.DeathScreen.AutoClose", function()
    if IsValid(deathFrame) and IsValid(LocalPlayer()) and LocalPlayer():Alive() then
        closeDeathScreen()
    end
end)