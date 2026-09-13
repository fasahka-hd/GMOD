--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

local PANEL = {}

function PANEL:Init()
    self:SetTextColor(color_white)
end

function PANEL:SetColor(clr)
    self:SetTextColor(clr)
end

function PANEL:SetInfo(text, font)
    self:SetText(text)
    self:SetFont(font)

    self:SizeToContents()
end

vgui.Register('eui.Label', PANEL, 'DLabel')

--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
