--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher

include("unbox_config_2.lua")

BUC2.History = {}
BUC2.buttonsLocked = false

surface.CreateFont( "ub2_1", {
	font = "Open Sans Semibold", -- Use the font-name which is shown to you by your operating system Font Viewer, not the file name
	size = 19,
	weight = 8000,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false,
	extended = true
} )

surface.CreateFont( "ub2_2", {
	font = "Open Sans Semibold", -- Use the font-name which is shown to you by your operating system Font Viewer, not the file name
	size = 13,
	weight = 10,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false,
	extended = true
} )

surface.CreateFont( "ub2_3", {
	font = "Open Sans Semibold", -- Use the font-name which is shown to you by your operating system Font Viewer, not the file name
	size = 30,
	weight = 8000,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false,
	extended = true
} )

surface.CreateFont( "ub2_4", {
	font = "Open Sans Semibold", -- Use the font-name which is shown to you by your operating system Font Viewer, not the file name
	size = 24,
	weight = 8000,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false,
	extended = true
} )

surface.CreateFont( "ub2_5", {
	font = "Open Sans Semibold", -- Use the font-name which is shown to you by your operating system Font Viewer, not the file name
	size = 85,
	weight = 8000,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = true,
	additive = false,
	outline = true,
	extended = true
} )

surface.CreateFont( "ub2_6", {
	font = "Open Sans Semibold", -- Use the font-name which is shown to you by your operating system Font Viewer, not the file name
	size = 45,
	weight = 8000,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = true,
	additive = false,
	outline = true,
	extended = true
} )

surface.CreateFont( "ub2_7", {
	font = "Open Sans Semibold", -- Use the font-name which is shown to you by your operating system Font Viewer, not the file name
	size = 16,
	weight = 8000,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false,
	extended = true
} )

local function divColor( clr, x )
	return Color( clr.r/x, clr.g/x, clr.b/x )
end

local ButtonBlur = Material( "opencase/button_blur.png" )

local headerHight = 30

local ubButtons = {
	[ "Shop" ] = {
		Name = "Магазин",
		Icon = Material "opencase/icons/shop.png",
		Color = Color( 0, 152, 226 ),
		Order = 1
	},
	[ "Upgrade" ] = {
		Name = "Апгрейд",
		Icon = Material "opencase/icons/upgrade.png",
		Color = Color( 165, 90, 251 ),
		Order = 2
	},
	[ "Crate" ] = {
		Icon = Material "opencase/icons/inventory.png",
		Color = Color( 255, 196, 0 ),
		Order = 3
	},
	[ "Spin" ] = {Hidden = true, Order = 99},
}

local ub_createUpgrade
local ub_createSpin
local poorApi = { // Old (poorly coded) unbox api
	pages = {},
}

local ubFrame = nil
local ubPage = "Crate"

local isOpen = false

local p = FindMetaTable("Panel")

//local inventoryBackground = Material("bu2/inventory_background.png","smooth noclamp")

//local spinBackground = Material("bu2/spin_bg.png","smooth noclamp")
//local spinGlass = Material("bu2/spin_glass.png","smooth noclamp")
local itemShadowMat = Material("bu2/item_shadow.png","smooth noclamp")
local itemBackgroundMat = Material "opencase/bluredcircle.png"
//local itemBannerMat = Material("bu2/item_banner.png","smooth noclamp")
local moneyIcon = Material("bu2/money.png","smooth noclamp")

local OpenCase_Panel = {}

local frameColor = Color(30 , 35, 39 ,255)

local function FixCam( self )
	local min, max = self.Entity:GetRenderBounds()

	self:SetFOV( 80 )

	self:SetCamPos(min:Distance(max) * Vector(0.43, 0.43, 0))
	self:SetLookAt((max + min) / 2)
end


local function ub_findByIGSid( itemID )
	for k,v in pairs( BUC2.ITEMS ) do
		if v.weaponName == itemID or v.amount == itemID then
			return k
		end
	end
end

net.Receive("ub_annouceunbox", function()
	local player = net.ReadEntity()
	local items = net.ReadTable( )

	local msg = {}

	table.Add( msg, {
		Color(255,255,255,255), "|"
	} )

	table.Add( msg, {
		player:Name(), team.GetColor(player:Team()),
		Color(255,255,255,255), " открыл кейс и получил ",
	} )

	for i, itemID in pairs( items ) do
		local itemName = BUC2.ITEMS[itemID].name1
		local itemColor = BUC2.ITEMS[itemID].color

		if i ~= 1 then
			table.Add( msg, {Color(255,255,255), ", "} )
		end
		table.Add( msg, {itemColor, itemName} )
	end

	table.Add( msg, {
		Color(99,230,86,255), "  F6"
	} )

	table.Add( msg, {
		Color(255,255,255,255), " -> "
	} )

	table.Add( msg, {
		Color(170,86,230,255), "Кейсы"
	} )

	--Print the message
	chat.AddText( unpack( msg ) )
end) 

local function GenerateOutline( self )
	local x = 4
	local w,h = self:GetSize( )

	self.OutlineTop = {
		{x = 0, y = x},
		{x = x, y = 0},

		{x = w - x, y = 0},
		{x = w, y = x},
	}
	self.OutlineBottom = {
		{x = x, y = h},
		{x = 0, y = h - x},

		{x = w, y = h - x},
		{x = w - x, y = h},
	}
end

local SizeW = ScrW() <= 800 and (800 + 10) or 982
local resultWin = ScrW() <= 800 and 88 or 89

local function weight(w) return (w / 1920) * ScrW() end
local function height(h) return (h / 1080) * ScrH() end

local ModelPanel = CompileFile "unbox/modelpanel.lua" {
	outline = GenerateOutline,
	cam = FixCam,
	mat1 = itemBackgroundMat,
	mat2 = moneyIcon,
	weight = weight,
	height = height,
}
local CratePanel = CompileFile "unbox/crate.lua" ( )

function initUnboxFrame()

	if IsValid( sdasdasdsadasd ) then
		sdasdasdsadasd:Remove( )
	end
	BUC2.buttonsLocked = false

	ubPage = "Crate"

	isOpen = true
	ubFrame = vgui.Create("DFrame")
	sdasdasdsadasd = ubFrame
	ubFrame:SetSize(SizeW + 10, ScrH() <= 600 and 600 or 700)
	ubFrame:Center()
	ubFrame:SetDraggable(false)
	ubFrame:SetVisible(true)
	ubFrame:U_PaintFrame() 
	ubFrame:ShowCloseButton(false)
	ubFrame:MakePopup()

	// remove dframe default title
	ubFrame:SetTitle ""
	ubFrame:DockPadding( 5, 0, 5, 5 )


	local close_button = vgui.Create( "DButton" )
	close_button:MakePopup( )
	close_button:NoClipping( true )
	close_button:SetSize( 32, 32 )
	close_button:SetText ""
	close_button:RequestFocus( )
	close_button.Paint = function( self, w, h )
		surface.SetDrawColor( frameColor )
		surface.DrawRect( 0, 0, w, h )

		draw.SimpleText( "X", "DermaLarge", w/2, h/2, Color( 255, 0, 0 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )

		DisableClipping( true )
			draw.NoTexture( )
			surface.DrawPoly( {
				{x = -w * 1.5, y = h},
				{x = 0, y = 0},
				{x = 0, y = h}
			} )
		DisableClipping( false )
	end
	close_button.DoClick = function( self )
		if BUC2.buttonsLocked then return end
		if IsValid( ubFrame ) then
			ubFrame:Remove( )
		else // is it possible?
			self:Remove( )
		end
	end
	ubFrame.PerformLayout = function( self, w, h )
		local x,y = self:GetPos( )
		close_button:SetPos( x + w - 32, y - 32 )
	end
	ubFrame.OnRemove = function( )
		BUC2.buttonsLocked = false
		isOpen = false
		if IsValid( close_button ) then
			close_button:Remove( )
		end
	end


	ubFrame.historyHeader = vgui.Create( "EditablePanel", ubFrame )
	ubFrame.historyHeader:DockMargin( 5, 5, 5, 10 )
	ubFrame.historyHeader:Dock( TOP )
	ubFrame.historyHeader:SetTall( 115 )
	ubFrame.historyHeader.Fill = function( self, data )
		self:Clear( )
		for k, v in pairs( data ) do
			local id = ub_findByIGSid( v )
			if not id then continue end
			local t = vgui.CreateFromTable( ModelPanel, self )
			t:Dock( LEFT )
			t:DockMargin( 5, 0, 10, 0 )
			t:SetWide( 100 )
			t:Set( id )
	
		end
	end
	ubFrame.historyHeader:Fill( BUC2.History )


	local buttonsPanel = vgui.Create( "EditablePanel", ubFrame )
	buttonsPanel:Dock( TOP )
	buttonsPanel:SetTall( 35 )
	buttonsPanel:DockMargin(5, 0, 5, 5)


	ubFrame.scroller = vgui.Create( "DHorizontalScroller", ubFrame )
	ubFrame.scroller:Dock( FILL )
	ubFrame.scroller:SetShowDropTargets( false )
	ubFrame.scroller.btnLeft.Paint=nil
	ubFrame.scroller.btnRight.Paint=nil

	ubFrame.scroller.GetScroll = function( self ) return self.OffsetX end
	ubFrame.scroller.OnMouseWheeled = nil
	--ubFrame.scroller:SetOverlap( -100 )
	ubFrame.scroller:InvalidateParent( true )

	local function CreatePage( id, data )
		local btn = vgui.Create( "DButton", buttonsPanel )
		if data.Hidden then
			btn:SetVisible( false )
		end
		btn:Dock( LEFT )
		btn:DockMargin( 0, 0, 10, 0 )
		btn:SetText ""
		btn.Name = data.Name
		btn.Icon = data.Icon
		btn.Color = data.Color

		btn.CalculateSize = function( self )
			if self.Name then
				surface.SetFont( "ub2_3" )
				local w,h = surface.GetTextSize( self.Name )

				self:SetWide( w + 4 + 32 + 4 + 15 )
			else
				self:SetWide( 4 + 32 + 4 )
			end
		end
		btn:CalculateSize( )

		btn.Paint = function( self, w, h )
			local clr = self.Color or Color( 27, 151, 223 )
			clr = active == self and divColor(clr, 1.5) or self:IsDown() and divColor(clr, 2) or self:IsHovered() and divColor(clr, 1.75) or clr
			
			DisableClipping( true )
				surface.SetDrawColor( clr )
				surface.SetMaterial( ButtonBlur )
				surface.DrawTexturedRect( -w/10, -h/3.4, w + w/5, h + h/1.7 )
			DisableClipping( false )
			
			draw.RoundedBox( 0, 0, 0, w, h, clr )

			surface.SetDrawColor( 255, 255, 255 )
			surface.SetMaterial( self.Icon )
			surface.DrawTexturedRect( 4, h/2 - 16, 32, 32 )

			draw.SimpleText( self.Name, "ub2_3", 32 + 4 + 4, h/2 - 2 /*center font*/, Color( 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
		end

		local page = vgui.Create("DScrollPanel" , ubFrame.scroller)
		page:Dock( LEFT )
		page:SetWide( SizeW ) 
		page.Paint = function()end
		page:InvalidateParent( true )

		poorApi.pages[ id ] = page

		btn.DoClick = function( self )
			if BUC2.buttonsLocked then return end
			ub_Goto( id )
		end

		ubFrame.scroller:AddPanel( page )
	end

	for id, data in SortedPairsByMemberValue( ubButtons, "Order" ) do
		CreatePage( id, data )
	end

	local igs_money = vgui.Create( "EditablePanel", buttonsPanel )
	igs_money:Dock( RIGHT )
	igs_money:DockMargin( 0, 0, 10, 0 )
	igs_money:SetText ""

	local last

	igs_money.CalculateSize = function( self )
		surface.SetFont( "ub2_3" )
		local w,h = surface.GetTextSize( self.Text )

		self:SetWide( w + 4 + 32 + 4 + 8 )
	end

	igs_money.Paint = function( self, w, h )
		local igs = LocalPlayer():IGSFunds( )
		if last ~= igs then
			last = igs
			self.Text = igs .. " ₽"
			self:CalculateSize( )
		end
		draw.RoundedBox( 0, 0, 0, w, h, Color( 92, 137, 52 ) )

		draw.SimpleText( self.Text, "ub2_3", 32 + 4 + 4, h/2 - 2 /*center font*/, Color( 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
	end
	local plus = vgui.Create( "DButton", igs_money )
	plus:Dock( LEFT )
	plus:SetWide( 32 )
	plus:SetText ""
	plus.Paint = function( self, w, h )
		draw.RoundedBox( 0, 0, 0, w, h, Color( 145, 235, 65 ) )
		draw.SimpleText( "+", "DermaLarge", w/2, h/2, Color( 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	end
	plus.DoClick = function( self )
		if BUC2.buttonsLocked then return end
		IGS.WIN.Deposit( 100 )
	end

	poorApi.pages.Crate.Paint = function(s , w , h)

		--[[surface.SetDrawColor(255,255,255,255)
		surface.SetMaterial(inventoryBackground)
		surface.DrawTexturedRect(0,0,w,h)]]

		--draw.RoundedBox( 0, 0, 0, w, h, Color( 0, 255, 0 ) )
		if LocalPlayer().ubinv == nil or table.Count(LocalPlayer().ubinv) == 0 then
			draw.SimpleText("ПУСТО:(","ub2_5",w/2 , h/2,Color(255,255,255,255) , 1 , 1)
		end

	end

	ub_CreateInventory()
	ub_createShop()
	ub_createUpgrade( )
	ub_createSpin( )

	ubFrame.scroller:ScrollToChild( poorApi.pages.Shop ) // todo: Shop
end

local diagBack = Material("bu2/dialog_background.png", "noclamp smooth")

function ub_refreshInventory()

	if isOpen then
		
		poorApi.pages.Crate:Clear( )

		ub_CreateInventory()

	end

end

function createTansactionWindow(itemID , Amount)


	local buyWindow = vgui.Create("DFrame")
	buyWindow:SetSize(400 , 200)
	buyWindow:Center()
	buyWindow:SetTitle("")
	buyWindow:ShowCloseButton(false)
	buyWindow.itemID = itemID
	buyWindow.Amount = Amount
	buyWindow:SetText("")
	buyWindow.Paint = function(s , w , h)

		Derma_DrawBackgroundBlur( s, CurTime() )

		surface.SetDrawColor(255,255,255,255)
		surface.SetMaterial(diagBack)
		surface.DrawTexturedRect(0,0,w,h) 

		draw.SimpleText("Чек", "ub2_6",200 , 60, Color(255,255,255) , 1,1)

		draw.SimpleText("Кейс : "..BUC2.ITEMS[s.itemID].name1, "ub2_4",200 , 90, Color(255,255,255) , 1,1)
		draw.SimpleText("Количество : "..s.Amount, "ub2_4",200 , 115, Color(255,255,255) , 1,1)
		draw.SimpleText("Цена: "..(BUC2.ITEMS[s.itemID].price * s.Amount).."₽", "ub2_4",200 , 115 + 25, Color(255,255,255) , 1,1)


	end
	buyWindow:SetVisible(true)
	buyWindow:MakePopup()

	local cb = vgui.Create("DButton",buyWindow)
	cb:SetPos(23,200 - 35)
	cb:SetSize(200 - 60,23)
	cb:SetText("")
	cb.p = buyWindow
	cb.Paint = function(s , w  ,h)

		draw.RoundedBox(0,0,0,w,h , Color(30,150,30))

		draw.SimpleText("ОТМЕНА","ub2_2",math.floor(w/2) , math.floor(h/2) , Color(255,255,255,255) , 1 , 1)

	end
	cb.DoClick = function(s)

		s.p:Close()

	end

	local bb = vgui.Create("DButton",buyWindow)
	bb:SetPos(400 - 23 - (200-60),200 - 35)
	bb:SetSize(200 - 60,23)
	bb:SetText("")
	bb.itemID = itemID
	bb.Amount = Amount
	bb.parent = buyWindow
	bb.price = BUC2.ITEMS[itemID].price * Amount
	bb.canBuy = false
	bb.Paint = function(s , w  ,h)

		local c = Color(30,150,30)

		if not BUC2.BuyItemsWithPoints and not BUC2.BuyItemsWithPoints2 then
			
			if IGS.CanAfford(LocalPlayer(),s.price) == false then
				
				s.canBuy = false 
				c = Color(90,90,90) 

			else

				s.canBuy = true

			end


		else
			if BUC2.BuyItemsWithPoints then
				if LocalPlayer():PS_HasPoints(s.price) == false then
					s.canBuy = false 
					c = Color(90,90,90) 
				else
					s.canBuy = true
				end
			else
				if BUC2.BuyItemsWithPoints2 then
					if LocalPlayer().PS2_Wallet.points < s.price then
						s.canBuy = false 
						c = Color(90,90,90) 
					else
						s.canBuy = true
					end
				end
			end

		end

		draw.RoundedBox(0,0,0,w,h , c)

		draw.SimpleText("КУПИТЬ","ub2_2",math.floor(w/2) , math.floor(h/2) , Color(255,255,255,255) , 1 , 1)

	end
	bb.DoClick = function(s)

		if s.canBuy then

			net.Start("ub_purchase")
				net.WriteString(s.itemID)
				net.WriteInt(s.Amount , 8)
			net.SendToServer() 

			s.parent:Close()

		end

	end

end

local matsfstars = Material( "data/sfstarslogos.jpg", "smooth" )
http.Fetch( "https://i.imgur.com/Noiu7Pp.png", function( data )
    file.Write( "sfstarslogos.jpg", data )
    matsfstars = Material( "data/sfstarslogos.jpg" )
end )

local matrande = Material( "data/randelogos.jpg", "smooth" )
http.Fetch( "https://i.imgur.com/3zOYJLQ.png", function( data )
    file.Write( "randelogos.jpg", data )
    matrande = Material( "data/randelogos.jpg" )
end )

function ub_createShop()

	local xPos = 0
	local yPos = 0

	for k , v in pairs(BUC2.ITEMS) do
		
		if v.canBuy then

			local temp = vgui.CreateFromTable( CratePanel, poorApi.pages.Shop, "CratePanel" )
			temp:SetSize( 180, 180 )
			temp:SetPos(xPos + 5, yPos + 10)
			temp:Set( v )

			local amountPanel = vgui.Create("DPanel",temp)
			amountPanel:Dock( BOTTOM )
			amountPanel:SetTall( 30 )
			amountPanel.Paint = function(s , w , h)

				--[[draw.RoundedBox(0,0,0,w , h , Color(30,40,50))

				surface.SetDrawColor(Color(0,0,0))

				surface.DrawLine(0,0,180,0)
				surface.DrawLine(0,29,180,29)
				surface.DrawLine(0,28,180,28)

				surface.DrawLine(0,0,0,30)
				surface.DrawLine(1,0,1,30)

				surface.DrawLine(179,0,179,30)
				surface.DrawLine(178,0,178,30)]]

				draw.RoundedBox( 6, 5, 5, 80, 20, Color( 0, 75, 0 ) )

			end

			local plusAmount = vgui.Create("DButton",amountPanel)
			plusAmount:SetPos(5,5)
			plusAmount:SetSize(20,20)
			plusAmount:SetText("")
			plusAmount.Paint = function(s , w ,h)

				draw.RoundedBox(6,0,0,w,h , Color(0, 152, 0))

				draw.SimpleText("-","ub2_2",w/2 , h/2 , Color(255,255,255,255) , 1 , 1)

			end
			plusAmount.DoClick = function(s)

				s.dis.Amount = s.dis.Amount - 1

				if s.dis.Amount < 1 then
					
					s.dis.Amount = 1

				end

			end

			local minusAmount = vgui.Create("DButton",amountPanel)
			minusAmount:SetPos(180 /2 - 5 - 20 , 5)
			minusAmount:SetSize(20,20)
			minusAmount:SetText("")
			minusAmount.Paint = function(s , w ,h)

				draw.RoundedBox(6,0,0,w,h , Color(0, 152, 0))

				draw.SimpleText("+","ub2_2",w/2 , h/2 , Color(255,255,255,255) , 1 , 1)
 
			end
			minusAmount.DoClick = function(s)

				s.dis.Amount = s.dis.Amount + 1

				if s.dis.Amount > 16 then
					
					s.dis.Amount = 16

				end

			end

			local amountDisplay = vgui.Create("DPanel",amountPanel)
			amountDisplay:SetPos(5 + 20, 5)
			amountDisplay:SetSize((180/2 - 20 - 20 - 5 - 5),20)
			amountDisplay.Amount = 1
			amountDisplay.Paint = function(s , w , h)

				draw.SimpleText(s.Amount,"ub2_2",w/2 , h/2 , Color(255,255,255,255) , TEXT_ALIGN_CENTER , TEXT_ALIGN_CENTER)

			end

			plusAmount.dis = amountDisplay
			minusAmount.dis = amountDisplay


			local buyButton = vgui.Create("DButton",amountPanel)
			buyButton:SetPos(180/2 + 5 , 5)
			buyButton:SetSize(180/2 - 5 - 5 , 20)
			buyButton.item = k
			buyButton.dis = amountDisplay
			buyButton.Paint = function(s , w , h)

				draw.RoundedBox(6,0,0,w,h , Color(0, 152, 0))
				if BUC2.ITEMS[s.item].discountedFrom and BUC2.ITEMS[s.item].discountedFrom > 0 then
					draw.SimpleText((BUC2.ITEMS[s.item].discountedFrom * s.dis.Amount) .."₽","ub2_2", 10 , h / 2, Color(255,255,255,255) , 0 , 1)

					draw.SimpleText((BUC2.ITEMS[s.item].price * s.dis.Amount).."₽","ub2_1", 40, h / 2, Color(255,0,0,255) , 0 , 1)

					surface.SetDrawColor( 255, 255, 255, 255 )
					surface.DrawLine( 5, 5, w / 2 - 5, h - 5 )
				else
					draw.SimpleText((BUC2.ITEMS[s.item].price * s.dis.Amount).."₽","ub2_1", w/2, h / 2, Color(255,255,255,255) , 1 , 1)
				end

			end
			buyButton:SetText("")
			buyButton.DoClick = function(s)

				createTansactionWindow(s.item , s.dis.Amount)

			end

			temp:SetCursor "hand"
			temp.OnMouseReleased = function( s )
				--createTansactionWindow(s.item , s.dis.Amount)
				local t = BUC2.ITEMS[s.item].itemType
			 
				if t == "Crate" then
					initSpinMenu(s.item, true) 
					ub_Goto("Spin") 
				end
			end
			temp.item = k
			temp.dis = amountDisplay

			
			

			xPos = xPos + 198

			if xPos > SizeW - 100 then
				
				xPos = 0
				yPos = yPos + 180 + 15

			end

		end

	end

end

function createModelModule(k , v , x ,y)
	
	local temp = vgui.Create("DPanel" , poorApi.pages.Crate)
	temp:SetSize(180, 180)
	temp:SetPos(x + 10 , y + 10)
	temp.itemTable = v
	temp.itemType = v.itemType 
	temp.outlinec = Color(0,0,0) 
	temp.Paint = function(s , w ,h)

		surface.SetDrawColor(255,255,255,255)
		surface.SetMaterial(itemShadowMat)
		surface.DrawTexturedRect(0,0,180,180)

		local col = s.itemTable.color

		--[[ surface.SetDrawColor(col)
		surface.SetMaterial(itemBannerMat)
		surface.DrawTexturedRect(0,180,180,40)--]] 

		--Draw text

		draw.SimpleText(s.itemTable.name1,"ub2_1",w/2,2,Color(255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
		--draw.SimpleText(s.itemTable.name2,"ub2_2",5,200,Color(255,255,255))

	end

	local mod = vgui.Create("DModelPanel" , temp)
	mod:SetPos(0,0)
	mod:SetSize(180,180)
	mod:SetModel(v.model)
	mod:SetAnimated(false)
	mod.ang = mod.Entity:GetAngles()
	function mod:LayoutEntity(Entity)
		if ( self.bAnimated ) then
			self:RunAnimation()
		end
	end

	FixCam( mod )
	
	local over = vgui.Create("DButton" , temp)
	over:SetText("")
	over:SetPos(0,0)
	over:SetSize(180,180)
	over.col = Color(0,0,0,255)
	over.alpha = 0
	over.itemID = k
	over.Paint = function(s , w , h)

		--draw.SimpleText("OPEN","ub2_3",180/2,180/2,Color(255,255,255 , s.alpha) , 1 , 1)
		if BUC2.ITEMS[s.itemID].itemType == "Weapon" then
			
			if BUC2.ITEMS[s.itemID].permanent then
				
				draw.RoundedBox(0 , 0,0 , 180 , 20 , Color(255,90,90,255))
				draw.SimpleText("PERMANENT","ub2_1",180/2 , 10,Color(255,255,255) , 1 , 1)

			end

		end

		draw.RoundedBox(0,0,0,w,h,Color(40,40,40,s.alpha))

		surface.SetDrawColor(s.col)

		surface.DrawLine(0,180 , 180, 180)
		for i = 0 , 1 do  

			surface.DrawOutlinedRect( i, i, w - (i*2),h - (i*2))

		end

	end
	over.Think = function(s)

		if s:IsHovered() then
			
			s.col = Color(30,150,30)
			s.alpha = Lerp(10*FrameTime() , s.alpha ,190)

		else

			s.col = Color(0,0,0)
			s.alpha = Lerp(10*FrameTime() , s.alpha , 0)

		end 

	end

	return over

end


function createPngModule(k , v , x ,y)
	
	local temp = vgui.CreateFromTable( CratePanel, poorApi.pages.Crate, "CratePanel" )
	temp:SetSize( 180, 180 )
	temp:SetPos(x + 5 , y + 10)
	temp:Set( v )
	
	local over = vgui.Create("DButton" , temp)
	over:SetText("")
	over:SetPos(0,0)
	over:SetSize(180,180)
	over.col = Color(0,0,0,255)
	over.alpha = 0
	over.itemID = k
	over.Paint = function(s , w , h)

		draw.RoundedBox(0,0,0,w,h,Color(40,40,40,s.alpha))

		--draw.SimpleText("OPEN","ub2_3",180/2,180/2,Color(255,255,255 , s.alpha) , 1 , 1)

		surface.SetDrawColor(s.col)

		surface.DrawLine(0,180 , 180, 180)
		for i = 0 , 1 do  

			surface.DrawOutlinedRect( i, i, w - (i*2),h - (i*2))

		end

	end
	over.Think = function(s)

		if s:IsHovered() then
			
			s.col = Color(30,150,30)
			s.alpha = Lerp(10*FrameTime() , s.alpha ,190)

		else

			s.col = Color(0,0,0)
			s.alpha = Lerp(10*FrameTime() , s.alpha , 0)

		end 

	end

	return over

end

local containPanel = nil

function generateTape(itemID)

	local totalChance = 0

	for k, itemKey in pairs(BUC2.ITEMS[itemID].items) do
		local itemData = BUC2.ITEMS[itemKey]
		if itemData then
			totalChance = totalChance + itemData.chance
		end
	end

	local itemList = {}

	for i = 0, 99 do

		local num = math.random(1, totalChance)

		local prevCheck = 0

		local item = nil

		for k, itemKey in pairs(BUC2.ITEMS[itemID].items) do

			local itemData = BUC2.ITEMS[itemKey]
			if itemData then

				if itemData.itemType ~= "Key" and itemData.itemType ~= "Crate" then

					if num >= prevCheck and num <= prevCheck + itemData.chance then

						item = itemKey -- store BUC2.ITEMS key, not display name

					end

					prevCheck = prevCheck + itemData.chance

				end

			end

		end

		if item == nil then
			for k, v in pairs(BUC2.ITEMS[itemID].items) do
				local itemData = BUC2.ITEMS[v]
				if itemData and itemData.itemType ~= "Key" and itemData.itemType ~= "Crate" then
					item = v
					break
				end
			end
		end

		itemList[i] = item

	end

	return itemList

end

net.Receive("StartClientSpinAnimation",function()

	LocalPlayer():EmitSound("buttons/lever1.wav")

	local tbl = net.ReadTable( )

	if isOpen and IsValid( ubFrame ) and poorApi.pages.Spin then
		poorApi.pages.Spin:DoSpin( tbl )
	elseif IsValid( BUC2.DonateInvPanel ) then
		BUC2.DonateInvPanel:DoSpin( tbl )
	else
		BUC2.buttonsLocked = false
	end

end)  

local function ub_getUpgradeItems( upgrade )
	if not IsValid( upgrade ) then return nil end
	if istable( upgrade.Items ) then return upgrade.Items end
	if upgrade.GetItems then return upgrade:GetItems( ) end
	if IsValid( upgrade.Page ) and upgrade.Page.GetItems then return upgrade.Page:GetItems( ) end
	return nil
end

local function ub_removeSelectedUpgradeItem( upgrade )
	if not IsValid( upgrade ) or upgrade.IsMoney then return end
	if not upgrade.GetLeft then return end

	local left = upgrade:GetLeft( )
	if not left then return end

	local items = ub_getUpgradeItems( upgrade )
	local left_item = items and items[ left ]
	if left_item and IsValid( left_item.panel ) then
		left_item.panel:Remove( )
	end
end

net.Receive("StartClientUpgradeAnimation",function()

	local mode = net.ReadUInt( 3 )

	if IsValid( BUC2.DonateUpgradePanel ) then
		if mode == 0 then
			buttonsLockeds = false
		elseif mode == 1 then
			BUC2.DonateUpgradePanel:DoSpin( true )
		elseif mode == 2 then
			BUC2.DonateUpgradePanel:DoSpin( false )
		end

		if mode == 1 or mode == 2 then
			ub_removeSelectedUpgradeItem( BUC2.DonateUpgradePanel )
		end
		return
	end

	if not isOpen then return end
	if !IsValid( ubFrame ) then return end

	if mode == 0 then
		BUC2.buttonsLocked = false

	elseif mode == 1 then
		poorApi.pages.Upgrade:DoSpin( true )

	elseif mode == 2 then
		poorApi.pages.Upgrade:DoSpin( false )

	else
		BUC2.buttonsLocked = false
	end

	if mode == 1 or mode == 2 then
		ub_removeSelectedUpgradeItem( poorApi.pages.Upgrade )
	end

end)

function initSpinMenu(itemID, check)

	if containPanel ~= nil then
		
		poorApi.pages.Spin:Clear()
		containPanel:Remove()

	end  

	poorApi.pages.Spin.GetCaseID = function() return itemID end

	local opencaseblur = Material( "opencase/opencase.png" )
	opencaseblur:Recompute( )

	local temp = vgui.CreateFromTable( CratePanel, poorApi.pages.Spin, "CratePanel" )
	poorApi.pages.Spin.spinPanel = temp
	temp:Dock( TOP )
	temp:SetTall( 225 )
	temp:DockMargin( 8, 10, 8, 0 )
	temp:Set( BUC2.ITEMS[ itemID ] )
	temp:SetTooltip( )
	local red = Color( 255, 0, 0 )
	temp.PaintBackground = function( self, w, h )
		surface.SetDrawColor( red )
		surface.SetMaterial( opencaseblur )
		surface.DrawTexturedRect( 0, 0, w, h )

		draw.SimpleText( self.itemTable.name1, "ub2_3", w/2, 0, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP )
		--draw.RoundedBox( 0, 0, 0, w, h, Color( 255, 100, 100, 100 ) )
	end

	if not check then
		local color = Color( 255, 24, 24 )
		local OpenButton = vgui.Create( "DButton", temp )
		OpenButton:SetPos( (3*SizeW/4) - 75, 225/2 - 20 )
		OpenButton:SetSize( 166, 40 )
		OpenButton:SetText ""
		OpenButton.Mat = Material( "opencase/icons/unbox.png" )
		OpenButton.Paint = function( self, w, h )
			draw.RoundedBox( 6, 0, 0, w, h, self:IsDown() and divColor( color, 1.75 ) or self:IsHovered() and divColor( color, 1.25 ) or color )

			surface.SetDrawColor( 255, 255, 255 )
			surface.SetMaterial( self.Mat )
			surface.DrawTexturedRect( 10, h/2 - 19/2 + 1, 24, 19 )

			draw.SimpleText( "ОТКРЫТЬ", "ub2_3", 44, h/2, Color( 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
		end

		local tbl = {
			1, 2, 3, 5, 10
		}
		local count = table.Count( tbl )

		local Available = 0
		for k,v in pairs( LocalPlayer().ubinv or {} ) do
			if v == itemID then
				Available = Available + 1
				if Available == tbl[ count ] then
					break
				end
			end
		end

		if Available < 10 then
			tbl = {
				1, 2, 3, 4, 5
			}
		end

		for k, v in pairs( tbl ) do
			if v > Available then
				tbl[ k ] = nil
			end
		end
		count = table.Count( tbl )

		local active = 1
		if count > 1 then

			local panel = vgui.Create( "EditablePanel", temp )
			local size = count * 40 + (count - 1) * 1
			panel:SetPos( (SizeW/5) - size/2, 225/2 - 20 )
			panel:SetSize( size, 40 )
			panel.Paint = function( self, w, h )
				draw.RoundedBox( 0, 2, 0, w - 4, h, Color( 73, 11, 11 ) )
			end


			local color = Color( 216, 12, 12 )
			for k, v in next, tbl do
				local bt = vgui.Create( "DButton", panel )
				bt:Dock( LEFT )
				bt:DockMargin( k == 1 and 0 or 1, 0, 0, 0 )
				bt:SetWide( 40 )
				bt:SetText ""
				if k ~= 1 and k ~= count then
					bt.PaintBox = function( self, w, h )
						draw.RoundedBox( 0, 0, 0, w, h, active == v and divColor( color, 1.5 ) or self:IsDown() and divColor( color, 2 ) or self:IsHovered() and divColor( color, 1.75 ) or color )
					end
				else
					bt.PaintBox = function( self, w, h )
						if k == 1 then
							draw.RoundedBoxEx( 6, 0, 0, w, h, active == v and divColor( color, 1.5 ) or self:IsDown() and divColor( color, 2 ) or self:IsHovered() and divColor( color, 1.75 ) or color, true, false, true, false )
						else
							draw.RoundedBoxEx( 6, 0, 0, w, h, active == v and divColor( color, 1.5 ) or self:IsDown() and divColor( color, 2 ) or self:IsHovered() and divColor( color, 1.75 ) or color, false, true, false, true )
						end
					end
				end
				bt.Paint = function( self, w, h )
					self:PaintBox( w, h )
					draw.SimpleText( v, "ub2_3", w/2, h/2, Color( 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
				end
				bt.DoClick = function( s )
					active = v
				end
			end
		end

		OpenButton.requestSent = nil
		OpenButton.DoClick = function( self, w, h )
			if Available < active then return end
			if not self.requestSent then
				self.requestSent = true
				BUC2.buttonsLocked = true
				net.Start("BeginSpin")
					net.WriteString( itemID )
					net.WriteUInt( active, 4 )
				net.SendToServer( )
			end 
		end
	end

	containPanel = vgui.Create("EditablePanel", poorApi.pages.Spin)
	containPanel:Dock( TOP )
	containPanel:DockMargin( 0, 10, 0, 0 )

	--Create All the Items Modules

	if BUC2.ITEMS[itemID] ~= nil then
		
		if BUC2.ITEMS[itemID].items ~= nil and table.Count(BUC2.ITEMS[itemID].items) > 0 then
			
			local xPos = 5
			local yPos = 10 

			for k, v in pairs(BUC2.ITEMS[itemID].items) do
				

				local testPan = vgui.CreateFromTable( ModelPanel, containPanel )
				testPan:SetPos(xPos,yPos)
				testPan:SetSize(100 , 110)
				testPan:Set( v )
				xPos = xPos + 100 + 9

				if xPos > SizeW - 50 then
					
					xPos = 5
					yPos = yPos + 100 + 20 + 9

				end

			end

			containPanel:SetTall( yPos + 110 )

		end

	end


end

function ub_inventory_menu(itemID)

	local m = vgui.Create("DMenu")
	m:SetPos(gui.MouseX() , gui.MouseY())

	local t = BUC2.ITEMS[itemID].itemType
 
	if t == "Crate" then

		local t = m:AddOption("Открыть")
		t.id = itemID
		t.DoClick = function(s) 
			initSpinMenu(s.id) 
			ub_Goto("Spin") 
		end

	end

	if t == "Entity" then
		
		local e = m:AddOption("Spawn", function(s)

			net.Start("ub_spawnEntity")
				net.WriteString(s.id)
			net.SendToServer()

			isOpen = false
			ubFrame:Close()

		end)
		e.id = itemID

	end

	if t == "Weapon" then 
		
		m:AddOption("Equip", function(s)

			net.Start("ub_equipweapon")
				net.WriteString(itemID)
			net.SendToServer()

		end)
		m.id = itemID

	end

	local sm = m:AddSubMenu("Подарить")
	for k , v in pairs(player.GetAll()) do
		
		if v ~= LocalPlayer() then
			 
			local temp = sm:AddOption(v:Name() , function(s)

				net.Start("ub_giftitem")
					net.WriteString(s.id)
					net.WriteEntity(s.ply)
				net.SendToServer()

			end)
			temp.id = itemID
			temp.ply = v

		end

	end

	sm:AddSpacer()

	m:Open()

end
 
function ub_CreateInventory()

	if LocalPlayer().ubinv ~= nil and table.Count(LocalPlayer().ubinv) > 0 then
		
		local xPos = 0
		local yPos = 0

		for k , v in pairs(LocalPlayer().ubinv) do

			if v ~= nil and BUC2.ITEMS[v] ~= nil then

				local id = v
				v = BUC2.ITEMS[v]
				local pan = nil



				if v.itemType == "Key" or v.itemType == "Crate" then
					
					pan = createPngModule(k , v , xPos ,yPos) 

				else

					pan = createModelModule(k , v , xPos , yPos)

				end

				pan.itemID = id
				pan.DoClick = function(s)

					ub_inventory_menu(s.itemID)

				end

				xPos = xPos + 198

				if xPos > SizeW - 100 then
					
					xPos = 0
					yPos = yPos + 190

				end

			end

		end

	end

end


local prevPos = 0
function ub_Goto(page)

	if page ~= ubPage then

		ubST = 0
		ubPage = page

	end

	local function navTo( pnl )
		if not IsValid( pnl ) then return end
		local x, y = ubFrame.scroller:GetCanvas( ):GetChildPosition( pnl )
		local w, h = pnl:GetSize()

		x = x + w * 0.5
		x = x - ubFrame.scroller:GetWide() * 0.5

		--self:SetScroll( x )
		ubFrame.scroller.Think = function( self )
			self:SetScroll( Lerp( 10*FrameTime(), self:GetScroll( ), x ) )
			if math.abs(x - self:GetScroll( )) < 0.1 then
				self:SetScroll( x )
				self.Think = nil
			end
		end
	end

	navTo( poorApi.pages[ page ] )

end 

function p:U_PaintFrame()

	self.Paint = function(s , w ,h)

		draw.RoundedBox(0,0,0,w,h, frameColor)
 
		surface.SetDrawColor( Color( 0,0,0,255 ) )
		surface.DrawOutlinedRect( 0, 0, w,h)

	end
 
end


net.Receive( "ub_openui", function( )

	if isOpen == false then

		initUnboxFrame( ) 

	end

end )

function ub_hasItem(itemID)

	for k , v in pairs(LocalPlayer().ubinv or {}) do
		
		if v == itemID then
			
			return true 

		end

	end

	return false

end


net.Receive("ub_inventory_update", function()
	local len = net.ReadDouble()
	local e = net.ReadData(len)
	e = util.Decompress(e)
	e = util.JSONToTable(e)
	
	--Convert from ID'S to string ID's
	local i = {}
	for k ,v in pairs(e) do 
		for a = 1 , v do
			table.insert(i, k)
		end 
	end  
	LocalPlayer().ubinv = i
	ub_refreshInventory()
end)

net.Receive( "ub_history_update", function()
	local dataLen = net.ReadUInt( 16 )
	local compressed = net.ReadData( dataLen )
	if not compressed then return end
	local json = util.Decompress( compressed )
	if not json then return end
	local tbl = util.JSONToTable( json )

	BUC2.History = tbl

	if isOpen and IsValid( ubFrame ) and IsValid( ubFrame.historyHeader ) then
		if tbl and table.Count( tbl ) > 0 then
			ubFrame.historyHeader:Fill( tbl )
		end
	end

	if IsValid( BUC2.DonateCasePanel ) and BUC2.DonateCasePanel._historyHeaders then
		if IsValid( BUC2.DonateCasePanel._historyHeaders ) then
			if tbl and table.Count( tbl ) > 0 then
				BUC2.DonateCasePanel._historyHeaders:Fill( tbl )
			end
		end
	end
end )

 

net.Receive("unboxadmin" , function()

	local isAllowed = false

	for k , v in pairs(BUC2.RanksThatCanGiveItems) do
		
		if LocalPlayer():GetUserGroup() == v then
			
			isAllowed = true

		end

	end

end)

function ub_giveitems()

	local frame = vgui.Create("DFrame")
	frame:SetSize(250,160)
	frame:Center()
	frame:SetVisible(true)
	frame:SetTitle("Unboxing Admin Panel")
	frame:MakePopup()

	local item = vgui.Create("DComboBox",frame)
	item:SetPos(20 , 35)
	item:SetSize(210,20)
	item:SetValue("Select An Item")
	for k , v in pairs(BUC2.ITEMS) do
		if v.itemType ~= "IGS" and v.itemType ~= "Points" and v.itemType ~= "Points2" and v.itemType ~= "PSItem" and v.itemType ~= "PSItem2" then
			item:AddChoice(k)
		end
	end

	local target = vgui.Create("DComboBox",frame)
	target:SetPos(20 , 35 + 30)
	target:SetSize(210,20)
	target:SetValue("Select A Player")
	for k , v in pairs(player.GetAll()) do
		target:AddChoice(v:Name() , v)
	end

	local amount = vgui.Create( "DTextEntry", frame )	
	amount:SetPos( 20 , 35 + 30 + 30 )
	amount:SetSize( 210, 20 )
	amount:SetText( "Enter Amount" )

	local give = vgui.Create( "DButton", frame )	
	give:SetPos( 20 , 35 + 30 + 30 + 30 )
	give:SetSize( 210, 20 )
	give:SetText( "Give" )
	give.target = target
	give.item = item
	give.amount = amount
	give.DoClick = function(s)

		if BUC2.buttonsLocked then return end

		if BUC2.ITEMS[s.item:GetSelected()] ~= nil then
			
			local name , ply = s.target:GetSelected()

			if name ~= "Select A Player" and IsValid(ply) then
				
				local amount = tonumber(amount:GetValue())

				if amount ~= nil and amount > 0 and amount < 1000 then
					
					net.Start("ub_admingiveitems")
						net.WriteString(s.item:GetSelected())	
						net.WriteEntity(ply)
						net.WriteInt(amount , 8)
					net.SendToServer()	

				end

			end

		end


	end

end

local UpgradePage = CompileFile "unbox/upgrade.lua" {
	ModelPanel = ModelPanel,
	find = ub_findByIGSid,
	FixCam = FixCam,
	divColor = divColor,
}

function ub_createUpgrade( )
	local page = vgui.CreateFromTable( UpgradePage, poorApi.pages.Upgrade, "Upgrade Panel" )
	page:Dock( FILL )
	page:InvalidateParent( true )
	page:SetTall( poorApi.pages.Upgrade:GetTall( ) )
	poorApi.pages.Upgrade.Page = page
	poorApi.pages.Upgrade.DoSpin = function(s, b) page:DoSpin( b ) end
	poorApi.pages.Upgrade.GetLeft = function(s) return page:GetLeft( ) end
	poorApi.pages.Upgrade.GetRight = function(s) return page:GetRight( ) end
	poorApi.pages.Upgrade.GetItems = function(s) return page:GetItems( ) end
	poorApi.pages.Upgrade.GetLeftData = function(s) return page:GetLeftData( ) end
end

local SpinnerPanel = CompileFile "unbox/spinner.lua" {
	ModelPanel = ModelPanel,
	generateTape = generateTape,
	frameColor = frameColor,
	gradientL = gradientL,
	gradientR = gradientR,
	weight = weight,
	height = height,
}

function ub_createSpin( )

	poorApi.pages.Spin.OnFinish = function( self )
		net.Start( "SpinEnded" )
			net.WriteBool( true )
		net.SendToServer( )

		LocalPlayer( ):EmitSound( "buttons/lever6.wav" )

		timer.Simple(2.5,function()

			ub_Goto("Crate")
			BUC2.buttonsLocked = false

		end)
	end
	poorApi.pages.Spin.DoSpin = function( self, tbl )

		// hide childs
		--[[ for k, v in pairs( self:GetChildren( ) ) do
			if v:GetName( ) ~= "Spinner" then
				v:SetVisible( false )
			end
		end--]] -- unnecessary, because it will be recreated on next attempt to spin
		if IsValid( self.spinPanel ) then
			self.spinPanel:Remove( )
		end

		local caseID = self:GetCaseID( )
		local p = nil
		for i, id in next, tbl do
			local panel = vgui.CreateFromTable( SpinnerPanel, self, "Spinner" )
			panel:Dock( TOP )
			panel:DockMargin( 5, 5, 5, 5 )
			panel:SetWide( SizeW )
			panel:SetTall( 115 )
			panel:SetID( caseID )
			panel:DoSpin( id )
			panel:SetZPos( -200 )
			p = panel
		end
		if !IsValid( p ) then BUC2.buttonsLocked = false return end
		p.OnFinish = self.OnFinish
	end
end


--[[ hook.Add("HUDPaint", "showskidd", function()
	if isOpen then
		local colorskidki = HSVToColor( CurTime() % 6 * 60, 1, 1 )
		colorskidki.a = 255
		draw.SimpleText("СКИДКИ ДО 90% НА ВСЕ КЕЙСЫ!","ub2_5",ScrW() / 2 , ScrH() / 2 - 350,colorskidki , 1 , 1)
	end
end)--]] 

--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher