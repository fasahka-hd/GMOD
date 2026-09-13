--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

util.AddNetworkString( "Incass:Menu" )
util.AddNetworkString( "Incass:Sell" )
util.AddNetworkString( "Incass:Take" )

net.Receive( "Incass:Sell", function( _, pl )

	if pl:GetNWInt( "Incass:Bags", 0 ) == 30 then
		local bool = net.ReadBool()
		if bool then
			pl:SetNWInt( "Incass:Bags", 0 )
			local chance = math.random( 1, 100 )
			if chance <= Incass.WarrantChance * 100 then
				pl:Warrant(nil, "Кража инкасационных средств")
				rp.Notify( pl, 1, Incass.WarrantMessage )
			else
				rp.Notify( pl, 1, Incass.NoWarrantMessage )
			end
			pl:AddMoney( Incass.BagsPrice, 'Инкассация кража' )
		else
			pl:SetNWInt( "Incass:Bags", 0 )
			rp.Notify( pl, 0, Incass.GiveBagsMessage )
		end
	else
		rp.Notify( pl, 1, "Недостаточно пачек денег! Необходимо собрать: " .. Incass.MaxBags )
	end

end)

net.Receive( "Incass:Take", function( _, pl )

	if pl:GetNWInt( "Incass:Bags", 0 ) == Incass.MaxBags then return end
	local ent = pl:GetEyeTrace().Entity

	if not ent.cooldown then
		ent.cooldown = {}
	end

	if ent.cooldown[pl:SteamID64()] and ent.cooldown[pl:SteamID64()] + Incass.Cooldown > os.time() then return end
    if not ent or not IsValid(ent) or not ent:GetClass() == "incass_bank" or pl:GetPos():Distance( ent:GetPos() ) > 60 then return end

	if pl:Team() ~= Incass.Job then return end

	local bool = net.ReadBool()
	if not pl.takeStart or not bool then
		pl.takeStart = os.time()
		return
	end


	if bool and os.time() - pl.takeStart == 6 then
		pl.takeStart = nil
		pl:SetNWInt( "Incass:Bags", pl:GetNWInt( "Incass:Bags", 0 ) + 1 )
		rp.Notify( pl, 0, "Вы достали из банкомата пачку денег. Сейчас у вас: " .. pl:GetNWInt( "Incass:Bags" ) )
		eui.battlepass.AddProgress(pl, 7)
		eui.battlepass.AddProgress(pl, 33)
		ent.cooldown[pl:SteamID64()] = os.time()
	end

	

end)

--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
