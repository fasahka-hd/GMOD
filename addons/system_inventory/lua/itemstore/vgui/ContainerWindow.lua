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
~ file: addons/itemstore/lua/itemstore/vgui/containerwindow.lua ~

]]

local PANEL = {}

function PANEL:Init()
	self:SetSkin( "itemstore" )

	self.Container = vgui.Create( "ItemStoreContainer", self )
	self.Container:SizeToContents()
end

function PANEL:PerformLayout()
	self:SetSize( self.Container:GetWide() + 10, self.Container:GetTall() + 40 )
	self.Container:SetPos( 5, 31 )

	self.BaseClass.PerformLayout( self )
end

function PANEL:Refresh()
	self.Container:Refresh()
end

function PANEL:SetContainerID( id )
	self.Container:SetContainerID( id )
end

function PANEL:GetContainerID()
	return self.Container:GetContainerID()
end

vgui.Register( "ItemStoreContainerWindow", PANEL, "ui_frame" )


--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
