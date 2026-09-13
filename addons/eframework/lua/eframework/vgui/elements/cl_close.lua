--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

local PANEL = {}

local roundedBox = paint.roundedBoxes.roundedBox

local scrW, scrH = ScrW(), ScrH()

function PANEL:Init()
    self.font = eui.Font('20:SemiBod')
    self.w1 = eui.GetTextSize('Выход', self.font)
    self.w2 = eui.GetTextSize('Esc', self.font)

    self:SetSize(self.w1 + self.w2 + eui.ScaleWide(29), eui.ScaleTall(48))
end

function PANEL:SetFrame(frame)
    self.frame = frame
end

function PANEL:DoClick()
    self.frame:Close()
end

do
    local roundedBox = paint.roundedBoxes.roundedBox
    local simpleText = draw.SimpleText

    function PANEL:Paint(w, h)
        local x, y = self:LocalToScreen(0, 0)

        self.alpha = eui.Lerp(self.alpha, self:IsHovered() and 50 or 100)
        simpleText('Выход', eui.Font('20:SemiBold'), 0, h / 2, eui.Color('FFFFFF', self.alpha), 0, 1)
        roundedBox(5, x + self.w1 + eui.ScaleTall(11), y, self.w2 + eui.ScaleWide(18), h, eui.Color('FFFFFF', self.alpha)) 

        simpleText('Esc', eui.Font('20:SemiBold'), self.w1 + eui.ScaleTall(11) + (self.w2 + eui.ScaleWide(18)) / 2, h / 2, color_black, 1, 1)
    end
end

vgui.Register('eui.Close', PANEL, 'eui.Button')

--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
