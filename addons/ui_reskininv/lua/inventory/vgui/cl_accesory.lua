--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

surface.CreateFont("inv.count", {
	font = "Inter Bold",
	extended = true,
	size = enc.h(15),
	weight = 1,
})

local PANEL = {}

function PANEL:Init()
	local slot = self:GetParent().slot
	local iscrate = self:GetParent().crate
	local slot2 = (iscrate and iscrate or LocalPlayer()).inventory[slot] or {}
	

	local item = enc_inv.getItem(slot2)
	slot2 = slot2.Class or ''

	if !slot2 || slot2 == '' then return end

	if slot2[1] == "_" then
		local id = string.TrimLeft( slot2, "_acc_" )
		
		local tb = AAS.GetTableById(id)
		item.mdl = tb.model
	end

	if item.GetModel then item.mdl = item:GetModel() end
	if item.GetIcon then item.mat = item:GetIcon() end

	if IsValid(self.mdl) then self.mdl:Remove() end
	self.Paint = nil

	if item.mdl then
		self.mdl = vgui.Create("DModelPanel", self)
		self.mdl:Dock(FILL)
		self.mdl:SetModel(item.mdl)
		self.mdl:SetMouseInputEnabled(false)
		
		local mn, mx = self.mdl.Entity:GetRenderBounds()
		local size = 0
		size = math.max(size, math.abs(mn.x) + math.abs(mx.x))
		size = math.max(size, math.abs(mn.y) + math.abs(mx.y))
		size = math.max(size, math.abs(mn.z) + math.abs(mx.z))
		
		local fov = 16
		self.mdl:SetFOV(fov)
		
		self.mdl.Entity:SetPos(Vector(0, 0, size/2 - fov/2))
		self.mdl:SetCamPos(Vector(size, size, size))
		self.mdl:SetLookAt((mn + mx) * 0.5)
		self.mdl.LayoutEntity = function() return false end
		function self.mdl:LayoutEntity( Entity ) return end
	elseif item.mat then
		self.Paint = function(self,w,h)
			surface.SetMaterial(item.mat)
			surface.SetDrawColor(255, 255, 255)
			surface.DrawTexturedRect(0,0,w,h)
		end
	end
end

function PANEL:OnSizeChanged(w,h)
	self:Init()
end

vgui.Register("enc.inv.icon", PANEL, "Panel")

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
		local item = enc_inv.getItem(slot)

		if !slot then return end
		if self.crate then return end

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
				local id = string.TrimLeft(slot.Class, '_acc_')
				local tb = AAS and AAS.GetTableById and AAS.GetTableById(id)
				if tb and tb.name then mm:AddSpacer() mm:AddOption(tb.name):SetIcon('icon16/box.png') end
			end

			mm:Open()
			return
		end

		mousePressed(self)
	end

	local mouseReleased = PANEL.OnMouseReleased
	function PANEL:OnMouseReleased()
		mouseReleased(self)
	end
end

function PANEL:Rebuild(w, h)
	if IsValid(self.icon) then self.icon:Remove() end

	local w, h = self:GetSize()
	self.icon = vgui.Create("enc.inv.icon", self)

	local ww, hh = w, h
	-- self.icon:SetSize(ww,hh)
	-- self.icon:SetPos((w-ww)*.5,(h-hh)*.5)
	self.icon:Dock(FILL)
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
	draw.RoundedBox(4,0,0,w,h,enc.clrs.bg)

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
	local item = enc_inv.getItem(slot)

	local model
	local name = ""
	if slot.Class[1] == "_" then
		local id = string.TrimLeft( slot.Class, "_acc_" )
		
		local tb = AAS.GetTableById(id)
		name = tb.name
		model = tb.model
	else
		name = item:GetName()
	end

	Tooltip = vgui.Create("DPanel")
	Tooltip:SetSize(140,64)
	Tooltip:SetPos(gui.MouseX()+13, gui.MouseY()+13) 
	Tooltip:SetMouseInputEnabled(false)
	Tooltip:MakePopup()
	Tooltip.Think = function(self)
		if IsValid(mm) then mm:Remove() end
	end
	Tooltip.Paint = function(self,w,h)
		draw.RoundedBox(6,0,0,w,h,Color(37,37,37))
		local rtable = enc_inv.Rarity[name]
		rtable = rtable or {}

		draw.RoundedBox(3,8,8,28,28,rtable.color or color_white)
		local _x, _y = draw.SimpleText(name, "inv.tptitle", 44, 7, color_white,0)
		local __x, __y = draw.SimpleText(rtable.rarity or '', "inv.tptitle", 44, 20, rtable.color,0)

		self:SetWide(7+_x+4+7+44)
		self:SetTall(44)
	end

	local mdl = vgui.Create('SpawnIcon', Tooltip) -- хули лезешь сюда, ебло утинное, модельки не нравятся?
	mdl:SetSize(20,20)
	mdl:SetPos(28 / 2 - 20 / 2 + 8, 28 / 2 - 20 / 2 + 8)
	mdl:SetModel(model or 'models/Items/item_item_crate.mdl')
	mdl:SetTooltip()
	mdl:SetDisabled(true)
	mdl:SetMouseInputEnabled(false)
	mdl.DoClick = function() return end
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

vgui.Register("enc.inv.slot", PANEL, "DPanel")

local pos = {
	[1] = enc.h(71),
	[2] = enc.h(71),
	[3] = enc.h(75),
	[4] = enc.h(110)
}

local PANEL = {}

function PANEL:Init()
	self.mat = false
end

function PANEL:SetTitle(title)
	self.title = vgui.Create('DLabel', self)
    self.title:Dock(TOP)
    self.title:DockMargin(enc.w(21),enc.h(16),0,0)
    self.title:SetText(title)
    self.title:SetFont('MB_12')
    self.title:SetTextColor(enc.clrs.white)
    self.title:SizeToContentsY()
end

function PANEL:SetBackroung(mat)
	self.mat = mat
end

function PANEL:SetSlot(i)
    self.slot = vgui.Create('enc.inv.slot', self)
	self.slot:SetPos(enc.w(22),pos[i])
	self.slot:SetSize(enc.w(42),enc.h(42))
    self.slot:SetSlot(i*-1)
end

function PANEL:Paint(w,h)
	if self.mat then
		surface.SetMaterial(self.mat)
		surface.SetDrawColor(255,255,255)
		surface.DrawTexturedRect(0,0,w,h)
	end
end

vgui.Register("enc.inv.accessory", PANEL, "Panel")

hook.Add("InitPostEntity", "VInventory.Init", function()
	LocalPlayer().inventory = {}
end)

net.Receive('enc.inv.sync',function()
    print(3,LocalPlayer())
	LocalPlayer().inventory = net.ReadTable()
end)

--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher