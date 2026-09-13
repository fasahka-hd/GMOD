--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

local PANEL = {}

local function resizeElements(pnl, x, y)
	pnl.label:SetPos(ba.ui.NewMenuScreenScale(61, 22))
	pnl.label:SizeToContents()

	pnl.desc:SetPos(15/331*x, 67/118*y)
	pnl.desc:SetSize(240/331*x, 40/118*y)

	local x, y = pnl:GetSize()

	pnl.checkbox:SetPos(263/331*x, 85/118*y)
	pnl.checkbox:SetSize(ba.ui.NewMenuScreenScale(40, 23))
end

function PANEL:Init()
	self.label = self:Add('DLabel')
	self.label:SetFont('ba_new_menu_font_player')

	self.desc = self:Add('DLabel')
	self.desc:SetFont('ba_new_menu_font_desc')
	self.desc:SetWrap(true)

	self.checkbox = self:Add('ba_new_menu_checkbox')

	self.checkbox.OnChangeCustom = function(pnl, val) 
		if val then 
			self:OnSelected()
		else
			self:OnDeSelected()
		end 
	end
end

function PANEL:OnSelected() end
function PANEL:OnDeSelected() end

function PANEL:SetCommand(cmd)
	self.command = cmd

	self.label:SetText('/' .. cmd.Name)
	self.desc:SetText(cmd.Help or '')
	self.desc:SetColor( Color(137, 137, 137) )	
end

do
	local color = Color(23,23,23)
	local drawRoundedBox = draw.RoundedBox

	local mat = Material('menu/icon.png')

	local setMaterial = surface.SetMaterial
	local setDrawColor = surface.SetDrawColor
	local drawTexturedRect = surface.DrawTexturedRect

	function PANEL:Paint(x, y)
		drawRoundedBox(6, 0, 0, x, y, color)

		setMaterial(mat)
		setDrawColor(255, 255, 255)

		local posX, posY = (15/331) * x, (14/118) * y
		local size, sizeX = (34/118)*y, (34/331)*x
		drawTexturedRect(posX, posY, sizeX, size)
	end
end

PANEL.PerformLayout = resizeElements

vgui.Register('ba_new_menu_command', PANEL)

--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
