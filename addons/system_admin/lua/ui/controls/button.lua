
--[[
addons/badmin_1/lua/ui/controls/button.lua
--]]
local PANEL = {}

function PANEL:Init()
	self:SetContentAlignment( 5 )

	self:SetDrawBorder( true )
	self:SetPaintBackground( true )

	self:SetTall( 22 )
	self:SetMouseInputEnabled( true )
	self:SetKeyboardInputEnabled( true )

	self:SetCursor( "hand" )

	self:SetFont('ui.18')
	self:SetTextColor(ui.col.White)
end

function PANEL:SetImageColor(color)
	if IsValid(self.m_Image) then
		self.m_Image:SetImageColor(color)
	end
end

function PANEL:PerformLayout()
	if IsValid(self.m_Image) then
		self:SetContentAlignment(4)
		self.m_Image:SetPos(5, 5)
		self.m_Image:SetSize(self:GetTall() - 10, self:GetTall() - 10)

		surface.SetFont(self:GetFont())
		local textW, textH = surface.GetTextSize(self:GetText())

		local iconW = self.m_Image:GetWide() + 5

		self:SetTextInset((self:GetWide() * 0.5) - (textW * 0.5) + (iconW * 0.5), 0)
	end
	DLabel.PerformLayout(self)
end

function PANEL:SetBackgroundColor(color)
	self.BackgroundColor = color
end

function PANEL:Paint(w, h)
	derma.SkinHook('Paint', 'Button', self, w, h)

	return false
end

vgui.Register('ui_button', PANEL, 'DButton')
