--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher


--[[

~ yuck, anti cheats! ~

~ file stolen by ~
                __  .__                          .__            __                 .__               
  _____   _____/  |_|  |__ _____    _____ ______ |  |__   _____/  |______    _____ |__| ____   ____  
 /     \_/ __ \   __\  |  \\__  \  /     \\____ \|  |  \_/ __ \   __\__  \  /     \|  |/    \_/ __ \ 
|  Y Y  \  ___/|  | |   Y  \/ __ \|  Y Y  \  |_> >   Y  \  ___/|  |  / __ \|  Y Y  \  |   |  \  ___/ 
|__|_|  /\___  >__| |___|  (____  /__|_|  /   __/|___|  /\___  >__| (____  /__|_|  /__|___|  /\___  >
      \/     \/          \/     \/      \/|__|        \/     \/          \/      \/        \/     \/ 

~ purchase the superior cheating software at https://methamphetamine.solutions ~

~ server ip: 212.22.93.35_27015 ~ 
~ file: addons/itemstore/lua/itemstore/vgui/slot.lua ~

]]

local PANEL = {}

surface.CreateFont( "ItemStoreAmount", {
	font = system.IsLinux() and "DejaVu Sans" or "Tahoma",
	size = 11,
	weight = 500
} )

local GradientUp = Material( "gui/gradient_up" )
local GradientDown = Material( "gui/gradient_down" )

AccessorFunc( PANEL, "Item", "Item" )
AccessorFunc( PANEL, "ContainerID", "ContainerID", FORCE_NUMBER )
AccessorFunc( PANEL, "Slot", "Slot", FORCE_NUMBER )

function PANEL:Init()
	self.BaseClass.Init( self )

	self:Droppable( "ItemStore" )
	self:Receiver( "ItemStore", function( receiver, droptable, dropped )
		local droppable = droptable[ 1 ]

		if not dropped then return end

		local droppable = droptable[ 1 ]

		local from_con = droppable:GetContainerID()
		local to_con = droppable:GetContainerID()

		if not from_con then return end
		if not to_con then return end

		local from_slot = droppable:GetSlot()
		local to_slot = receiver:GetSlot()

		if not from_slot then return end
		if not to_slot then return end

		local from_item = droppable:GetItem()
		local to_item = receiver:GetItem()

		if from_item and to_item and ( from_item:CanMerge( to_item ) or
			from_item:CanUseWith( to_item ) ) then
			local menu = DermaMenu()

			if from_item:CanUseWith( to_item ) then
				menu:AddOption( itemstore.Translate( "usewith" ), function()
					LocalPlayer():UseItemWith( droppable:GetContainerID(), droppable:GetSlot(),
						receiver:GetContainerID(), receiver:GetSlot() )
				end ):SetIcon( "icon16/wrench_orange.png" )

				menu:AddSpacer()
			end

			menu:AddOption( itemstore.Translate( "move" ), function()
				LocalPlayer():MoveItem( droppable:GetContainerID(), droppable:GetSlot(),
					receiver:GetContainerID(), receiver:GetSlot() )
			end ):SetIcon( "icon16/arrow_switch.png" )

			if from_item:CanMerge( to_item ) then
				menu:AddOption( itemstore.Translate( "merge" ), function()
					LocalPlayer():MergeItem( droppable:GetContainerID(), droppable:GetSlot(),
						receiver:GetContainerID(), receiver:GetSlot() )
				end ):SetIcon( "icon16/arrow_join.png" )
			end

			menu:Open()
		else
			LocalPlayer():MoveItem( droppable:GetContainerID(), droppable:GetSlot(),
				receiver:GetContainerID(), receiver:GetSlot() )
		end
	end )
end

function PANEL:Paint( w, h )
	local item = self:GetItem()

	if item and item.HighlightColor then
		local col = Color( item.HighlightColor.r, item.HighlightColor.g, item.HighlightColor.b )
		local bright = Color( col.r * 1.25, col.g * 1.25, col.b * 1.25 )
		local dark = Color( bright.r / 2, bright.g / 2, bright.b / 2 )

		if itemstore.config.HighlightStyle == "full" then
			surface.SetDrawColor( dark )
			surface.DrawRect( 0, 0, w, h )

			surface.SetMaterial( GradientDown )
			surface.SetDrawColor( self.Hovered and bright or col )
			surface.DrawTexturedRect( 0, 0, w, h )
		elseif itemstore.config.HighlightStyle == "subtle" then
			surface.SetMaterial( GradientUp )
			surface.SetDrawColor( self.Hovered and bright or col )
			surface.DrawTexturedRect( 0, 0, w, h )
		elseif itemstore.config.HighlightStyle == "corner" then
			surface.SetMaterial( GradientUp )
			surface.SetDrawColor( self.Hovered and bright or col )
			surface.DrawTexturedRectRotated( w, h, w * 1.25, h * 1.25, 45 )
		elseif itemstore.config.HighlightStyle == "border" then
			surface.SetDrawColor( col )
			surface.DrawOutlinedRect( 0, 0, w, h )
		end
	end
	draw.RoundedBox(4,0,0,w,h,enc.clrs.bg)

	-- surface.SetDrawColor( 255,255,255,5 )
	-- surface.DrawOutlinedRect( 1, 1, w - 2, h - 2 )

	self.BaseClass.Paint( self, w, h )

	local item = self:GetItem()
	if item and item:GetAmount() > 1 then
		draw.SimpleText( item:FormatAmount(), "MM_10", enc.w(10), 
			enc.h(8), color_white)
	end

end

function PANEL:Refresh()
	local item = self:GetItem()

	if item then
		self:SetModel( item:GetModel() )

		self.Entity:SetMaterial( item:GetMaterial() )
		self:SetColor( item:GetColor() or color_white )

		min, max = self.Entity:GetRenderBounds()

		self:SetCamPos( Vector( 0.55, 0.55, 0.55 ) * min:Distance( max ) )
		self:SetLookAt( ( min + max ) / 2 )
	else
		self.Entity = nil
		self:SetTooltip( nil )
	end
end

function PANEL:DoDoubleClick()
	local con_id = self:GetContainerID()
	local slot = self:GetSlot()
	local item = self:GetItem()

	if not con_id then return end
	if not slot then return end
	if not item then return end
	if not item.Use then return end

	LocalPlayer():UseItem( con_id, slot )
end

function PANEL:DoMiddleClick()
	local con_id = self:GetContainerID()
	local slot = self:GetSlot()
	local item = self:GetItem()

	if not con_id then return end
	if not slot then return end
	if not item then return end

	LocalPlayer():DropItem( con_id, slot )
end

function PANEL:DoRightClick()
	local con_id = self:GetContainerID()
	local slot = self:GetSlot()
	local item = self:GetItem()

	if not con_id then return end
	if not slot then return end
	if not item then return end
	if IsValid(invnewpanel) then invnewpanel:Remove() end

	local mx,my = input.GetCursorPos()
	invnewpanel = vgui.Create('Panel')
	invnewpanel:SetSize(174,259)
	invnewpanel:SetPos(mx,my)
	invnewpanel:MakePopup()

	local info = vgui.Create('Panel', invnewpanel)
	info:Dock(TOP)
	info:SetTall(44)
	function info:Paint(w,h)
		draw.RoundedBox(6,0,0,w,h,enc.clrs.inbg)
		draw.RoundedBox(3,8,8,28,28,enc.clrs.white)
		PrintTable(item)
		draw.SimpleText(item:GetName(), "inv.tptitle", 44, 7, color_white,0)
		draw.SimpleText(item:GetAmount() or '0', "inv.tptitle", 44, 20, enc.clrs.whitea,0)
	end

	local mdl = vgui.Create('SpawnIcon', info) -- хули лезешь сюда, ебло утинное, модельки не нравятся?
	mdl:SetSize(20,20)
	mdl:SetPos(28 / 2 - 20 / 2 + 8, 28 / 2 - 20 / 2 + 8)
	mdl:SetModel(item:GetModel() or 'models/Items/item_item_crate.mdl')
	mdl:SetTooltip()
	mdl:SetDisabled(true)
	mdl:SetMouseInputEnabled(false)
	mdl.DoClick = function() return end

	local use = vgui.Create('DButton', invnewpanel)
	use:Dock(TOP)
	use:DockMargin(0,3,0,0)
	use:SetTall(44)
	use:SetText('Использовать')
	use:SetFont("inv.tptitle")
	use:SetTextColor(enc.clrs.white)
	function use:Paint(w,h)
		local hov = self:IsHovered()
		local clr = hov and enc.clrs.white or enc.clrs.inbg
		draw.RoundedBox(6,0,0,w,h,clr)
	end
	function use:OnCursorEntered()
		self:SetTextColor(enc.clrs.black)
	end
	function use:OnCursorExited()
		self:SetTextColor(enc.clrs.white)
	end
	function use:DoClick()
		LocalPlayer():UseItem( con_id, slot )
		invnewpanel:Remove()
	end

	local drop = vgui.Create('DButton', invnewpanel)
	drop:Dock(TOP)
	drop:DockMargin(0,3,0,0)
	drop:SetTall(44)
	drop:SetText('Выкинуть')
	drop:SetFont("inv.tptitle")
	drop:SetTextColor(enc.clrs.white)
	function drop:Paint(w,h)
		local hov = self:IsHovered()
		local clr = hov and enc.clrs.white or enc.clrs.inbg
		draw.RoundedBox(6,0,0,w,h,clr)
	end
	function drop:OnCursorEntered()
		self:SetTextColor(enc.clrs.black)
	end
	function drop:OnCursorExited()
		self:SetTextColor(enc.clrs.white)
	end
	function drop:DoClick()
		LocalPlayer():DropItem( con_id, slot )
		invnewpanel:Remove()
	end

	local destroy = vgui.Create('DButton', invnewpanel)
	destroy:Dock(TOP)
	destroy:DockMargin(0,3,0,0)
	destroy:SetTall(44)
	destroy:SetText('Уничтожить')
	destroy:SetFont("inv.tptitle")
	destroy:SetTextColor(enc.clrs.white)
	function destroy:Paint(w,h)
		local hov = self:IsHovered()
		local clr = hov and enc.clrs.white or enc.clrs.inbg
		draw.RoundedBox(6,0,0,w,h,clr)
	end
	function destroy:OnCursorEntered()
		self:SetTextColor(enc.clrs.black)
	end
	function destroy:OnCursorExited()
		self:SetTextColor(enc.clrs.white)
	end
	function destroy:DoClick()
		LocalPlayer():DestroyItem( con_id, slot )
		invnewpanel:Remove()
	end
end

local Tooltip

function PANEL:CreateTooltip()
	if IsValid( Tooltip ) then
		Tooltip:SetVisible( true )
		return
	end

	Tooltip = vgui.Create( "ItemStoreTooltip" )
	self:UpdateTooltip()
end

function PANEL:UpdateTooltip()
	if not IsValid( Tooltip ) then return end

	Tooltip:SetContainerID( self:GetContainerID() )
	Tooltip:SetSlot( self:GetSlot() )
	Tooltip:SetItem( self:GetItem() )
	Tooltip:Refresh()
end

function PANEL:HideTooltip()
	if IsValid( Tooltip ) then Tooltip:SetVisible( false ) end
end

function PANEL:OnCursorEntered()
	if not self:GetItem() then return end

	-- self:CreateTooltip()
	-- self:UpdateTooltip()
end

function PANEL:OnCursorMoved()
	if not IsValid( Tooltip ) then return end

	local x, y = gui.MousePos()
	Tooltip:SetPos( x, y - Tooltip:GetTall() )
end

function PANEL:OnCursorExited()
	self:HideTooltip()
end

vgui.Register( "ItemStoreSlot", PANEL, "DModelPanel" )


--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
