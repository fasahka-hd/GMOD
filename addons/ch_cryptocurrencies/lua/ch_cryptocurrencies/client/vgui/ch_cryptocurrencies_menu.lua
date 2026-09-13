--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

CH_CryptoCurrencies.Colors = CH_CryptoCurrencies.Colors or {}
CH_CryptoCurrencies.Materials = CH_CryptoCurrencies.Materials or {}

--[[
	Cache materials in our table.
--]]
CH_CryptoCurrencies.Materials.CloseIcon = Material( "materials/craphead_scripts/ch_cryptocurrencies/gui/closebtn.png", "noclamp smooth" )
CH_CryptoCurrencies.Materials.BackIcon = Material( "materials/craphead_scripts/ch_cryptocurrencies/gui/arrowbtn.png", "noclamp smooth" )

CH_CryptoCurrencies.Materials.ArrowUpIcon = Material( "materials/craphead_scripts/ch_cryptocurrencies/gui/arrow_up.png", "noclamp smooth" )
CH_CryptoCurrencies.Materials.ArrowDownIcon = Material( "materials/craphead_scripts/ch_cryptocurrencies/gui/arrow_down.png", "noclamp smooth" )
CH_CryptoCurrencies.Materials.ArrowExchangeIcon = Material( "materials/craphead_scripts/ch_cryptocurrencies/gui/arrow_exchange.png", "noclamp smooth" )

--[[
	Cache colors in our table.
--]]
CH_CryptoCurrencies.Colors.DarkGray = Color( 30, 30, 30, 255 )
CH_CryptoCurrencies.Colors.LightGray = Color( 50, 50, 50, 255 )

CH_CryptoCurrencies.Colors.Green = Color( 0, 100, 0, 255 )
CH_CryptoCurrencies.Colors.GreenHovered = Color( 0, 150, 0, 255 )
CH_CryptoCurrencies.Colors.GreenAlpha = Color( 0, 150, 0, 40 )

CH_CryptoCurrencies.Colors.Red = Color( 100, 0, 0, 255 )
CH_CryptoCurrencies.Colors.RedHovered = Color( 150, 0, 0, 255 )
CH_CryptoCurrencies.Colors.RedAlpha = Color( 150, 0, 0, 70 )

CH_CryptoCurrencies.Colors.WhiteAlpha = Color( 255, 255, 255, 5 )
CH_CryptoCurrencies.Colors.WhiteAlpha2 = Color( 255, 255, 255, 70 )
CH_CryptoCurrencies.Colors.Invisible = Color( 0, 0, 0, 0 )

CH_CryptoCurrencies.Colors.GMSBlue = Color( 52, 152, 219, 255 )

--[[
	Net message to show crypto menu.
--]]
net.Receive( "CH_CryptoCurrencies_ShowCryptoMenu", function( len, ply )
	CH_CryptoCurrencies.CryptoMenu()
end )

--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
