--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

ENT.Type = "anim"
ENT.Base = "base_entity"
ENT.PrintName = "Derma Printer"
ENT.Author = "phoenix"
ENT.Spawnable = true
ENT.AdminSpawnable = true 
ENT.Category = "PhoenixPrinters"
ENT.IsMoneyPrinter = true
ENT.CanCarry = true
ENT.RemoveOnJobChange = true
ENT.PressKeyText 			= 'Открыть меню принтера'
function ENT:SetupDataTables()
	self:NetworkVar("Int",1,"Money")
	self:NetworkVar("Float",2,"Charge")
	self:NetworkVar("Entity",3,"owning_ent")
	self:NetworkVar("Float",4,"TempRate")
	self:NetworkVar("Bool",5,"toggle")
	self:NetworkVar("Int",6,"Upgradelvl")
	self:NetworkVar("Int",7,"Coolinglvl")
	self:NetworkVar("Int",8,"lvl2price")
	self:NetworkVar("Int",9,"lvl3price")
	self:NetworkVar("Int",10,"lvl4price")
	self:NetworkVar("Float",11,"PTemp")
	self:NetworkVar("Bool",12,"Destroyed")
	self:NetworkVar("Int",13,"Rechargeprice")
	self:NetworkVar("Int",14,"Cooling1price")
	self:NetworkVar("Int",15,"Cooling2price")
	self:NetworkVar("Int",16,"Cooling3price")
	--color rgb--
	self:NetworkVar("Int",17,"MainColorR")
	self:NetworkVar("Int",18,"MainColorG")
	self:NetworkVar("Int",19,"MainColorB")
	--color rgb--
	self:NetworkVar("Int",20,"BgColorR")
	self:NetworkVar("Int",21,"BgColorG")
	self:NetworkVar("Int",22,"BgColorB")
	--activator--
	self:NetworkVar("Entity",23,"Activator")
end

--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
