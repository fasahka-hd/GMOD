--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

local PANEL = {}

local roundedBox = paint.roundedBoxes.roundedBox
local roundedBoxEx = paint.roundedBoxes.roundedBoxEx
local scrW, scrH = ScrW(), ScrH()

hook.Add('OnScreenSizeChanged', 'eui.FrameScreenSizi', function(_, _, w, h)
    scrW, scrH = w, h
end)

function PANEL:Init()
    self:SetAlpha(0)
    self:AlphaTo(255, 0.3, 0)
    self.opening = true

    self.clr = eui.Color('0F0F0F')
    self.rounded = 0
end

function PANEL:SetColor(clr)
    self.clr = clr
end

function PANEL:SetRounded(rounded)
    self.rounded = rounded
end

do
    local roundedBox = paint.roundedBoxes.roundedBox

    function PANEL:Paint(w, h)
        local alpha = surface.GetAlphaMultiplier()
        local x, y = self:LocalToScreen(0, 0)
    
        roundedBox(self.rounded, x, y, w, h, self.clr) 
    end
end


function PANEL:RunAnimation()
    self:SetPos(scrW / 2 - self:GetWide() / 2, scrH / 2 + self:GetTall() / 2)
    self:MoveTo(scrW / 2 - self:GetWide() / 2, scrH / 2 - self:GetTall() / 2, 0.6, 0, 0.2, function()
        self.opening = false
    end)
end

function PANEL:SetCloseButton(but)
    self.closeButton = but
end

function PANEL:Think()
    if not self.closeButton then return end
    if self.opening then return end

    if istable(self.closeButton) then
        for k, v in ipairs(self.closeButton) do
            if not input.IsKeyDown(v) then continue end

            self:Close()
        end

        return
    end

    if input.IsKeyDown(self.closeButton) then
        self:Close()
    end
end

function PANEL:Close()
    self:MoveTo(scrW / 2 - self:GetWide() / 2, scrH / 2 + self:GetTall(), 0.6, 0, 0.3)
    self:AlphaTo(0, 0.3, 0, function()
        self:Remove()
    end)
    if self.closeButton == KEY_ESCAPE then
        gui.HideGameUI()
    end
end

vgui.Register('eui.Frame', PANEL, 'EditablePanel')

--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
