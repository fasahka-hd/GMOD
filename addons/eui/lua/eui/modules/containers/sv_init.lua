eui.container.bets = eui.container.bets or {}
eui.container.ends = eui.container.ends or {}

local tbl = eui.container.bets

function eui.container.PlaceBet(pl, money, cont)
	if not eui.container.IsActive(cont) then return 'Контейнер неактивен!' end
	if pl:GetMoney() < money then return 'У вас недостаточно средств' end

	local sid = pl:SteamID64()
	tbl[cont] = tbl[cont] or {}
	tbl[cont].winner = tbl[cont].winner or {}

	local contTbl = tbl[cont]
	if contTbl.winner[sid] then return 'Ваша ставка и так лидирует!' end

	pl:AddMoney(-money)
	local oldMoney = contTbl[sid] or 0
	local newMoney = oldMoney + money

	local max = 0
	for k, v in next, contTbl.winner do
		max = math.max(max, v)
	end

	contTbl[sid] = newMoney

	if newMoney > max then
		contTbl.winner = {}
		contTbl.winner[sid] = newMoney
	end

	for k, v in next, contTbl.winner do
		net.Start('eui.container:UpdateLeader')
		net.WriteTable({name = k, money = v})
		net.Broadcast()
	end

	return 'Вы успешно поставили ставку!'
end

function eui.container.GenerateItem(cont)
	local items = eui.container.items[cont]

	if not items or not istable(items) then return end

	local total = 0
	for _, v in next, items do
		total = total + v.chance
	end

	if total <= 0 then return end

	local cur = 0
	local random = math.random(total)

	for _, v in next, items do
		cur = cur + v.chance
		if random <= cur then
			return v
		end
	end

	return nil
end

function eui.container.endContainer()
	for k, cont in next, eui.container.containers do
		if eui.container.ends[k] then continue end
		if eui.container.IsActive(k) then continue end

		if not eui.container.bets[k] or not eui.container.bets[k].winner then
			eui.container.ends[k] = true
			continue
		end

		local winner = tbl[k].winner
		if winner and istable(winner) then
			for k2, v2 in next, winner do
				winner = k2
			end
		end

		if table.Count(tbl[k]) < 2 then
			for k2, v2 in next, tbl[k] do
				if k2 == 'winner' then continue end

				local pl = player.GetBySteamID64(k2)
				if not IsValid(pl) then continue end

				pl:AddMoney(v2)
				rp.Notify(pl, 5, 'Недостаточно участников. Вам вернули: ' .. string.Comma(v2) .. ' ₽')
			end

			return
		end

		for k2, v2 in next, tbl[k] do
			if k2 == 'winner' then continue end
			if k2 == winner then continue end

			local pl = player.GetBySteamID64(k2)
			if not IsValid(pl) then continue end

			pl:AddMoney(v2 / 2)
			rp.Notify(pl, 5, 'Вы проиграли. Вам вернули: ' .. string.Comma(v2 / 2, ' ') .. ' ₽')
		end

		for sid, v2 in next, tbl[k].winner do
			local pl = player.GetBySteamID64(sid)
			if not IsValid(pl) then
				eui.container.ends[sid] = k
				eui.container.ends[k] = true
				continue
			end

			local item = eui.container.GenerateItem(k)
			if not item then continue end

			item.take(pl)
			rp.Notify(pl, 5, 'Вы успешно выиграли контейнер. В нем находился: ' .. item.name)

			eui.container.ends[k] = true
			break
		end
	end
end

timer.Create('eui.containers.EndContainer', 60, 0, eui.container.endContainer)
