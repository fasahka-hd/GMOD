--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

--[[
	Function to save the players wallet using SQL
--]]
function CH_CryptoCurrencies.SavePlayerWalletSQL( ply )
	local ply_steamid64 = ply:SteamID64()

	-- Save the players wallet using SQL
	local queryObj = mysql:Select( "cryptos_wallets" )
	queryObj:Where( "steamid", ply_steamid64 )
	queryObj:Callback( function( results, status, lastid )
		if not ply.CH_CryptoCurrencies_Wallet then
			return
		end
		
		if not results[1] then -- PLAYER HAS NO WALLET SO WE INSERT INTO THE SQL
			for prefix, crypto in pairs( ply.CH_CryptoCurrencies_Wallet ) do
				local insertObj = mysql:Insert( "cryptos_wallets" )
					insertObj:Insert( "crypto", prefix )
					insertObj:Insert( "amount", crypto.Amount )
					insertObj:Insert( "steamid", ply_steamid64 )
				insertObj:Execute()
			end
		else -- PLAYER HAS WALLET SO WE UPDATE THE CURRENT ONES
			for prefix, crypto in pairs( ply.CH_CryptoCurrencies_Wallet ) do
				local updateObj = mysql:Update( "cryptos_wallets" )
					updateObj:Update( "amount", crypto.Amount )
					updateObj:Where( "steamid", ply_steamid64 )
					updateObj:Where( "crypto", prefix )
				updateObj:Execute()
			end
		end
	end )
	queryObj:Execute()
end

--[[
	Load the wallet from the SQL database
--]]
function CH_CryptoCurrencies.LoadWalletSQL( ply )
	local ply_steamid64 = ply:SteamID64()
	
	CH_CryptoCurrencies.DebugPrint( "LOADING WALLET SQL FOR ".. ply:Nick() )
	
	-- Create the wallet table for the player
	ply.CH_CryptoCurrencies_Wallet = {}
	
	-- Get data from SQL and insert it into players wallet table.
	local queryObj = mysql:Select( "cryptos_wallets" )
	queryObj:Where( "steamid", ply_steamid64 )
	queryObj:Callback( function( results, status, lastid )
		-- Insert into the players wallet table
		for key, value in ipairs( results ) do
			ply.CH_CryptoCurrencies_Wallet[ value.crypto ] = {
				Amount = value.amount,
			}
		end

		-- Run missing crypto check in the callback
		CH_CryptoCurrencies.CheckMissingCryptos( ply )
		
		-- Network wallet
		timer.Simple( 2, function()
			if IsValid( ply ) then
				CH_CryptoCurrencies.NetworkWalletToPlayer( ply, "INITIALIZE" )
			end
		end )
	end )
	queryObj:Execute()
end

--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
