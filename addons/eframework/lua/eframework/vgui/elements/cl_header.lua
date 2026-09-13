--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

local PANEL = {}

local roundedBox = paint.roundedBoxes.roundedBox

local scrW, scrH = ScrW(), ScrH()

function PANEL:Init()
    self:SetTall(eui.ScaleTall(119))

    self.rounded = 20
    self.clr = eui.Color('181A1D')
    self.icon = eui.Material('logo1')
    
    self.material = self:Add('Panel')
    self.material:Dock(LEFT)
    self.material:Margin(eui.ScaleTall(32), eui.ScaleTall(25), 0, eui.ScaleTall(25))
    self.material:SetWide(eui.ScaleTall(61))
    function self.material.Paint(s, w, h)
        eui.DrawMaterial(self.icon, 0, 0, w, h)
    end

    self.line = self:Add('Panel')
    self.line:Dock(LEFT)
    self.line:Margin(eui.ScaleWide(15), eui.ScaleTall(46), 0, eui.ScaleTall(46))
    self.line:SetWide(1)
    function self.line:Paint(w, h)
        local x, y = self:LocalToScreen(0, 0)

        roundedBox(0, x, y, w, h, eui.Color('7C837E'))
    end

    self.info = self:Add('Panel')
    self.info:Dock(LEFT)
    self.info:Margin(eui.ScaleWide(24), eui.ScaleTall(35), 0, eui.ScaleTall(35))
    self.info:SetWide(eui.ScaleTall(300))

    self.title = self.info:Add('eui.Label')
    self.title:Dock(TOP)
    self.title:SetInfo('Добро пожаловать,', eui.Font('16:Regular'))
    self.title:SetColor(eui.Color('7C837E'))

    self.desc = self.info:Add('eui.Label')
    self.desc:Dock(BOTTOM)
    self.desc:SetInfo(LocalPlayer():Name(), eui.Font('28:Bold'))

    self.close = self:Add('eui.Close')

    self.buttons = self:Add('Panel')
    self.buttons:Dock(FILL)
    self.buttons:Margin(0, eui.ScaleTall(35), self.close:GetWide() + eui.ScaleWide(87), eui.ScaleTall(35))
    self.button = {}
end

function PANEL:SetFrame(frame)
    self.close:SetFrame(frame)
end

function PANEL:AddButton()
    local button = self.buttons:Add('eui.Button')
    button:Dock(RIGHT)
    button:Margin(0, 0, eui.ScaleWide(10))
    button:SetWide(eui.ScaleWide(225))
    self.button[#self.button + 1] = button
    function button.DoClick(s)
        if s.Click then
            s.Click()
        end

        if s.noSelected then return end
        for k, v in next, self.button do
            v:SetSelected(false)
        end

        s:SetSelected(true)
    end

    return button
end

function PANEL:PerformLayout(w, h)
    self.material:CenterVertical()

    self.close:SetX(w - self.close:GetWide() - eui.ScaleWide(45))
    self.close:CenterVertical()
end

function PANEL:SetTitle(title)
    self.title:SetInfo(title, eui.Font('16:Regular'))
end

function PANEL:SetDesc(desc)
    self.desc:SetInfo(desc, eui.Font('16:Regular'))
end

function PANEL:SetColor(clr)
    self.clr = clr
end

function PANEL:SetRounded(rounded)
    self.rounded = rounded
end

function PANEL:SetMaterial(icon)
    self.icon = icon
end

do
    local roundedBox = paint.roundedBoxes.roundedBox

    function PANEL:Paint(w, h)
        local x, y = self:LocalToScreen(0, 0)
    
        roundedBox(self.rounded, x, y, w, h, self.clr) 
    end
end

vgui.Register('eui.Header', PANEL, 'Panel')

--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
