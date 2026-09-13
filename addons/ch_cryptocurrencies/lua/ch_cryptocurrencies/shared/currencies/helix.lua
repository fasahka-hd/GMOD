--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

CH_CryptoCurrencies.Currencies[ "Helix" ] = {
	Name = "Helix Money",
	
	AddMoney = function( ply, amount )
		ply:GetCharacter():GiveMoney( amount )
	end,
	
	TakeMoney = function( ply, amount )
		ply:GetCharacter():TakeMoney( amount )
	end,
	
	GetMoney = function( ply )
		return ply:GetCharacter():GetMoney()
	end,
	
	CanAfford = function( ply, amount )
		return ply:GetCharacter():HasMoney( amount )
	end,
	
	FormatMoney = function( amount )
		return ix.currency.Get( amount )
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
