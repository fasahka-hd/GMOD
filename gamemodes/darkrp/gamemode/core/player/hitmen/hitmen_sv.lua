--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

util.AddNetworkString('rp.SyncHits')
util.AddNetworkString('rp.AddHit')
util.AddNetworkString('rp.RemoveHit')

rp.Hitlist = rp.Hitlist or {}

function PLAYER:AddHit(price)
	if self:GetNetVar('HitPrice') then
		self:SetNetVar('HitPrice', self:GetNetVar('HitPrice') + price)
		rp.Hitlist[self:SteamID64()] = self:GetNetVar('HitPrice') + price
	else
		self:SetNetVar('HitPrice', price)
		rp.Hitlist[self:SteamID64()] = price
	end
end

function PLAYER:RemoveHit(hitman)
	if IsValid(hitman) then
		rp.NotifyAll(NOTIFY_GENERIC, term.Get('HitComplete'), self)
		self:Notify(NOTIFY_GENERIC, term.Get('YourHitComplete'))
		hitman:AddMoney(self:GetHitPrice(), 'Получил с заказа')
		--hitman:LVLAddExp( enc.lvls["hit"] )
	end
	self:SetNetVar('HitPrice', nil)
	rp.Hitlist[self:SteamID64()] = nil
end

rp.AddCommand('hit', function(pl, targ, text)
	local price = tonumber(text or rp.cfg.HitMinCost)

	if (targ == pl) then
		pl:Notify(NOTIFY_ERROR, term.Get('CantHitYourself'))
	elseif targ:IsHitman() then
		pl:Notify(NOTIFY_ERROR, term.Get('CantHitHitman'))
	elseif pl:IsHitman() then
		pl:Notify(NOTIFY_ERROR, term.Get('CantPlaceHit'))
	elseif (not pl:CanAfford(price)) then
		pl:Notify(NOTIFY_ERROR, term.Get('CannotAfford'))
	elseif (price < rp.cfg.HitMinCost) or (price > rp.cfg.HitMaxCost) then
		pl:Notify(NOTIFY_ERROR, term.Get('HitPriceLimit'))
	elseif pl.LastHitTime and (pl.LastHitTime > CurTime()) and (not pl:IsRoot()) then
		pl:Notify(NOTIFY_ERROR, term.Get('HitTimer'), math.ceil(pl.LastHitTime - CurTime()))
	elseif pl.LastHit and (pl.LastHit == targ) and (not pl:IsRoot()) then
		pl:Notify(NOTIFY_ERROR, term.Get('MultiHit'))
	else
		pl.LastHit 		= targ
		pl.LastHitTime 	= CurTime() + rp.cfg.HitCoolDown

		if targ:HasHit() then
			pl:Notify(NOTIFY_SUCCESS, term.Get('BountyIncrease'), targ, rp.FormatMoney(price))
		else
			pl:Notify(NOTIFY_SUCCESS, term.Get('HitPlaced'), targ, rp.FormatMoney(price))
		end

		hook.Call('playerRequestedHit', GAMEMODE, pl, targ)

		pl:TakeMoney(price, 'Заказал игрока')
		targ:AddHit(price)
		eui.battlepass.AddProgress(pl, 10)
		eui.battlepass.AddProgress(pl, 31)

	end
end)
:AddParam(cmd.PLAYER_ENTITY)
:AddParam(cmd.STRING)

hook('PlayerDeath', function(pl, wep, killer)
	if pl:HasHit() and killer:IsPlayer() and killer:IsHitman() and (killer ~= pl) then
		pl:RemoveHit(killer)
		eui.battlepass.AddProgress(killer, 9)
		eui.battlepass.AddProgress(killer, 34)
		hook.Call('playerCompletedHit', GAMEMODE, killer, pl)
	end

	if pl:IsHitman() and killer:IsPlayer() and killer:HasHit() then
		pl:TeamBan(pl:Team(), 180)
		pl:ChangeTeam(1, true)
		pl:Notify(NOTIFY_ERROR, term.Get('HitmanFailed'))
	end
end)

hook('PlayerInitialSpawn', function(pl)
	if rp.Hitlist[pl:SteamID64()] then
		pl:AddHit(rp.Hitlist[pl:SteamID64()])
	end
end)

--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
