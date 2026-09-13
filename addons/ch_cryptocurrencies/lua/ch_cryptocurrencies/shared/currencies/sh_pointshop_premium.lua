--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

CH_CryptoCurrencies.Currencies[ "sh_pointshop_premium" ] = {
	Name = "SH Pointshop Premium Points",
	
	AddMoney = function( ply, amount )
		ply:PS2_AddPremiumPoints( amount )
	end,
	
	TakeMoney = function( ply, amount )
		ply:PS2_AddPremiumPoints( -amount )
	end,
	
	GetMoney = function( ply )
		return ply.PS2_Wallet.premiumPoints
	end,
	
	CanAfford = function( ply, amount )
		return ply.PS2_Wallet.premiumPoints >= amount
	end,
	
	FormatMoney = function( amount )
		return string.Comma( amount ) .. " point" .. ( amount > 1 and "s" or "" )
	end,
	
	CurrencyAbbreviation = function()
		return "PTS"
	end,
}

--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
