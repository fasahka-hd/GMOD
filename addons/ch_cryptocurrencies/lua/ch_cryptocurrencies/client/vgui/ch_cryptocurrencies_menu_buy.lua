--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

--[[
	BUY CRYPTO MENU
--]]
function CH_CryptoCurrencies.BuyCryptoMenu( crypto_to_buy )
	local crypto = CH_CryptoCurrencies.CryptosCL[ crypto_to_buy ]
	
	local ply = LocalPlayer()
	local player_money = CH_CryptoCurrencies.GetMoney( ply )
	local player_owns = math.Round( ply.CH_CryptoCurrencies_Wallet[ crypto.Currency ].Amount, 7 )
	
	local crypto_amount_to_buy = 0
	
	local scr_w = ScrW()
	local scr_h = ScrH()
	
	local GUI_BuyCryptoFrame = vgui.Create( "DFrame" )
	GUI_BuyCryptoFrame:SetTitle( "" )
	GUI_BuyCryptoFrame:SetSize( scr_w * 0.2, scr_h * 0.2175 )
	GUI_BuyCryptoFrame:Center()
	GUI_BuyCryptoFrame.Paint = function( self, w, h )
		-- Draw frame
		draw.RoundedBox( 8, 0, 0, w, h, CH_CryptoCurrencies.Colors.LightGray )
		
		-- Draw top
		draw.RoundedBoxEx( 8, 0, 0, w, scr_h * 0.03, CH_CryptoCurrencies.Colors.DarkGray, true, true, false, false )

		-- Draw the top title.
		draw.SimpleText( CH_CryptoCurrencies.LangString( "Buy" ) .." ".. crypto.Name, "CH_CryptoCurrency_Font_Size8", w / 2, scr_h * 0.015, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		
		-- Coin Icon
		surface.SetDrawColor( color_white )
		surface.SetMaterial( crypto.Icon )
		surface.DrawTexturedRect( scr_w * 0.005, h * 0.17, 64, 64 )
		
		--[[
			Coin Name & Price
		--]]
		draw.SimpleText( crypto.Name, "CH_CryptoCurrency_Font_Size10", scr_w * 0.04, scr_h * 0.053, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
		
		surface.SetFont( "CH_CryptoCurrency_Font_Size8" )
		local x, y = surface.GetTextSize( crypto.Price )
		
		draw.SimpleText( crypto.Price, "CH_CryptoCurrency_Font_Size8", scr_w * 0.04, scr_h * 0.078, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
		draw.SimpleText( CH_CryptoCurrencies.CurrencyAbbreviation(), "CH_CryptoCurrency_Font_Size6", scr_w * 0.04 + ( x + scr_w * 0.0015 ), scr_h * 0.08, CH_CryptoCurrencies.Colors.WhiteAlpha2, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
		
		--[[
			Left Text Entry BG
		--]]
		draw.RoundedBox( 8, scr_w * 0.005, scr_h * 0.12, scr_w * 0.08, scr_h * 0.04, CH_CryptoCurrencies.Colors.DarkGray )
		
		draw.SimpleText( CH_CryptoCurrencies.FormatMoney( player_money ), "CH_CryptoCurrency_Font_Size6", scr_w * 0.0065, scr_h * 0.112, CH_CryptoCurrencies.Colors.WhiteAlpha2, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
		
		draw.SimpleText( CH_CryptoCurrencies.CurrencyAbbreviation(), "CH_CryptoCurrency_Font_Size8", scr_w * 0.082, scr_h * 0.14, CH_CryptoCurrencies.Colors.WhiteAlpha2, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER )
		
		--[[
			Right Text Entry BG
		--]]
		draw.RoundedBox( 8, w * 0.57, scr_h * 0.12, scr_w * 0.08, scr_h * 0.04, CH_CryptoCurrencies.Colors.DarkGray )
		
		draw.SimpleText( string.format( "%f", player_owns ) .." ".. crypto.Currency, "CH_CryptoCurrency_Font_Size6", w * 0.96, scr_h * 0.112, CH_CryptoCurrencies.Colors.WhiteAlpha2, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER )
		
		draw.SimpleText( crypto.Currency, "CH_CryptoCurrency_Font_Size8", w * 0.95, scr_h * 0.14, CH_CryptoCurrencies.Colors.WhiteAlpha2, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER )
		
		draw.SimpleText( string.format( "%f", crypto_amount_to_buy ), "CH_CryptoCurrency_Font_Size8", w * 0.59, scr_h * 0.14, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
		
		-- Exchange Icon
		surface.SetDrawColor( color_white )
		surface.SetMaterial( CH_CryptoCurrencies.Materials.ArrowExchangeIcon )
		surface.DrawTexturedRect( w / 2 - 16, scr_h * 0.125, 32, 32 )
	end
	GUI_BuyCryptoFrame:MakePopup()
	GUI_BuyCryptoFrame:SetDraggable( false )
	GUI_BuyCryptoFrame:ShowCloseButton( false )
	
	local GUI_CloseMenu = vgui.Create( "DButton", GUI_BuyCryptoFrame )
	GUI_CloseMenu:SetPos( scr_w * 0.185, scr_h * 0.01 )
	GUI_CloseMenu:SetSize( 16, 16 )
	GUI_CloseMenu:SetText( "" )
	GUI_CloseMenu.Paint = function( self, w, h )
		surface.SetDrawColor( color_white )
		surface.SetMaterial( CH_CryptoCurrencies.Materials.CloseIcon )
		surface.DrawTexturedRect( 0, 0, 16, 16 )
	end
	GUI_CloseMenu.DoClick = function()
		GUI_BuyCryptoFrame:Remove()
	end
	
	local GUI_GoBack = vgui.Create( "DButton", GUI_BuyCryptoFrame )
	GUI_GoBack:SetPos( scr_w * 0.1725, scr_h * 0.01 )
	GUI_GoBack:SetSize( 16, 16 )
	GUI_GoBack:SetText( "" )
	GUI_GoBack.Paint = function( self, w, h )
		surface.SetDrawColor( color_white )
		surface.SetMaterial( CH_CryptoCurrencies.Materials.BackIcon )
		surface.DrawTexturedRect( 0, 0, 16, 16 )
	end
	GUI_GoBack.DoClick = function()
		CH_CryptoCurrencies.CryptoMenu()
		
		GUI_BuyCryptoFrame:Remove()
	end
	
	local GUI_TextField = vgui.Create( "DTextEntry", GUI_BuyCryptoFrame )
	GUI_TextField:RequestFocus()
	GUI_TextField:SetPos( scr_w * 0.008, scr_h * 0.125 )
	GUI_TextField:SetSize( scr_w * 0.058, scr_h * 0.03 )
	GUI_TextField:SetFont( "CH_CryptoCurrency_Font_Size8" )
	GUI_TextField:SetTextColor( color_white )
	GUI_TextField:SetPlaceholderText( "0" )
	GUI_TextField:SetAllowNonAsciiCharacters( false ) -- When allowing non-ASCII characters, a small box appears inside the text entry, indicating your keyboard's current language.  That makes the user unable to input some letters from German, French, Swedish, etc. alphabet. 
	GUI_TextField:SetMultiline( false )
	GUI_TextField:SetNumeric( true )
	GUI_TextField:SetDrawBackground( false )
	GUI_TextField.OnChange = function( self )
		if not tonumber( self:GetValue() ) then
			return
		end
		
		if tonumber( self:GetValue() ) > player_money then
			self:SetText( player_money )
		end
		
		crypto_amount_to_buy = math.Round( self:GetValue() / crypto.Price, 7 )
		--crypto_amount_to_buy = string.format( "%f", crypto_amount_to_buy )
	end
	
	local GUI_BuyCryptoBtn = vgui.Create( "DButton", GUI_BuyCryptoFrame )
	GUI_BuyCryptoBtn:SetSize( scr_w * 0.191, scr_h * 0.04 )
	GUI_BuyCryptoBtn:SetPos( scr_w * 0.005, scr_h * 0.17 )
	GUI_BuyCryptoBtn:SetTextColor( Color( 0, 0, 0, 255 ) )
	GUI_BuyCryptoBtn:SetText( "" )
	GUI_BuyCryptoBtn.Paint = function( self, w, h )
		draw.RoundedBox( 8, 0, 0, w, h, CH_CryptoCurrencies.Colors.DarkGray )
		
		if self:IsHovered() then
			draw.RoundedBoxEx( 8, 0, h * 0.8, w, h * 0.2, CH_CryptoCurrencies.Colors.GMSBlue, false, false, true, true )
		end
		
		draw.SimpleText( CH_CryptoCurrencies.LangString( "Confirm Trade" ), "CH_CryptoCurrency_Font_Size8", w / 2, h / 2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	end
	GUI_BuyCryptoBtn.DoClick = function()
		net.Start( "CH_CryptoCurrencies_Net_BuyCrypto" )
			net.WriteUInt( crypto_to_buy, 6 )
			net.WriteDouble( crypto_amount_to_buy )
		net.SendToServer()
		
		GUI_BuyCryptoFrame:Remove()
	end
end

--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
