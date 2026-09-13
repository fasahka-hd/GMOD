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
~ file: addons/itemstore/lua/itemstore/vgui/container.lua ~

]]

local PANEL = {}

function PANEL:Init()
    self.Page = 1
	self.Pages = {}
	self.Slots = {}

	table.insert( itemstore.containers.Panels, self )
end

function PANEL:SetContainerID( id )
	self.ContainerID = id
	self:Refresh()
end

function PANEL:GetContainerID()
	return self.ContainerID
end

function PANEL:GetPage()
    return self.Page
end

function PANEL:SetPage(page)
    self.Page = page
    for k, v in ipairs(self.Pages) do
        if IsValid(v) then
            v:SetVisible(k == page)
        end
    end
end

function PANEL:Refresh()
	local id = self:GetContainerID()
	local con = itemstore.containers.Get( id )
	local pagepael

	if con then
		for i = 1, con:GetSize() do
			local page_id = con:GetPageFromSlot( i )
			local page = self.Pages[ page_id ]

			if not page then
				page = vgui.Create( "DIconLayout", self )
				page:Dock(TOP)
				page:SetSpaceX( enc.w(9) )
				page:SetSpaceY( enc.h(9) )
				self.Pages[ page_id ] = page
				self:SetPage(1)

				if not IsValid(pagepael) then
					pagepael = vgui.Create('Panel', self)
					pagepael:Dock(BOTTOM)
					pagepael:DockMargin(0,0,0,0)
					pagepael:SetTall(enc.h(30))
					
					local backpage = vgui.Create('DButton', pagepael)
					backpage:Dock(LEFT)
					backpage:SetWide(enc.w(30))
					backpage:SetText('<')
					backpage:SetTextColor(enc.clrs.white)
					function backpage:Paint(w,h)
						draw.RoundedBox(4,0,0,w,h,enc.clrs.bg)
					end
					function backpage.DoClick()
						if self:GetPage() == 1 then return end
						
						self:SetPage(self:GetPage()-1)
						mypage:SetText('Страница ' .. self:GetPage())
						mypage:SizeToContents()
					end

					local nextpage = vgui.Create('DButton', pagepael)
					nextpage:Dock(LEFT)
					nextpage:DockMargin(enc.w(5),0,0,0)
					nextpage:SetWide(enc.w(30))
					nextpage:SetText('>')
					nextpage:SetTextColor(enc.clrs.white)
					function nextpage:Paint(w,h)
						draw.RoundedBox(4,0,0,w,h,enc.clrs.bg)
					end
					function nextpage.DoClick()
						if self:GetPage() >= table.Count(self.Pages) then return end

						self:SetPage(self:GetPage()+1)
						mypage:SetText('Страница ' .. self:GetPage())
						mypage:SizeToContents()
					end

					mypage = vgui.Create('DLabel', pagepael)
					mypage:Dock(LEFT)
					mypage:DockMargin(enc.w(10),0,0,0)
					mypage:SetText('Страница ' .. self:GetPage())
					mypage:SetFont('MKfont.16')
					mypage:SetTextColor(enc.clrs.white)
					mypage:SizeToContents()
				end
			end

			local slot = self.Slots[ i ]

			if not slot then
				slot = page:Add( "ItemStoreSlot" )
				slot:SetSize( enc.w(70), enc.h(70) )
				slot:SetContainerID( self:GetContainerID() )
				slot:SetSlot( i )

				self.Slots[ i ] = slot
			end

			slot:SetItem( con:GetItem( i ) )
			slot:Refresh()
		end
	end
	self:SizeToContents()
end

function PANEL:SizeToContents()
	local id = self:GetContainerID()
	local con = itemstore.containers.Get( id )

	self:SetSize( enc.w(307), enc.h(585) )
end

function PANEL:Paint(w,h)
end

vgui.Register( "ItemStoreContainer", PANEL, "Panel" )


--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
