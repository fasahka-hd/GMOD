--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

--[[
	Notification function based on the current gamemode
--]]
function CH_CryptoCurrencies.NotifyPlayer( ply, text )
	if DarkRP then
		DarkRP.notify( ply, 1, CH_CryptoCurrencies.Config.NotificationTime, text )
	else
		ply:ChatPrint( text )
	end
end

--[[
	Functions to add and take crypto currency from the player
--]]
function CH_CryptoCurrencies.GiveCrypto( ply, crypto, amount )
	-- Safety control checks
	if not ply:IsPlayer() then
		return
	end
	
	if not ply.CH_CryptoCurrencies_Wallet[ crypto ] then
		print( "ERROR: The crypto to be given does not exist! Contact the developer of this extension!" )
		return
	end
	
	-- Get wallet and calculate new wallet
	local cur_wallet = ply.CH_CryptoCurrencies_Wallet[ crypto ].Amount
	local new_wallet = cur_wallet + amount
	
	-- Update wallet table for the player
	ply.CH_CryptoCurrencies_Wallet[ crypto ] = {
		Amount = new_wallet,
	}
	
	-- Save players wallet
	CH_CryptoCurrencies.SavePlayerWallet( ply )
	
	-- Network that one crypto to client
	CH_CryptoCurrencies.NetworkWalletToPlayer( ply, crypto )
end

function CH_CryptoCurrencies.TakeCrypto( ply, crypto, amount )
	-- Safety control checks
	if not ply:IsPlayer() then
		return
	end
	
	if not ply.CH_CryptoCurrencies_Wallet[ crypto ] then
		print( "ERROR: The crypto to be taken does not exist! Contact the developer of this extension!" )
		return
	end
	
	-- Get wallet and calculate new wallet
	local cur_wallet = ply.CH_CryptoCurrencies_Wallet[ crypto ].Amount
	local new_wallet = math.Clamp( cur_wallet - amount, 0, 99999999999 )
	
	-- Update wallet table for the player
	ply.CH_CryptoCurrencies_Wallet[ crypto ] = {
		Amount = new_wallet,
	}
	
	-- Save players wallet
	CH_CryptoCurrencies.SavePlayerWallet( ply )
	
	-- Network that one crypto to client
	CH_CryptoCurrencies.NetworkWalletToPlayer( ply, crypto )
end

--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
