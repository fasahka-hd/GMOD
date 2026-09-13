surface.CreateFont("OrbitUI_Title", {font = "Roboto", size = 24, weight = 800, extended = true})
surface.CreateFont("OrbitUI_Btn", {font = "Roboto", size = 18, weight = 500, extended = true})
surface.CreateFont("OrbitUI_Warn", {font = "Roboto", size = 16, weight = 500, extended = true})

ORBIT_EFFECTS_LIST = ORBIT_EFFECTS_LIST or {}

local cvQuality = CreateClientConVar("orbit_fx_quality", "1", true, false, "Orbit client FX quality", 0, 1)

ORBIT_MATS = ORBIT_MATS or {}
ORBIT_MATS.glow = Material("sprites/light_glow02_add")
ORBIT_MATS.beam = Material("trails/laser") or ORBIT_MATS.glow

function Orbit_Register(id, name, func)
    if not id or not name then return end
    ORBIT_EFFECTS_LIST[id] = {name = name, func = func}
end

function Orbit_GetQuality()
    return cvQuality:GetBool()
end

function Orbit_Pos(ply, index, speed, radius, height, bob, phase)
    local t = CurTime()
    local a = t * speed + index * 2.094395102 + (phase or 0)
    return ply:GetPos() + Vector(math.cos(a) * radius, math.sin(a) * radius, height + math.sin(t * 2.1 + index) * (bob or 8)), a
end

function Orbit_SetGlow()
    render.SetMaterial(ORBIT_MATS.glow or Material("sprites/light_glow02_add"))
end

function Orbit_SetBeam()
    render.SetMaterial(ORBIT_MATS.beam or ORBIT_MATS.glow or Material("sprites/light_glow02_add"))
end

function Orbit_Orb(pos, size, main, core)
    Orbit_SetGlow()
    render.DrawSprite(pos, size * 2.0, size * 2.0, Color(main.r, main.g, main.b, 42))
    render.DrawSprite(pos, size * 1.05, size * 1.05, Color(main.r, main.g, main.b, 150))
    render.DrawSprite(pos, size * 0.35, size * 0.35, Color(core.r, core.g, core.b, 245))
end

function Orbit_Comet(pos, angle, size, main, core, tail)
    tail = tail or 32
    local back = pos - Vector(math.cos(angle), math.sin(angle), 0) * tail
    Orbit_SetBeam()
    render.DrawBeam(back, pos, math.max(3, size * 0.13), 0, 1, Color(main.r, main.g, main.b, 135))
    Orbit_Orb(pos, size, main, core)
end

function Orbit_Sparks(center, count, radius, col, size, speed, seed)
    if not Orbit_GetQuality() then return end
    local t = CurTime()
    Orbit_SetGlow()
    for i = 1, count do
        local k = i / count
        local a = t * speed + k * math.pi * 2 + seed
        local r = radius * (0.55 + 0.45 * math.sin(t * 1.3 + i + seed))
        local p = center + Vector(math.cos(a) * r, math.sin(a) * r, math.sin(a * 1.6 + seed) * radius * 0.25)
        render.DrawSprite(p, size, size, col)
    end
end

function Orbit_Beam(a, b, width, col)
    if not Orbit_GetQuality() then return end
    Orbit_SetBeam()
    render.DrawBeam(a, b, width or 3, 0, 1, col)
end

hook.Add("PostPlayerDraw", "OrbitRenderCore", function(ply)
    if not IsValid(ply) or not ply:Alive() then return end
    local lp = LocalPlayer()
    if not IsValid(lp) then return end
    local fxID = ply:GetNWInt("OrbitFX", 0)
    if fxID == 0 then return end
    if lp:GetPos():DistToSqr(ply:GetPos()) > 1800000 then return end
    local fx = ORBIT_EFFECTS_LIST[fxID]
    if fx and fx.func then fx.func(ply) end
end)

local blur = Material("pp/blurscreen")
local function DrawBlur(panel, amount)
    if not blur then return end
    local x, y = panel:LocalToScreen(0, 0)
    local scrW, scrH = ScrW(), ScrH()
    surface.SetDrawColor(255, 255, 255)
    surface.SetMaterial(blur)
    for i = 1, 3 do
        blur:SetFloat("$blur", (i / 3) * (amount or 6))
        blur:Recompute()
        render.UpdateScreenEffectTexture()
        surface.DrawTexturedRect(x * -1, y * -1, scrW, scrH)
    end
end

concommand.Add("orbit_menu", function()
    if not IsValid(LocalPlayer()) then return end
    local frame = vgui.Create("DFrame")
    frame:SetSize(800, 500)
    frame:Center()
    frame:SetTitle("")
    frame:MakePopup()
    frame:ShowCloseButton(false)

    frame.Paint = function(s, w, h)
        DrawBlur(s, 5)
        draw.RoundedBox(0, 0, 0, w, h, Color(25, 25, 25, 240))
        draw.RoundedBox(0, 0, 0, 250, h, Color(35, 35, 35, 200))
        draw.RoundedBox(0, 0, 0, w, 50, Color(0, 0, 0, 150))
        draw.SimpleText("ДОСТУПНЫЕ ЭФФЕКТЫ", "OrbitUI_Title", 15, 25, Color(255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
    end

    local btnClose = vgui.Create("DButton", frame)
    btnClose:SetPos(750, 0)
    btnClose:SetSize(50, 50)
    btnClose:SetText("✕")
    btnClose:SetFont("OrbitUI_Btn")
    btnClose:SetTextColor(Color(200, 200, 200))
    btnClose.Paint = function(s, w, h)
        if s:IsHovered() then draw.RoundedBox(0, 0, 0, w, h, Color(200, 50, 50, 200)) end
    end
    btnClose.DoClick = function() frame:Close() end

    local scroll = vgui.Create("DScrollPanel", frame)
    scroll:SetPos(0, 50)
    scroll:SetSize(250, 450)
    scroll:GetCanvas():SetPos(0, 0)

    local selectedID = 0
    local labelStatus

    local function AddItem(id, name)
        local btn = scroll:Add("DButton")
        btn:SetText("")
        btn:Dock(TOP)
        btn:SetHeight(45)
        btn:DockMargin(0, 0, 0, 1)
        btn.Paint = function(s, w, h)
            local isSel = selectedID == id
            if isSel then
                draw.RoundedBox(0, 0, 0, w, h, Color(0, 140, 255, 60))
                draw.RoundedBox(0, 0, 0, 4, h, Color(0, 140, 255))
            elseif s:IsHovered() then
                draw.RoundedBox(0, 0, 0, w, h, Color(255, 255, 255, 10))
            end
            local color = isSel and Color(255, 255, 255) or Color(180, 180, 180)
            draw.SimpleText(string.upper(name), "OrbitUI_Btn", 15, h / 2, color, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
        end
        btn.DoClick = function()
            selectedID = id
            if IsValid(labelStatus) then labelStatus:SetText(id == 0 and "ОТКЛЮЧЕНО" or string.upper(name)) end
        end
    end

    AddItem(0, "Отключить")
    for id, v in SortedPairs(ORBIT_EFFECTS_LIST) do
        if LocalPlayer():GetNWBool("Orbit_Has_" .. id, false) then AddItem(id, v.name) end
    end

    local pnlRight = vgui.Create("DPanel", frame)
    pnlRight:SetPos(250, 50)
    pnlRight:SetSize(550, 450)
    pnlRight.Paint = function() end

    labelStatus = vgui.Create("DLabel", pnlRight)
    labelStatus:SetPos(0, 100)
    labelStatus:SetSize(550, 40)
    labelStatus:SetFont("OrbitUI_Title")
    labelStatus:SetText("ВЫБЕРИТЕ ЭФФЕКТ")
    labelStatus:SetContentAlignment(5)

    local btnApply = vgui.Create("DButton", pnlRight)
    btnApply:SetPos(125, 200)
    btnApply:SetSize(300, 60)
    btnApply:SetText("ПРИМЕНИТЬ")
    btnApply:SetFont("OrbitUI_Title")
    btnApply:SetTextColor(Color(255, 255, 255))
    btnApply.Paint = function(s, w, h)
        local col = s:IsHovered() and Color(0, 180, 100) or Color(0, 150, 80)
        draw.RoundedBox(6, 0, 0, w, h, col)
    end
    btnApply.DoClick = function()
        net.Start("Orbit_UpdateEffect")
        net.WriteUInt(selectedID, 4)
        net.SendToServer()
        frame:Close()
    end
end)

net.Receive("Orbit_OpenCrafting", function()
    local frame = vgui.Create("DFrame")
    frame:SetSize(400, 500)
    frame:Center()
    frame:SetTitle("СТОЛ КРАФТА")
    frame:MakePopup()

    local scroll = vgui.Create("DScrollPanel", frame)
    scroll:Dock(FILL)

    for id, v in SortedPairs(ORBIT_EFFECTS_LIST) do
        local has = LocalPlayer():GetNWBool("Orbit_Has_" .. id, false)
        local btn = scroll:Add("DButton")
        btn:SetText(v.name .. (has and " (УЖЕ ЕСТЬ)" or ""))
        btn:Dock(TOP)
        btn:SetHeight(40)
        btn:SetEnabled(not has)
        btn.DoClick = function()
            net.Start("Orbit_DoCraft")
            net.WriteUInt(id, 4)
            net.SendToServer()
            frame:Close()
        end
    end
end)
