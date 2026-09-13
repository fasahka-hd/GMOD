--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

--[[
	SEND CRYPTO MENU
--]]
function CH_CryptoCurrencies.SendCryptoMenu( crypto_to_send )
	local crypto = CH_CryptoCurrencies.CryptosCL[ crypto_to_send ]
	
	local ply = LocalPlayer()
	local player_money = CH_CryptoCurrencies.GetMoney( ply )
	local player_owns = math.Round( ply.CH_CryptoCurrencies_Wallet[ crypto.Currency ].Amount, 7 )
	
	local crypto_amount_to_send = 0
	local crypto_amount_to_usd = 0
	
	local GUI_SelectedPlayer_Text = CH_CryptoCurrencies.LangString( "Select Player" )
	local SelectedPlayer = nil
	
	local scr_w = ScrW()
	local scr_h = ScrH()
	
	local GUI_SendCryptoFrame = vgui.Create( "DFrame" )
	GUI_SendCryptoFrame:SetTitle( "" )
	GUI_SendCryptoFrame:SetSize( scr_w * 0.2, scr_h * 0.27 )
	GUI_SendCryptoFrame:Center()
	GUI_SendCryptoFrame.Paint = function( self, w, h )
		-- Draw frame
		draw.RoundedBox( 8, 0, 0, w, h, CH_CryptoCurrencies.Colors.LightGray )
		
		-- Draw top
		draw.RoundedBoxEx( 8, 0, 0, w, scr_h * 0.03, CH_CryptoCurrencies.Colors.DarkGray, true, true, false, false )

		-- Draw the top title.
		draw.SimpleText( CH_CryptoCurrencies.LangString( "Send" ) .." ".. crypto.Name, "CH_CryptoCurrency_Font_Size8", w / 2, scr_h * 0.015, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		
		-- Coin Icon
		surface.SetDrawColor( color_white )
		surface.SetMaterial( crypto.Icon )
		surface.DrawTexturedRect( scr_w * 0.005, scr_h * 0.037, 64, 64 )
		
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
		
		draw.SimpleText( string.format( "%f", player_owns ) .." ".. crypto.Currency, "CH_CryptoCurrency_Font_Size6", scr_w * 0.0065, scr_h * 0.112, CH_CryptoCurrencies.Colors.WhiteAlpha2, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
		
		draw.SimpleText( crypto.Currency, "CH_CryptoCurrency_Font_Size8", scr_w * 0.08, scr_h * 0.14, CH_CryptoCurrencies.Colors.WhiteAlpha2, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER )
		
		--[[
			Right Text Entry BG
		--]]
		draw.RoundedBox( 8, w * 0.57, scr_h * 0.12, scr_w * 0.08, scr_h * 0.04, CH_CryptoCurrencies.Colors.DarkGray )
		
		draw.SimpleText( CH_CryptoCurrencies.FormatMoney( player_money ), "CH_CryptoCurrency_Font_Size6", w * 0.96, scr_h * 0.112, CH_CryptoCurrencies.Colors.WhiteAlpha2, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER )
		
		draw.SimpleText( CH_CryptoCurrencies.CurrencyAbbreviation(), "CH_CryptoCurrency_Font_Size8", w * 0.95, scr_h * 0.14, CH_CryptoCurrencies.Colors.WhiteAlpha2, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER )
		
		draw.SimpleText( CH_CryptoCurrencies.FormatMoney( crypto_amount_to_usd ), "CH_CryptoCurrency_Font_Size8", w * 0.59, scr_h * 0.14, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
		
		-- Exchange Icon
		surface.SetDrawColor( color_white )
		surface.SetMaterial( CH_CryptoCurrencies.Materials.ArrowExchangeIcon )
		surface.DrawTexturedRect( w / 2 - 16, scr_h * 0.125, 32, 32 )
	end
	GUI_SendCryptoFrame:MakePopup()
	GUI_SendCryptoFrame:SetDraggable( false )
	GUI_SendCryptoFrame:ShowCloseButton( false )
	
	local GUI_CloseMenu = vgui.Create( "DButton", GUI_SendCryptoFrame )
	GUI_CloseMenu:SetPos( scr_w * 0.185, scr_h * 0.01 )
	GUI_CloseMenu:SetSize( 16, 16 )
	GUI_CloseMenu:SetText( "" )
	GUI_CloseMenu.Paint = function( self, w, h )
		surface.SetDrawColor( color_white )
		surface.SetMaterial( CH_CryptoCurrencies.Materials.CloseIcon )
		surface.DrawTexturedRect( 0, 0, 16, 16 )
	end
	GUI_CloseMenu.DoClick = function()
		GUI_SendCryptoFrame:Remove()
	end
	
	local GUI_GoBack = vgui.Create( "DButton", GUI_SendCryptoFrame )
	GUI_GoBack:SetPos( scr_w * 0.1725, scr_h * 0.01 )
	GUI_GoBack:SetSize( 16, 16 )
	GUI_GoBack:SetText( "" )
	GUI_GoBack.Paint = function( self, w, h )
		surface.SetDrawColor( color_white )
		surface.SetMaterial( CH_CryptoCurrencies.Materials.BackIcon )
		surface.DrawTexturedRect( 0, 0, 16, 16 )
	end
	GUI_GoBack.DoClick = function()
		CH_CryptoCurrencies.PortfolioMenu()
		
		GUI_SendCryptoFrame:Remove()
	end
	
	local GUI_TextField = vgui.Create( "DTextEntry", GUI_SendCryptoFrame )
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
		
		if tonumber( self:GetValue() ) > player_owns then
			self:SetText( player_owns )
		end
		
		--self:SetText( string.format( "%f", self:GetValue() ) )
		
		crypto_amount_to_send = self:GetValue()
		crypto_amount_to_usd = math.Round( self:GetValue() * crypto.Price )
	end
	
	local GUI_SelectPlayer = vgui.Create( "DComboBox", GUI_SendCryptoFrame )
	GUI_SelectPlayer:SetPos( scr_w * 0.005, scr_h * 0.17 )
	GUI_SelectPlayer:SetSize( scr_w * 0.191, scr_h * 0.04 )
	GUI_SelectPlayer:SetValue( "" )
	GUI_SelectPlayer.OnSelect = function( index, text, data )
		GUI_SelectedPlayer_Text = data
		GUI_SelectPlayer:SetValue( "" )
	end
	for k, v in ipairs( player.GetAll() ) do
		if ply != v then
			GUI_SelectPlayer:AddChoice( v:Nick() )
		end
	end
	GUI_SelectPlayer.Paint = function( self, w, h )
		draw.RoundedBox( 8, 0, 0, w, h, CH_CryptoCurrencies.Colors.DarkGray )
		
		if self:IsHovered() then
			draw.RoundedBoxEx( 8, 0, h * 0.8, w, h * 0.2, CH_CryptoCurrencies.Colors.GMSBlue, false, false, true, true )
		end
		
		draw.SimpleText( GUI_SelectedPlayer_Text, "CH_CryptoCurrency_Font_Size8", w / 2, h / 2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	end
	
	local GUI_SendCryptoBtn = vgui.Create( "DButton", GUI_SendCryptoFrame )
	GUI_SendCryptoBtn:SetSize( scr_w * 0.191, scr_h * 0.04 )
	GUI_SendCryptoBtn:SetPos( scr_w * 0.005, scr_h * 0.22 )
	GUI_SendCryptoBtn:SetTextColor( Color( 0, 0, 0, 255 ) )
	GUI_SendCryptoBtn:SetText( "" )
	GUI_SendCryptoBtn.Paint = function( self, w, h )
		draw.RoundedBox( 8, 0, 0, w, h, CH_CryptoCurrencies.Colors.DarkGray )
		
		if self:IsHovered() then
			draw.RoundedBoxEx( 8, 0, h * 0.8, w, h * 0.2, CH_CryptoCurrencies.Colors.GMSBlue, false, false, true, true )
		end
		
		draw.SimpleText( CH_CryptoCurrencies.LangString( "Send Crypto" ), "CH_CryptoCurrency_Font_Size8", w / 2, h / 2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	end
	GUI_SendCryptoBtn.DoClick = function()
		-- First we need to find the player by looping through all players.
		for k, v in ipairs( player.GetAll() ) do
			if v:Nick() == GUI_SelectedPlayer_Text then
				SelectedPlayer = v
				break
			end
		end
	
		net.Start( "CH_CryptoCurrencies_Net_SendCrypto" )
			net.WriteUInt( crypto_to_send, 6 )
			net.WriteDouble( crypto_amount_to_send )
			net.WriteEntity( SelectedPlayer )
		net.SendToServer()
		
		GUI_SendCryptoFrame:Remove()
	end
end

--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
