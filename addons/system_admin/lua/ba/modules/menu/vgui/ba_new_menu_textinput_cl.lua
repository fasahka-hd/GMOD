--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

local PANEL = {}

function PANEL:Init()
	self:SetPaintBackground(false)
	self:SetFont('ba_new_menu_font_textinput')
	self:SetPlaceholderText('Введите значение...')
	self:SetPlaceholderColor(Color(140, 140, 140))
	self:SetTextColor(color_white)
	self:SetCursorColor(color_white)
end

do
	local drawRoundedBox = draw.RoundedBox
	local color = Color(24, 24, 24)

	function PANEL:Paint(x, y)
		drawRoundedBox(4, 0, 0, x, y, color)
		self.BaseClass.Paint(self, x, y)
	end
end

vgui.Register('ba_new_menu_textinput', PANEL, 'DTextEntry')

--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
