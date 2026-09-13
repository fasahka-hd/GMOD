local CAMERAS   = CamersSystem.CAMERAS
local CAM_COUNT = CamersSystem.CAM_COUNT
local IsPolice  = CamersSystem.IsPolice
local FOV_DEF   = CamersSystem.FOV_DEF
local FOV_MIN   = CamersSystem.FOV_MIN
local FOV_MAX   = CamersSystem.FOV_MAX
local YAW_LIMIT = CamersSystem.YAW_LIMIT
local REPAIR_DIST_SQR = CamersSystem.REPAIR_DIST_SQR
local REPAIR_TIME     = CamersSystem.REPAIR_TIME

local isOpen     = false
local BuildPanel
local ShowLoginScreen

hook.Remove("HUDPaint", "CamSys_3D")
hook.Remove("RenderScene", "CamSys_RT")

local PANEL_W   = 910
local PANEL_H   = 535
local SIDEBAR_W = 228
local BAR_W     = 4
local VP_X      = SIDEBAR_W + BAR_W + 8
local VP_Y      = 8
local VP_W      = PANEL_W - VP_X - 8
local VP_H      = PANEL_H - VP_Y - 78

local BG       = Color(28, 28, 28)
local BTN      = Color(55, 55, 55)
local BTN_HOV  = Color(70, 70, 70)
local BTN_ACT  = Color(40, 40, 40)
local BLUE     = Color(0, 70, 255)
local CAM_BG   = Color(6, 6, 6)
local WHITE    = Color(255, 255, 255)
local REC_COL  = Color(220, 30, 30)
local DOT_GRN  = Color(45, 195, 55)
local DOT_RED  = Color(195, 40, 40)
local DISC_COL = Color(195, 30, 30)
local TS_COL   = Color(210, 210, 210)
local MRK_COL  = Color(220, 30, 30)
local MRK_BG   = Color(0, 0, 0, 150)
local LOGIN_BG   = Color(10, 18, 55)
local LOGIN_FIELD = Color(80, 160, 255)
local LOGIN_DIM   = Color(40, 80, 180)
local LOGIN_GLOW  = Color(60, 140, 255, 80)

local selCam     = 1
local recBlink   = true
local recTimer   = 0
local camYaw     = 0
local camPitch   = 0
local camFOV     = FOV_DEF
local frame
local repairStart = nil

local NW, NH     = 60, 45
local noiseGrid  = {}
local noiseTick  = 0
local NOISE_RATE = 0.05

local function RebuildNoise()
    for i = 1, NW * NH do
        noiseGrid[i] = math.random(15, 245)
    end
end
RebuildNoise()

local logoMat = Material("camers_system/logo", "noclamp smooth")

local camRT    = GetRenderTarget("CamSys_RT_View_D", 1024, 768, true)
local camRTMat = CreateMaterial("CamSys_RTMat_D", "UnlitGeneric", {
    ["$basetexture"] = camRT:GetName(),
    ["$nolod"] = 1,
})

local rtRendering = false

local function RR(x, y, w, h, r, col) draw.RoundedBox(r, x, y, w, h, col) end
local function TX(t, f, x, y, c, ha) draw.SimpleText(t, f, x, y, c, ha or TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER) end

local function Utf8Len(s)
    local count = 0
    local i = 1
    local len = #s
    while i <= len do
        local b = string.byte(s, i)
        if b < 128 then i = i + 1
        elseif b < 224 then i = i + 2
        elseif b < 240 then i = i + 3
        else i = i + 4 end
        count = count + 1
    end
    return count
end

local function Utf8Sub(s, startChar, endChar)
    local i = 1
    local ci = 0
    local len = #s
    local startByte, endByte
    while i <= len do
        ci = ci + 1
        if ci == startChar then startByte = i end
        local b = string.byte(s, i)
        if b < 128 then i = i + 1
        elseif b < 224 then i = i + 2
        elseif b < 240 then i = i + 3
        else i = i + 4 end
        if ci == endChar then endByte = i - 1; break end
    end
    if not startByte then return "" end
    if not endByte then endByte = len end
    return s:sub(startByte, endByte)
end

local function TypeText(full, elapsed, tStart, speed)
    if elapsed < tStart then return "", false end
    local totalChars = Utf8Len(full)
    local chars = math.floor((elapsed - tStart) / speed) + 1
    if chars >= totalChars then return full, true end
    return Utf8Sub(full, 1, chars), false
end

local function MakeBtn(parent, x, y, w, h, text, font, r, onClick)
    local btn = vgui.Create("DButton", parent)
    btn:SetPos(x, y)
    btn:SetSize(w, h)
    btn:SetText("")
    local hov = false
    btn.OnCursorEntered = function() hov = true  end
    btn.OnCursorExited  = function() hov = false end
    btn.DoClick = onClick
    btn.Paint = function(self, bw, bh)
        RR(0, 0, bw, bh, r, hov and BTN_HOV or BTN)
        TX(text, font, bw * 0.5, bh * 0.5, WHITE, TEXT_ALIGN_CENTER)
    end
    return btn
end

local function Close()
    isOpen = false
    hook.Remove("RenderScene", "CamSys_RT")
    if IsValid(frame) then frame:Remove() end
end

ShowLoginScreen = function()
    if isOpen then return end
    isOpen = true

    if IsValid(frame) then frame:Remove() end

    local loginFrame = vgui.Create("DFrame")
    loginFrame:SetSize(PANEL_W, PANEL_H)
    loginFrame:Center()
    loginFrame:SetTitle("")
    loginFrame:SetDraggable(true)
    loginFrame:ShowCloseButton(false)
    loginFrame:MakePopup()

    local startTime = RealTime()
    local nick = LocalPlayer():Nick() or "admin"
    local loginUser = Utf8Sub(nick, 1, 16)
    local passChars = string.rep("*", 10)
    local charSpeed = 0.065

    local loginLen = Utf8Len(loginUser)
    local p0 = 0.4
    local p1 = 1.2
    local p1e = p1 + loginLen * charSpeed
    local p2 = p1e + 0.3
    local p2e = p2 + #passChars * charSpeed
    local p3 = p2e + 0.4
    local p3e = p3 + 1.6
    local p4 = p3e
    local p4e = p4 + 0.8
    local done = false

    local termNum = math.random(100, 999)
    local termIP = "192.168.1." .. math.random(10, 99)

    local function DrawBadge(cx, cy, sz)
        local bw = sz * 1.5
        local bh = sz * 1.2
        local bx = cx - bw / 2
        local by = cy - sz * 0.8
        RR(bx, by, bw, bh, 6, BLUE)
        RR(bx + 3, by + 3, bw - 6, bh - 6, 4, Color(4, 8, 28))
        local triTop = by + bh - 1
        local triBot = triTop + sz * 0.6
        draw.NoTexture()
        surface.SetDrawColor(BLUE)
        surface.DrawPoly({
            { x = bx, y = triTop },
            { x = bx + bw, y = triTop },
            { x = cx, y = triBot },
        })
        surface.SetDrawColor(Color(4, 8, 28))
        surface.DrawPoly({
            { x = bx + 3, y = triTop },
            { x = bx + bw - 3, y = triTop },
            { x = cx, y = triBot - 4 },
        })
        draw.SimpleText("★", "CamSys_Access", cx, cy - sz * 0.2, Color(220, 190, 60), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end

    loginFrame.OnRemove = function()
        if not done then isOpen = false end
    end

    loginFrame.Paint = function(self, w, h)
        draw.RoundedBox(16, 0, 0, w, h, Color(4, 8, 28))

        local t = RealTime()

        surface.SetDrawColor(BLUE.r, BLUE.g, BLUE.b, 80)
        surface.DrawOutlinedRect(0, 0, w, h)

        surface.SetDrawColor(BLUE.r, BLUE.g, BLUE.b, 120)
        surface.DrawRect(8, 28, w - 16, 1)
        surface.DrawRect(8, h - 28, w - 16, 1)

        draw.SimpleText("POLICE SURVEILLANCE NETWORK", "CamSys_Term", 14, 16, Color(200, 210, 230), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
        draw.SimpleText("TERMINAL #" .. termNum, "CamSys_TermSm", w - 14, 16, Color(100, 120, 160), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)

        draw.SimpleText(termIP .. " | ENCRYPTED", "CamSys_TermSm", 14, h - 16, Color(100, 120, 160), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
        draw.SimpleText(os.date("%d/%m/%Y  %H:%M:%S"), "CamSys_TermSm", w - 14, h - 16, Color(100, 120, 160), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)

        local elapsed = t - startTime
        local cx = w / 2

        DrawBadge(cx, 80, 40)

        draw.SimpleText("P O L I C E", "CamSys_Label", cx, 130, Color(180, 200, 240), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

        draw.SimpleText("DEPARTMENT OF POLICE", "CamSys_Access", cx, 160, WHITE, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        draw.SimpleText("SURVEILLANCE DIVISION", "CamSys_Status", cx, 183, Color(120, 150, 200), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        draw.SimpleText("AUTHORIZED PERSONNEL ONLY", "CamSys_TermSm", cx, 200, Color(200, 70, 70), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

        surface.SetDrawColor(BLUE.r, BLUE.g, BLUE.b, 40)
        surface.DrawRect(w * 0.1, 215, w * 0.8, 1)

        if elapsed >= p0 then
            local statusCol = LOGIN_DIM
            if elapsed >= p0 + 0.3 then statusCol = Color(40, 180, 80) end
            draw.SimpleText("> CONNECTING TO SERVER...", "CamSys_TermSm", 30, 230, LOGIN_DIM, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
            if elapsed >= p0 + 0.3 then
                draw.SimpleText("CONNECTED", "CamSys_TermSm", w - 30, 230, Color(40, 180, 80), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
            end
        end

        local fieldX = cx - 100
        local fieldW = 240
        local fieldH = 28

        local userY = 250
        draw.SimpleText("USER:", "CamSys_Label", fieldX - 10, userY + fieldH / 2, Color(200, 210, 230), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
        RR(fieldX, userY, fieldW, fieldH, 3, Color(10, 20, 50))
        surface.SetDrawColor(BLUE.r, BLUE.g, BLUE.b, 60)
        surface.DrawOutlinedRect(fieldX, userY, fieldW, fieldH)

        if elapsed >= p1 then
            local txt, fin = TypeText(loginUser, elapsed, p1, charSpeed)
            local cur = ""
            if not fin or (elapsed < p2 and math.floor(elapsed * 3) % 2 == 0) then cur = "|" end
            draw.SimpleText(txt .. cur, "CamSys_Field", fieldX + 8, userY + fieldH / 2, LOGIN_FIELD, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
        else
            if math.floor(elapsed * 3) % 2 == 0 then
                draw.SimpleText("|", "CamSys_Field", fieldX + 8, userY + fieldH / 2, LOGIN_FIELD, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
            end
        end

        local passY = userY + fieldH + 14
        draw.SimpleText("PASS:", "CamSys_Label", fieldX - 10, passY + fieldH / 2, Color(200, 210, 230), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
        RR(fieldX, passY, fieldW, fieldH, 3, Color(10, 20, 50))
        surface.SetDrawColor(BLUE.r, BLUE.g, BLUE.b, 60)
        surface.DrawOutlinedRect(fieldX, passY, fieldW, fieldH)

        if elapsed >= p2 then
            local txt, fin = TypeText(passChars, elapsed, p2, charSpeed)
            local cur = ""
            if not fin or (elapsed < p3 and math.floor(elapsed * 3) % 2 == 0) then cur = "|" end
            draw.SimpleText(txt .. cur, "CamSys_Field", fieldX + 8, passY + fieldH / 2, LOGIN_FIELD, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
        end

        if elapsed >= p3 then
            local progress = math.Clamp((elapsed - p3) / (p3e - p3), 0, 1)
            local barY = passY + fieldH + 24
            local barW = 320
            local barX = cx - barW / 2

            draw.SimpleText("АВТОРИЗАЦИЯ...", "CamSys_Status", cx, barY - 8, Color(180, 190, 210), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

            RR(barX, barY + 8, barW, 14, 2, Color(8, 16, 40))
            surface.SetDrawColor(BLUE.r, BLUE.g, BLUE.b, 40)
            surface.DrawOutlinedRect(barX, barY + 8, barW, 14)
            RR(barX + 2, barY + 10, (barW - 4) * progress, 10, 2, BLUE)

            draw.SimpleText(math.floor(progress * 100) .. "%", "CamSys_TermSm", barX + barW + 8, barY + 15, Color(200, 220, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
        end

        if elapsed >= p4 then
            local accY = passY + fieldH + 70
            draw.SimpleText("[ ДОСТУП РАЗРЕШЕН ]", "CamSys_Label", cx, accY, Color(50, 230, 100), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
            draw.SimpleText("ЗАГРУЗКА СИСТЕМЫ НАБЛЮДЕНИЯ...", "CamSys_TermSm", cx, accY + 22, Color(150, 170, 200), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        end
    end

    loginFrame.Think = function(self)
        local elapsed = RealTime() - startTime
        if elapsed >= p4e and not done then
            done = true
            loginFrame:Remove()
            BuildPanel()
        end
    end
end

BuildPanel = function()
    if IsValid(frame) then frame:Remove() end

    selCam   = 1
    camYaw   = 0
    camPitch = 0
    camFOV   = FOV_DEF

    frame = vgui.Create("DFrame")
    frame:SetSize(PANEL_W, PANEL_H)
    frame:Center()
    frame:SetTitle("")
    frame:SetDraggable(true)
    frame:ShowCloseButton(false)
    frame:MakePopup()

    frame.OnRemove = function()
        isOpen = false
        hook.Remove("RenderScene", "CamSys_RT")
    end

    frame.Paint = function(self, w, h)
        RR(0, 0, w, h, 16, BG)

        RR(6, 7, SIDEBAR_W - 12, 36, 18, BLUE)

        if not logoMat:IsError() then
            surface.SetMaterial(logoMat)
            surface.SetDrawColor(255, 255, 255, 255)
            surface.DrawTexturedRect(10, 9, 32, 32)
        end

        TX("CAMERS SYSTEM V1.0", "CamSys_Title", SIDEBAR_W / 2 + 10, 25, WHITE, TEXT_ALIGN_CENTER)

        surface.SetDrawColor(BLUE)
        surface.DrawRect(SIDEBAR_W, 0, BAR_W, h)

        local cd = CAMERAS[selCam]

        if cd.broken then
            surface.SetDrawColor(CAM_BG)
            surface.DrawRect(VP_X, VP_Y, VP_W, VP_H)

            local cw = VP_W / NW
            local ch = VP_H / NH
            for row = 0, NH - 1 do
                for col = 0, NW - 1 do
                    local v = noiseGrid[row * NW + col + 1] or 128
                    surface.SetDrawColor(v, v, v, 255)
                    surface.DrawRect(
                        VP_X + math.floor(col * cw),
                        VP_Y + math.floor(row * ch),
                        math.ceil(cw) + 1,
                        math.ceil(ch) + 1
                    )
                end
            end

            TX("DISCONNECTED!", "CamSys_Disc",
                VP_X + VP_W * 0.5, VP_Y + VP_H * 0.5,
                DISC_COL, TEXT_ALIGN_CENTER)
        else
            surface.SetMaterial(camRTMat)
            surface.SetDrawColor(255, 255, 255, 255)
            surface.DrawTexturedRect(VP_X, VP_Y, VP_W, VP_H)
        end

        TX("КАМЕРА " .. selCam .. " - " .. cd.name,
            "CamSys_HUD", VP_X + 8, VP_Y + 10, WHITE)

        if not cd.broken then
            if recBlink then
                surface.SetDrawColor(REC_COL)
                surface.DrawRect(VP_X + VP_W - 48, VP_Y + 8, 8, 8)
            end
            TX("REC", "CamSys_HUD", VP_X + VP_W - 36, VP_Y + 10, REC_COL)
        end

        TX(os.date("%d/%m/%Y  %H:%M:%S"),
            "CamSys_HUD", VP_X + 8, VP_Y + VP_H - 10, TS_COL)
    end

    frame.Think = function(self)
        local t = RealTime()
        if t - recTimer > 0.55 then
            recBlink = not recBlink
            recTimer = t
        end
        if CAMERAS[selCam].broken and t - noiseTick > NOISE_RATE then
            noiseTick = t
            RebuildNoise()
        end
    end

    hook.Add("RenderScene", "CamSys_RT", function()
        if rtRendering then return end
        if not isOpen or not IsValid(frame) then
            hook.Remove("RenderScene", "CamSys_RT")
            return
        end
        if CAMERAS[selCam].broken then return end

        rtRendering = true

        local cd  = CAMERAS[selCam]
        local ang = Angle(cd.ang.p + camPitch, cd.ang.y + camYaw, 0)

        local oldW, oldH = ScrW(), ScrH()
        render.PushRenderTarget(camRT)
        render.SetViewPort(0, 0, 1024, 768)
        render.Clear(0, 0, 0, 255, true)
        local oldWriteDepth = render.SetWriteDepthToDestAlpha(false)
        render.RenderView({
            origin        = cd.pos,
            angles        = ang,
            fov           = camFOV,
            drawviewmodel = false,
            dopostprocess = false,
        })
        render.SetWriteDepthToDestAlpha(oldWriteDepth)
        render.SetViewPort(0, 0, oldW, oldH)
        render.PopRenderTarget()

        rtRendering = false
    end)

    local btnY = 56
    for i = 1, CAM_COUNT do
        local cd  = CAMERAS[i]
        local btn = vgui.Create("DButton", frame)
        btn:SetPos(8, btnY)
        btn:SetSize(SIDEBAR_W - 16, 44)
        btn:SetText("")

        local hov = false
        btn.OnCursorEntered = function() hov = true  end
        btn.OnCursorExited  = function() hov = false end

        local idx = i
        btn.DoClick = function()
            selCam   = idx
            camYaw   = 0
            camPitch = 0
            camFOV   = FOV_DEF
        end

        btn.Paint = function(self, w, h)
            local isAct = (selCam == idx)
            local col   = isAct and BTN_ACT or (hov and BTN_HOV or BTN)
            RR(0, 0, w, h, 22, col)
            TX(cd.name, "CamSys_Btn", w * 0.5, h * 0.5, WHITE, TEXT_ALIGN_CENTER)
            RR(w - 20, h * 0.5 - 5, 10, 10, 5, cd.broken and DOT_RED or DOT_GRN)
        end

        btnY = btnY + 50
    end

    MakeBtn(frame, 8, PANEL_H - 50, SIDEBAR_W - 16, 38,
        "←  ВЫЙТИ", "CamSys_Btn", 19, Close)

    local ctrlY = VP_Y + VP_H + 10

    MakeBtn(frame, VP_X, ctrlY, 90, 38,
        "←——", "CamSys_Btn", 6,
        function() camYaw = math.Clamp(camYaw + 15, -YAW_LIMIT, YAW_LIMIT) end)

    MakeBtn(frame, VP_X + 98, ctrlY, 90, 38,
        "——→", "CamSys_Btn", 6,
        function() camYaw = math.Clamp(camYaw - 15, -YAW_LIMIT, YAW_LIMIT) end)

    local zx = VP_X + VP_W - 266

    MakeBtn(frame, zx, ctrlY, 130, 38,
        "ПРИБЛИЗИТЬ", "CamSys_ZoomBtn", 5,
        function() camFOV = math.Clamp(camFOV - 5, FOV_MIN, FOV_MAX) end)

    MakeBtn(frame, zx + 136, ctrlY, 130, 38,
        "ОТДАЛИТЬ", "CamSys_ZoomBtn", 5,
        function() camFOV = math.Clamp(camFOV + 5, FOV_MIN, FOV_MAX) end)

    isOpen = true
end

net.Receive("CamersSystem_Open", function()
    if not isOpen then ShowLoginScreen() end
end)

net.Receive("CamersSystem_SyncBroken", function()
    local idx = net.ReadUInt(4)
    CAMERAS[idx].broken = net.ReadBool()
end)

net.Receive("CamersSystem_SyncAll", function()
    for i = 1, CAM_COUNT do
        CAMERAS[i].broken = net.ReadBool()
    end
end)

hook.Add("HUDPaint", "CamSys_WorldHUD", function()
    local ply = LocalPlayer()
    if not IsValid(ply) or not ply:Alive() then
        repairStart = nil
        return
    end

    local isCP    = IsPolice(ply)
    local plyPos  = ply:GetPos()

    if isCP then
        for i = 1, CAM_COUNT do
            if CAMERAS[i].broken then
                local scrPos = CAMERAS[i].pos:ToScreen()
                if scrPos.visible then
                    local label = "! " .. CAMERAS[i].name .. " - СЛОМАНА"
                    surface.SetFont("CamSys_Marker")
                    local tw, th = surface.GetTextSize(label)
                    local sx, sy = scrPos.x, scrPos.y
                    draw.RoundedBox(4, sx - tw / 2 - 8, sy - th / 2 - 4,
                        tw + 16, th + 8, MRK_BG)
                    draw.SimpleText(label, "CamSys_Marker", sx, sy,
                        MRK_COL, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
                    local dist = math.floor(plyPos:Distance(CAMERAS[i].pos) / 40)
                    draw.SimpleText(dist .. " м", "CamSys_ZoomBtn", sx, sy + th / 2 + 6,
                        MRK_COL, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
                end
            end
        end
    end

    if not isCP then
        repairStart = nil
        return
    end

    local nearIdx = nil
    for i = 1, CAM_COUNT do
        if CAMERAS[i].broken and plyPos:DistToSqr(CAMERAS[i].pos) < REPAIR_DIST_SQR then
            nearIdx = i
            break
        end
    end

    if not nearIdx then
        repairStart = nil
        return
    end

    local sw, sh = ScrW(), ScrH()
    local rt = RealTime()

    if ply:KeyDown(IN_USE) then
        if not repairStart then
            repairStart = rt
        end

        local progress = math.Clamp((rt - repairStart) / REPAIR_TIME, 0, 1)
        local bw, bh = 200, 20
        local bx = sw / 2 - bw / 2
        local by = sh / 2 + 50

        surface.SetDrawColor(0, 0, 0, 200)
        surface.DrawRect(bx, by, bw, bh)
        surface.SetDrawColor(BLUE)
        surface.DrawRect(bx + 2, by + 2, (bw - 4) * progress, bh - 4)

        draw.SimpleText("ПОЧИНКА...", "CamSys_Repair",
            sw / 2, by - 15, WHITE, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    else
        repairStart = nil
        draw.SimpleText("Нажмите [E] для починки", "CamSys_Repair",
            sw / 2, sh / 2 + 50, WHITE, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end
end)

concommand.Add("camers_open", function(ply)
    if not IsValid(ply) or not ply:IsSuperAdmin() then return end
    if not isOpen then ShowLoginScreen() end
end)