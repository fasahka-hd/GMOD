--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

--[[
	Buying cryptocurrencies
	https://bitcoin.stackexchange.com/questions/9445/how-do-i-calculate-the-value-of-some-amount-of-bitcoins-in-my-native-currency
--]]
net.Receive( "CH_CryptoCurrencies_Net_BuyCrypto", function( len, ply )
	if ( ply.CH_CryptoCurrencies_NetDelay or CurTime() ) > CurTime() then
		ply:ChatPrint( "You're running the command too fast. Slow down champ!" )
		return
	end
	ply.CH_CryptoCurrencies_NetDelay = CurTime() + 1
	
	local crypto_index = net.ReadUInt( 6 )
	local buy_amount = net.ReadDouble()

	local crypto_table = CH_CryptoCurrencies.Cryptos[ crypto_index ]
	local crypto_prefix = crypto_table.Currency
	local crypto_costs = math.Round( crypto_table.Price * buy_amount )
	
	local crypto_wallet = ply.CH_CryptoCurrencies_Wallet[ crypto_prefix ]
	
	-- Perform a series of security checks before completing a transaction.
	if not crypto_wallet then
		CH_CryptoCurrencies.NotifyPlayer( ply, CH_CryptoCurrencies.LangString( "ERROR: Tried trading a non-existant cryptocurrency!" ) )
		return
	end
	
	if buy_amount <= 0 then
		CH_CryptoCurrencies.NotifyPlayer( ply, CH_CryptoCurrencies.LangString( "ERROR: The amount must be positive!" ) )
		return
	end
	
	if crypto_costs <= 0 then
		CH_CryptoCurrencies.NotifyPlayer( ply, CH_CryptoCurrencies.LangString( "ERROR: You must trade at least 1 dollar worth of crypto!" ) )
		return
	end
	
	if CH_CryptoCurrencies.Config.UseMoneyFromBankAccount and CH_ATM then
		if CH_ATM.GetMoneyBankAccount( ply ) < crypto_costs then
			CH_CryptoCurrencies.NotifyPlayer( ply, CH_CryptoCurrencies.LangString( "ERROR: You cannot afford this!" ) )
			return
		end
	else
		if not CH_CryptoCurrencies.CanAfford( ply, crypto_costs ) then
			CH_CryptoCurrencies.NotifyPlayer( ply, CH_CryptoCurrencies.LangString( "ERROR: You cannot afford this!" ) )
			return
		end
	end
	
	-- If all checks passed then complete transaction
	if CH_CryptoCurrencies.Config.UseMoneyFromBankAccount and CH_ATM then
		CH_ATM.TakeMoneyFromBankAccount( ply, crypto_costs )
		
		hook.Run( "CH_ATM_bLogs_TakeMoney", crypto_costs, ply, "Purchased ".. string.format( "%f", buy_amount ) .." ".. crypto_table.Name )
	else
		CH_CryptoCurrencies.TakeMoney( ply, crypto_costs )
	end
	
	-- Give crypto
	CH_CryptoCurrencies.GiveCrypto( ply, crypto_prefix, buy_amount )
	
	-- Log transaction and network it to the player after 1 second (only works with SQL enabled)
	CH_CryptoCurrencies.LogSQLTransaction( ply, "buy", crypto_prefix, crypto_table.Name, buy_amount, crypto_costs )
	
	timer.Simple( 1, function()
		if IsValid( ply ) then
			CH_CryptoCurrencies.NetworkTransactionsSQL( ply )
		end
	end )
	
	-- bLogs support
	hook.Run( "CH_CryptoCurrencies_bLogs_BuyCrypto", ply, string.format( "%f", buy_amount ), crypto_table.Name, crypto_costs )
	
	CH_CryptoCurrencies.NotifyPlayer( ply, CH_CryptoCurrencies.LangString( "You have purchased" ) .." ".. string.format( "%f", buy_amount ) .." ".. crypto_table.Name )
	CH_CryptoCurrencies.NotifyPlayer( ply, CH_CryptoCurrencies.LangString( "The trade has cost you" ) .." ".. CH_CryptoCurrencies.FormatMoney( crypto_costs ) )
end )

--[[
	Selling cryptocurrencies
--]]
net.Receive( "CH_CryptoCurrencies_Net_SellCrypto", function( len, ply )
	if ( ply.CH_CryptoCurrencies_NetDelay or CurTime() ) > CurTime() then
		ply:ChatPrint( "You're running the command too fast. Slow down champ!" )
		return
	end
	ply.CH_CryptoCurrencies_NetDelay = CurTime() + 1
	
	local crypto_index = net.ReadUInt( 6 )
	local sell_amount = net.ReadDouble()

	local crypto_table = CH_CryptoCurrencies.Cryptos[ crypto_index ]
	local crypto_prefix = crypto_table.Currency
	local crypto_earn_from_sale = math.Round( sell_amount * crypto_table.Price )
	
	local crypto_wallet = ply.CH_CryptoCurrencies_Wallet[ crypto_prefix ]
	local crypto_wallet_amount = math.Round( crypto_wallet.Amount, 7 )
	
	-- Perform a series of security checks before completing a transaction.
	if not crypto_wallet then
		CH_CryptoCurrencies.NotifyPlayer( ply, CH_CryptoCurrencies.LangString( "ERROR: Tried trading a non-existant cryptocurrency!" ) )
		return
	end
	
	if crypto_wallet_amount < sell_amount then
		CH_CryptoCurrencies.NotifyPlayer( ply, CH_CryptoCurrencies.LangString( "You don't own this many" ) .. crypto_table.Name )
		return
	end
	
	if sell_amount <= 0 then
		CH_CryptoCurrencies.NotifyPlayer( ply, CH_CryptoCurrencies.LangString( "ERROR: The amount must be positive!" ) )
		return
	end
	
	if crypto_earn_from_sale <= 0 then
		CH_CryptoCurrencies.NotifyPlayer( ply, CH_CryptoCurrencies.LangString( "ERROR: You must trade at least 1 dollar worth of crypto!" ) )
		return
	end

	-- If all checks passed then complete transaction
	if CH_CryptoCurrencies.Config.UseMoneyFromBankAccount and CH_ATM then
		CH_ATM.AddMoneyToBankAccount( ply, crypto_earn_from_sale )
		
		hook.Run( "CH_ATM_bLogs_ReceiveMoney", crypto_earn_from_sale, ply, "Sold ".. string.format( "%f", sell_amount ) .." ".. crypto_table.Name )
	else
		CH_CryptoCurrencies.AddMoney( ply, crypto_earn_from_sale )
	end
	-- Take crypto
	CH_CryptoCurrencies.TakeCrypto( ply, crypto_prefix, sell_amount )
	
	-- Log transaction and network it to the player after 1 second (only works with SQL enabled)
	CH_CryptoCurrencies.LogSQLTransaction( ply, "sell", crypto_prefix, crypto_table.Name, sell_amount, crypto_earn_from_sale )
	
	timer.Simple( 1, function()
		if IsValid( ply ) then
			CH_CryptoCurrencies.NetworkTransactionsSQL( ply )
		end
	end )
	
	-- bLogs support
	hook.Run( "CH_CryptoCurrencies_bLogs_SellCrypto", ply, string.format( "%f", sell_amount ), crypto_table.Name, crypto_earn_from_sale )
	
	CH_CryptoCurrencies.NotifyPlayer( ply, CH_CryptoCurrencies.LangString( "You have sold" ) .." ".. string.format( "%f", sell_amount ) .." ".. crypto_table.Name )
	CH_CryptoCurrencies.NotifyPlayer( ply, CH_CryptoCurrencies.LangString( "The trade has earned you" ) .." ".. CH_CryptoCurrencies.FormatMoney( crypto_earn_from_sale ) )
end )

--[[
	Sending cryptocurrencies to other players
--]]
net.Receive( "CH_CryptoCurrencies_Net_SendCrypto", function( len, ply )
	if ( ply.CH_CryptoCurrencies_NetDelay or CurTime() ) > CurTime() then
		ply:ChatPrint( "You're running the command too fast. Slow down champ!" )
		return
	end
	ply.CH_CryptoCurrencies_NetDelay = CurTime() + 1
	
	local crypto_index = net.ReadUInt( 6 )
	local sent_amount = net.ReadDouble()
	local receiver = net.ReadEntity()

	local crypto_table = CH_CryptoCurrencies.Cryptos[ crypto_index ]
	local crypto_prefix = crypto_table.Currency
	
	local crypto_wallet = ply.CH_CryptoCurrencies_Wallet[ crypto_prefix ]
	
	-- Perform a series of security checks before completing a transaction.
	if not crypto_wallet then
		CH_CryptoCurrencies.NotifyPlayer( ply, CH_CryptoCurrencies.LangString( "ERROR: Tried trading a non-existant cryptocurrency!" ) )
		return
	end
	
	if crypto_wallet.Amount < sent_amount then
		CH_CryptoCurrencies.NotifyPlayer( ply, CH_CryptoCurrencies.LangString( "You don't own this many" ) .." ".. crypto_table.Name )
		return
	end
	
	if sent_amount <= 0 then
		CH_CryptoCurrencies.NotifyPlayer( ply, CH_CryptoCurrencies.LangString( "ERROR: The amount must be positive!" ) )
		return
	end
	
	if not IsValid( receiver ) then
		CH_CryptoCurrencies.NotifyPlayer( ply, CH_CryptoCurrencies.LangString( "ERROR: Player not found!" ) )
		return
	end
	
	-- If all checks passed then complete transaction
	
	-- Remove the crypto from the SENDER
	CH_CryptoCurrencies.TakeCrypto( ply, crypto_prefix, sent_amount )
	
	-- Add the crypto to the RECEIVER
	CH_CryptoCurrencies.GiveCrypto( receiver, crypto_prefix, sent_amount )
	
	-- bLogs support
	hook.Run( "CH_CryptoCurrencies_bLogs_SendCrypto", ply, string.format( "%f", sent_amount ), crypto_table.Name, receiver )
	
	CH_CryptoCurrencies.NotifyPlayer( ply, CH_CryptoCurrencies.LangString( "You have sent" ) .." ".. string.format( "%f", sent_amount ) .." ".. crypto_table.Name .." to " .. receiver:Nick() )
	
	CH_CryptoCurrencies.NotifyPlayer( receiver, CH_CryptoCurrencies.LangString( "You have received" ) .." ".. string.format( "%f", sent_amount ) .." ".. crypto_table.Name .." from " .. ply:Nick() )
end )

--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
