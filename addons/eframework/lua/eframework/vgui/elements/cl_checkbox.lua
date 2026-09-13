--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

local PANEL = {}

do
	local function resizeElements(pnl)
		local x, y = pnl:GetSize()
		
		pnl.circle:SetSize(y * 0.8, y * 0.8)
		pnl.circle:CenterVertical(0.5)
		pnl.circle:SetX(pnl:GetCirclePos(pnl:GetChecked()))
	end

	PANEL.PerformLayout = resizeElements
end

function PANEL:GetCirclePos(state)
	local x, w = self:GetWide(), self.circle:GetWide()

	if state then
		return x - w - x * 0.05
	else
		return x * 0.05
	end
end

do
	local drawCircle = paint.circles.drawCircle

	function PANEL:Init()
		self.alpha = 0
	
		self.clr = eui.Color('262626')
		self.default = eui.Color('262626')
		self.lerpColor = eui.Color('FF4D77')
	
		self.circle = vgui.Create('Panel', self)
		self.circle:SetMouseInputEnabled(false)
		self.circle.alpha = 0.5
		function self.circle.Paint(s, w, h)
			local x, y = s:LocalToScreen(0, 0)
	
			s.alpha = eui.Lerp(s.alpha, self:IsHovered() and 50 or 100)
			drawCircle(x + w / 2, y + h / 2, w / 2, h / 2, eui.Color('FFFFFF', s.alpha))
		end
	end
end

function PANEL:OnChange(val)
	local newX = self:GetCirclePos(val)
	self.circle:MoveTo(newX, self.circle:GetY(), 0.1)

	self:OnChangeCustom(val)
end

function PANEL:OnChangeCustom(val) end

do
	local roundedBox = paint.roundedBoxes.roundedBox

	function PANEL:Paint(w, h)
		local x, y = self:LocalToScreen(0, 0)
		
		self.clr = self.clr:Lerp(self:GetChecked() and self.lerpColor or self.default, engine.TickInterval())
		self.alpha = eui.Lerp(self.alpha, self:IsHovered() and 127 or 255)

		roundedBox(h / 2, x, y, w, h, ColorAlpha(self.clr, self.alpha))
	end
end


vgui.Register('eui.CheckBox', PANEL, 'DCheckBox')

--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
