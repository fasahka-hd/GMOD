--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

CH_CryptoCurrencies.Currencies[ "darkrp" ] = {
	Name = "DarkRP Money",

	AddMoney = function( ply, amount )
		ply:AddMoney( amount, 'Получение денег с Крипты' )
	end,
	
	TakeMoney = function( ply, amount )
		ply:AddMoney( amount * -1, 'Перевел деньги в Крипту' )
		eui.battlepass.AddProgress(ply, 22)
		eui.battlepass.AddProgress(ply, 37)
	end,
	
	GetMoney = function( ply )
		return ply:GetMoney()
	end,
	
	CanAfford = function( ply, amount )
		return ply:CanAfford( amount )
	end,
	
	FormatMoney = function( amount )
		return rp.FormatMoney( amount )
	end,
	
	CurrencyAbbreviation = function()
		return CH_CryptoCurrencies.Config.ExchangeRateCurrency
	end,
}

--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
