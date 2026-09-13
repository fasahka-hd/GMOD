--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

PANEL = {}

function PANEL:Init()
    self.hover = false

    self.textEntry = vgui.Create('DTextEntry', self)
    self.textEntry:Dock(FILL)
    self.textEntry:SetDrawLanguageID()
    function self.textEntry.OnGetFocus(s)
        if s:GetValue() ~= s.startText then return end

        s:SetValue('') 
        self:SetSelected(true)
    end
    function self.textEntry.OnLoseFocus(s)
        self:SetSelected(false)
    end
end

function PANEL:SetInfo(text, font, x, y)
    self.textEntry.startText = text
    self.textEntry:SetFont(font)
    self.textEntry:SetValue(text)
    self.textEntry:Margin(x)

    local clr = ColorAlpha(color_white, 40)
    function self.textEntry.Paint(pan, w, h)
        self.hover = pan:IsHovered()

        pan:DrawTextEntryText(color_white, clr, color_white)
    end
end

function PANEL:GetValue()
    return self.textEntry:GetValue()
end

function PANEL:SetValue(val)
    self.textEntry:SetValue(val)
end

vgui.Register('eui.TextEntry', PANEL, 'eui.Button')

--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
