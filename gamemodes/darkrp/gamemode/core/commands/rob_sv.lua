--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

rp.AddCommand('rob', function(pl)
	local robamount = math.random(100, 2000)
	local target = pl:GetEyeTrace().Entity

	if not pl:Alive() then rp.Notify(pl, NOTIFY_ERROR, term.Get('YouAreDead')) return end

	if (not IsValid(target)) or (not target:IsPlayer()) or (pl:EyePos():DistToSqr(target:GetPos()) > 28900) then
		rp.Notify(pl, NOTIFY_ERROR, term.Get('GetCloser'))
		return
	end

	if not pl:GetTeamTable().canrobbery then rp.Notify(pl, NOTIFY_ERROR, term.Get('CantDoThis')) return end

	if pl.RobCooldown != nil && CurTime() < pl.RobCooldown then 
		rp.Notify(pl, NOTIFY_ERROR, term.Get('NeedToWait'), math.ceil(pl.RobCooldown-CurTime()))
		return
	end

	pl.RobCooldown = (CurTime() + 180)

	pl:EmitSound('npc/combine_soldier/gear5.wav', 50, 100)

	if target:IsCP() then
		rp.Notify(pl, NOTIFY_ERROR, term.Get('BaitingRule'))
		pl:Wanted(nil, 'Ограбление')
		return
	end

	if target:GetTeamTable().hobo then
		rp.Notify(pl, NOTIFY_GENERIC, term.Get('FoundNothing'))
		return
	end

	if not target:CanAfford(1000) then
		rp.Notify(pl, NOTIFY_GENERIC, term.Get('FoundNothing'))
		rp.Notify(target, NOTIFY_ERROR, term.Get('RobberyAttempt'))
		return
	end

	if math.random(1, 2) != 2 then
		rp.Notify(pl, NOTIFY_ERROR, term.Get('RobberyFailed'))
		rp.Notify(target, NOTIFY_ERROR, term.Get('RobberyAttempt'))
		return
	end

	if (not pl:IsWanted()) and pl:CloseToCPs() then pl:Wanted(nil, 'Ограбление') return end

	target:TakeMoney(robamount, 'Проебал с ограбления ' .. pl:SteamID64())
	pl:AddMoney(robamount, 'Получил с ограбления ' .. target:SteamID64())


	rp.Notify(pl, NOTIFY_SUCCESS, term.Get('YouRobbed'), robamount)
	rp.Notify(target, NOTIFY_ERROR, term.Get('YouAreRobbed'))
	return
end)

--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
