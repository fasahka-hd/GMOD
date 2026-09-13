--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

local map = string.lower( game.GetMap() )

function CH_CryptoCurrencies.SpawnCurrencyScreens()
	for k, v in ipairs( file.Find( "craphead_scripts/ch_cryptocurrencies/entities/".. map .."/screens/exchange_rate_screen_*.json", "DATA" ) ) do
		local PositionFile = file.Read( "craphead_scripts/ch_cryptocurrencies/entities/".. map .."/screens/".. v, "DATA" )

		local Pos = util.JSONToTable( PositionFile )
		local TheVector = Vector( Pos.EntityVector.x, Pos.EntityVector.y, Pos.EntityVector.z )
		local TheAngle = Angle( Pos.EntityAngles.x, Pos.EntityAngles.y, Pos.EntityAngles.z )

		local CryptoRateScreen = ents.Create( "ch_cryptocurrencies_exchange_rates" )
		CryptoRateScreen:SetPos( TheVector )
		CryptoRateScreen:SetAngles( TheAngle )
		CryptoRateScreen:Spawn()
		timer.Simple( 1, function()
			if IsValid( CryptoRateScreen ) then
				CryptoRateScreen:SetMoveType( MOVETYPE_NONE )
			end
		end )
	end
end

local function CH_CryptoCurrencies_SaveExchangeRateScreens( ply, cmd, args )
	if not ply:IsAdmin() then
		CH_CryptoCurrencies.NotifyPlayer( ply, CH_CryptoCurrencies.LangString( "Only administrators can perform this action!" ) )
		return
	end
	
	for k, v in ipairs( file.Find( "craphead_scripts/ch_cryptocurrencies/entities/".. map .."/screens/exchange_rate_screen_*.json", "DATA" ) ) do
		file.Delete( "craphead_scripts/ch_cryptocurrencies/entities/".. map .."/screens/".. v )
	end
	
	for k, ent in ipairs( ents.FindByClass( "ch_cryptocurrencies_exchange_rates" ) ) do
		local Entity_Position = {
			EntityVector = {
				x = ent:GetPos().x,
				y = ent:GetPos().y,
				z = ent:GetPos().z,
			},
			EntityAngles = {
				x = ent:GetAngles().x,
				y = ent:GetAngles().y,
				z = ent:GetAngles().z,
			},
		}
		
		file.Write( "craphead_scripts/ch_cryptocurrencies/entities/".. map .."/screens/exchange_rate_screen_".. math.random( 1, 9999999 ) ..".json", util.TableToJSON( Entity_Position ), "DATA" )
	end
	
	CH_CryptoCurrencies.NotifyPlayer( ply, CH_CryptoCurrencies.LangString( "All crypto exchange rate screens have been saved!" ) )
end
concommand.Add( "ch_cryptocurrencies_savescreens", CH_CryptoCurrencies_SaveExchangeRateScreens )

--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
