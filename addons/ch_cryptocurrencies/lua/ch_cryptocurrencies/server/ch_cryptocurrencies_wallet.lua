--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

--[[
	Called on PlayerInitialSpawn to check if the player has a wallet or not and call the appropriate function
--]]
function CH_CryptoCurrencies.ControlPlayerWallet( ply )
	local ply_steamid64 = ply:SteamID64()

	if CH_CryptoCurrencies.Config.EnableSQL then
		local queryObj = mysql:Select( "cryptos_wallets" )
		queryObj:Where( "steamid", ply_steamid64 )
		queryObj:Callback( function( results, status, lastid )
			if results[1] then
				-- WALLET EXISTS - Load players wallet and setup tables
				CH_CryptoCurrencies.LoadWalletSQL( ply )
			else
				-- NO WALLET - Initialize a new wallet for the player
				CH_CryptoCurrencies.InitializeWalletFiles( ply )
			end
		end )
		queryObj:Execute()
	elseif file.Exists( "craphead_scripts/ch_cryptocurrencies/wallets/".. ply_steamid64 .."/crypto_wallet.json", "DATA" ) then
		-- WALLET EXISTS - Load players wallet and setup tables
		CH_CryptoCurrencies.LoadWalletFiles( ply )
	else
		-- NO WALLET - Initialize a new wallet for the player
		CH_CryptoCurrencies.InitializeWalletFiles( ply )
	end
end

--[[
	Create a wallet for the player
--]]
function CH_CryptoCurrencies.InitializeWalletFiles( ply )
	-- Initialize table
	ply.CH_CryptoCurrencies_Wallet = {}
	
	-- Populate their wallet table
	for index, crypto in ipairs( CH_CryptoCurrencies.Cryptos ) do
		local crypto_prefix = crypto.Currency
		
		ply.CH_CryptoCurrencies_Wallet[ crypto_prefix ] = {
			Amount = 0,
		}
	end
	
	-- Save players wallet
	CH_CryptoCurrencies.SavePlayerWallet( ply )
	
	-- Network wallet
	timer.Simple( 2, function()
		if IsValid( ply ) then
			CH_CryptoCurrencies.NetworkWalletToPlayer( ply, "INITIALIZE" )
		end
	end )
end

--[[
	Load wallet files if the player already has a wallet
--]]
function CH_CryptoCurrencies.LoadWalletFiles( ply )
	local ply_steamid64 = ply:SteamID64()

	CH_CryptoCurrencies.DebugPrint( "LOADING WALLET FILE FOR ".. ply:Nick() )
	
	-- Load wallet from file if no SQL
	local crypto_file = file.Read( "craphead_scripts/ch_cryptocurrencies/wallets/".. ply_steamid64 .."/crypto_wallet.json", "DATA" )
		
	-- Create wallet table based on json from json file.
	ply.CH_CryptoCurrencies_Wallet = util.JSONToTable( crypto_file )
		
	-- Run missing crypto check
	CH_CryptoCurrencies.CheckMissingCryptos( ply )
	
	-- Network wallet
	timer.Simple( 2, function()
		if IsValid( ply ) then
			CH_CryptoCurrencies.NetworkWalletToPlayer( ply, "INITIALIZE" )
		end
	end )
end

--[[
	Perform a check to see if any new cryptos were added to the config
	Loop through config table of cryptos, compare currency prefix of existing wallet with config currency prefixes
	If new pre-fix is found then write it to the table
--]]
function CH_CryptoCurrencies.CheckMissingCryptos( ply )
	local ply_steamid64 = ply:SteamID64()
	
	for index, crypto in ipairs( CH_CryptoCurrencies.Cryptos ) do
		local crypto_prefix = crypto.Currency

		if not ply.CH_CryptoCurrencies_Wallet[ crypto_prefix ] then
			MsgC( Color( 160, 0, 0 ), "CryptoCurrencies by Crap-Head | ", color_white, "NEW CRYPTO FOUND (".. crypto_prefix ..") - ADDING TO WALLET TABLE\n")
			
			ply.CH_CryptoCurrencies_Wallet[ crypto_prefix ] = {
				Amount = 0,
			}
			
			-- If using SQL then write a new row for this crypto
			if CH_CryptoCurrencies.Config.EnableSQL then
				local insertObj = mysql:Insert( "cryptos_wallets" )
					insertObj:Insert( "crypto", crypto_prefix )
					insertObj:Insert( "amount", 0 )
					insertObj:Insert( "steamid", ply_steamid64 )
				insertObj:Execute()
			end
		end
	end
end

--[[
	Network wallet to the player
--]]
function CH_CryptoCurrencies.NetworkWalletToPlayer( ply, crypto )
	if not ply.CH_CryptoCurrencies_Wallet[ crypto ] and crypto != "INITIALIZE" then
		MsgC( Color( 160, 0, 0 ), "CryptoCurrencies by Crap-Head | ", color_white, "Trying to network a cryptocurrency that does not exist on the server!\n")
		MsgC( Color( 160, 0, 0 ), "CryptoCurrencies by Crap-Head | ", color_white, "This net message was triggered by ".. ply .."\n")
		MsgC( Color( 160, 0, 0 ), "CryptoCurrencies by Crap-Head | ", color_white, "Usually this would not happen within the addon itself. There is a chance they are trying to exploit.\n")
		return
	end
	
	-- The the crypto variable is INITIALIZE it means we're networking the full wallet to the player.
	-- This happens on PlayerInitSpawn for example.
	-- Any other use-case will only network the updated crypto to the player to be as efficient as possible.
	if crypto == "INITIALIZE" then
		-- Get the length of the table so we know how many uints and floats we need to receive on the other end
		local table_length = 0
		for prefix, crypto in pairs( ply.CH_CryptoCurrencies_Wallet ) do
			table_length = table_length + 1
		end

		-- Network it to the client as efficient as possible
		net.Start( "CH_CryptoCurrencies_Net_NetworkWallet" )
			net.WriteUInt( table_length, 6 )
		
			for prefix, crypto in pairs( ply.CH_CryptoCurrencies_Wallet ) do
				net.WriteString( prefix )
				net.WriteDouble( crypto.Amount )
			end
		net.Send( ply )
	else
		-- Network just the crypto requested
		net.Start( "CH_CryptoCurrencies_Net_NetworkWallet" )
			net.WriteUInt( 1, 6 )
			net.WriteString( crypto )
			net.WriteDouble( ply.CH_CryptoCurrencies_Wallet[ crypto ].Amount )
		net.Send( ply )
	end
end

--[[
	Function to save the players wallet
--]]
function CH_CryptoCurrencies.SavePlayerWallet( ply )
	local ply_steamid64 = ply:SteamID64()
	
	if CH_CryptoCurrencies.Config.EnableSQL then
		-- Save the players wallet using SQL
		CH_CryptoCurrencies.SavePlayerWalletSQL( ply )
	else
		file.Write( "craphead_scripts/ch_cryptocurrencies/wallets/".. ply_steamid64 .."/crypto_wallet.json", util.TableToJSON( ply.CH_CryptoCurrencies_Wallet ), "DATA" )
	end
end

--[[
	Save the players cryptocurrencies on disconnect.
	While we already save it once a crypto is updated, this is just a safety measure in case server owners decide they want other ways of giving players cryptos.
--]]
local function CH_CryptoCurrencies_PlayerDisconnected( ply )
	CH_CryptoCurrencies.SavePlayerWallet( ply )
end
hook.Add( "PlayerDisconnected", "CH_CryptoCurrencies_PlayerDisconnected", CH_CryptoCurrencies_PlayerDisconnected )

--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
