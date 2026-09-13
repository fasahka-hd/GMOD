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
~ file: addons/itemstore/lua/itemstore/vgui/traderequest.lua ~

]]

local PANEL = {}

function PANEL:Init()
	self:SetSkin( "itemstore" )
	self:SetTitle( itemstore.Translate( "trade_request" ) )

	self:ShowCloseButton( false )

	self.Label = vgui.Create( "DLabel", self )

	self.Accept = vgui.Create( "DButton", self )
	self.Accept:SetText( itemstore.Translate( "accept" ) )

	function self.Accept.DoClick()
		itemstore.trading.Panel = vgui.Create( "ItemStoreTrade" )
		itemstore.trading.Panel:Refresh()
		itemstore.trading.Panel:Center()
		itemstore.trading.Panel:MakePopup()

		self:Remove()
	end

	self.Deny = vgui.Create( "DButton", self )
	self.Deny:SetText( itemstore.Translate( "deny" ) )
	
	function self.Deny.DoClick()
		net.Start( "ItemStoreCloseTrade" ) net.SendToServer()
		self:Remove()
	end
end

function PANEL:Refresh()
	self.Label:SetText( itemstore.Translate( "wants_to_trade",
		LocalPlayer().Trade.Left.Player:Name() ) )
end

function PANEL:PerformLayout()
	self.BaseClass.PerformLayout( self )

	self.Label:SizeToContents()
	self.Label:SetPos( self:GetWide() / 2 - self.Label:GetWide() / 2, 30 )

	self.Accept:SetSize( 75, 30 )
	self.Accept:SetPos( self:GetWide() / 2 - self.Accept:GetWide() - 15, self:GetTall() / 2 + 10 )

	self.Deny:SetSize( 75, 30 )
	self.Deny:SetPos( self:GetWide() / 2 + 15, self:GetTall() / 2 + 10 )
end

vgui.Register( "ItemStoreTradeRequest", PANEL, "DFrame" )


--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
