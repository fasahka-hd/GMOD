--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

local PANEL = {}

ALIGN_PANEL_LEFT = 0
ALIGN_PANEL_CENTER = 1
ALIGN_PANEL_RIGHT = 2

eui.Accessor(PANEL, 'Align', ALIGN_PANEL_CENTER)
eui.Accessor(PANEL, 'Offset', 0)
eui.Accessor(PANEL, 'Rounded', 6)
eui.Accessor(PANEL, 'Color')

function PANEL:Init()
    self.contents = {}
end

function PANEL:SetInfo(str, font, color, offset)
    self.label = self:Add('eui.Label')
    self.label:SetInfo(str, font)
    self.label:SetColor(color or color_white)
    self.label:SetMouseInputEnabled(false)

    self.contents[#self.contents + 1] = {self.label, offset}
end

function PANEL:SetMaterial(mat, size, color, offset)
    self.material = self:Add('Panel')
    self.material:SetSize(size, size)
    self.material:SetMouseInputEnabled(false)
    function self.material:Paint(w, h)
        eui.DrawMaterial(mat, 0, 0, w, h, color)
    end

    self.contents[#self.contents + 1] = {self.material, offset}
end

function PANEL:AddElement(panel, offset)
    self.panel = self:Add(panel)
    self.panel:SetMouseInputEnabled(false)

    self.contents[#self.contents + 1] = {self.panel, offset}

    return self.panel
end

function PANEL:PerformLayout(w, h)
    local total = 0
    for _, v in next, self.contents do
        total = total + v[1]:GetWide() + (v[2] or 0)
    end
    
    local tbl = {
        [ALIGN_PANEL_LEFT] = self:GetOffset(),
        [ALIGN_PANEL_CENTER] = (w - total) / 2,
        [ALIGN_PANEL_RIGHT] = w - total - self:GetOffset()
    }

    local x = tbl[self:GetAlign()]

    for _, v in next, self.contents do
        v[2] = v[2] or 0
        
        v[1]:SetPos(x, (h - v[1]:GetTall()) / 2)
        x = x + v[1]:GetWide() + v[2]
    end

    total = total + (self:GetAlign() == ALIGN_PANEL_CENTER and self:GetOffset() or 0)

    if self.sizeToContent and not self.size then
        self:SetWide(total)

        self.size = true
    end
end

function PANEL:SizeToContent()
    self.sizeToContent = true
end

do
    local roundedBox = paint.roundedBoxes.roundedBox

    function PANEL:Paint(w, h)
        if not self:GetColor() then return end

        local x, y = self:LocalToScreen(0, 0)

        roundedBox(self:GetRounded(), x, y, w, h, self:GetColor()) 
    end
end

vgui.Register('eui.NewPanel', PANEL)

--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
