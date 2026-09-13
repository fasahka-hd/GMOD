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
~ file: addons/itemstore/lua/itemstore/vgui/admin.lua ~

]]

local PANEL = {}

function PANEL:Init()
	self:SetTitle( itemstore.Translate( "admin_title" ) )
	self:SetSkin( "itemstore" )

	self.Scroll = vgui.Create( "DScrollPanel", self )
	self.Scroll:Dock( FILL )

	self.List = vgui.Create( "DListLayout", self.Scroll )
	self.List:Dock( FILL )
	for _, pl in ipairs( player.GetAll() ) do
		local b = self.List:Add( "DButton" )
		b:SetText( pl:Name() )
		b:DockMargin( 0, 0, 0, 2 )

		function b.DoClick()
			local menu = DermaMenu()

			menu:AddOption( itemstore.Translate( "inventory" ), function()
				net.Start( "ItemStoreAdminInventory" )
				 	net.WriteEntity( pl )
				net.SendToServer()
			end )

			menu:AddOption( itemstore.Translate( "bank" ), function()
				net.Start( "ItemStoreAdminBank" )
					net.WriteEntity( pl )
				net.SendToServer()
			end )

			menu:Open()
		end
	end
end

vgui.Register( "ItemStoreAdmin", PANEL, "DFrame" )


--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
