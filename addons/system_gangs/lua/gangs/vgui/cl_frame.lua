--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

local PANEL = {}

AccessorFunc(PANEL, "m_bHeaderHeight", "HeaderHeight", FORCE_NUMBER)
AccessorFunc(PANEL, "m_bTitleFont", "TitleFont", FORCE_STRING)
AccessorFunc(PANEL, "m_bSizable", "Sizable", FORCE_BOOL)
AccessorFunc(PANEL, "m_iMinWidth", "MinWidth", FORCE_NUMBER)
AccessorFunc(PANEL, "m_iMinHeight", "MinHeight", FORCE_NUMBER)

function PANEL:Init()
	self:Center()
	self:SetHeaderHeight(28)
end

function PANEL:SetSizes(w, h)
	self.real_w, self.real_h = w, h
	self:ScaleChanged()
end

function PANEL:ScaleChanged()
	if self.sizing then return end

	local new_w, new_h = enc.w(self.real_w), enc.h(self.real_h)
	self.x, self.y = self.x + (self:GetWide() / 2 - new_w / 2), self.y + (self:GetTall() / 2 - new_h / 2)
	self:SetSize(new_w, new_h)
end

local anim_speed = 0.2

local function show(s)
	local w, h = s.real_w, s.real_h

	if s.anim_scale then
		w, h = enc.w(w), enc.h(h)
	end

	s:SetSize(s, w * 1.1, h * 1.1)
	s:Center()

	s:SizeTo(w, h, anim_speed, 0, -1)
	s:MoveTo((ScrW() / 2) - (w / 2), (ScrH() / 2) - (h / 2), anim_speed, 0, -1)
	s:AlphaTo(255, anim_speed + 0.02, 0)
	s:MakePopup()
end

local function remove(s, hide)
	if not hide and not s:IsVisible() then
		s:Remove()
		return
	end

	local w, h = s.real_w, s.real_h

	if s.anim_scale then
		w, h = enc.w(w), enc.h(h)
	end

	w, h = w * 1.1, h * 1.1

	s:SizeTo(w, h, anim_speed, 0, -1)
	s:MoveTo((ScrW() / 2) - (w / 2), (ScrH() / 2) - (h / 2), anim_speed, 0, -1)
	s:AlphaTo(0, anim_speed + 0.02, 0, function()
		s:Remove()
	end)
end

local function hide(s)
	remove(s, true)
end

function PANEL:AddAnimations(w, h, no_scale)
	self.anim_scale = not no_scale
	self.real_w, self.real_h = w, h

	self:SetAlpha(0)
	show(self)

	self.Removes = remove
	self.Show = show
end

vgui.Register("enc.frame", PANEL, "EditablePanel")

--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
