--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

function ENT:Initialize()
	
	self:SetModel( self.Model )
	self:StartActivity(ACT_IDLE)
	
	self.nextClick = 0
	
end

local function PlayEffect(pos, ent)
	timer.Simple(0.1, function()
		
		if not IsValid( ent ) then return end
	
		ent:Remove()
		local effectdata = EffectData()
		effectdata:SetOrigin( pos+Vector(0,0,0) )
		effectdata:SetNormal( Vector(0,0,1) )
		util.Effect( "ManhackSparks", effectdata )
	end)
end

function ENT:AcceptInput( event, a, p )
	
	if !( event == "Use" && p:IsPlayer() && self.nextClick < CurTime() )  then return end 	
	
	if GmodEats.Config.LimitedToJob and not table.HasValue(GmodEats.Config.Jobs, p:Team()) then return end
	
	if not p:HasWeapon("uber_eat_bag_weap") then return end
	
	self.nextClick = CurTime() + 2
	p.ListMissions = p.ListMissions or {}
	
	if self.Client then
		self.Id = self.Id  or -1
		for k,v in pairs( p.ListMissions ) do 
				
			if not v.Accepted then continue end
			
			if self.Id == v.Client and ( p:GetNWInt("Command1") == self.Id or p:GetNWInt("Command2") == self.Id or p:GetNWInt("Command3") == self.Id ) then
			
				local dist = GmodEats.Config.CookPos[v.Cook].pos:Distance(GmodEats.Config.ClientPos[v.Client].pos)
				local price = math.Round(dist/30*GmodEats.Config.MoneyPerMeters)
				
				p:AddMoney(price, 'Доставщик еды донес еду')
				eui.battlepass.AddProgress(p, 3)
				eui.battlepass.AddProgress(p, 36)
				self:EmitSound("uber_eats/money.wav")
				GmodEats.Config.ClientPos[v.Client].NotFree = false
				p.ListMissions[k] = nil
				
				p:UE_Notif(GmodEats.Config.Lang["You've earned"][GmodEats.Config.Language].." $"..price) 
				
				if p:GetNWInt("Command1") == v.Client then	
					p:SetNWInt("Command1",0)
				elseif p:GetNWInt("Command2") == v.Client then	
					p:SetNWInt("Command2",0)
				elseif p:GetNWInt("Command3") == v.Client then	
					p:SetNWInt("Command3",0)
				end
				
				net.Start("GmodEats.NetworkMission")
					net.WriteTable( p.ListMissions )
				net.Send( p )
				
				p.HasDelivery = false
				PlayEffect(self:GetPos(), self)
			end
		end

		return 
	end

	for k,v in pairs( p.ListMissions ) do
		if not v.Accepted then
			continue 
		end
		
		if p.HasDelivery then
			p:UE_Notif(GmodEats.Config.Lang["You are already delivering food. Go to the drop-off!"][GmodEats.Config.Language])
			break 
		end
	
		local cookent = GmodEats.Config.CookPos[v.Cook].Entity

		if cookent == self then
			if p:GetNWInt("Command1") == 0 then	
				p:SetNWInt("Command1",v.Client)
			elseif p:GetNWInt("Command2") == 0 then	
				p:SetNWInt("Command2",v.Client)
			elseif p:GetNWInt("Command3") == 0 then	
				p:SetNWInt("Command3",v.Client)
			else
				return
			end
			
			p:UE_Notif(GmodEats.Config.Lang["Here is the command!"][GmodEats.Config.Language])
			
			local npc = ents.Create("uber_eat_npc")
			npc.Client = true
			npc:SetClient(true)
			npc.Id = v.Client
			npc:SetPos(GmodEats.Config.ClientPos[v.Client].pos)
			npc:SetAngles(GmodEats.Config.ClientPos[v.Client].ang)
			npc.Model = "models/humans/group01/male_0"..math.random(1,8)..".mdl"
			npc:Spawn()
			GmodEats.Config.ClientPos[v.Client].Entity = npc
			
			p.HasDelivery = true
		end
		self:EmitSound("vo/coast/odessa/nlo_cub_hello.wav")
	end
end

function ENT:OnInjured( dmg )
	local damage = dmg:GetDamage( 0 )
	dmg:SetDamage( 0 )
	self:SetHealth( damage + 1 )
end

function ENT:RunBehaviour()
	while (true) do
		
		local anim = self.ShouldAnim or false
		
		if anim then
		
			self:PlaySequenceAndWait("Heal", 1)
			self.ShouldAnim = false
			
			timer.Simple(0.5, function()
				if IsValid( self ) then
					self:StartActivity(ACT_IDLE)
				end
			end)
			
		end
		
		coroutine.yield()
	end
end


--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
