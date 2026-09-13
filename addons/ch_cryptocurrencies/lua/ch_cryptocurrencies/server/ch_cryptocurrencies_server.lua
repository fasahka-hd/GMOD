--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

--[[
	PlayerInitialSpawn hook
--]]
function CH_CryptoCurrencies.PlayerInitialSpawn( ply )
	-- Setup files for the player
	local ply_steamid64 = ply:SteamID64()
	
	-- Check if directory exists or create it for the player
	if not file.IsDir( "craphead_scripts/ch_cryptocurrencies/wallets/".. ply_steamid64, "DATA" ) then
		file.CreateDir( "craphead_scripts/ch_cryptocurrencies/wallets/".. ply_steamid64, "DATA" )
	end
	
	-- Control if they have a wallet or not and initialize/load accordingly
	CH_CryptoCurrencies.ControlPlayerWallet( ply )

	-- Network current crypto values to the player
	CH_CryptoCurrencies.NetworkCryptoToPlayer( ply )
	
	-- Network transaction history to the player
	timer.Simple( 5, function()
		if IsValid( ply ) then
			CH_CryptoCurrencies.NetworkTransactionsSQL( ply )
		end
	end )
end
hook.Add( "PlayerInitialSpawn", "CH_CryptoCurrencies.PlayerInitialSpawn", CH_CryptoCurrencies.PlayerInitialSpawn )

--[[
	Fail safe hook to notify admins and above of non-existant crypto currencies in case of failure config.
--]]
function CH_CryptoCurrencies.PlayerSpawn( ply )
	if ply:IsAdmin() then
		local tbl_count = #CH_CryptoCurrencies.FailedCryptos
		
		if tbl_count > 0 then
			net.Start( "CH_CryptoCurrencies_Net_ColorChatPrint" )
				net.WriteUInt( 160, 8 )
				net.WriteUInt( 0, 8 )
				net.WriteUInt( 0, 8 )
				net.WriteString( "One or more cryptocurrencies could not be fetched from the API! Below is a list:" )
			net.Send( ply )
			
			for k, crypto_prefix in ipairs( CH_CryptoCurrencies.FailedCryptos ) do
				MsgC( Color( 160, 0, 0 ), "CryptoCurrencies by Crap-Head | ", color_white, "Error fetching ".. crypto_prefix .." - Currency does not exist on CoinBase API!\n")
				
				net.Start( "CH_CryptoCurrencies_Net_ColorChatPrint" )
					net.WriteUInt( 160, 8 )
					net.WriteUInt( 0, 8 )
					net.WriteUInt( 0, 8 )
					net.WriteString( "Error fetching ".. crypto_prefix .." - Currency does not exist on CoinBase API!" )
				net.Send( ply )
			end
		end
	end
end
hook.Add( "PlayerSpawn", "CH_CryptoCurrencies.PlayerSpawn", CH_CryptoCurrencies.PlayerSpawn )

--[[
	Open crypto menu via chat command
--]]
function CH_CryptoCurrencies.PlayerSay( ply, text )
	if string.lower( text ) == CH_CryptoCurrencies.Config.CryptoMenuChatCommand then
		if not CH_CryptoCurrencies.Config.UseCryptoChatCommand then
			return
		end

		net.Start( "CH_CryptoCurrencies_ShowCryptoMenu" )
		net.Send( ply )
		return ""
	end
end
hook.Add( "PlayerSay", "CH_CryptoCurrencies.PlayerSay", CH_CryptoCurrencies.PlayerSay )

--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
