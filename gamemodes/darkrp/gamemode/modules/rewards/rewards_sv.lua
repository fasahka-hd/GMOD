--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

resource.AddFile("materials/rewards_icons/close.png")
resource.AddFile("materials/rewards_icons/deny.png")
resource.AddFile("materials/rewards_icons/reward.png")
resource.AddFile("materials/rewards_icons/user.png")
resource.AddFile("materials/rewards_icons/yes.png")

local db = rp._Stats

util.AddNetworkString("Refs::OpenMenu")
util.AddNetworkString("Refs::UsePromo")
util.AddNetworkString("Refs::TakeMoney")
util.AddNetworkString("Refs::OnTakeMoney")

concommand.Add("Refs_OpenMenu", function(ply)
	db:Query('SELECT * FROM `rp_refsystem` WHERE steamid= "' .. ply:SteamID64() .. '";', function(_data)
		if #_data == 0 then
      		db:Query('INSERT INTO rp_refsystem(steamid, refcode, count, uses, pickup, donate) VALUES(?, ?, ?, ?, ?, ?);', ply:SteamID64(), string.Random(8), 0, 0, "false", "none")
      		ply:ChatPrint('Вы успешно создали промокод! Откройте меню ещё раз!')
      		return
      	end
      	net.Start("Refs::OpenMenu")
      	net.WriteTable(_data)
      	net.Send(ply)
	end)
end)

net.Receive("Refs::UsePromo", function(len, ply)
	local promo = string.lower(net.ReadString())
	if ply:GetPData("UsePromoSS") then ply:ChatPrint('Вы уже использовали промокод!') return end
	if ply:GetPlayTime() > 1 * 3600 then ply:ChatPrint('Вы уже давно не новый игрок!') return end
	db:Query('SELECT * FROM `rp_refsystem` WHERE refcode= "' .. promo .. '";', function(_data)
		if not _data[1] then ply:ChatPrint('Промокод не найден!') return end
		if _data[1].steamid == ply:SteamID64() then ply:ChatPrint('Вы не можете использовать свой же промокод!') return end
    	db:Query('UPDATE rp_refsystem SET count=? WHERE refcode=?', _data[1].count + 1, promo)
    	ply:ChatPrint('Вы успешно использовали промокод! И вы получили 15.000$')
    	ply:AddMoney(15000, 'Получил с промокода')
    	local owner = player.GetBySteamID64(_data[1].steamid)
    	if IsValid(owner) then
    		owner:ChatPrint('Игрок '..ply:GetName()..' использовал ваш промокод!')
    	end
    	ply:SetPData("UsePromoSS", tobool(true))
	end)
end)

net.Receive("Refs::TakeMoney", function(len, ply)
	db:Query('SELECT * FROM `rp_refsystem` WHERE steamid= "' .. ply:SteamID64() .. '";', function(_data)
		if _data[1].count <= 0 then ply:ChatPrint('На вашем счету 0 рублей!') return end
		if _data[1].count <= _data[1].uses / 150 then ply:ChatPrint('На вашем счету 0 рублей!') return end
		local rub = _data[1].count * 150 - _data[1].uses
		db:Query('UPDATE rp_refsystem SET uses=? WHERE steamid=?', _data[1].uses + rub, ply:SteamID64())
		ply:ChatPrint('Вы успешно вывели '..rub..' рублей!')
		ply:AddCredits(rub, 'Refs::AddCredits')
	end)
end)

net.Receive("Refs::OnTakeMoney", function(len, ply)
	db:Query('SELECT * FROM `rp_refsystem` WHERE steamid= "' .. ply:SteamID64() .. '";', function(_data)
		if _data[1].count < 2 then return end
		if ply:GetPlayTime() < 24 * 3600 then return end
		if _data[1].donate != "true" then return end
		if _data[1].pickup == "true" then return end
		if ply:GetPData("fundament") then
			ply:ChatPrint('Вы уже получали бонус за /greenrp!')
			db:Query('UPDATE rp_refsystem SET pickup=? WHERE steamid=?', "true", ply:SteamID64())
			return
		end
		ply:SetPData( "fundament", os.time( ) )
		db:Query('UPDATE rp_refsystem SET pickup=? WHERE steamid=?', "true", ply:SteamID64())
		ply:ChatPrint('Вы успешно получили бонус 500 рублей за выполненные задания!')
		ply:AddCredits(500, 'Refs::AddCredits')
	end)
end)


hook.Add("OnBuyDonateItem", "Refs::OnDonate", function(pl, id)
	db:Query('SELECT * FROM `rp_refsystem` WHERE steamid= "' .. pl:SteamID64() .. '";', function(_data)
		if not _data[1] then return end
		if pl:GetPData("RefssDonate") then return end
		if _data[1].count >= 2 then
			db:Query('UPDATE rp_refsystem SET donate=? WHERE steamid=?', "true", pl:SteamID64())
			pl:SetPData("RefssDonate", tobool(true))
		end
	end)
end)


--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
