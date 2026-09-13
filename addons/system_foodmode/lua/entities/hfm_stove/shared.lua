--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

ENT.Base = "base_anim"
ENT.Type = "anim"
ENT.RemoveOnJobChange = true

if SERVER then
	util.AddNetworkString( "HFM_StoveMenu_S2C" )
	util.AddNetworkString( "HFM_DoCook_C2S" )
	util.AddNetworkString( "HFM_GetFood_C2S" )
	
	function ENT:OpenMenu(ply)
		local Data2Send = {}
		Data2Send.Ent = self
		
		local PotData = {}
		for k = 1, 6 do
			if self.Pots[k] then
				PotData[k] = {}
				local SP = self.Pots[k]
				local ITB = HFMGetTable(SP.luaname)
				PotData[k].LuaName = SP.luaname
				PotData[k].TimeSpent = CurTime() - SP.CreatedTime
				PotData[k].TimeRequired = ITB.CookingTime
			end
		end
		
		Data2Send.Pots = PotData
		net.Start( "HFM_StoveMenu_S2C" )
			net.WriteTable(Data2Send)
		net.Send(ply)
	end
	
	net.Receive( "HFM_DoCook_C2S", function( len,ply )
		local TB = net.ReadTable()
		local luaname = TB.luaname
		local stove = TB.stove
		local slot = TB.slot
		local FTB = HFMGetTable(luaname)
			
		if !ply:CanCookFood(luaname) then return end
		
		for k,v in pairs(FTB.Ingredients or {}) do
			ply:HFM_RemoveItem(k,v)
		end
	
		if stove and stove:IsValid() and stove:GetClass() == "hfm_stove" then
			stove:DoCook(luaname,slot,ply)
		end
	end)
	
	net.Receive( "HFM_GetFood_C2S", function( len,ply )
		local TB = net.ReadTable()
		local Ent = TB.Ent
		local Slot = TB.Slot
		
		if Ent and Ent:IsValid() and Ent:GetClass() == "hfm_stove" and Ent:GetPos():Distance(ply:GetPos()) < 150 then
			local PD = Ent.Pots[Slot]
			if !PD then return end
			local luaname = PD.luaname
			local ITB = HFMGetTable(luaname)
			local DeltaTime = CurTime() - PD.CreatedTime
			if DeltaTime >= ITB.CookingTime then
				if PD:GetDTBool(0) then
					PD:Remove()
					Ent.Pots[Slot] = nil
					Ent:OpenMenu(ply)
					ply:ChatPrint("Ууупс. Еда сгорела.")
					return
				end
				
				PD:Remove()
				Ent.Pots[Slot] = nil
				Ent:OpenMenu(ply)
				ply:GetCookedItem(luaname,1)
			end
		end
		
	end)
	
else
	net.Receive( "HFM_StoveMenu_S2C", function( len,ply )
		local TB = net.ReadTable()
		HFMOpenStoveMenu(TB)
	end)
	function HFMDoCook(luaname,slot,stove)
		local TB2Send = {}
		TB2Send.luaname = luaname
		TB2Send.stove = stove
		TB2Send.slot = slot
		net.Start( "HFM_DoCook_C2S" )
			net.WriteTable(TB2Send)
		net.SendToServer()
	end
	function HFMGetItem(Ent,Slot)
		net.Start( "HFM_GetFood_C2S" )
			net.WriteTable({Ent=Ent,Slot=Slot})
		net.SendToServer()
	end
end

HFMPotPositions = {}
HFMPotPositions[1] = Vector(-7,	-16,	55)
HFMPotPositions[2] = Vector(-7,	-3,		55)
HFMPotPositions[3] = Vector(-7,	10,		55)
HFMPotPositions[4] = Vector(6.5,	-16,	55)
HFMPotPositions[5] = Vector(6.5,	-3,		55)
HFMPotPositions[6] = Vector(6.5,	10,		55)

--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
