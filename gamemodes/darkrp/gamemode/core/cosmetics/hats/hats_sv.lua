--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

rp.AddCommand('buyhat', function(pl, targ, text)
	if not targ or not rp.hats.list[targ] or table.HasValue(pl:GetNetVar('HatData') or {}, targ) then return end

	local hat = rp.hats.list[targ]

	if not pl:CanAfford(hat.price) then
		rp.Notify(pl, NOTIFY_ERROR, term.Get('CannotAfford'))
		return
	end

	local HatData = pl:GetNetVar('HatData') or {}
	table.insert(HatData, targ)
	pl:SetNetVar('HatData', HatData)

	rp.data.SetHat(pl, hat.model, function()
		pl:TakeMoney(hat.price, 'Купил шляпу')
		rp.Notify(pl, NOTIFY_SUCCESS, term.Get('HatPurchased'), hat.name, rp.FormatMoney(hat.price))
	end)
end)
:AddParam(cmd.STRING)

rp.AddCommand('sethat', function(pl, targ, text)
	if not targ or not rp.hats.list[targ] or not pl:GetNetVar('HatData') or not table.HasValue(pl:GetNetVar('HatData') or {}, targ) then return end

	rp.Notify(pl, NOTIFY_SUCCESS, term.Get('HatEquipped'))
	rp.data.SetHat(pl, targ)
end)
:AddParam(cmd.STRING)

rp.AddCommand('removehat', function(pl, targ, text)
	rp.Notify(pl, NOTIFY_SUCCESS, term.Get('HatRemoved'))
	rp.data.SetHat(pl, nil)
end)

--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
