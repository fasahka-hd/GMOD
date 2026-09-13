--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

local PANEL = {}

vgui.Register('ba_new_menu_log_leftside', PANEL)

do
	local function resizeElements(pnl, x, y)
		pnl.header:SetTall(select(2, ba.ui.NewMenuScreenScale(nil, 120)))

		local left, top = ba.ui.NewMenuScreenScale(25, 28)
		local right, bottom = ba.ui.NewMenuScreenScale(14, 28)
		pnl.scroll:DockMargin(left, top, right, bottom)
	end

	PANEL.PerformLayout = resizeElements
end

function PANEL:Init()
	self.header = self:Add('ba_new_menu_header')
	self.header:Dock(TOP)
	self.header:SetText('Логи', 'Выберите категорию которую хотите посмотреть')

	self.scroll = self:Add('ba_new_menu_scrollpanel')
	self.scroll:Dock(FILL)

	self:CreateTabs()
end

function PANEL:CreateTabs()
	local scroll = self.scroll

	local function doClick(pnl)
		self:GetParent():UpdateLogs(pnl.log)
	end

	for k, v in ipairs(ba.logs.Maping) do
		local button = scroll:Add('ba_new_menu_log_button')
		button:Dock(TOP)
		button:SetTall(select(2, ba.ui.NewMenuScreenScale(nil, 70)))
		button:SetText(v)
		button.log = v

		button:DockMargin(0, 0, 0, select(2, ba.ui.NewMenuScreenScale(nil, 14)))

		button.DoClick = doClick
	end
end

--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
