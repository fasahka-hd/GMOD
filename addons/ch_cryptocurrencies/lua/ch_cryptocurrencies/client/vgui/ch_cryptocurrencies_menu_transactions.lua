--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

--[[
	PORTFOLIO MENU
--]]
local buy_icon = Material( "materials/craphead_scripts/ch_cryptocurrencies/gui/plus.png" )
local sold_icon = Material( "materials/craphead_scripts/ch_cryptocurrencies/gui/minus.png" )

function CH_CryptoCurrencies.TransactionsMenu()
	local ply = LocalPlayer()
	
	local scr_w = ScrW()
	local scr_h = ScrH()
	
	local GUI_TransactionsFrame = vgui.Create( "DFrame" )
	GUI_TransactionsFrame:SetTitle( "" )
	GUI_TransactionsFrame:SetSize( scr_w * 0.37, scr_h * 0.485 )
	GUI_TransactionsFrame:Center()
	GUI_TransactionsFrame.Paint = function( self, w, h )
		-- Draw frame
		draw.RoundedBox( 8, 0, 0, w, h, CH_CryptoCurrencies.Colors.LightGray )
		
		-- Draw top
		draw.RoundedBoxEx( 8, 0, 0, w, scr_h * 0.03, CH_CryptoCurrencies.Colors.DarkGray, true, true, false, false )

		-- Draw the top title.
		draw.SimpleText( CH_CryptoCurrencies.LangString( "Transactions" ), "CH_CryptoCurrency_Font_Size8", w / 2, scr_h * 0.015, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	end
	GUI_TransactionsFrame:MakePopup()
	GUI_TransactionsFrame:SetDraggable( false )
	GUI_TransactionsFrame:ShowCloseButton( false )
	
	local GUI_CloseMenu = vgui.Create( "DButton", GUI_TransactionsFrame )
	GUI_CloseMenu:SetPos( scr_w * 0.355, scr_h * 0.01 )
	GUI_CloseMenu:SetSize( 16, 16 )
	GUI_CloseMenu:SetText( "" )
	GUI_CloseMenu.Paint = function( self, w, h )
		surface.SetDrawColor( color_white )
		surface.SetMaterial( CH_CryptoCurrencies.Materials.CloseIcon )
		surface.DrawTexturedRect( 0, 0, 16, 16 )
	end
	GUI_CloseMenu.DoClick = function()
		GUI_TransactionsFrame:Remove()
	end
	
	local GUI_PortfolioFrameBtn = vgui.Create( "DButton", GUI_TransactionsFrame )
	GUI_PortfolioFrameBtn:SetSize( scr_w * 0.1, scr_h * 0.03 )
	GUI_PortfolioFrameBtn:SetPos( scr_w * 0.11, scr_h * 0.0375 )
	GUI_PortfolioFrameBtn:SetTextColor( Color( 0, 0, 0, 255 ) )
	GUI_PortfolioFrameBtn:SetText( "" )
	GUI_PortfolioFrameBtn.Paint = function( self, w, h )
		draw.RoundedBox( 8, 0, 0, w, h, CH_CryptoCurrencies.Colors.DarkGray )
		
		if IsValid( GUI_PortfolioFrame ) then
			draw.RoundedBoxEx( 8, 0, h * 0.8, w, h * 0.2, CH_CryptoCurrencies.Colors.GMSBlue, false, false, true, true )
		elseif self:IsHovered() then
			draw.RoundedBoxEx( 8, 0, h * 0.8, w, h * 0.2, CH_CryptoCurrencies.Colors.GMSBlue, false, false, true, true )
		end
		
		draw.SimpleText( CH_CryptoCurrencies.LangString( "Portfolio" ), "CH_CryptoCurrency_Font_Size8", w / 2, h / 2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	end
	GUI_PortfolioFrameBtn.DoClick = function()
		GUI_TransactionsFrame:Remove()
		
		CH_CryptoCurrencies.PortfolioMenu()
	end
	
	local GUI_BuyCryptoFrameBtn = vgui.Create( "DButton", GUI_TransactionsFrame )
	GUI_BuyCryptoFrameBtn:SetSize( scr_w * 0.1, scr_h * 0.03 )
	GUI_BuyCryptoFrameBtn:SetPos( scr_w * 0.005, scr_h * 0.0375 )
	GUI_BuyCryptoFrameBtn:SetTextColor( Color( 0, 0, 0, 255 ) )
	GUI_BuyCryptoFrameBtn:SetText( "" )
	GUI_BuyCryptoFrameBtn.Paint = function( self, w, h )
		draw.RoundedBox( 8, 0, 0, w, h, CH_CryptoCurrencies.Colors.DarkGray )
		
		if self:IsHovered() then
			draw.RoundedBoxEx( 8, 0, h * 0.8, w, h * 0.2, CH_CryptoCurrencies.Colors.GMSBlue, false, false, true, true )
		end
		
		draw.SimpleText( CH_CryptoCurrencies.LangString( "Cryptos" ), "CH_CryptoCurrency_Font_Size8", w / 2, h / 2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	end
	GUI_BuyCryptoFrameBtn.DoClick = function()
		GUI_TransactionsFrame:Remove()
		
		CH_CryptoCurrencies.CryptoMenu()
	end
	
	local GUI_TransactionsFrameBtn = vgui.Create( "DButton", GUI_TransactionsFrame )
	GUI_TransactionsFrameBtn:SetSize( scr_w * 0.1, scr_h * 0.03 )
	GUI_TransactionsFrameBtn:SetPos( scr_w * 0.215, scr_h * 0.0375 )
	GUI_TransactionsFrameBtn:SetTextColor( Color( 0, 0, 0, 255 ) )
	GUI_TransactionsFrameBtn:SetText( "" )
	GUI_TransactionsFrameBtn.Paint = function( self, w, h )
		draw.RoundedBox( 8, 0, 0, w, h, CH_CryptoCurrencies.Colors.DarkGray )
		
		if IsValid( GUI_TransactionsFrame ) and not GUI_BuyCryptoFrameBtn:IsHovered() and not GUI_PortfolioFrameBtn:IsHovered() then
			draw.RoundedBoxEx( 8, 0, h * 0.8, w, h * 0.2, CH_CryptoCurrencies.Colors.GMSBlue, false, false, true, true )
		elseif self:IsHovered() then
			draw.RoundedBoxEx( 8, 0, h * 0.8, w, h * 0.2, CH_CryptoCurrencies.Colors.GMSBlue, false, false, true, true )
		end
		
		draw.SimpleText( CH_CryptoCurrencies.LangString( "Transactions" ), "CH_CryptoCurrency_Font_Size8", w / 2, h / 2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	end
	GUI_TransactionsFrameBtn.DoClick = function()
	end
	
	local GUI_CryptoList = vgui.Create( "DPanelList", GUI_TransactionsFrame )
	GUI_CryptoList:SetSize( scr_w * 0.36, scr_w * 0.225 )
	GUI_CryptoList:SetPos( scr_w * 0.005, scr_h * 0.075 )
	GUI_CryptoList:EnableVerticalScrollbar( true )
	GUI_CryptoList:EnableHorizontal( true )
	GUI_CryptoList:SetSpacing( 7 )
	GUI_CryptoList.Paint = function( self, w, h )
		draw.RoundedBox( 0, 0, 0, w, h, CH_CryptoCurrencies.Colors.Invisible )
	end
	
	if ( GUI_CryptoList.VBar ) then
		GUI_CryptoList.VBar.Paint = function( self, w, h )
			draw.RoundedBox( 0, 0, 0, w, h, CH_CryptoCurrencies.Colors.Invisible ) -- BG
		end
		
		GUI_CryptoList.VBar.btnUp.Paint = function( self, w, h )
			draw.RoundedBox( 0, 0, 0, w, h, CH_CryptoCurrencies.Colors.Invisible )
		end
		
		GUI_CryptoList.VBar.btnGrip.Paint = function( self, w, h )
			draw.RoundedBoxEx( 8, 0, 0, w, h, CH_CryptoCurrencies.Colors.DarkGray, true, true, true, true )
		end
		
		GUI_CryptoList.VBar.btnDown.Paint = function( self, w, h )
			draw.RoundedBox( 0, 0, 0, w, h, CH_CryptoCurrencies.Colors.Invisible )
		end
	end
	
	if not ply.CH_CryptoCurrencies_Transactions then
		return
	end
	
	for index, crypto in ipairs( ply.CH_CryptoCurrencies_Transactions ) do
		if crypto then -- Check if this exists. If this doesn't exist it means we have some coins that are no longer available on the server and thus we don't show that.
			local prefix = crypto.Crypto
			
			local GUI_CryptoPortfolioPanel = vgui.Create( "DPanelList" )
			GUI_CryptoPortfolioPanel:SetSize( scr_w * 0.348, scr_h * 0.075 )
			GUI_CryptoPortfolioPanel.Paint = function( self, w, h )
				-- Background
				draw.RoundedBox( 8, 0, 0, w, h, CH_CryptoCurrencies.Colors.DarkGray )
				
				-- Coin Icon
				surface.SetDrawColor( color_white )
				surface.SetMaterial( CH_CryptoCurrencies.CryptoIconsCL[ prefix ].Icon )
				surface.DrawTexturedRect( w * 0.0125, h * 0.1, 64, 64 )
				
				-- Action Icon
				surface.SetDrawColor( color_white )
				if crypto.Action == "buy" then
					surface.SetMaterial( buy_icon )
				else
					surface.SetMaterial( sold_icon )
				end
				surface.DrawTexturedRect( w * 0.892, h * 0.1, 64, 64 )
				
				-- Vertical seperator line
				surface.SetDrawColor( CH_CryptoCurrencies.Colors.WhiteAlpha )
				surface.DrawRect( w * 0.12, h * 0.135, 2.5, scr_h * 0.0565 )
				
				-- Vertical seperator line END
				surface.SetDrawColor( CH_CryptoCurrencies.Colors.WhiteAlpha )
				surface.DrawRect( w * 0.875, h * 0.135, 2.5, scr_h * 0.0565 )
				
				-- Horizontal seperator line
				surface.SetDrawColor( CH_CryptoCurrencies.Colors.WhiteAlpha )
				surface.DrawRect( w * 0.135, h * 0.5, scr_w * 0.2525, 2.5 )
				
				--[[
					Coin Name & Price
				--]]
				draw.SimpleText( crypto.Name, "CH_CryptoCurrency_Font_Size10", w * 0.135, h * 0.25, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )

				surface.SetFont( "CH_CryptoCurrency_Font_Size8" )
				local x, y = surface.GetTextSize( string.format( "%f", crypto.Amount ) )
					
				draw.SimpleText( string.format( "%f", crypto.Amount ), "CH_CryptoCurrency_Font_Size8", w * 0.135, h * 0.75, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
				draw.SimpleText( crypto.Crypto, "CH_CryptoCurrency_Font_Size6", w * 0.135 + ( x + scr_w * 0.0015 ), h * 0.775, CH_CryptoCurrencies.Colors.WhiteAlpha2, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
				
				--[[
					Worth
				--]]
				if crypto.Action == "buy" then
					draw.SimpleText( CH_CryptoCurrencies.LangString( "Cost" ), "CH_CryptoCurrency_Font_Size10", w * 0.855, h * 0.25, color_white, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER )
				else
					draw.SimpleText( CH_CryptoCurrencies.LangString( "Earned" ), "CH_CryptoCurrency_Font_Size10", w * 0.855, h * 0.25, color_white, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER )
				end
				draw.SimpleText( string.Comma( crypto.Price ), "CH_CryptoCurrency_Font_Size8", w * 0.81, h * 0.75, color_white, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER )
				draw.SimpleText( CH_CryptoCurrencies.CurrencyAbbreviation(), "CH_CryptoCurrency_Font_Size6", w * 0.855, h * 0.775, CH_CryptoCurrencies.Colors.WhiteAlpha2, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER )
				
				--[[
					Purchased/Sold text and Timestamp
				--]]
				if crypto.Action == "buy" then
					draw.SimpleText( CH_CryptoCurrencies.LangString( "Purchased" ), "CH_CryptoCurrency_Font_Size6", w / 2, h * 0.25, CH_CryptoCurrencies.Colors.Green, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
				else
					draw.SimpleText( CH_CryptoCurrencies.LangString( "Sold" ), "CH_CryptoCurrency_Font_Size6", w / 2, h * 0.25, CH_CryptoCurrencies.Colors.Red, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
				end
				draw.SimpleText( crypto.TimeStamp, "CH_CryptoCurrency_Font_Size6", w / 2, h * 0.775, CH_CryptoCurrencies.Colors.WhiteAlpha2, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
			end

			
			GUI_CryptoList:AddItem( GUI_CryptoPortfolioPanel )
		end
	end
end

--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
