--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

local MODULE = GAS.Logging:MODULE()

MODULE.Category = "Crypto"
MODULE.Name = "Transaction History"
MODULE.Colour = Color( 70, 70, 70 )

MODULE:Setup( function()
	MODULE:Hook( "CH_CryptoCurrencies_bLogs_BuyCrypto", "ch_cryptocurrencies_buy_crypto", function( ply, amount, currency, price )
		MODULE:Log( "{1} has bought {2} {3}'s for {4}.", GAS.Logging:FormatPlayer( ply ), GAS.Logging:Highlight( amount ), GAS.Logging:Highlight( currency ), GAS.Logging:FormatMoney( price ) )
	end )

	MODULE:Hook( "CH_CryptoCurrencies_bLogs_SellCrypto", "ch_cryptocurrencies_sell_crypto", function( ply, amount, currency, price )
		MODULE:Log( "{1} has sold {2} {3}'s for {4}.", GAS.Logging:FormatPlayer( ply ), GAS.Logging:Highlight( amount ), GAS.Logging:Highlight( currency ), GAS.Logging:FormatMoney( price ) )
	end )
end )

GAS.Logging:AddModule( MODULE )

-- 76561198845136653

--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
