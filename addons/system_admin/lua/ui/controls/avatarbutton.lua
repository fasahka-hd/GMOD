
local PANEL = {}

function PANEL:Init()
	self:SetText('')

	self.AvatarImage = ui.Create('AvatarImage', self)

	self.Button = ui.Create('DButton', self)
	self.Button:SetText('')
	self.Button.DoClick = function()
		self:DoClick()
	end
	self.Button.OnCursorEntered = function()
		self.Hovered = true
	end
	self.Button.OnCursorExited = function()
		self.Hovered = false
	end
	self.Button.PaintOver = function(_, w, h)
		derma.SkinHook('Paint', 'AvatarImage', self, w, h)
	end
	self.Button.Paint = function() end
end

function PANEL:PerformLayout()
	self.AvatarImage:SetPos(0,0)
	self.AvatarImage:SetSize(self:GetWide(), self:GetTall())

	self.Button:SetPos(0,0)
	self.Button:SetSize(self:GetWide(), self:GetTall())
end

function PANEL:DoClick()
	if IsValid(self.Player) then
		self.Player:ShowProfile()
	else
		gui.OpenURL('http://steamcommunity.com/profiles/' .. (self.SteamID64 or ''))
	end
end

function PANEL:SetPlayer(pl)
	if not IsValid(pl) or not pl:IsPlayer() then return end
	self.AvatarImage:SetPlayer(pl, 64)
	self.SteamID64 = pl:SteamID64()
	self.Player = pl
end

function PANEL:SetSteamID64(steamid64)
	if not steamid64 then return end
	self.AvatarImage:SetSteamID(steamid64, 64)
	self.SteamID64 = steamid64
end

vgui.Register('ui_avatarbutton', PANEL, 'DPanel')
