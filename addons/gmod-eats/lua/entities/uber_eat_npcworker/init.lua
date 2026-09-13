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

function ENT:AcceptInput( event, a, p )

	if( event == "Use" && p:IsPlayer() && self.nextClick < CurTime() )  then
	
		self.nextClick = CurTime() + 2
		
		if GmodEats.Config.LimitedToJob and not table.HasValue(GmodEats.Config.Jobs, p:Team()) then return end
		
		if p:HasWeapon("uber_eat_bag_weap") then
			net.Start("GmodEats.NPCMenu")
				net.WriteEntity(self)
				net.WriteInt(2, 32)
			net.Send(p)
		else
			net.Start("GmodEats.NPCMenu")
				net.WriteEntity(self)
				net.WriteInt(1, 32)
			net.Send(p)
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
