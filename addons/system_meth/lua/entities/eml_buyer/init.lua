--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include('shared.lua')

function ENT:Initialize()
	self:SetModel("models/Humans/Group02/male_03.mdl");
	self:SetHullType(HULL_HUMAN);
	self:SetHullSizeNormal();
	self:SetNPCState(NPC_STATE_SCRIPT);
	self:SetSolid(SOLID_BBOX);
	self:SetUseType(SIMPLE_USE);
	self:SetBloodColor(BLOOD_COLOR_RED);
	self:SetCollisionGroup(COLLISION_GROUP_DEBRIS_TRIGGER)
	
	self.Removed = true;

end;

function ENT:AcceptInput(name, activator, caller)	
	if caller:Team() == TEAM_ADMIN then return end
	if (!self.nextUse or CurTime() >= self.nextUse) then
		if (name == "Use" and caller:IsPlayer() and (caller:GetNWInt("player_meth") == 0)) then
			self:EmitSound("vo/npc/male01/gethellout.wav");			
			caller:SendLua("local tab = {Color(1,241,249,255), [[Скупщик мета: ]], Color(255,255,255), [["..table.Random(EML_Meth_Salesman_NoMeth).."]] } chat.AddText(unpack(tab))");
			timer.Simple(0.25, function() self:EmitSound(table.Random(EML_Meth_Salesman_NoMeth_Sound), 100, 100) end);
		elseif (name == "Use") and (caller:IsPlayer()) and (caller:GetNWInt("player_meth") > 0) then
			caller:addMoney(caller:GetNWInt("player_meth"), 'Получил за мет');
			eui.battlepass.AddProgress(caller, 1, caller:GetNWInt("player_meth"))
			eui.battlepass.AddProgress(caller, 29, caller:GetNWInt("player_meth"))
			caller:SendLua("local tab = {Color(1,241,249,255), [[Скупщик мета: ]], Color(255,255,255), [["..table.Random(EML_Meth_Salesman_GotMeth)..", это твои ]], Color(128, 255, 128), [["..caller:GetNWInt("player_meth").."p.]] } chat.AddText(unpack(tab))");
			caller:SetNWInt("player_meth", 0);
			timer.Simple(0.25, function() self:EmitSound(table.Random(EML_Meth_Salesman_GotMeth_Sound), 100, 100) end);
			timer.Simple(2.5, function() self:EmitSound("vo/npc/male01/moan0"..math.random(1, 5)..".wav") end);
		end;
		self.nextUse = CurTime() + 1;
	end;
end;

function ENT:OnTakeDamage(dmginfo)
	return false;
end;

function ENT:OnTakeDamage(dmginfo)
	return false;
end;

hook.Add('InitPostEntity', "EblanNaEmlBuyere", function()
	local npc = ents.Create('eml_buyer')
	npc:SetPos(Vector(3618.937500, -210.375000, -299.312500))
	npc:SetAngles(Angle(0.000, -129.479, 0.000))
	npc:DropToFloor()
	npc:Spawn()
end)

--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
