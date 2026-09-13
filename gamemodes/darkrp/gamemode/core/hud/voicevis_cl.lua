-- Voice HUD override for DarkRP
-- Белая полупрозрачная закруглённая плашка + плавная громкость.

local PANEL = {}
local PlayerVoicePanels = {}

surface.CreateFont("DarkRPVoiceNotify.Name", {
    font = "Exo 2",
    size = 18,
    weight = 700,
    extended = true,
    antialias = true
})

surface.CreateFont("DarkRPVoiceNotify.Small", {
    font = "Exo 2",
    size = 12,
    weight = 600,
    extended = true,
    antialias = true
})

local VoicePanelWide = 248
local VoicePanelTall = 45

local colWhite = Color(220, 220, 220, 118)
local colWhiteHover = Color(220, 220, 220, 138)
local colText = Color(255, 255, 255, 235)
local colTextMuted = Color(255, 255, 255, 145)
local colBarBack = Color(0, 0, 0, 32)
local colAccent = Color(98, 65, 228, 215)
local colAccentGlow = Color(98, 65, 228, 42)

local function CreatePanel(class, parent)
    if class == "AvatarImage" then
        return vgui.Create(class, parent)
    end

    if ui and ui.Create then
        return ui.Create(class, parent)
    end

    return vgui.Create(class, parent)
end

local function GetVoiceName(pl)
    if not IsValid(pl) then return "" end

    local prefix = pl:GetNetVar("RC_RadioOnSpeak") and "[РАЦИЯ] " or ""
    local jobTable = pl.GetJobTable and pl:GetJobTable() or nil

    if jobTable and jobTable.reversed and pl.GetJobName then
        return prefix .. pl:GetJobName()
    end

    return prefix .. pl:Nick()
end

function PANEL:Init()
    self.SmoothVolume = 0

    self.Avatar = CreatePanel("AvatarImage", self)
    self.Avatar:SetSize(34, 34)
    self.Avatar:SetPos(6, 6)
    self.Avatar:SetPaintedManually(true)

    self.LabelName = CreatePanel("DLabel", self)
    self.LabelName:SetFont("DarkRPVoiceNotify.Name")
    self.LabelName:SetTextColor(colText)
    self.LabelName:SetPos(50, 5)
    self.LabelName:SetSize(VoicePanelWide - 62, 21)
    self.LabelName:SetContentAlignment(4)

    self.LabelHint = CreatePanel("DLabel", self)
    self.LabelHint:SetFont("DarkRPVoiceNotify.Small")
    self.LabelHint:SetTextColor(colTextMuted)
    self.LabelHint:SetText("Говорит")
    self.LabelHint:SetPos(50, 24)
    self.LabelHint:SetSize(66, 15)
    self.LabelHint:SetContentAlignment(4)

    self:SetSize(VoicePanelWide, VoicePanelTall)
    self:DockPadding(0, 0, 0, 0)
    self:DockMargin(0, 4, 0, 4)
    self:Dock(BOTTOM)
end

function PANEL:Setup(pl)
    self.pl = pl
    self.VoiceBars = {}
    self.NextBarUpdate = 0
    self.LabelName:SetText(GetVoiceName(pl))
    self.Avatar:SetPlayer(pl, 64)
    self.Avatar:SetPaintedManually(true)
    self:InvalidateLayout()
end

function PANEL:Paint(w, h)
    if not IsValid(self.pl) then return end

    local targetVolume = math.Clamp(self.pl:VoiceVolume() * 1.35, 0, 1)
    self.SmoothVolume = Lerp(FrameTime() * 14, self.SmoothVolume or 0, targetVolume)

    -- Только скруглённые боксы, без квадратного outline — так не появляются полупрозрачные углы.
    -- Цвет как в макете: #949393 с opacity 0.25, без плотной белой заливки.
    draw.RoundedBox(20, 0, 0, w, h, self:IsHovered() and colWhiteHover or colWhite)

    -- Закруглённая аватарка через stencil.
    render.ClearStencil()
    render.SetStencilEnable(true)
    render.SetStencilWriteMask(255)
    render.SetStencilTestMask(255)
    render.SetStencilReferenceValue(1)
    render.SetStencilCompareFunction(STENCIL_ALWAYS)
    render.SetStencilPassOperation(STENCIL_REPLACE)
    render.SetStencilFailOperation(STENCIL_KEEP)
    render.SetStencilZFailOperation(STENCIL_KEEP)

    render.OverrideColorWriteEnable(true, false)
    draw.RoundedBox(18, 6, 6, 34, 34, color_white)
    render.OverrideColorWriteEnable(false, false)

    render.SetStencilCompareFunction(STENCIL_EQUAL)
    render.SetStencilPassOperation(STENCIL_KEEP)
    self.Avatar:PaintManual()
    render.SetStencilEnable(false)
    render.ClearStencil()

    draw.RoundedBox(18, 6, 6, 34, 34, Color(255, 255, 255, 34))

    self.VoiceBars = self.VoiceBars or {}
    if (self.NextBarUpdate or 0) < CurTime() then
        self.NextBarUpdate = CurTime() + 0.028

        if #self.VoiceBars >= 19 then
            table.remove(self.VoiceBars, 19)
        end

        local add = self.SmoothVolume
        if self.pl == LocalPlayer() and add < 0.02 then
            add = math.Rand(0.02, 0.08)
        end

        table.insert(self.VoiceBars, 1, add)
    end

    local waveX = 112
    local waveY = h - 14
    local count = 19
    local barW = 3
    local gap = 3
    local maxH = 18

    for i = 1, count do
        local value = self.VoiceBars[i] or 0
        local barH = math.max(3, math.floor(value * maxH))
        local x = waveX + (i - 1) * (barW + gap)
        local alpha = 60 + math.floor(value * 155)

        draw.RoundedBox(3, x, waveY - barH * 0.5, barW, barH, Color(98, 65, 228, alpha))
    end

    -- Точка-индикатор слева от волны, тоже плавно реагирует на голос.
    local dotAlpha = 70 + math.floor(self.SmoothVolume * 140)
    draw.RoundedBox(5, 100, h - 19, 9, 9, Color(98, 65, 228, dotAlpha))
end

function PANEL:Think()
    if IsValid(self.pl) then
        self.LabelName:SetText(GetVoiceName(self.pl))
    else
        self:Remove()
        return
    end

    if self.fadeAnim then
        self.fadeAnim:Run()
    end
end

function PANEL:FadeOut(anim, delta)
    if anim.Finished then
        if IsValid(PlayerVoicePanels[self.pl]) then
            PlayerVoicePanels[self.pl]:Remove()
            PlayerVoicePanels[self.pl] = nil
        end

        return
    end

    self:SetAlpha(255 - (255 * delta))
end

derma.DefineControl("VoiceNotify", "", PANEL, "DPanel")

local function DarkRPVoiceStart(pl)
    if not IsValid(g_VoicePanelList) then return end

    DarkRPVoiceEnd(pl)

    if IsValid(PlayerVoicePanels[pl]) then
        if PlayerVoicePanels[pl].fadeAnim then
            PlayerVoicePanels[pl].fadeAnim:Stop()
            PlayerVoicePanels[pl].fadeAnim = nil
        end

        PlayerVoicePanels[pl]:SetAlpha(255)
        return
    end

    if not IsValid(pl) then return end

    local pnl = g_VoicePanelList:Add("VoiceNotify")
    pnl:Setup(pl)
    PlayerVoicePanels[pl] = pnl
end

function DarkRPVoiceEnd(pl)
    if IsValid(PlayerVoicePanels[pl]) then
        if PlayerVoicePanels[pl].fadeAnim then return end

        PlayerVoicePanels[pl].fadeAnim = Derma_Anim("FadeOut", PlayerVoicePanels[pl], PlayerVoicePanels[pl].FadeOut)
        PlayerVoicePanels[pl].fadeAnim:Start(1.2)
    end
end

hook.Add("PlayerStartVoice", "DarkRPVoiceNotify.Start", DarkRPVoiceStart)
hook.Add("PlayerEndVoice", "DarkRPVoiceNotify.End", DarkRPVoiceEnd)

local function CreateVoiceVGUI()
    if IsValid(g_VoicePanelList) then
        g_VoicePanelList:Remove()
    end

    local listH = ScrH() * 0.36

    g_VoicePanelList = CreatePanel("DPanel")
    g_VoicePanelList:ParentToHUD()
    g_VoicePanelList:SetPos(ScrW() - VoicePanelWide - 30, ScrH() - listH - 95)
    g_VoicePanelList:SetSize(VoicePanelWide, listH)
    g_VoicePanelList:SetPaintBackground(false)
    g_VoicePanelList.Paint = function() end
end

hook.Add("InitPostEntity", "DarkRPVoiceNotify.Create", function()
    timer.Simple(0, CreateVoiceVGUI)
end)

hook.Add("OnScreenSizeChanged", "DarkRPVoiceNotify.Create", CreateVoiceVGUI)

timer.Simple(1, function()
    if not IsValid(g_VoicePanelList) then
        CreateVoiceVGUI()
    end
end)

timer.Create("DarkRPVoiceNotify.Clean", 10, 0, function()
    for pl in pairs(PlayerVoicePanels) do
        if not IsValid(pl) then
            DarkRPVoiceEnd(pl)
        end
    end
end)