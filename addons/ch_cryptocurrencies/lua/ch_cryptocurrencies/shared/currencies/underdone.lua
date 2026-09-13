--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

CH_CryptoCurrencies.Currencies[ "underdone" ] = {
	Name = "Underdone Money",
	
	AddMoney = function( ply, amount )
		ply:AddItem( "money", amount )
	end,
	
	TakeMoney = function( ply, amount )
		ply:RemoveItem( "money", -amount )
	end,
	
	GetMoney = function( ply )
		return ply.Data.Inventory["money"] or 0
	end,
	
	CanAfford = function( ply, amount )
		local cur_money = ply.Data.Inventory["money"] or 0
		
		return cur_money >= amount
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
