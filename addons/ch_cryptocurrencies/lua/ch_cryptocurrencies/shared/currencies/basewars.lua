--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

CH_CryptoCurrencies.Currencies[ "basewars" ] = {
	Name = "Basewars Money",
	
	AddMoney = function( ply, amount )
		ply:GiveMoney( amount )
	end,
	
	TakeMoney = function( ply, amount )
		ply:TakeMoney( amount )
	end,
	
	GetMoney = function( ply )
		return ply:GetMoney()
	end,
	
	CanAfford = function( ply, amount )
		return ply:GetMoney() >= amount
	end,
	
	FormatMoney = function( amount )
		return DarkRP.formatMoney( amount )
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
