--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

local term = ba.logs.Term

-- Kills
ba.logs.AddTerm('Killed', '#(#) убил #(#) с помощью # #', {
	'Attacker Name',
	'Attacker SteamID',
	[3] = 'Name',
	[4] = 'SteamID',
})

ba.logs.Create 'Убийства'
	:SetColor(Color(200,0,0))
	:Hook('PlayerDeath', function(self, pl, ent, killer)
		if killer:IsPlayer() and not pl:IsBanned() then
			local w = killer:GetActiveWeapon()
			if w and w:IsValid() then
				wep = w:GetClass()
			else
				wep = "none"
			end	
			self:PlayerLog({pl, killer}, term('Killed'), killer:Name(), killer:SteamID(), pl:Name(), pl:SteamID(), wep, ((killer:InSpawn() or pl:InSpawn()) and 'на спавне' or '') .. ((killer:IsHitman() and pl:HasHit()) and ' for a hit' or ''))
		end
	end)


-- Damage
ba.logs.AddTerm('Damage', '#(#) нанёс # урона #(#) с помощью # #', {
	'Attacker Name',
	'Attacker SteamID',
	[4] = 'Name',
	[5] = 'SteamID',
})

ba.logs.Create 'Урон'
	:Hook('EntityTakeDamage', function(self, ent, dmginfo)
		if ent:IsPlayer() and dmginfo:GetAttacker():IsPlayer() and not ent:IsBanned() then
			local attacker = dmginfo:GetAttacker()
			local w = attacker:GetActiveWeapon()
			if w and w:IsValid() then
				wep = w:GetClass()
			else
				wep = "none"
			end	
			self:Log(term('Damage'), attacker:Name(), attacker:SteamID(), math.Round(dmginfo:GetDamage(), 0), ent:Name(), ent:SteamID(), wep, ((dmginfo:GetAttacker():InSpawn() or ent:InSpawn()) and ' in spawn ' or ''))
		end
	end)


-- Props
ba.logs.AddTerm('Prop', '#(#) создал #', {
	'Name',
	'SteamID',
})

ba.logs.Create 'Пропы'
	:SetColor(Color(50,175,255))
	:Hook('PlayerSpawnProp', function(self, pl, mdl)
		if (not pl:IsBanned()) and (not pl:IsJailed()) and (not pl.SpawningDupeProp) then 
			self:PlayerLog(pl, term('Prop'), pl:Name(), pl:SteamID(), mdl)
		end
	end)

-- Dupes
ba.logs.AddTerm('Dupe', '#(#) создал копию с # энтити и # ограничениями', {
	'Name',
	'SteamID',
})

ba.logs.Create 'Копии'
	:SetColor(Color(153,102,255))
	:Hook('PlayerSpawnDupe', function(self, pl, file, ents, constraints)
		self:PlayerLog(pl, term('Dupe'), pl:Name(), pl:SteamID(), #ents, #constraints)
	end)


-- Tools
ba.logs.AddTerm('Tool', '#(#) использовал тулган на # принадлежащий #(#) с помощью #', {
	'Name',
	'SteamID',
})

ba.logs.Create 'Тулган'
	:Hook('PlayerToolEntity', function(self, pl, ent, tool)
		if IsValid(ent) then
			if IsValid(ent:CPPIGetOwner()) then
				self:PlayerLog(pl, term('Tool'), pl:Name(), pl:SteamID(), ent:GetClass(), ent:CPPIGetOwner():Name(), ent:CPPIGetOwner():SteamID(), tool)
			else
				self:PlayerLog(pl, term('Tool'), pl:Name(), pl:SteamID(), ent:GetClass(), 'Unknown', 'STEAM:0:0', tool)
			end
		end
	end)


-- Physgun
ba.logs.AddTerm('Physgun', '#(#) использовал физган на # принадлежащий #(#)', {
	'Name',
	'SteamID',
})

ba.logs.Create('Физган', false)
	:Hook('PlayerPhysgunEntity', function(self, pl, ent)
		if IsValid(ent:CPPIGetOwner()) then
			self:PlayerLog(pl, term('Physgun'), pl:Name(), pl:SteamID(), ent:GetClass(), ent:CPPIGetOwner():Name(), ent:CPPIGetOwner():SteamID(), tool)
		else
			self:PlayerLog(pl, term('Physgun'), pl:Name(), pl:SteamID(), ent:GetClass(), 'Unknown', 'STEAM:0:0', tool)
		end
	end)


-- Actions
ba.logs.AddTerm('RunRPCommand', '#(#) выполнил # #', {
	'Name',
	'SteamID',
})

ba.logs.Create 'РП Команды'
	:Hook('PlayerRunRPCommand', function(self, pl, cmd, args, arg_str)
		if (cmd ~= '/weaponcolor') and (cmd ~= '/playercolor') then
			self:PlayerLog(pl, term('RunRPCommand'), pl:Name(), pl:SteamID(), cmd, arg_str)
		end
	end)
	

-- Transactions
ba.logs.AddTerm('DropMoney', '#(#) выкинул $# (Нынешняя сумма кошелька: $#)', {
	'Name',
	'SteamID',
})

ba.logs.AddTerm('PickupMoney', '#(#) подобрал $# (Нынешняя сумма кошелька: $#)', {
	'Name',
	'SteamID',
})

ba.logs.AddTerm('DropCheck', '#(#) выкинул чек #(#) за $# (Нынешняя сумма кошелька: $#)', {
	'Name',
	'SteamID',
	'Target Name',
	'Target SteamID'
})

ba.logs.AddTerm('PickupCheck', '#(#) передал #(#) сумма $# (Нынешняя сумма кошелька: $#)', {
	'Name',
	'SteamID',
	'Giver Name',
	'Giver SteamID'
})

ba.logs.AddTerm('VoideCheck', '#(#) ограбил #(#) на $# (Нынешняя сумма кошелька: $#)', {
	'Name',
	'SteamID',
	'Target Name',
	'Target SteamID'
})

ba.logs.AddTerm('BuyItem', '#(#) купил # за $# (Нынешняя сумма кошелька: $#)', {
	'Name',
	'SteamID',
})

ba.logs.AddTerm('InsertMayor', '#(#) внес $# в казну города (Нынешняя сумма кошелька: $#)', {
	'Name',
	'SteamID',
})

ba.logs.AddTerm('WithdrawMayor', '#(#) снял $# с казны города (Нынешняя сумма кошелька: $#)', {
	'Name',
	'SteamID',
})

ba.logs.Create 'История денег'
	:Hook('PlayerDropRPMoney', function(self, pl, amt, newcash)
		self:PlayerLog(pl, term('DropMoney'), pl:Name(), pl:SteamID(), amt, newcash)
	end)
	:Hook('PlayerPickupRPMoney', function(self, pl, amt, newcash)
		self:PlayerLog(pl, term('PickupMoney'), pl:Name(), pl:SteamID(), amt, newcash)
	end)
	:Hook('PlayerDropRPCheck', function(self, pl, topl, amt, newcash)
		self:PlayerLog(pl, term('DropCheck'), pl:Name(), pl:SteamID(), topl:Name(), topl:SteamID(), amt, newcash)
	end)
	:Hook('PlayerPickupRPCheck', function(self, pl, frompl, amt, newcash)
		self:PlayerLog(pl, term('PickupCheck'), pl:Name(), pl:SteamID(), frompl:Name(), frompl:SteamID(), amt, newcash)
	end)
	:Hook('PlayerVoidedRPCheck', function(self, pl, topl, amt, newcash)
		self:PlayerLog(pl, term('VoideCheck'), pl:Name(), pl:SteamID(), topl:Name(), topl:SteamID(), amt, newcash)
	end)
	:Hook('PlayerBoughtItem', function(self, pl, item, amt, newcash)
		self:PlayerLog(pl, term('BuyItem'), pl:Name(), pl:SteamID(), item, amt, newcash)
	end)
	:Hook('mayor::money::insert::alogs', function(self, pl, amt, newcash)
		self:PlayerLog(pl, term('InsertMayor'), pl:Name(), pl:SteamID(), amt, newcash)
	end)
	:Hook('mayor::money::withdraw::alogs', function(self, pl, amt, newcash)
		self:PlayerLog(pl, term('WithdrawMayor'), pl:Name(), pl:SteamID(), amt, newcash)
	end)

-- Police
ba.logs.AddTerm('Warranted', '#(#) взял ордер на #(#) за #', {
	'Officer Name',
	'Officer SteamID',
	'Name',
	'SteamID',
})

ba.logs.AddTerm('UnWarranted', '#(#) отменил ордер на #(#)', {
	'Officer Name',
	'Officer SteamID',
	'Name',
	'SteamID',
})

ba.logs.AddTerm('Wanted', '#(#) объявил розыск на #(#) за #', {
	'Officer Name',
	'Officer SteamID',
	'Name',
	'SteamID',
})

ba.logs.AddTerm('UnWanted', '#(#) отменил розыск на #(#)', {
	'Officer Name',
	'Officer SteamID',
	'Name',
	'SteamID',
})

ba.logs.AddTerm('Arrested', '#(#) арестовал #(#)', {
	'Officer Name',
	'Officer SteamID',
	'Name',
	'SteamID',
})

ba.logs.AddTerm('cuff', '#(#) надел наручники на #(#)', {
	'Officer Name',
	'Officer SteamID',
	'Name',
	'SteamID',
})

ba.logs.AddTerm('UnArrested', '#(#) разарестовал #(#)', {
	'Officer Name',
	'Officer SteamID',
	'Name',
	'SteamID',
})

ba.logs.Create 'Полиция'
	:SetColor(Color(20,0,255))
	:Hook('PlayerWarranted', function(self, pl, actor, reason)
		if IsValid(actor) then
			self:PlayerLog({pl, actor}, term('Warranted'), actor:Name(), actor:SteamID(), pl:Name(), pl:SteamID(), reason)
		end
	end)
	:Hook('PlayerUnWarranted', function(self, pl, actor)
		if IsValid(actor) then
			self:PlayerLog({pl, actor}, term('UnWarranted'), actor:Name(), actor:SteamID(), pl:Name(), pl:SteamID())
		end
	end)
	:Hook('PlayerWanted', function(self, pl, actor, reason)
		if IsValid(actor) then
			self:PlayerLog({pl, actor}, term('Wanted'), actor:Name(), actor:SteamID(), pl:Name(), pl:SteamID(), reason)
		end
	end)
	:Hook('PlayerUnwanted', function(self, pl, actor, reason)
		if IsValid(actor) then
			self:PlayerLog({pl, actor}, term('UnWanted'), actor:Name(), actor:SteamID(), pl:Name(), pl:SteamID())
		end
	end)
	:Hook('PlayerArrested', function(self, pl, actor, reason)
		if IsValid(actor) then
			self:PlayerLog({pl, actor}, term('Arrested'), actor:Name(), actor:SteamID(), pl:Name(), pl:SteamID())
		end
	end)
	:Hook('PlayerUnArrested', function(self, pl, actor, reason)
		if IsValid(actor) then
			self:PlayerLog({pl, actor}, term('UnArrested'), actor:Name(), actor:SteamID(), pl:Name(), pl:SteamID())
		end
	end)
	:Hook('PlayerCuf', function(self, pl, actor)
		if IsValid(actor) then
			self:PlayerLog({pl, actor}, term('cuff'), actor:Name(), actor:SteamID(), pl:Name(), pl:SteamID())
		end
	end)



-- Mayor
ba.logs.AddTerm('StartLotto', '#(#) запустил лотерею', {
	'Name',
	'SteamID',
})

ba.logs.AddTerm('StartLockdown', '#(#) запустил комендандский час', {
	'Name',
	'SteamID',
})

ba.logs.AddTerm('EndLockdown', '#(#) отменил комендандский час', {
	'Name',
	'SteamID',
})

ba.logs.AddTerm('ChangeLaws', '#(#) изменил законы', {
	'Name',
	'SteamID',
})

ba.logs.Create 'Мэр'
	:SetColor(Color(200,0,0))
	:Hook('lotteryStarted', function(self, pl)
		self:PlayerLog(pl, term('StartLotto'), pl:Name(), pl:SteamID())
	end)
	:Hook('LockdownStarted', function(self, pl)
		self:PlayerLog(pl, term('StartLockdown'), pl:Name(), pl:SteamID())
	end)
	:Hook('LockdownEnded', function(self, pl)
		self:PlayerLog(pl, term('EndLockdown'), pl:Name(), pl:SteamID())
	end)
	:Hook('mayorSetLaws', function(self, pl)
		self:PlayerLog(pl, term('ChangeLaws'), pl:Name(), pl:SteamID())
	end)
	:Hook('mayorResetLaws', function(self, pl)
		if IsValid(pl) then
			self:PlayerLog(pl, term('ChangeLaws'), pl:Name(), pl:SteamID())
		end
	end)


-- Hit logs
ba.logs.AddTerm('RequestHit', '#(#) заказал убийство на #(#)', {
	'Requester Name',
	'Requester SteamID',
	'Name',
	'SteamID',
})

ba.logs.AddTerm('CompleteHit', '#(#) выполнил заказ на #(#)', {
	'Hitman Name',
	'Hitman SteamID',
	'Name',
	'SteamID',
})

ba.logs.Create 'Заказы'
	:SetColor(Color(204,204,0))
	:Hook('playerRequestedHit', function(self, pl, target)
		self:PlayerLog({pl, target}, term('RequestHit'), pl:Name(), pl:SteamID(), target:Name(), target:SteamID())
	end)
	:Hook('playerCompletedHit', function(self, pl, target)
		self:PlayerLog({pl, target}, term('CompleteHit'), pl:Name(), pl:SteamID(), target:Name(), target:SteamID())
	end)


-- RP
ba.logs.AddTerm('ChangeName', '#(#) изменил свое РП имя на "#"', {
	'Name',
	'SteamID',
})

ba.logs.AddTerm('DemotePlayer', '#(#) начал голосование на увольнение на #(#) за "#"', {
	'Demoter Name',
	'Demoter SteamID',
	'Name',
	'SteamID',
})

ba.logs.AddTerm('Disguise', '#(#) замаскировался # с #', {
	'Name',
	'SteamID',
})

ba.logs.AddTerm('Chnage', '#(#) поменял работу на # с #', {
	'Name',
	'SteamID',
})

ba.logs.AddTerm('HirePlayer', '#(#) нанял #(#)', {
	'Name',
	'SteamID',
	'Employee Name',
	'Employee SteamID',
})

ba.logs.AddTerm('Bailed', '#(#) внёс залог за #(#) за $#', {
	'Name',
	'SteamID',
	'Target Name',
	'Target SteamID',
})

ba.logs.Create 'РП'
	:SetColor(Color(100,50,20))
	:Hook('playerChangedRPName', function(self, pl, newname)
		self:PlayerLog(pl, term('ChangeName'), pl:Name(), pl:SteamID(), newname)
	end)
	:Hook('playerDemotePlayer', function(self,  pl, target, reason)
		self:PlayerLog({pl, target}, term('DemotePlayer'), pl:Name(), pl:SteamID(), target:Name(), target:SteamID(), reason)
	end)
	:Hook('playerDisguised', function(self, pl, oldt, newt)
		self:PlayerLog(pl, term('Disguise'), pl:Name(), pl:SteamID(), team.GetName(newt), team.GetName(oldt))
	end)
	:Hook('OnPlayerChangedTeam', function(self, pl, oldt, newt)
		self:PlayerLog(pl, term('Chnage'), pl:Name(), pl:SteamID(), team.GetName(newt), team.GetName(oldt))
	end)
	:Hook('PlayerHirePlayer', function(self, employer, employee)
		self:PlayerLog({employer, employer}, term('HirePlayer'), employer:Name(), employer:SteamID(), employee:Name(), employee:SteamID())
	end)
	:Hook('PlayerBailPlayer', function(self, pl, targ, cost)
		self:PlayerLog({pl, targ}, term('Bailed'), pl:Name(), pl:SteamID(), targ:Name(), targ:SteamID(), cost)
	end)


-- NLR
ba.logs.AddTerm('EnterNLR', '#(#) вошел в зону NLR с оставшимися # секундами', {
	'Name',
	'SteamID',
})

ba.logs.AddTerm('ExitNLR', '#(#) вышел с зоны NLR с оставшимися # секундами', {
	'Name',
	'SteamID',
})


ba.logs.Create 'NLR'
	:SetColor(Color(255,100,0))
	:Hook('PlayerEnterNLRZone', function(self, pl, time)
		self:PlayerLog(pl, term('EnterNLR'), pl:Name(), pl:SteamID(), math.Round(time, 0))
	end)
	:Hook('PlayerLeaveNLRZone', function(self, pl, time)
		self:PlayerLog(pl, term('ExitNLR'), pl:Name(), pl:SteamID(), math.Round(time, 0))
	end)


-- Raid
ba.logs.AddTerm('PlaceC4', '#(#) поставил С4 на #', {
	'Name',
	'SteamID',
})

ba.logs.AddTerm('PlaceC4On', '#(#) поставил С4 на # принадлежащий #(#)', {
	'Name',
	'SteamID',
})

ba.logs.AddTerm('DropC4', '#(#) выбросил С4', {
	'Name',
	'SteamID',
})

ba.logs.AddTerm('StartKeypadCrack', '#(#) начал взламывать кейпад принадлежащий #(#)', {
	'Name',
	'SteamID',
})

ba.logs.AddTerm('FinishKeypadCrack', '#(#) закончил взламывать кейпад принадлежащий #(#)', {
	'Name',
	'SteamID',
})

ba.logs.AddTerm('StartLockpickOwner', '#(#) начал взламывать дверной замок принадлежащий #(#)', {
	'Name',
	'SteamID',
})

ba.logs.AddTerm('StartLockpickGroup', '#(#) начал взламывать дверной замок принадлежащий #', {
	'Name',
	'SteamID',
})

ba.logs.AddTerm('FinishLockpickOwner', '#(#) закончил взламывать дверной замок принадлежащий #(#)', {
	'Name',
	'SteamID',
})

ba.logs.AddTerm('FinishLockpickGroup', '#(#) закончил взламывать дверной замок принадлежащий #', {
	'Name',
	'SteamID',
})


ba.logs.Create 'Рейды'
	:Hook('PlayerPlaceC4', function(self, pl, ent)
		if IsValid(ent) then
			local owner = ent:CPPIGetOwner() or ent.ItemOwner or ent:DoorGetOwner()
			if IsValid(owner) then
				self:PlayerLog(pl, term('PlaceC4On'), pl:Name(), pl:SteamID(), ent:GetClass(), owner:Name(), owner:SteamID())
			else
				self:PlayerLog(pl, term('PlaceC4'), pl:Name(), pl:SteamID(), ent:GetClass())
			end
		else
			self:PlayerLog(pl, term('DropC4'), pl:Name(), pl:SteamID())
		end
	end)

	:Hook('PlayerStartKeypadCrack', function(self, pl, ent)
		self:PlayerLog(pl, term('StartKeypadCrack'), pl:Name(), pl:SteamID(), ent:CPPIGetOwner():Name(), ent:CPPIGetOwner():SteamID())
	end)
	:Hook('PlayerFinishKeypadCrack', function(self, pl, ent)
		self:PlayerLog(pl, term('FinishKeypadCrack'), pl:Name(), pl:SteamID(), ent:CPPIGetOwner():Name(), ent:CPPIGetOwner():SteamID())
	end)

	:Hook('PlayerStartLockpicking', function(self, pl, ent)
		if IsValid(ent:DoorGetOwner()) then
			self:PlayerLog(pl, term('StartLockpickOwner'), pl:Name(), pl:SteamID(), ent:DoorGetOwner():Name(), ent:DoorGetOwner():SteamID())
		else
			self:PlayerLog(pl, term('StartLockpickGroup'), pl:Name(), pl:SteamID(), (ent:DoorGetGroup() or team.GetName(ent:DoorGetTeam())))
		end
	end)
	:Hook('PlayerFinishLockpicking', function(self, pl, ent)
		if IsValid(ent:DoorGetOwner()) then
			self:PlayerLog(pl, term('FinishLockpickOwner'), pl:Name(), pl:SteamID(), ent:DoorGetOwner():Name(), ent:DoorGetOwner():SteamID())
		else
			self:PlayerLog(pl, term('FinishLockpickGroup'), pl:Name(), pl:SteamID(), (ent:DoorGetGroup() or team.GetName(ent:DoorGetTeam())))
		end
	end)



ba.logs.AddTerm('GiveUsergroup', '#(#) выдал #(#) группу #', {
	'Name',
	'SteamID',
	'Giver Name',
	'Giver SteamID',
	'Group'
})


ba.logs.Create 'Выдача прав'
:Hook('playerUsergroupChanged', function(self, name, steamid, tname, tsteamid, tgroup)
	-- print(tname, tsteamid, name, steamid, tgroup)
	self:PlayerLog(pl, term('GiveUsergroup'),  tname, tsteamid, name, steamid, tgroup)
end)

--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
