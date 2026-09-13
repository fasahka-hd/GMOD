--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()
	self:SetModel("models/props_lab/clipboard.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetUseType(SIMPLE_USE)

	self:PhysWake()
end

function ENT:Use(activator, caller)
	local owner = self:Getowning_ent()
	local recipient = self:Getrecipient()
	local amount = self:Getamount() or 0

	if (IsValid(activator) and IsValid(recipient)) and activator == recipient then
		local ownername = (IsValid(owner) and owner:Nick()) or "Disconnected player"
		rp.Notify(activator, NOTIFY_SUCCESS, term.Get('ChequeFound'), rp.FormatMoney(amount), (IsValid(owner) and owner or 'Disconnected player'))
		activator:AddMoney(amount, 'Получил с чека ' .. owner:SteamID64())
		
		hook.Call('PlayerPickupRPCheck', GAMEMODE, activator, (IsValid(owner) and owner or {NameID=function()return'Disconnected player'end,Name=function()return'N/A'end,SteamID=function()return'N/A'end}), amount, activator:GetMoney())
		self:Remove()
	elseif (IsValid(owner) and IsValid(recipient)) and owner ~= activator then
		rp.Notify(activator, NOTIFY_GENERIC, term.Get('ChequeMadeTo'), recipient)
	elseif IsValid(owner) and owner == activator then
		rp.Notify(activator, NOTIFY_SUCCESS, term.Get('ChequeTorn'))
		owner:AddMoney(self:Getamount(), 'Вернул деньги с своего чека') -- return the money on the cheque to the owner.
		
		hook.Call('PlayerVoidedRPCheck', GAMEMODE, activator, recipient, amount, activator:GetMoney())
		self:Remove()
	elseif not IsValid(recipient) then 
		self:Remove()
	end
end

function ENT:Touch(ent)
	if ent:GetClass() ~= 'spawned_cheque' or self.hasMerged or ent.hasMerged then return end
	if ent:Getowning_ent() ~= self:Getowning_ent() then return end
	if ent:Getrecipient() ~= self:Getrecipient() then return end

	ent.hasMerged = true
	
	self:Setamount(self:Getamount() + ent:Getamount())
	ent:Remove()
end

--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
