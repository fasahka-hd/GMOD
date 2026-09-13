--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

local PANEL = {}

local roundedBox = paint.roundedBoxes.roundedBox

local scrW, scrH = ScrW(), ScrH()

function PANEL:Init()
    self.rounded = 10
    self.color = eui.Color('FF4C78')
end

function PANEL:SetRounded(rounded)
    self.roudned = rounded
end

function PANEL:SetColor(color)
    self.color = color
end

ALIGN_ICON_LEFT = 0
ALIGN_ICON_CENTER = 1
ALIGN_ICON_RIGHT = 2

function PANEL:SetIcon(icon, w, h, align, offset)
    self.icon = self:Add('Panel')
    self.icon:Dock(LEFT)
    self.icon:Margin(align == 0 and offset, 0, align == 2 and offset)
    self.icon:SetWide(w)
    function self.icon.PerformLayout(s)
        s:SetTall(h)

        if align == 1 then
            s:CenterHorizontal()
        end

        s:CenterVertical()
    end
    function self.icon:Paint(w, h)
        eui.DrawMaterial(icon, 0, 0, w, h) 
    end
end

function PANEL:SetInfo(text, font, dock, align, offset, offset2)
    if istable(text) then 
        for k, v in next, text do
            self.label = self:Add('eui.Label')
            self.label:Dock(dock)
            self.label:Margin(v[2], 0, offset2)
            self.label:SetInfo(v[1], v[3] or font)

            if not align then return end
            self.label:SetContentAlignment(align)
        end

        return 
    end

    self.label = self:Add('eui.Label')
    self.label:Dock(dock)
    self.label:Margin(offset, 0, offset2)
    self.label:SetInfo(text, font)

    if not align then return end
    self.label:SetContentAlignment(align)
end

function PANEL:SetTextMaterial(icon, w, h, text, font, align, offset, offset1)
    self.icon = self:Add('Panel')
    self.icon:SetSize(w, h)
    function self.icon:Paint(w, h)
        eui.DrawMaterial(icon, 0, 0, w, h) 
    end

    self.label = self:Add('eui.Label')
    self.label:SetInfo(text, font)

    if align == ALIGN_ICON_LEFT then
        local size1 = w

        self.icon:SetX(offset)
        self.label:SetX(offset + size1 + offset1)

        function self.label.PerformLayout()
            self.label:CenterVertical()
            self.icon:CenterVertical()
        end
    else
        local size1 = w
        local w = self:GetWide()
        local size2 = self.label:GetWide()
        local totalSize = size1 + size2 + offset
        local mainX = w / 2 - totalSize / 2
   
        self.icon:SetX(mainX)
        self.label:SetX(mainX + size1 + offset) 
        
        function self.label.PerformLayout()
            self.label:CenterVertical()
            self.icon:CenterVertical()
        end
    end
end

function PANEL:SetTextColor(color)
    self.label:SetColor(color)
end

do
    local roundedBox = paint.roundedBoxes.roundedBox

    function PANEL:Paint(w, h)
        local x, y = self:LocalToScreen(0, 0)

        roundedBox(self.rounded, x, y, w, h, self.color) 
    end
end

vgui.Register('eui.Panel', PANEL)

--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
