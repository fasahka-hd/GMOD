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
~ file: addons/itemstore/lua/itemstore/vgui/itemtooltip.lua ~

]]

DEFINE_BASECLASS( "DListLayout" )

local PANEL = {}

AccessorFunc( PANEL, "ContainerID", "ContainerID", FORCE_NUMBER )
AccessorFunc( PANEL, "Slot", "Slot", FORCE_NUMBER )
AccessorFunc( PANEL, "Item", "Item" )

function PANEL:Init()
	self:SetWide( 200 )
	self:SetDrawOnTop( true )
	self:DockPadding( 5, 5, 5, 5 )

	self.Name = self:Add( "DLabel" )
	self.Name:SetFont( "DermaDefaultBold" )
	self.Name:SetWrap( true )

	self.Model = self:Add( "DModelPanel" )
	self.Model:SetSize( 125, 125 )

	self.Description = self:Add( "DLabel" )
	self.Description:SetWrap( true )
end

PANEL.Blur = Material( "pp/blurscreen" )
function PANEL:Paint( w, h )
	self.Blur:SetFloat( "$blur", 8 )
	self.Blur:Recompute()
	render.UpdateScreenEffectTexture()

	local x, y = self:LocalToScreen( 0, 0 )

	surface.SetDrawColor( 255, 255, 255 )
	surface.SetMaterial( self.Blur )
	surface.DrawTexturedRect( x * -1, y * -1, ScrW(), ScrH() )

	surface.SetDrawColor( Color( 30, 30, 30, 200 ) )
	surface.DrawRect( 0, 0, w, h )
end

function PANEL:PerformLayout()
	self.Name:SizeToContents()
	self.Description:SizeToContents()

	BaseClass.PerformLayout( self )
end

function PANEL:Refresh()
	local item = self:GetItem()

	if not item then
		self.Model.Entity:Remove()
		self.Name:SetText( "" )
		self.Description:SetText( "" )

		return
	end

	local name = item:GetName()
	local desc = item:GetDescription() or ""

	if item:GetAmount() > 1 then
		name = name .. " x" .. item:GetAmount()
	end

	if self:GetSlot() then
		desc = desc .. "\n\n" .. itemstore.Translate( "dragtomove" )
		desc = desc .. "\n" .. itemstore.Translate( "mclicktodrop" )
		desc = desc .. "\n" .. itemstore.Translate( "rclickforoptions" )

		if item.Use then
			desc = desc .. "\n" .. itemstore.Translate( "dclicktouse" )
		end
	end

	self.Name:SetText( name )
	self.Name:SizeToContents()

	self.Description:SetText( desc )
	self.Description:SizeToContents()

	self.Model:SetModel( item:GetModel() )

	self.Model.Entity:SetMaterial( item:GetMaterial() )
	self.Model:SetColor( item:GetColor() or color_white )

	min, max = self.Model.Entity:GetRenderBounds()

	self.Model:SetCamPos( Vector( 0.55, 0.55, 0.55 ) * min:Distance( max ) )
	self.Model:SetLookAt( ( min + max ) / 2 )

	self:InvalidateLayout( true )
end

vgui.Register( "ItemStoreTooltip", PANEL, "DListLayout" )


--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
