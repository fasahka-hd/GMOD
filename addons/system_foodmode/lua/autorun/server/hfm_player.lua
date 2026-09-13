--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

local meta = FindMetaTable("Player")

function meta:GetCookedItem(luaname,amount)
	local ITB = HFMGetTable(luaname)
	amount = amount or 1
	self:HFM_GiveItem(luaname,amount)
	DarkRP.notify(self, 0, 5, "Вы забрали " .. ITB:GetPrintName())
end

function meta:HFM_GetHunger()
	return self.HFM_Hunger or 0
end
function meta:HFM_SetHunger(int)
	if IsValid(self) then
		int = math.Clamp( int, 0, HFM_Config.MaxPlayerHunger )
		self.HFM_Hunger = int
		self:FMSyncVar("HFM_Hunger", int)
	end
end

function meta:SetHunger(int, ...)
	int = math.Clamp( int, 0, HFM_Config.MaxPlayerHunger )
	self.HFM_Hunger = int
	self:FMSyncVar("HFM_Hunger", int)
end


function meta:HFM_GetThirsty()
	return self.HFM_Thirsty or 0
end

function meta:HFM_SetThirsty(int)
	int = math.Clamp( int, 0, HFM_Config.MaxPlayerThirsty )
	self.HFM_Thirsty = int
	self:FMSyncVar("HFM_Thirsty", int)
end

local function HFM_TimerLoop(ply, CountLeft, Time, Func)
	if CountLeft <= 0 or !ply or !ply:IsValid() or !ply:Alive() then return end
	Func()
	timer.Simple(Time, function()
		HFM_TimerLoop(ply, CountLeft - 1, Time, Func)
	end)
end

function meta:HFM_AddHealth(amount, time)
	if time < 1 then
		self:SetHealth(math.Clamp( self:Health() + amount, 0, HFM_Config.MaxPlayerHealth ))
		if self:Health() < 1 then self:Kill() end
	else
		local CountLeft = math.abs(amount)
		local a = CountLeft / amount
		local Time = time / CountLeft
		HFM_TimerLoop(self, CountLeft, Time, function()
			if self:Health() < 1 then self:Kill() end
			self:SetHealth(math.Clamp( self:Health() + a, 0, HFM_Config.MaxPlayerHealth ))
		end)
	end
	
end

function meta:HFM_AddHunger(amount, time)
	if amount < 0 then
		v:EmitSound("vo/npc/male01/pain0" .. math.random(1,9) .. ".wav")
	end
	if time < 1 then
		self:HFM_SetHunger(self:HFM_GetHunger() + amount)
	else
		local CountLeft = math.abs(amount)
		local a = CountLeft / amount
		local Time = time / CountLeft
		HFM_TimerLoop(self, CountLeft, Time, function()
			self:HFM_SetHunger(self:HFM_GetHunger() + a)
		end)
	end
end

function meta:HFM_AddThirsty(amount, time)
	if time < 1 then
		self:HFM_SetThirsty(self:HFM_GetThirsty() + amount)
	else
		local CountLeft = math.abs(amount)
		local a = CountLeft / amount
		local Time = time / CountLeft
		HFM_TimerLoop(self, CountLeft, Time, function()
			self:HFM_SetThirsty(self:HFM_GetThirsty() + a)
		end)
	end
end

hook.Add("PlayerInitialSpawn", "HFMSetStartVar", function(ply)
	timer.Simple(1, function()
		if IsValid(ply) then
			ply:HFM_SetHunger(HFM_Config.MaxPlayerHunger * HFM_Config.StartHunger)
			ply:HFM_SetThirsty(HFM_Config.MaxPlayerThirsty * HFM_Config.StartThirsty)
		end
	end)
end)

hook.Add("PlayerDeath", "HFMDeathSound", function( victim )
	victim:EmitSound("foods/dying.wav")
end)

timer.Create("HFM_HungerDrop", 5, 0, function()
	
	for k, v in pairs(player.GetAll()) do
		
		if v.Objora then return end

		if v:Team() == TEAM_ADMIN then return end
		
		if v:Alive() then
			if v:HFM_GetHunger() == HFM_Config.MaxPlayerHunger /*and v:HFM_GetThirsty() == HFM_Config.MaxPlayerThirsty*/ then
				v:HFM_AddHealth(HFM_Config.Healing, HFM_Config.DropTime)
			end
			
-------------------------------------------------------------------------------------------------------------------------------------------------
			v:HFM_SetHunger(v:HFM_GetHunger() - 1)
			
			if v:HFM_GetHunger() <= HFM_Config.HUDDangerMin then
				v:ChatPrint(HFM_Config.LowHungryMessage)
			end
			
			if v:HFM_GetHunger() < 1 then
				v:HFM_AddHealth(-HFM_Config.LowDmgHunger, HFM_Config.DropTime)
			end
			
-------------------------------------------------------------------------------------------------------------------------------------------------
			/*v:HFM_SetThirsty(v:HFM_GetThirsty() - 2)
			
			if v:HFM_GetThirsty() <= HFM_Config.HUDDangerMin then
				v:ChatPrint(HFM_Config.LowThirstyMessage)
			end
			
			if v:HFM_GetThirsty() < 1 then
				v:HFM_AddHealth(-HFM_Config.LowDmgThirsty, HFM_Config.DropTime)
			end*/
		end
	end
end)

--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
