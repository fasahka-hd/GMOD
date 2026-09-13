--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

util.AddNetworkString("mayor::resetLaws")
util.AddNetworkString("mayor::addLaw")
util.AddNetworkString("mayor::removeLaw")

util.AddNetworkString("mayor::topup")
util.AddNetworkString("mayor::withdraw")

util.AddNetworkString("mayor::getTax")
util.AddNetworkString("mayor::setTax")

util.AddNetworkString("mayor::getUpgrade")
util.AddNetworkString("mayor::buyUpgrade")

util.AddNetworkString("mayor::popUpActions")

hook.Add("PlayerInitialSpawn", "mayor::setTB", function()
	nw.SetGlobal('TheLaws', rp.cfg.DefaultLaws)

	hook.Remove("PlayerInitialSpawn", "mayor::setTB")
end)

util.AddNetworkString('addLaws')
net.Receive("mayor::resetLaws", function(_, ply)
	if not ply:IsMayor() then return rp.Notify(ply, 1, "Вы не являетесь мэром!")  end

	rp.Laws = rp.cfg.DefaultLaws
	nw.SetGlobal('TheLaws', rp.Laws)

	hook.Call('mayorResetLaws', GAMEMODE, ply)
	rp.Notify(ply, 0, "Законы сброшены")

	net.Start('addLaws')
	net.Broadcast()
end)

hook.Add('PlayerInitialSpawn', 'sendLaws', function(pl)
	nw.WaitForPlayer(pl, function(pl)
		net.Start('addLaws')
		net.Send(pl)
	end)
end)
//
//net.Receive("mayor::addLaw", function(_,ply)
//	local str = net.ReadString()
//
//	if(!ply:IsMayor()) then
//		return rp.Notify(ply,1,"Вы не являетесь мэром!") 
//	end
//	
//	if( utf8_len(str) < 6 || utf8_len(str) > 36 ) then
//		return rp.Notify(ply,1,"Текст закона слишком длинный/короткий") 
//	end
//
//	local laws = nw.GetGlobal('TheLaws') or {}
//	laws[#laws+1] = str
//	nw.SetGlobal('TheLaws', laws)
//
//	hook.Call('mayorSetLaws', GAMEMODE, pl)
//	rp.Notify(ply,0,"Закон добавлен")
//end)
//
//net.Receive("mayor::removeLaw", function(_,ply)
//	local int = net.ReadUInt(8)
//
//	if(!ply:IsMayor()) then
//		return rp.Notify(ply,1,"Вы не являетесь мэром!") 
//	end
//
//	local laws = nw.GetGlobal('TheLaws') or {}
//	if(!laws[int]) then
//		return rp.Notify(ply,1,"Этого закона не существует!") 
//	end
//	table.remove(laws, int)
//
//	nw.SetGlobal('TheLaws', laws)
//
//	hook.Call('mayorSetLaws', GAMEMODE, pl)
//	hook.Call('mayorRemoveLaws', GAMEMODE, pl)
//
//	rp.Notify(ply,0,"Закон удален")
//end)

util.AddNetworkString("mayor::getMoneyData")

local money = 0
local transactions = {}
local upgrades = {}
local pending = false
mayorNPC = nil

net.Receive("mayor::getMoneyData", function(_,ply)
	net.Start("mayor::getMoneyData")
	net.WriteUInt( money, 32 )
	net.WriteTable( transactions )
	net.Send(ply)
end)

net.Receive("mayor::topup", function(_,ply)
	local mny = net.ReadUInt(32)

	if(!ply:IsMayor()) then
		return rp.Notify(ply,1,"Вы не являетесь мэром!") 
	end

	if(mny <= 0) then return end
	if(!ply:CanAfford(mny)) then
		return rp.Notify(ply,1,"У вас недостаточно денег") 
	end

	ply:AddMoney(-mny, 'Пополнил казну')
	money = money + mny

	transactions[#transactions + 1] = {
		sum = mny,
		topup = true,
		reason = "Пополнение через меню",
		time = os.time()
	}

	hook.Run("mayor::money::insert::alogs", ply, mny, ply:GetMoney())

	rp.Notify(ply,0,"Баланс пополнен")
end)

function popup_kazna(mny, reas)
	if(mny <= 0) then return end

	money = money + mny

	transactions[#transactions + 1] = {
		sum = mny,
		topup = true,
		reason = reas,
		time = os.time()
	}
end

net.Receive("mayor::withdraw", function(_,ply)
	local mny = net.ReadUInt(32)

	if(!ply:IsMayor()) then
		return rp.Notify(ply,1,"Вы не являетесь мэром!") 
	end

	if(mny <= 0) then return end
	if(money < mny) then
		return rp.Notify(ply,1,"У вас недостаточно денег") 
	end
	if(pending) then 
		return rp.Notify(ply,0,"Операция уже в процессе")
	end

	rp.Notify(ply,0,"Деньги будут начислены через 5 минут")
	pending = true

	timer.Simple(300, function()
		pending = false
		if(mny <= 0) then return end
		if(money < mny) then return end
		if(!IsValid(ply) || rp.teams[ply:Team()].mayor != true) then return end
		ply:AddMoney(mny, 'Снял с казны')
		money = money - mny
	
		transactions[#transactions + 1] = {
			sum = mny,
			topup = false,
			reason = "Снятие через меню",
			time = os.time()
		}
	
		hook.Run("mayor::money::withdraw::alogs", ply, mny, ply:GetMoney())

		rp.Notify(ply,0,"Деньги сняты")
	end)
end)


net.Receive("mayor::setTax", function(_,ply)
	local id = net.ReadUInt(5)
	local tx = net.ReadFloat()
	tx = math.Round(tx, 2)
	if(tx < 0 || tx > 0.3) then return end 

	if(!ply:IsMayor()) then
		return rp.Notify(ply,1,"Вы не являетесь мэром!") 
	end

	local tax = nw.GetGlobal'taxData' or {}
	tax[id] = tx
	nw.SetGlobal("taxData", tax)

	net.Start("mayor::getTax")
	net.Send(ply)

	rp.Notify(ply,0,"Налог изменен")
	rp.NotifyAll(0, "Налоги были изменены")
end)

net.Receive("mayor::getUpgrade", function(_,ply)
	net.Start("mayor::getUpgrade")
	net.WriteTable(upgrades)
	net.Send(ply)
end)

local upList = mayor_system.upgrades
net.Receive("mayor::buyUpgrade", function(_,ply)
	local id = net.ReadUInt(7)

	if(!upList[id]) then return end

	if(!ply:IsMayor()) then
		return rp.Notify(ply,1,"Вы не являетесь мэром!") 
	end

	local dat = upList[id]

	if(money < dat.price) then
		return rp.Notify(ply,1,"У вас недостаточно денег") 
	end

	money = money - dat.price
	transactions[#transactions + 1] = {
		sum = dat.price,
		topup = false,
		reason = "Покупка улучшения",
		time = os.time()
	}
	upgrades[id] = true
	rp.Notify(ply,0,"Вы приобрели улучшение")

	if(dat.onBuy) then dat.onBuy() end
end)

net.Receive("mayor::popUpActions", function(_,ply)
	local id = net.ReadUInt(7)

	if(!ply:IsMayor()) then
		return rp.Notify(ply,1,"Вы не являетесь мэром!") 
	end

	if(id == 1) then
		local ent = net.ReadEntity()
		
		if(!IsValid(ent) || !ent:IsPlayer() || !ent:IsCP()) then return end
		
		ent:ChangeTeam(rp.DefaultTeam, true)

		rp.Notify(ply,0,"Вы выгнали сотрудника с рабочего места")
		rp.Notify(ent,0,"Мэр выгнал вас с вашего рабочего места")
	elseif(id == 2) then
		local ent = net.ReadEntity()
		local mny = net.ReadUInt(32)
		if(!IsValid(ent) || !ent:IsPlayer() || !ent:IsCP()) then return end
		if(mny < 0) then return end
		if(money < mny) then return end

		money = money - mny
		transactions[#transactions + 1] = {
			sum = mny,
			topup = false,
			reason = "Выплата премии " .. ent:Name(),
			time = os.time()
		}

		ent:AddMoney(mny, 'Получил премию')

		rp.Notify(ent,0,"Вам выписали премию в размере " .. rp.FormatMoney(mny))
		rp.Notify(ply,0,"Премия выписана")
	elseif(id == 3) then
		local ent = net.ReadEntity()
		
		if(!IsValid(ent) || !ent:IsPlayer() || !ent:IsCP()) then return end

		ent:TeamBan(ent:Team(),600)
		ent:ChangeTeam(rp.DefaultTeam, true)

		rp.Notify(ply,0,"Вы выгнали сотрудника с рабочего места и запретили ему работать на 10 минут")
		rp.Notify(ent,0,"Мэр выгнал вас с вашего рабочего места и запретил вам работать на 10 минут")
	end
end)

function mayor_system:add_balance( sum )
	money = money + sum
end

function mayor_system:get_balance()
	return money
end

function mayor_system:check_up( id )
	return upgrades[ id ] or false
end

util.AddNetworkString("mayor::lockdown")

local reasonList = mayor_system.indexReason_lockdown
net.Receive("mayor::lockdown", function(_,ply)
	local reason = net.ReadString()

	if(!ply:IsMayor()) then
		return rp.Notify(ply,1,"Вы не являетесь мэром!")
	end
	if(!reasonList[reason]) then return end

	if(!nw.GetGlobal('lockdown')) then
		GAMEMODE:Lockdown(ply, reason)
	else
		GAMEMODE:UnLockdown(ply)
	end
end)

function mayor_system:loadNPC()
	mayorNPC = ents.Create("npc_rp_sec")
	mayorNPC:SetPos( Vector(-37.148128509521, 5803.3315429688, 80.03125 ) )
	mayorNPC:SetAngles( Angle( 0, 0, 0 ) )
	mayorNPC:Spawn()
end

hook('OnPlayerChangedTeam', 'mayor::OnPlayerChangedTeam', function(pl, before, after)
	if (rp.teams[before].mayor == true) then
		money = 0
		transactions = {}
		upgrades = {}
		pending = false

		nw.SetGlobal('TheLaws', rp.cfg.DefaultLaws)

		net.Start('addLaws')
		net.Broadcast()

		if(IsValid(mayorNPC)) then mayorNPC:Remove() end
	end
end)

hook("PlayerLoadout", "mayor::loadData", function(ply)
	if(mayor_system:check_up(2) && ply:IsCP()) then
		ply:SetMaxHealth( 125 )
		ply:SetHealth( 125 )
	end
	if(mayor_system:check_up(3) && ply:IsCP()) then
		ply:SetMaxArmor( 125 )
		timer.Simple(0.5, function() ply:SetArmor( 125 ) end)
	end
end)

hook("mayorSetLaws", "mayor::setLaws", function()
	rp.NotifyAll(0, "Законы были изменены")

	timer.Simple(.5, function()
	net.Start('addLaws')
	net.Broadcast()
	end)
end)

util.AddNetworkString("mayor::menu")
rp.AddCommand("mayormenu", function(ply)
	if(!ply:IsMayor()) then return end
	net.Start("mayor::menu")
	net.Send(ply)
end)

--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
