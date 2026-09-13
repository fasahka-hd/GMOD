--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

function PLAYER:AddHealth(amt)
	self:SetHealth(self:Health() + amt)
end

function PLAYER:GiveAmmos(amount, show)
	for k, v in ipairs(rp.ammoTypes) do
		self:GiveAmmo(amount, v.ammoType, show)
	end
end
---------------------------------------------------------
-- Variables
---------------------------------------------------------
local previousname = "N/A"
local newname= "N/A"

---------------------------------------------------------
-- RP names
---------------------------------------------------------

local function RPName(ply, args)
	if ply.NextNameChange and ply.NextNameChange > CurTime() then
		rp.Notify(ply, NOTIFY_ERROR, term.Get('PleaseWaitX'), math.ceil(ply.NextNameChange - CurTime()))
		return ""
	end

	local len = string.len(args)
	local low = string.lower(args)

	if len > 20 then
		rp.Notify(ply, NOTIFY_ERROR, term.Get('RPNameLong'), 21)
		return ""
	elseif len < 3 then
		rp.Notify(ply, NOTIFY_ERROR, term.Get('RPNameShort'), 2)
		return ""
	end

	local canChangeName = hook.Call("CanChangeRPName", GAMEMODE, ply, low)
	if canChangeName == false then
		rp.Notify(ply, NOTIFY_ERROR, term.Get('CannotRPName'))
		return ""
	end

	-- local allowed = {'1', '2', '3', '4', '5', '6', '7', '8', '9', '0',
	-- 'q', 'w', 'e', 'r', 't', 'y', 'u', 'i', 'o', 'p',
	-- 'a', 's', 'd', 'f', 'g', 'h', 'j', 'k', 'l',
	-- 'z', 'x', 'c', 'v', 'b', 'n', 'm', ' ',
	-- 'й', 'ц', 'у', 'к', 'е', 'н', 'г', 'ш', 'щ', 'з', 'х', 'ъ',
	-- 'ф', 'ы', 'а', 'п', 'р', 'о', 'л', 'д', 'ж', 'э',
	-- 'я', 'ч', 'с', 'м', 'и', 'т', 'ь', 'б', 'ю',
	-- '(', ')', '[', ']', '!', '@', '#', '$', '%', '^', '&', '*', '-', '_', '=', '+', '|', '\\'}

	-- for k in string.gmatch(args, ".") do
	-- 	if not table.HasValue(allowed, string.lower(k)) then
	-- 		rp.Notify(ply, NOTIFY_ERROR, term.Get('RPNameUnallowed'), k)
	-- 		return ""
	-- 	end
	-- end
	hook.Call("playerChangedRPName", GAMEMODE, ply, args)
	ply:SetRPName(args)
	ply.NextNameChange = CurTime() + 20

	return ""
end
rp.AddCommand('rpname', RPName)
:AddParam(cmd.STRING)
:AddAlias 'name'
:AddAlias 'nick'
rp.AddCommand("randomname", function(ply)
	if ply.NextNameChange and ply.NextNameChange > CurTime() then
		rp.Notify(ply, NOTIFY_ERROR, term.Get('PleaseWaitX'), math.ceil(ply.NextNameChange - CurTime()))
		return ""
	end

	local name = rp.names.Random()
	hook.Call("playerChangedRPName", GAMEMODE, ply, name)
	ply:SetRPName(name)
	ply.NextNameChange = CurTime() + 20
end)

function PLAYER:SetRPName(name, firstRun)
	name = string.Trim(name)
	name = string.sub(name, 1, 20)

	-- Make sure nobody on this server already has this RP name
	local lowername = string.lower(tostring(name))
	rp.data.GetNameCount(name, function(taken)
		if string.len(lowername) < 2 and not firstrun then return end
		-- If we found that this name exists for another player
		if taken then
			if firstRun then
				-- If we just connected and another player happens to be using our steam name as their RP name
				-- Put a 1 after our steam name
				rp.Notify(self, NOTIFY_ERROR, term.Get('SteamRPNameTaken'))
			else
				rp.Notify(self, NOTIFY_ERROR, term.Get('RPNameTaken'))
				return ""
			end
		else	
			rp.NotifyAll(NOTIFY_GENERIC, term.Get('ChangeName'), self:SteamName(), name)
			rp.data.SetName(self, name)
		end
	end)
end

hook("PlayerDataLoaded", "RP:RestorePlayerData", function(pl, data)
	pl:NewData()
end)

---------------------------------------------------------
-- Admin/automatic stuff
---------------------------------------------------------
function PLAYER:ChangeAllowed(t)
	if not self.bannedfrom then return true end
	if self.bannedfrom[t] == 1 then return false else return true end
end

function PLAYER:TeamUnBan(Team)
	if not IsValid(self) then return end
	if not self.bannedfrom then self.bannedfrom = {} end
	self.bannedfrom[Team] = 0
end

function PLAYER:TeamBan(t, time)
	if not self.bannedfrom then self.bannedfrom = {} end
	t = t or self:Team()
	self.bannedfrom[t] = 1

	if time == 0 then return end
	timer.Simple(time or 180, function()
		if not IsValid(self) then return end
		self:TeamUnBan(t)
	end)
end

function PLAYER:NewData()
	if not IsValid(self) then return end

	self:SetTeam(1)

	self:GetTable().LastVoteCop = CurTime() - 61
end

---------------------------------------------------------
-- Teams/jobs
---------------------------------------------------------
function PLAYER:ChangeTeam(t, force)
	local prevTeam = self:Team()

	if self:IsArrested() and not force then
		self:Notify(NOTIFY_ERROR, term.Get('CannotChangeJob'), 'arrested')
		return false
	end

	if (self:GetNWBool('isHandcuffed') == true) and not force then
		self:Notify(NOTIFY_ERROR, term.Get('CannotChangeJob'), 'cuffed')
		return false
	end

	if self:IsFrozen() and not force then
		self:Notify(NOTIFY_ERROR, term.Get('CannotChangeJob'), 'frozen')
		return false
	end

	if (not self:Alive()) and not force then
		self:Notify(NOTIFY_ERROR, term.Get('CannotChangeJob'), 'dead')
		return false
	end

	if self:IsWanted() and not force then
		self:Notify(NOTIFY_ERROR, term.Get('CannotChangeJob'), 'wanted')
		return false
	end

	if t ~= rp.DefaultTeam and not self:ChangeAllowed(t) and not force then
		rp.Notify(self, NOTIFY_ERROR, term.Get('BannedFromJob'))
		return false
	end

	if self.LastJob and rp.cfg.ChangeJobTime - (CurTime() - self.LastJob) >= 0 and not force then
		self:Notify(NOTIFY_ERROR, term.Get('NeedToWait'), math.ceil(rp.cfg.ChangeJobTime - (CurTime() - self.LastJob)))
		return false
	end

	if self.IsBeingDemoted then
		self:TeamBan()
		self.IsBeingDemoted = false
		self:ChangeTeam(1, true)
		GAMEMODE.vote.DestroyVotesWithEnt(self)
		rp.Notify(self, NOTIFY_ERROR, term.Get('EscapeDemotion'))

		return false
	end

	if prevTeam == t then
		rp.Notify(self, NOTIFY_ERROR, term.Get('AlreadyThisJob'))
		return false
	end

	local TEAM = rp.teams[t]
	if not TEAM then return false end

	if TEAM.vip and (not self:IsVIP()) then
		rp.Notify(self, NOTIFY_ERROR, term.Get('NeedVIP'))
		return 
	end

	if TEAM.playtime and (self:GetPlayTime() < TEAM.playtime) and (not self:IsVIP()) then
		rp.Notify(self, NOTIFY_ERROR, term.Get('JobNeedsPlaytime'), TEAM.playtime/3600)
		return false
	end

	if TEAM.CannotOwnDoors then
		if (self:GetVar('doorCount') or 0) <= 0 then

		else
			local count = self:GetVar('doorCount')
			local amt = (count * rp.doors.GetUniformPrice(self))
			self:DoorUnOwnAll()
			self:AddMoney(amt, 'Купил дверь')
			rp.Notify(self, NOTIFY_SUCCESS, term.Get('DoorsSold'), count, rp.FormatMoney(amt))
		end
	end

    if type(TEAM.NeedChange) == "number" and self:Team() ~= TEAM.NeedChange then
        rp.Notify(self, 1, 'Вы должны быть ' .. team.GetName(TEAM.NeedChange) .. ' чтобы стать ' .. TEAM.name)
        return ""
    end

	if TEAM.customCheck and not TEAM.customCheck(self) then
		rp.Notify(self, NOTIFY_ERROR, term.Get(TEAM.CustomCheckFailMsg) or TEAM.CustomCheckFailMsg)
		return false
	end

	if not self:GetVar("Priv"..TEAM.command) and not force then
		local max = TEAM.max
		if max ~= 0 and -- No limit
		(max >= 1 and team.NumPlayers(t) >= max or -- absolute maximum
		max < 1 and (team.NumPlayers(t) + 1) / #player.GetAll() > max) then -- fractional limit (in percentages)
			rp.Notify(self, NOTIFY_ERROR, term.Get('JobLimit'))
			return false
		end
	end

	if TEAM.PlayerChangeTeam then
		local val = TEAM.PlayerChangeTeam(self, prevTeam, t)
		if val ~= nil then
			return val
		end
	end

	local hookValue = hook.Call("playerCanChangeTeam", nil, self, t, force)
	if hookValue == false then return false end

	local isMayor = rp.teams[prevTeam] and rp.teams[prevTeam].mayor
	if isMayor then 
		nw.SetGlobal("lockdown", false)
		if nw.GetGlobal('lockdown') then
			GAMEMODE:UnLockdown(self)
		end
		-- rp.resetLaws()
		rp.Laws = table.Copy(rp.StartLaws)
        nw.SetGlobal('TheLaws_Tbl', rp.Laws)
		nw.SetGlobal("lockdown", false)
	end

	rp.NotifyAll(NOTIFY_GENERIC, term.Get('ChangeJob'), self:Name(), TEAM.name)

	if self:GetNetVar("HasGunlicense") then
		self:SetNetVar("HasGunlicense", nil)
	end

	self.PlayerModel = nil

	self.LastJob = CurTime()

	for k, v in ipairs(ents.GetAll()) do	
		if (v.ItemOwner == self) and v.RemoveOnJobChange and !rp.EntityMap[v:GetClass()].allowed[t] then
			v:Remove()
		end
	end
	
	if (self:GetNetVar('job') ~= nil) then
		self:SetNetVar('job', nil) 
	end
	
	self:SetVar('lastpayday', CurTime() + 300, false, false)
	self:SetTeam(t)
	hook.Call("OnPlayerChangedTeam", GAMEMODE, self, prevTeam, t)
	if self:InVehicle() then self:ExitVehicle() end
	if self:GetNWBool("ZombieTytDa",false) == true or self:GetNWBool("BossTytDa",false) == true or self:GetNWBool("NemTytDa",false) == true or self:GetNWBool("C8TytDa") == true then
		self:SetNWBool("ZombieTytDa",false)
		self:SetNWBool("BossTytDa",false)
		self:SetNWBool("NemTytDa", false)
		self:SetNWBool("C8TytDa",false)
	end
	self:SetModelScale(1)

	
	self:StripWeapons()
	self:Spawn()
	
	return true
end

hook('PlayerThink', function(pl)
	if (pl:GetVar('lastpayday') ~= nil) and (pl:GetVar('lastpayday') < CurTime()) then
		pl:PayDay()
	end
end)

---------------------------------------------------------
-- Money
---------------------------------------------------------
function PLAYER:PayDay()
	if not IsValid(self) then return end
	if not self:IsArrested() then
		local amount = self:GetSalary() or 0
		local amount_event = hook.Call("PlayerPayDay", GAMEMODE, self, amount)
		if amount_event then amount = amount_event end
		if amount == 0 then
			rp.Notify(self, NOTIFY_ERROR, term.Get('PayDayUnemployed'))
		else
			local tax = (self:GetVar('doorCount') or 0) * self:Wealth(rp.cfg.DoorTaxMin, rp.cfg.DoorTaxMax) * 10
			tax = mayor_system:calculate_tax(2, tax)

			if self:CanAfford(tax) then

				self:AddMoney(amount - tax, 'Получил за пэйдей')

				if (tax > 0) then
					rp.Notify(self, NOTIFY_SUCCESS, term.Get('PaydayTax'), amount, tax)
				else
					rp.Notify(self, NOTIFY_SUCCESS, term.Get('Payday'), amount)
				end
			else
				rp.Notify(self, NOTIFY_ERROR, term.Get('PayDayCanAfford'))

				self:DoorUnOwnAll()
			end
		end
	else
		rp.Notify(self, NOTIFY_ERROR, term.Get('PayDayMissed'))
	end
	self:SetVar('lastpayday', CurTime() + 300, false, false)
end

---------------------------------------------------------
-- Items
---------------------------------------------------------
function PLAYER:DropDRPWeapon(weapon)
	local ammo = self:GetAmmoCount(weapon:GetPrimaryAmmoType())
	self:DropWeapon(weapon) -- Drop it so the model isn't the viewmodel

	local ent = ents.Create("spawned_weapon")
	local model = (weapon:GetModel() == "models/weapons/v_physcannon.mdl" and "models/weapons/w_physics.mdl") or weapon:GetModel()

	ent.ShareGravgun = true
	ent:SetPos(self:GetShootPos() + self:GetAimVector() * 30)
	ent:SetModel(model)
	ent:SetSkin(weapon:GetSkin())
	ent.weaponclass = weapon:GetClass()
	ent.nodupe = true
	ent.clip1 = weapon:Clip1()
	ent.clip2 = weapon:Clip2()
	ent.ammoadd = ammo

	self:RemoveAmmo(ammo, weapon:GetPrimaryAmmoType())

	ent:Spawn()

	weapon:Remove()
end

timer.Create('PlayerThink', 5, 0, function()
	local pls = player.GetAll()
	for i = 1, #pls do
		if IsValid(pls[i]) then
			hook.Call('PlayerThink', GAMEMODE, pls[i])
		end
	end
end)

--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
