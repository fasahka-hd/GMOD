--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

--[[
	Logging transactions to the SQL database
--]]
function CH_CryptoCurrencies.LogSQLTransaction( ply, action, crypto, name, amount, price )
	if not CH_CryptoCurrencies.Config.EnableSQL then
		return
	end

	local ply_steamid64 = ply:SteamID64()
	local timestamp = os.date( "%Y/%m/%d %X", os.time() )
	
	local insertObj = mysql:Insert( "cryptos_transactions" )
		insertObj:Insert( "action", action )
		insertObj:Insert( "crypto", crypto )
		insertObj:Insert( "name", name )
		insertObj:Insert( "amount", amount )
		insertObj:Insert( "price", price )
		insertObj:Insert( "timestamp", timestamp )
		insertObj:Insert( "steamid", ply_steamid64 )
	insertObj:Execute()
end

--[[
	Network transaction to the client
--]]
function CH_CryptoCurrencies.NetworkTransactionsSQL( ply )
	if not CH_CryptoCurrencies.Config.EnableSQL then
		return
	end
	
	local ply_steamid64 = ply:SteamID64()
	
	-- Get data from SQL and network it to the client.
	local queryObj = mysql:Select( "cryptos_transactions" )
	queryObj:Where( "steamid", ply_steamid64 )
	queryObj:OrderByDesc( "timestamp" )
	queryObj:Limit( CH_CryptoCurrencies.Config.MaximumTransactionsToShow )
	queryObj:Callback( function( results, status, lastid )
		PrintTable( results )
		local table_length = #results
		
		-- Network it to the client as efficient as possible
		net.Start( "CH_CryptoCurrencies_Net_NetworkTransactions" )
			net.WriteUInt( table_length, 6 )

			for key, value in ipairs( results ) do
				net.WriteString( value.action )
				net.WriteString( value.crypto )
				net.WriteString( value.name )
				net.WriteDouble( value.amount )
				net.WriteDouble( value.price )
				net.WriteString( value.timestamp )
			end
		net.Send( ply )
	end )
	queryObj:Execute()
end

--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
