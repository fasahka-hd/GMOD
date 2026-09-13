--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

local PANEL = {}

function PANEL:Init()
    self.color = ColorAlpha(eui.Color('181A1D'), 255)
    self.lerpColor = ColorAlpha(eui.Color('FF4C78'), 255)

    self.clr = self.color

    self.min = 100
    self.max = 100
    self.rounded = 6
    self.alpha = self.min

    self.cacheAlphaMin = self.min * 2.55
    self.cacheAlphaMax = self.max * 2.55
end

function PANEL:OnCursorEntered()
    if self.cursor ~= 'hand' then
        self.cursor = 'hand'
        self:SetCursor(self.cursor)
    end
    chat.PlaySound()
end

function PANEL:OnCursorExited()
    if self.cursor ~= 'arrow' then
        self.cursor = 'arrow'
        self:SetCursor(self.cursor)
    end
end

function PANEL:SetSelected(sel)
    self.selected = sel
end

function PANEL:SetInfo(text, font)
    if IsValid(self.label) then
        self.label:Remove()
    end

    self.label = vgui.Create('eui.Label', self)
    self.label:Dock(FILL)
    self.label:SetInfo(text, font)
    self.label:SetContentAlignment(5)
end

function PANEL:SetTextColor(color)
    if self.label then
        self.label:SetColor(color)
    end
end

function PANEL:SetColor(color)
    self.color = color
    self.clr = color
end

function PANEL:SetHover(min, max)
    self.min = min
    self.max = max
    self.alpha = self.min

    self.cacheAlphaMin = self.min * 2.55
    self.cacheAlphaMax = self.max * 2.55
end

function PANEL:SetHoverColor(color)
    self.lerpColor = color
end

function PANEL:SetRounded(rounded)
    self.rounded = rounded
end

function PANEL:SetClick()
    self.click = true
end

function PANEL:Paint(w, h)
    local hovered = self:IsHovered() or self.hover
    local tickInterval = engine.TickInterval()

    if (hovered or self.selected) and self.lerpColor then
        self.clr = self.clr:Lerp(self.lerpColor, tickInterval)
        self.alpha = eui.Lerp(self.alpha, self.cacheAlphaMax)
    elseif hovered then
        self.alpha = eui.Lerp(self.alpha, self.cacheAlphaMax)
    elseif not hovered and self.lerpColor then
        self.clr = self.clr:Lerp(self.color, tickInterval)
        self.alpha = eui.Lerp(self.alpha, self.cacheAlphaMin)
    else
        self.alpha = eui.Lerp(self.alpha, self.cacheAlphaMin)
    end

    local x, y = self:LocalToScreen(0, 0)

    eui.Mask(function()
        paint.roundedBoxes.roundedBox(self.rounded, x, y, w, h, ColorAlpha(self.clr, self.alpha))
    end, function()
        local ripple = self.ripple
        if not ripple then return end

        local rippleX, rippleY, rippleStart = ripple[1], ripple[2], ripple[3]
        local percent = (RealTime() - rippleStart)

        if percent >= 1 then
            self.ripple = nil
        else
            local alpha = 50 * (1 - percent)
            local rad = math.max(w, h) * percent * math.sqrt(2)

            paint.circles.drawCircle(x + rippleX - rad, y + rippleY - rad, rad * 2, rad * 2, ColorAlpha(color_white, alpha))
        end
    end)
end

function PANEL:OnMousePressed(key)
    if key == MOUSE_LEFT and self.click then
        local posX, posY = self:LocalCursorPos()
        self.ripple = {posX, posY, RealTime()}
    end

    if self.DoClick then
        self:DoClick()
    end
end

vgui.Register('eui.Button', PANEL, 'Panel')

--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
