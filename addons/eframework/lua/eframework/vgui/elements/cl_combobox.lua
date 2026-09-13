--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

local PANEL = {}

local setMaterial = surface.SetMaterial
local setDrawColor = surface.SetDrawColor
local drawTextured = surface.DrawTexturedRectRotated

function PANEL:Init()
    self.open = false
    self.choices = {}
    self.current = -1

    self.arrow = self:Add('DPanel')
    self.arrow:Dock(RIGHT)
    self.arrow:Margin(0, 0, eui.ScaleTall(30))
    self.arrow:SetWide(eui.ScaleTall(15))
    self.arrow:SetMouseInputEnabled(false)
    self.arrow.hover = 0
    function self.arrow.Paint(s, w, h)
        s.hover = eui.Lerp(s.hover, (self.open or self:IsHovered()) and 180 or 0)
        
        setMaterial(eui.Material('just_bet', 'arrow'))
        setDrawColor(255, 255, 255)
        drawTextured(w / 2, h / 2, w, h, s.hover)
    end
    function self.arrow:PerformLayout(w, h)
        self:SetTall(w * 0.7)
        self:CenterVertical()
    end
end

function PANEL:AddChoice(text)
    local index = #self.choices + 1

    self.choices[index] = {
        text = text,
        index = index
    }
end

function PANEL:GetCurrentChoice()
    return self.choices[self.current]
end

function PANEL:DoClick()
    local x, y = self:LocalToScreen(0, 0)

    if IsValid(self.menu) then
        self.menu:Remove()
        self.open = false
        return
    end

    self.open = not self.open
    
    self.menu = vgui.Create('eui.Menu')
    self.menu:SetPos(x, y + self:GetTall())
    self.menu:SetMinimumWidth(self:GetWide())
    self.menu:SetMinimumTall(self:GetTall() * 0.7)

    for index, choice in ipairs(self.choices) do
        if self.current == index then
            goto skip
        end

        self.menu:AddOption(choice.text, function()
            self:SelectChoice(index, true)
        end)

        ::skip::
    end

    self.menu:Open()
end

function PANEL:SelectChoice(index, call)
    local text = 'None'
    local oldIndex = self.current
    local oldText = self:GetText()

    if index ~= -1 then
        text = self.choices[index].text
    end

    self.current = index

    self:SetInfo(text, eui.Font('20:Medium'))
    self.label:Dock(LEFT)
    self.label:Margin(eui.ScaleWide(24))

    if call then
        self:OnSelect(index, text, oldIndex, oldText)
    end
end

function PANEL:OnSelect() 
end

vgui.Register('eui.ComboBox', PANEL, 'eui.Button')

--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
