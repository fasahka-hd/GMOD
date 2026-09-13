--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

local PANEL = {}

do
	local function resizeElements(pnl, x, y)
		pnl.closeButton:SetPos(ba.ui.NewMenuScreenScale(1257, 33))
		pnl.closeButton:SetSize(ba.ui.NewMenuScreenScale(100, 36))

		pnl.leftSide:SetWide(ba.ui.NewMenuScreenScale(442))
	end

	PANEL.PerformLayout = resizeElements
end

do
	local color = Color(22, 22, 22)
	local drawRoundedBox = draw.RoundedBox

	function PANEL:Paint(x, y)
		drawRoundedBox(16, 0, 0, x, y, color)
	end
end

function PANEL:Init()
	self.leftSide = self:Add('ba_new_menu_log_leftside')
	self.leftSide:Dock(LEFT)

	self.rightSide = self:Add('ba_new_menu_log_rightside')
	self.rightSide:Dock(FILL)

	self.closeButton = self:Add('ba_new_menu_closebutton')

	self.closeButton.DoClick = function(btn)
		self:Remove()
	end
end

function PANEL:UpdateLogs(name)
	self.rightSide:SetLog(name)
end

vgui.Register('ba_new_menu_log', PANEL, 'EditablePanel')

--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
