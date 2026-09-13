local escFrame
local allowDefaultEsc = false
local allowDefaultStarted = 0
local RULES_URL = "https://docs.google.com/document/d/1zyht-meuvia7VClHJEc-g_AmlxskMTVK/edit#heading=h.2i1iwggc87k6"

local function scaleW(v)
    return ScrW() * v / 1921
end

local function scaleH(v)
    return ScrH() * v / 1080
end

local function scale(v)
    return math.Round(v * math.min(ScrW(), ScrH()) / 1080)
end

local function makeButton(parent, text, x, y, w, h, color, hoverColor, textColor, callback)
    local btn = vgui.Create("DButton", parent)
    btn:SetPos(x, y)
    btn:SetSize(w, h)
    btn:SetText("")
    btn.Hover = 0

    btn.Paint = function(self, bw, bh)
        self.Hover = math.Clamp(self:IsHovered() and self.Hover + FrameTime() * 8 or self.Hover - FrameTime() * 8, 0, 1)
        local col = Color(
            Lerp(self.Hover, color.r, hoverColor.r),
            Lerp(self.Hover, color.g, hoverColor.g),
            Lerp(self.Hover, color.b, hoverColor.b),
            Lerp(self.Hover, color.a, hoverColor.a)
        )

        draw.RoundedBox(scale(20), 0, 0, bw, bh, col)
        draw.SimpleText(text, "DermaLarge", bw * 0.5, bh * 0.5, textColor or color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end

    btn.DoClick = callback
    return btn
end

local rulesFrame

local function closeCustomEsc()
    if IsValid(escFrame) then
        escFrame:Remove()
    end

    escFrame = nil
    gui.EnableScreenClicker(false)
end

local function enableDefaultEscMode()
    allowDefaultEsc = true
    allowDefaultStarted = CurTime()
end

local function openDefaultEsc()
    enableDefaultEscMode()
    closeCustomEsc()

    timer.Simple(0, function()
        gui.ActivateGameUI()
    end)
end

local function openRules()
    closeCustomEsc()
    gui.OpenURL(RULES_URL)
end

local function openSettings()
    enableDefaultEscMode()
    closeCustomEsc()

    timer.Simple(0, function()
        gui.ActivateGameUI()

        timer.Simple(0.05, function()
            RunConsoleCommand("gamemenucommand", "openoptionsdialog")
        end)
    end)
end

local function openDonate()
    RunConsoleCommand("say", "/donate")
end

local function openCustomEsc()
    if IsValid(escFrame) then return end

    gui.HideGameUI()

    local fr = vgui.Create("EditablePanel")
    escFrame = fr
    fr:SetSize(ScrW(), ScrH())
    fr:SetPos(0, 0)
    fr:MakePopup()
    fr:SetKeyboardInputEnabled(true)
    fr:SetMouseInputEnabled(true)

    fr.OnKeyCodePressed = function(_, key)
        if key == KEY_ESCAPE then
            closeCustomEsc()
        end
    end

    fr.Paint = function(_, w, h)
        surface.SetDrawColor(15, 15, 15, 178)
        surface.DrawRect(0, 0, w, h)


    end

    local gray = Color(148, 147, 147, 64)
    local grayHover = Color(148, 147, 147, 95)
    local red = Color(218, 62, 68, 255)
    local redHover = Color(235, 80, 85, 255)
    local menuX = scaleW(34)
    local menuW = scaleW(400)
    local menuH = scaleH(74)
    local menuGap = scaleH(14)
    local buttonCount = 5
    local menuBottomMargin = scaleH(34)
    local menuTotalHeight = menuH * buttonCount + menuGap * (buttonCount - 1)
    local menuY = ScrH() - menuTotalHeight - menuBottomMargin

    makeButton(fr, "Вернуться", menuX, menuY, menuW, menuH, gray, grayHover, color_white, closeCustomEsc)
    makeButton(fr, "Правила", menuX, menuY + (menuH + menuGap) * 1, menuW, menuH, gray, grayHover, color_white, openRules)
    makeButton(fr, "Настройки", menuX, menuY + (menuH + menuGap) * 2, menuW, menuH, gray, grayHover, color_white, openSettings)
    makeButton(fr, "Старый ESC", menuX, menuY + (menuH + menuGap) * 3, menuW, menuH, gray, grayHover, color_white, openDefaultEsc)
    makeButton(fr, "Выйти", menuX, menuY + (menuH + menuGap) * 4, menuW, menuH, red, redHover, color_white, function()
        RunConsoleCommand("disconnect")
    end)
end

local function isConsoleVisible()
    return gui.IsConsoleVisible and gui.IsConsoleVisible()
end

local function interceptDefaultEsc()
    if allowDefaultEsc then return end
    if isConsoleVisible() then return end

    if gui.IsGameUIVisible() then
        gui.HideGameUI()

        if IsValid(escFrame) then
            closeCustomEsc()
        else
            openCustomEsc()
        end
    end
end

hook.Add("OnPauseMenuShow", "Arizona.CustomESC.OnPauseMenuShow", function()
    if allowDefaultEsc then return end

    if IsValid(escFrame) then
        gui.HideGameUI()
        closeCustomEsc()
        return false
    end

    timer.Simple(0, function()
        gui.HideGameUI()
        openCustomEsc()
    end)

    return false
end)

hook.Add("GameUIOpened", "Arizona.CustomESC.GameUIOpened", function()
    if allowDefaultEsc then return end
    if isConsoleVisible() then return end

    if IsValid(escFrame) then
        timer.Simple(0, function()
            gui.HideGameUI()
            closeCustomEsc()
        end)
        return
    end

    timer.Simple(0, function()
        if allowDefaultEsc or isConsoleVisible() then return end
        gui.HideGameUI()
        openCustomEsc()
    end)
end)

hook.Add("PlayerBindPress", "Arizona.CustomESC.AllowConsole", function(_, bind, pressed)
    if not pressed then return end
    if not string.find(string.lower(bind or ""), "toggleconsole", 1, true) then return end

    enableDefaultEscMode()
end)

hook.Add("PreRender", "Arizona.CustomESC.PreRender", interceptDefaultEsc)

hook.Add("Think", "Arizona.CustomESC.DefaultMonitor", function()
    if not allowDefaultEsc then return end
    if CurTime() - allowDefaultStarted < 0.75 then return end
    if gui.IsGameUIVisible() then return end
    if isConsoleVisible() then return end

    allowDefaultEsc = false
end)

concommand.Add("arizona_esc", openCustomEsc)