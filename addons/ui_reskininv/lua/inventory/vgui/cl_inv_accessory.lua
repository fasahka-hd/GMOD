--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

local PANEL = {}

local PANEL = {}
local Tooltip
local mm

function PANEL:Init( slot )
	self.slot = slot or 0
	self.fr = 0

	self:Droppable("slot")
	self:Receiver("slot", function(self, pnls, dropped)
		if !dropped then return end

		net.Start("enc.inv.move")
            net.WriteInt(pnls[1].slot, 12)
            net.WriteInt(self.slot, 12)
            if self.crate || pnls[1].crate then
                net.WriteEntity(self.crate or pnls[1].crate)
                net.WriteBool(self.crate or false)
                net.WriteBool(pnls[1].crate or false)
            end
		net.SendToServer()
	end)

	local mousePressed = PANEL.OnMousePressed
	function PANEL:OnMousePressed(keyCode)
		local slot = LocalPlayer().inventory[self.slot]

		if !slot then return end
		if self.crate then return end

		mousePressed(self)

		if keyCode == MOUSE_RIGHT then
			if IsValid(Tooltip) then Tooltip:Remove() end
			if IsValid(mm) then mm:Remove() end
			mm = DermaMenu()

			mm:AddOption('Использовать', function()
				net.Start('enc.inv.use')
					net.WriteInt(self.slot, 12)
				net.SendToServer()
			end):SetIcon('icon16/accept.png')

			mm:AddOption('Выбросить', function()
				net.Start('enc.inv.drop')
					net.WriteInt(self.slot, 12)
				net.SendToServer()
			end):SetIcon('icon16/delete.png')

			if slot.Class && slot.Class[1] == '_' then
				local id = string.TrimLeft(slot.Class, "_acc_")
				local tb = AAS and AAS.GetTableById and AAS.GetTableById(id)
				if tb and tb.name then mm:AddSpacer() mm:AddOption(tb.name):SetIcon('icon16/box.png') end
			end
			
			mm:Open()
		end
	end

	local mouseReleased = PANEL.OnMouseReleased
	function PANEL:OnMouseReleased()
		mouseReleased(self)
	end
end

function PANEL:Rebuild(w, h)
	if IsValid(self.icon) then self.icon:Remove() end

	local w, h = self:GetSize()
	self.icon = vgui.Create("inv.vgui.icon", self)

	local ww, hh = w*.75, h*.75
	self.icon:SetSize(ww,hh)
	self.icon:SetPos((w-ww)*.5,(h-hh)*.5)
	self.icon:SetMouseInputEnabled(false)
end

function PANEL:OnSizeChanged( w, h )
	if !self.icon then return end

	self:Rebuild(w, h)
end

function PANEL:SetSlot( id )
	self.slot = id
	self:Rebuild(self:GetSize())
end

local function ColorLerp(fraction, oldcolor, tocolor)
	return Color( Lerp(fraction, oldcolor.r, tocolor.r), Lerp(fraction, oldcolor.g, tocolor.g), Lerp(fraction, oldcolor.b, tocolor.b), Lerp(fraction, oldcolor.a, tocolor.a) )
end

function PANEL:Paint(w, h)
	self.fr = math.Clamp(self:IsHovered() and self.fr + FrameTime()*5 or self.fr - FrameTime()*5, 0, 1)

	draw.RoundedBox(0,0,0,w,h,ColorLerp(self.fr, Color(41,41,41,100), Color(60,60,60,100)))
	--draw.SimpleText(self.slot,"DermaDefault",0,0,color_white)

	local slot = (self.crate or LocalPlayer()).inventory[self.slot]
	if !slot then return end
	if !slot.Data then return end
	if !slot.Data.Count then return end
	draw.SimpleText(slot.Data.Count, 'inv.count', w-5, h-3, Color(255,255,255,120),2,4)
end

surface.CreateFont("inv.tptitle", {
	font = "Inter Bold",
	extended = true,
	size = 17,
	weight = 1,
})

function PANEL:OnCursorEntered()
	if IsValid(Tooltip) then Tooltip:Remove() end
	if IsValid(mm) then return end

	local slot = (self.crate or LocalPlayer()).inventory[self.slot]
	if !slot then return end

	local name = ""
	if slot.Class[1] == "_" then
		local id = string.TrimLeft( slot.Class, "_acc_" )
		
		local tb = AAS.GetTableById(id)
		name = tb.name
	end

	Tooltip = vgui.Create("DPanel")
	Tooltip:SetSize(140,64)
	Tooltip:SetPos(gui.MouseX()+13, gui.MouseY()+13) 
	Tooltip:MakePopup()
	Tooltip:SetMouseInputEnabled(false)
	Tooltip.Think = function(self)
		if IsValid(mm) then mm:Remove() end
	end
	Tooltip.Paint = function(self,w,h)
		--draw.RoundedBox(6,0,0,w,h,Color(37,37,37))
		-- draw.RoundedBox(3,8,8,28,28,)
		print(name)
		local _x, _y = draw.SimpleText(name, "inv.tptitle", 7, 5, color_white)
		-- local __x, _ = draw.SimpleText("("..slot.Class..")", "inv.tptitle", 7+_x+4, 5, Color(255,255,255,50))

		self:SetWide(7+_x+4+7)
		self:SetTall(5+_+5)
	end
end

function PANEL:OnCursorMoved()
	if !IsValid(Tooltip) then return end

	Tooltip:SetPos(gui.MouseX()+13, gui.MouseY()+13) 
end

function PANEL:OnCursorExited()
	if IsValid(Tooltip) then Tooltip:Remove() end
end

function PANEL:OnRemove()
	if IsValid(Tooltip) then Tooltip:Remove() end
end

vgui.Register('enc.accessory.inventory', PANEL, "DPanel")

--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
