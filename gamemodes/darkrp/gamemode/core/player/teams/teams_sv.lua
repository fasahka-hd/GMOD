--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

rp.AddCommand('model', function(pl, args, text) -- term.Get
	if args then
		pl:SetVar('Model', string.lower(args))
	end
end)
:AddParam(cmd.STRING)
--
-- META
--
util.AddNetworkString('PlayerDisguise')

function PLAYER:Disguise(t, time)
	if not self:Alive() then return end
	self:SetNetVar('DisguiseTeam', t)
	self:SetNetVar('DisguiseTime', CurTime() + time)
	if self:GetNetVar('job') then
		self:SetNetVar('job', nil)
	end
	self:SetModel(team.GetModel(t))
	if (time) then
		rp.Notify(self, NOTIFY_SUCCESS, term.Get('NowDisguisedTime'), math.Round(time/60, 0), rp.teams[t].name)
	else
		rp.Notify(self, NOTIFY_SUCCESS, term.Get('NowDisguised'), rp.teams[t].name)
	end
	hook.Call('playerDisguised', GAMEMODE, self, self:Team(), t)
	if not time then return end
	timer.Create('Disguise_' .. self:UniqueID(), time, 1, function()
		if not IsValid(self) then return end
		self:SetNetVar('DisguiseTeam', nil)
		self:SetNetVar('DisguiseTime', nil)
		if self:GetNetVar('job') then
			self:SetNetVar('job', nil)
		end
		GAMEMODE:PlayerSetModel(self)
		rp.Notify(self, NOTIFY_ERROR, term.Get('DisguiseWorn'))
	end)
end

function PLAYER:UnDisguise()
	timer.Destroy('Disguise_' .. self:UniqueID())

	self:SetNetVar('DisguiseTeam', nil)
	self:SetNetVar('DisguiseTime', nil)
end

function PLAYER:HirePlayer(pl)
	if pl:GetNetVar('job') then
		pl:SetNetVar('job', nil)
	end
	pl:SetNetVar('Employer', self)
	self:SetNetVar('Employee', pl)

	self:TakeMoney(pl:GetHirePrice(), 'Проебал из-за заказа')
	pl:AddMoney(pl:GetHirePrice(), 'Получил с заказа')
	
	hook.Call('PlayerHirePlayer', GAMEMODE, self, pl)
end

hook('OnPlayerChangedTeam', 'Disguise.OnPlayerChangedTeam', function(pl, prevTeam, t)
	pl:SetViewOffset(Vector(0,0,64))
	if prevTeam == TEAM_FERMER then
		local cyberBool = 0
		for z, x in ipairs(ents.FindByClass('base_seed')) do
			if x:CPPIGetOwner() == pl && x.Stay ~= 0 then
				if x.ENTS then
					for _, ent in ipairs(x.ENTS) do
						if ent && ent:IsValid() then ent:Remove() end;
					end
				end
				x:Remove()
				cyberBool = cyberBool + 1
			end
		end
		
		if cyberBool ~= 0 then
			rp.Notify(pl, 1, cyberBool > 1 && "Ваши посевы погибли..." || "Ваше посаженное семя умерло..")
		end
	end
	if pl:IsDisguised() then
		pl:UnDisguise()
	end
	if (pl:GetNetVar('Employer') ~= nil) then
		rp.Notify(pl:GetNetVar('Employer'), NOTIFY_ERROR, term.Get('EmployeeChangedJob'))
		rp.Notify(pl, NOTIFY_ERROR, term.Get('EmployeeChangedJobYou'))
		
		pl:GetNetVar('Employer'):SetNetVar('Employee', nil)
		pl:SetNetVar('Employer', nil)
		
	end
end)

net('PlayerDisguise', function(len, pl)
	local t = net.ReadInt(8)
	if (rp.teams[pl:Team()].candisguise or pl:IsCP()) and not (rp.teams[t].admin == 1) then
		if pl:IsDisguised() or pl.NextDisguise and pl.NextDisguise > CurTime() then 
			rp.Notify(pl, NOTIFY_ERROR, term.Get('DisguiseLimit'), math.ceil((pl.NextDisguise - CurTime())/60))
			return 
		end
		pl:Disguise(t, 300)
		pl.NextDisguise = CurTime() + 60
	end
end)

hook('PlayerDeath', 'teams.PlayerDeath', function(pl)
	if pl:IsDisguised() then
		pl:UnDisguise()
	end

	if (pl:GetNetVar('Employer') ~= nil) then
		rp.Notify(pl:GetNetVar('Employer'), NOTIFY_ERROR, term.Get('EmployeeDied'))
		rp.Notify(pl, NOTIFY_ERROR, term.Get('EmployeeDiedYou'))
		
		pl:GetNetVar('Employer'):SetNetVar('Employee', nil)
		pl:SetNetVar('Employer', nil)
		
	elseif (pl:GetNetVar('Employee') ~= nil) then
		rp.Notify(pl:GetNetVar('Employee'), NOTIFY_ERROR, term.Get('EmployerDied'))
		rp.Notify(pl, NOTIFY_ERROR, term.Get('EmployerDiedYou'))
		
		pl:GetNetVar('Employee'):SetNetVar('Employer', nil)
		pl:SetNetVar('Employee', nil)
	end
end)

hook('PlayerDisconnected', 'employees.PlayerDisconnected', function(pl)
	if (pl:GetNetVar('Employer') ~= nil) then
		rp.Notify(pl:GetNetVar('Employer'), NOTIFY_ERROR, term.Get('EmployeeLeft'))
		
		pl:GetNetVar('Employer'):SetNetVar('Employee', nil)
	elseif (pl:GetNetVar('Employee') ~= nil) then
		rp.Notify(pl:GetNetVar('Employee'), NOTIFY_ERROR, term.Get('EmployerLeft'))
		
		pl:GetNetVar('Employee'):SetNetVar('Employer', nil)
	end
end)

--
-- Commands
--
rp.AddCommand('hire', function(pl, targ, text)
	if not targ then
		targ = pl:GetEyeTrace().Entity
	end

	if not IsValid(targ) or not targ:IsPlayer() then return end

	if not targ:IsHirable() then
		rp.Notify(pl, NOTIFY_ERROR, term.Get('PlayerNotHirable'), targ)
		return
	end

	if pl:IsHirable() then
		rp.Notify(pl, NOTIFY_ERROR, term.Get('EmployeeTriedEmploying'))
		return
	end

	if (pl:GetNetVar('Employee') ~= nil) then
		rp.Notify(pl, NOTIFY_ERROR, term.Get('HasEmployee'))
		return
	end

	if (pl:GetNetVar('Employer') ~= nil) then
		rp.Notify(pl, NOTIFY_ERROR, term.Get('AlreadyEmployed'))
		return
	end

	if (not pl:CanAfford(targ:GetHirePrice())) then
		rp.Notify(pl, NOTIFY_ERROR, term.Get('CannotAffordEmployee'))
		return
	end
	rp.Notify(pl, NOTIFY_GENERIC, term.Get('EmployRequestSents'), targ)
	rp.Notify(targ, NOTIFY_GENERIC, term.Get('EmployRequestSent'), pl)

	GAMEMODE.ques:Create('Хотите работать на ' .. pl:Name() .. ' за ' .. rp.FormatMoney(targ:GetHirePrice()) .. '?', "hire" .. pl:UserID(), targ, 30, function(answer)
		if (tobool(answer) == true) and IsValid(pl) then
			rp.Notify(pl, NOTIFY_SUCCESS, term.Get('YouHired'), targ, rp.FormatMoney(targ:GetHirePrice()))
			rp.Notify(targ, NOTIFY_SUCCESS, term.Get('YouAreHired'), pl, rp.FormatMoney(targ:GetHirePrice()))
			pl:HirePlayer(targ)
		else
			rp.Notify(pl, NOTIFY_ERROR, term.Get('EmployRequestDen'), targ)
		end
	end)
end)

local function PlayerFire(pl, targ, text)
	if not (targ:GetNetVar('Employer') == pl) then return end

	rp.Notify(pl, NOTIFY_SUCCESS, 'Вы уволили '..targ:Name())
	rp.Notify(targ, NOTIFY_ERROR, 'Вас уволил '..pl:Name())

	targ:SetNetVar('Employer', nil)
	pl:SetNetVar('Employee', nil)
end
rp.AddCommand('fire', PlayerFire)
:AddParam(cmd.PLAYER_ENTITY)

rp.AddCommand('quitjob', function(pl, targ, text)
	if not IsValid(pl:GetNetVar('Employer')) then 
		return rp.Notify(pl, NOTIFY_ERROR, 'Вы еще не были наняты на работу!')
	end

	rp.Notify(pl, NOTIFY_SUCCESS, term.Get('EmployeeQuitYou'), pl:GetNetVar('Employer'))
	rp.Notify(pl:GetNetVar('Employer'), NOTIFY_ERROR, pl:Name() .. ' перестал на вас работать!')

	pl:GetNetVar('Employer'):SetNetVar('Employee', nil)
	pl:SetNetVar('Employer', nil)
end)

rp.AddCommand('sethireprice', function(pl, num)
	if not tonumber(num) and num then
		rp.Notify(pl, NOTIFY_ERROR, term.Get('InvalidArg'))
		return
	end
	
	if not pl:IsHirable() then
		rp.Notify(pl, NOTIFY_ERROR, "Вы не можете быть наняты!")
		return
	end
	
	if tonumber(num) > 50000 then
		rp.Notify(pl, NOTIFY_ERROR, "Нельзя поставить цену больше $50.000!")
		return
	end
	
	if tonumber(num) < 1000 then
		rp.Notify(pl, NOTIFY_ERROR, "Нельзя поставить цену меньше $1000!")
		return
	end
	
	pl:SetNetVar('EmployeePrice', num)
	rp.Notify(pl, NOTIFY_SUCCESS, "Вы поставили свою цену на: #", rp.FormatMoney(pl:GetHirePrice()))
end)
:AddParam(cmd.NUMBER)

--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
