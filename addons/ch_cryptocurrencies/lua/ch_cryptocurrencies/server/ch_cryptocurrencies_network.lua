--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

-- https://developers.coinbase.com/api/v2?shell#data-endpoints

--[[
	Fetch cryptocurrencies from coinbase API based on the configuration
--]]
function CH_CryptoCurrencies.FetchCryptoCurrencies()
	-- Loop through the currencies
	
	
	local crypto_exchange_currency = CH_CryptoCurrencies.Config.ExchangeRateCurrency
	
	for index, crypto in ipairs( CH_CryptoCurrencies.Cryptos ) do
		local crypto_prefix = crypto.Currency
		
		-- Fetch from coinbase
		http.Fetch( "https://api.coinbase.com/v2/prices/".. crypto_prefix .."-".. crypto_exchange_currency .."/buy",
			-- onSuccess
			function( body, length, headers, code )
				local returned_json = util.JSONToTable( body )
				
				if not returned_json["data"] then
					if CH_CryptoCurrencies.Config.FetchConsolePrints then
						MsgC( Color( 160, 0, 0 ), "CryptoCurrencies by Crap-Head | ", color_white, "Error fetching ".. crypto_prefix .." - Currency does not exist on CoinBase API!\n")
					end
					
					CH_CryptoCurrencies.Cryptos[ index ].Price = 0
					
					-- If a crypto fails to load then write it to this table, so we can notify admins when they join.
					-- This is a safety measure in case they don't see the console logs.
					if not table.HasValue( CH_CryptoCurrencies.FailedCryptos, crypto_prefix ) then
						table.insert( CH_CryptoCurrencies.FailedCryptos, crypto_prefix )
					end
					
					return
				end
				CH_CryptoCurrencies.Cryptos[ index ].Price = returned_json["data"].amount
				
				if CH_CryptoCurrencies.Config.FetchConsolePrints then
					MsgC( Color( 52, 152, 219 ), "--------------------------------------------------------------------------\n" )
					MsgC( Color( 52, 152, 219 ), "CryptoCurrencies by Crap-Head | ", color_white, "Successfully fetched ".. crypto_prefix .." and updated table.\n" )
					MsgC( Color( 52, 152, 219 ), "CryptoCurrencies by Crap-Head | ", color_white, "It currently trades at ".. returned_json["data"].amount .." ".. crypto_exchange_currency .."\n" )
				end
			end,
			
			-- onFailure
			function( error )
				if CH_CryptoCurrencies.Config.FetchConsolePrints then
					MsgC( Color( 160, 0, 0 ), "CryptoCurrencies by Crap-Head | ", color_white, "There was a critical error when trying to fetch a crypto currency!\n")
					MsgC( Color( 160, 0, 0 ), "CryptoCurrencies by Crap-Head | ", color_white, "ERROR: ".. error .."\n")
				end
			end
		)
	end
	
	-- Wait 10 seconds before networking it to ensure it has fetched on the server
	timer.Simple( 10, function()
		for k, ply in ipairs( player.GetAll() ) do
			-- Network the new crypto prices to all online players
			CH_CryptoCurrencies.NetworkCryptoToPlayer( ply )
			
			-- Notify players via chat if config is enabled
			if CH_CryptoCurrencies.Config.NotifyPlayersChatFetch then
				local text = CH_CryptoCurrencies.LangString( "All cryptocurrency exchange rates has just been updated with live data." )
				
				net.Start( "CH_CryptoCurrencies_Net_ColorChatPrint" )
					net.WriteUInt( 52, 8 )
					net.WriteUInt( 152, 8 )
					net.WriteUInt( 219, 8 )
					net.WriteString( text )
				net.Send( ply )
			end
		end
	end )
end

--[[
	Network all crypto indexes and values to the player
--]]
function CH_CryptoCurrencies.NetworkCryptoToPlayer( ply )
	-- Get the length of the table so we know how many uints and floats we need to receive on the other end
	local table_length = #CH_CryptoCurrencies.Cryptos
	
	-- Network it to the client as efficient as possible
	net.Start( "CH_CryptoCurrencies_Net_NetworkCurrencies" )
		net.WriteUInt( table_length, 6 )
	
		for index, crypto in ipairs( CH_CryptoCurrencies.Cryptos ) do
			net.WriteUInt( index, 6 )
			net.WriteDouble( crypto.Price )
		end
	net.Send( ply )
end

--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
