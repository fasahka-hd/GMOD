--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

local PANEL = {}

local function paintVBar(self, x, y)
	local width = 2

	surface.SetDrawColor(enc.clrs.scrollbg)
	surface.DrawRect(x-width, 0, width, y)
end

local function paintGrip(self, x, y)
	local width = 2

	surface.SetDrawColor(ui.col.SUP)
	surface.DrawRect(x-width, 0, width, y)
end

PANEL.PaintVBar = paintVBar
PANEL.PaintGrip = paintGrip

function PANEL:Init()
	local vBar = self:GetVBar()
	vBar:SetHideButtons(true)
	vBar.Paint = paintVBar
	
	vBar.btnGrip.Paint = paintGrip
end

vgui.Register('ba_new_menu_scrollpanel', PANEL, 'DScrollPanel')