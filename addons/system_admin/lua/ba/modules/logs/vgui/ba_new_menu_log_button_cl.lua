--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

local PANEL = {}

do
	local hoveredColor = Color(1, 89, 224)
	local color = Color(26,26,26)
	local drawRoundedBox = draw.RoundedBox

	function PANEL:Paint(x, y)
		drawRoundedBox(8, 0, 0, x, y, self:IsHovered() and hoveredColor or color)
	end
end

function PANEL:Init()
	self:SetFont('ba_new_menu_font_combobox')
	self:SetColor(color_white)
end

vgui.Register('ba_new_menu_log_button', PANEL, 'DButton')