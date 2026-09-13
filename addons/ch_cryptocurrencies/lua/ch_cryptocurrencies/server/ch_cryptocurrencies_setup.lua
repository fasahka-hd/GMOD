--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

-- Workshop content
resource.AddWorkshop( "2688654158" )

-- Network strings
util.AddNetworkString( "CH_CryptoCurrencies_Net_NetworkCurrencies" )
util.AddNetworkString( "CH_CryptoCurrencies_Net_BuyCrypto" )
util.AddNetworkString( "CH_CryptoCurrencies_Net_SellCrypto" )
util.AddNetworkString( "CH_CryptoCurrencies_Net_SendCrypto" )

util.AddNetworkString( "CH_CryptoCurrencies_Net_NetworkWallet" )
util.AddNetworkString( "CH_CryptoCurrencies_Net_NetworkTransactions" )

util.AddNetworkString( "CH_CryptoCurrencies_Net_ColorChatPrint" )
util.AddNetworkString( "CH_CryptoCurrencies_ShowCryptoMenu" )

local map = string.lower( game.GetMap() )
CH_CryptoCurrencies.Cryptos = CH_CryptoCurrencies.Cryptos or {}
CH_CryptoCurrencies.FailedCryptos = CH_CryptoCurrencies.FailedCryptos or {}

--[[
	Initialize our serverside directories
--]]
local function CH_CryptoCurrencies_InitDirectories()
	if not file.IsDir( "craphead_scripts", "DATA" ) then
		file.CreateDir( "craphead_scripts", "DATA" )
	end

	if not file.IsDir( "craphead_scripts/ch_cryptocurrencies", "DATA" ) then
		file.CreateDir( "craphead_scripts/ch_cryptocurrencies", "DATA" )
	end
	
	if not file.IsDir( "craphead_scripts/ch_cryptocurrencies/entities", "DATA" ) then
		file.CreateDir( "craphead_scripts/ch_cryptocurrencies/entities", "DATA" )
	end
	
	if not file.IsDir( "craphead_scripts/ch_cryptocurrencies/entities/".. map, "DATA" ) then
		file.CreateDir( "craphead_scripts/ch_cryptocurrencies/entities/".. map, "DATA" )
	end
	
	if not file.IsDir( "craphead_scripts/ch_cryptocurrencies/entities/".. map .."/npc", "DATA" ) then
		file.CreateDir( "craphead_scripts/ch_cryptocurrencies/entities/".. map .."/npc", "DATA" )
		
		local Entity_Position = {
			EntityVector = {
				x = 0,
				y = 0,
				z = 0,
			},
			EntityAngles = {
				x = 0,
				y = 0,
				z = 0,
			},
		}
		
		file.Write( "craphead_scripts/ch_cryptocurrencies/entities/".. map .."/npc/crypto_npc.json", util.TableToJSON( Entity_Position ), "DATA" )
	end
	
	if not file.IsDir( "craphead_scripts/ch_cryptocurrencies/entities/".. map .."/screens", "DATA" ) then
		file.CreateDir( "craphead_scripts/ch_cryptocurrencies/entities/".. map .."/screens", "DATA" )
	end

	if not file.IsDir( "craphead_scripts/ch_cryptocurrencies/wallets", "DATA" ) then
		file.CreateDir( "craphead_scripts/ch_cryptocurrencies/wallets", "DATA" )
	end
end

--[[
	Initialize the addon
--]]
local function CH_CryptoCurrencies_Initialize()
	-- Setup Directories
	CH_CryptoCurrencies_InitDirectories()
	
	-- Setup serverside table of cryptos based on config
	-- We're writing it in a new table because we don't want the user to live-lua-refresh their config with new cryptos and fuck everything up
	for index, crypto in ipairs( CH_CryptoCurrencies.Config.Currencies ) do
		CH_CryptoCurrencies.Cryptos[ index ] = {
			Currency = crypto.Currency,
			Name = crypto.Name,
			Icon = crypto.Icon,
			Price = 0,
		}
	end

	-- Start timer to fetch frequently
	local fetch_interval = math.Clamp( CH_CryptoCurrencies.Config.FetchCryptosInterval, 1, 99999999999 )
	
	timer.Create( "CH_CryptoCurrencies_FetchCryptos_Timer", fetch_interval, 0, function()
		CH_CryptoCurrencies.FetchCryptoCurrencies()
	end )
end
hook.Add( "Initialize", "CH_CryptoCurrencies_Initialize", CH_CryptoCurrencies_Initialize )

--[[
	We call this on the first available Tick on the server.
	This is too ensure the server is ready to perform HTTP fetch
--]]
local function CH_CryptoCurrencies_FirstTickToFetch()
	-- Fetch currencies to server
	CH_CryptoCurrencies.FetchCryptoCurrencies()
	
	hook.Remove( "Tick", "CH_CryptoCurrencies_FirstTickToFetch" )
end
hook.Add( "Tick", "CH_CryptoCurrencies_FirstTickToFetch", CH_CryptoCurrencies_FirstTickToFetch )

--[[
	Spawn entities
--]]
local function CH_CryptoCurrencies_InitPostEntity()
	-- Crypto NPC
	CH_CryptoCurrencies.SpawnCryptoNPC()
	
	-- Crypto Exchange Rate Screens
	CH_CryptoCurrencies.SpawnCurrencyScreens()
end
hook.Add( "InitPostEntity", "CH_CryptoCurrencies_InitPostEntity", CH_CryptoCurrencies_InitPostEntity )

--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
