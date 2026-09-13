--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

CH_CryptoCurrencies.Currencies[ "santosrp" ] = {
	Name = "SantosRP Money",
	
	AddMoney = function( ply, amount )
		ply:AddMoney( amount )
	end,
	
	TakeMoney = function( ply, amount )
		ply:AddMoney( -amount )
	end,
	
	GetMoney = function( ply )
		return ply:GetMoney()
	end,
	
	CanAfford = function( ply, amount )
		return ply:CanAfford( amount )
	end,
	
	FormatMoney = function( amount )
		return "$" .. string.Comma( amount )
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
