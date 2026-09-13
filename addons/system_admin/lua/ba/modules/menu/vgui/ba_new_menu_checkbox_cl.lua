--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

local PANEL = {}

local function resizeElements(pnl)
	local x, y = pnl:GetSize()
	
	pnl.circle:SetSize(y*0.9, y*0.9)
	pnl.circle:CenterVertical(0.5)

	pnl.circle:SetX(pnl:GetCirclePos(pnl:GetChecked()))
end

PANEL.PerformLayout = resizeElements

function PANEL:GetCirclePos(state)
	local x, circleWidth = self:GetWide(), self.circle:GetWide()
	if state then
		return x - circleWidth - x*0.085
	else
		return x*0.085
	end
end

do
	local colorOff = Color(36, 36, 36)
	local colorOn = Color(1, 89, 224)
	local setDrawColor = surface.SetDrawColor
	local setMaterial = surface.SetMaterial
	local drawTexturedRect = surface.DrawTexturedRect
	local circleMat = Material('menu/circle.png', 'mips smooth')

	local function draw(pnl, x, y)
		local checked = pnl:GetParent():GetChecked()
		setDrawColor(checked and colorOn or colorOff)
		setMaterial(circleMat)
		drawTexturedRect(0, 0, x, y)
	end

	function PANEL:Init()
		self.circle = self:Add('PANEL')
		self.circle:SetMouseInputEnabled(false)

		self.circle.Paint = draw
	end
end

function PANEL:OnChange(val)
	local newX = self:GetCirclePos(val)
	self.circle:MoveTo(newX, self.circle:GetY(), 0.1)

	self:OnChangeCustom(val)
end

function PANEL:OnChangeCustom(val) end

do
	local color = Color(48,48,48)
	local drawRoundedBox = draw.RoundedBox
	function PANEL:Paint(x, y)
		drawRoundedBox(16, 0, 0, x, y, color_white)
	end
end

vgui.Register('ba_new_menu_checkbox', PANEL, 'DCheckBox')