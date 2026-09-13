--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

-- local webiconId = vulcan.webicon.Create('https://i.imgur.com/tGUcamD.png', 'smooth mips')

local PANEL = {}

eui.Accessor(PANEL, 'DeleteSelf')
eui.Accessor(PANEL, 'MinimumWidth')

local tbl = {}
function PANEL:Init()
	self:SetDrawOnTop(true)
    self:SetDeleteSelf(true)
    self:SetVisible(false)

    self.bgColor = Color(122, 122, 122)
    self.options = {}

	RegisterDermaMenuForClose(self)
end

-- local option_OnMouseReleased = function(s, mousecode)
-- 	if s.Depressed and mousecode == MOUSE_LEFT then
-- 		CloseDermaMenus()
-- 	end
-- 	DButton.OnMouseReleased(s, mousecode)
-- end

function PANEL:PerformLayout(_, h)
    local _, localY = self:LocalToScreen(0, 0)
	local width = self:GetMinimumWidth()
	local height = 0
    local children = self.options
    local childrenCount = #children

	for index, child in next, self.options do
		height = height + child:GetTall()
	end

    if (localY + height) > ScrH() then
        height = ScrH() - localY
    end

	self:SetWide(width)
    self:SetTall(height)

	self.BaseClass.PerformLayout(self, width, height)
end

function PANEL:SetMinimumWidth(width)
    self.minimum = width
end

function PANEL:GetMinimumWidth()
    return self.minimum
end

function PANEL:SetMinimumTall(tall)
    self.minTall = tall
end

function PANEL:GetMinimumTall()
    return self.minTall
end


function PANEL:Paint(w, h)
	local x, y = self:LocalToScreen()

    draw.RoundedBox(4, x, y, w, h, self.bgColor)
end

function PANEL:ToCursor()
    self:SetPos(input.GetCursorPos())
end

function PANEL:AddOption(text, callback)
    self.button = self:Add('eui.Button')
    self.button:Dock(TOP)
    self.button:SetTall(self:GetMinimumTall())
    self.button:SetInfo(text, eui.Font('18:Medium'))
    function self.button.DoClick()
        self:Remove()

        if not callback then return end

        callback()
    end

    table.insert(self.options, self.button)

    return self.button
end

function PANEL:Open()
    self:SetVisible(true)
    self:MakePopup()
    self:InvalidateLayout(true)
end

function PANEL:Close()
    self:SetVisible(false)
end

vgui.Register('eui.Menu', PANEL, 'eui.ScrollPanel')

--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
