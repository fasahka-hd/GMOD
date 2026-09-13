--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

local sql_isconnected

CH_CryptoCurrencies.Config.SQL_HOST = "46.174.50.7"
CH_CryptoCurrencies.Config.SQL_USERNAME = "u39804_just"
CH_CryptoCurrencies.Config.SQL_PASSWORD = "pN8bP6sT1h"
CH_CryptoCurrencies.Config.SQL_DATABASE = "u39804_just"

--[[
	Connect to the SQL database of their choice when the gamemode is loaded.
--]]
function CH_CryptoCurrencies.ConnectDatabase()
	if not CH_CryptoCurrencies.Config.EnableSQL then
		return
	end
	
	mysql:SetModule( "mysqloo" )
	mysql:Connect( CH_CryptoCurrencies.Config.SQL_HOST , CH_CryptoCurrencies.Config.SQL_USERNAME, CH_CryptoCurrencies.Config.SQL_PASSWORD, CH_CryptoCurrencies.Config.SQL_DATABASE, 3306 )
	
	sql_isconnected = true
end
hook.Add( "PostGamemodeLoaded", "CH_CryptoCurrencies.ConnectDatabase", CH_CryptoCurrencies.ConnectDatabase ) 

--[[
	Reconnect to the SQL when the gamemode is reloaded by auto refresh in case something happens
--]]
function CH_CryptoCurrencies.OnReloaded()
	if not CH_CryptoCurrencies.Config.EnableSQL then
		return
	end
	
	if sql_isconnected then
		return
	end

	CH_CryptoCurrencies.ConnectDatabase()
end
hook.Add( "OnReloaded", "CH_CryptoCurrencies.OnReloaded", CH_CryptoCurrencies.OnReloaded )

--[[
	Create database table if it does not exist already
--]]
function CH_CryptoCurrencies.CreateDatabases()
	if not CH_CryptoCurrencies.Config.EnableSQL then
		return
	end
	
	local queryObj = mysql:Create( "cryptos_wallets" )
		queryObj:Create( "crypto", "varchar(45) NOT NULL" )
		queryObj:Create( "amount", "float(11) NOT NULL" )
		queryObj:Create( "steamid", "varchar(45) NOT NULL" )
	queryObj:Execute()
	
	local queryObj = mysql:Create( "cryptos_transactions" )
		queryObj:Create( "action", "varchar(5) NOT NULL" )
		queryObj:Create( "crypto", "varchar(45) NOT NULL" )
		queryObj:Create( "name", "varchar(45) NOT NULL" )
		queryObj:Create( "amount", "float(11) NOT NULL" )
		queryObj:Create( "price", "int(11) NOT NULL" )
		queryObj:Create( "timestamp", "timestamp NOT NULL" )
		queryObj:Create( "steamid", "varchar(45) NOT NULL" )
	queryObj:Execute()
end
hook.Add( "DatabaseConnected", "CH_CryptoCurrencies.CreateDatabases", CH_CryptoCurrencies.CreateDatabases )

--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
