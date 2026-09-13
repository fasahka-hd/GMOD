--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

local PANEL = {}

do
	local function resizeElements(pnl, x, y)
		pnl.textEntry:SetWide(pnl:GetIconPos(x, y) - 4)
	end

	PANEL.PerformLayout = resizeElements
end

do
	local color = Color(22, 22, 22)
	local material = Material("rpui/search.png")

	local drawRoundedBox = draw.RoundedBox

	local setDrawColor = surface.SetDrawColor
	local setMaterial = surface.SetMaterial
	local drawTexturedRect = surface.DrawTexturedRect

	function PANEL:Paint(x, y)
		drawRoundedBox(8, 0, 0, x, y, color)

		local iconX, iconY, iconSize = self:GetIconPos(x, y)

	end
end

function PANEL:GetIconPos(x, y)
	local iconSize = ba.ui.NewMenuScreenScale(40)
	return x - ba.ui.NewMenuScreenScale(15) - iconSize, (y - iconSize) / 2, iconSize
end

do
	local onValueChange = function(btn, value)
		btn:GetParent():OnValueChange(value)
	end

	function PANEL:Init()
		self.textEntry = self:Add('DTextEntry')
		self.textEntry:Dock(LEFT)
		self.textEntry:SetPlaceholderText('   Поиск')
		self.textEntry:SetFont('MKfont.18')
		self.textEntry:SetTextColor(color_white)
		self.textEntry:SetCursorColor(color_white)
		self.textEntry:SetPlaceholderColor(Color(125, 125, 125))
		self.textEntry:SetDrawBackground(false)
		self.textEntry:SetUpdateOnType(true)

		self.textEntry.OnValueChange = onValueChange
	end
end

function PANEL:OnValueChange()
end

vgui.Register('ba_new_menu_log_search', PANEL)

--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
