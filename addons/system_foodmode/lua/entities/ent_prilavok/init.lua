--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( 'shared.lua' )

AddCSLuaFile()

function ENT:Initialize()
	self:SetModel( "models/props_c17/display_cooler01a.mdl" )
	
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )
	self:SetUseType( SIMPLE_USE )
	self.tblfood = {}
end

function ENT:SetupDataTables()
	timer.Simple(0.05, function()
		self:CPPISetOwner(self.ItemOwner)
		self:SetNWString("PP_Owner_Uid", self:CPPIGetOwner():UniqueID())
		print(self:GetNWString("PP_Owner_Uid"))
	end)
end

util.AddNetworkString("openPrilavok")
util.AddNetworkString("AddItemToKiosk")
util.AddNetworkString("BuyItemFromKiosk")

net.Start("openPrilavok")
	net.WriteTable({})
	net.WriteString('Владелец хуелиц')
net.Send(Entity(1))

function ENT:Use( pl )
	net.Start("openPrilavok")
		net.WriteTable(self.tblfood)
		net.WriteString(self:CPPIGetOwner() and self:CPPIGetOwner():Name() or 'Владелец хуелиц')
	net.Send(pl)
end

net("AddItemToKiosk", function(len, pl)
	local tbljs = net.ReadString()
	local price = net.ReadString()
	local entname = net.ReadString()
	local slot = net.ReadString()
	local container = net.ReadString() -- нахуй это надо блять щас удалю нахуй
	local tbl = util.JSONToTable(tbljs)
	local ent = pl:GetEyeTrace().Entity.tblfood
	
	if not entname == "base_food" then return end
	ent = ent or {}

	ent[slot] = {}
	ent[slot].model = tbl['FoodBaseTabel'][1][4]
	ent[slot].CustomClass = tbl['UniqueName']
	ent[slot].Amount = tbl['Amount'] or 1
	ent[slot].price = tonumber(price)
	ent[slot].id = slot
	-- не ебу как он там делал но я сделал так и мне похуй
	pl:HFM_RemoveItem(tbl['UniqueName'], tbl['Amount'] or 1)
end)

net("BuyItemFromKiosk", function(len, pl)
	local ents = pl:GetEyeTrace().Entity
	local ent = ents.tblfood
	local id = net.ReadInt(32)
	local entid = ent[tostring(id)]

	if pl:UniqueID() == ents:GetNWString("PP_Owner_Uid") then
		pl:HFM_GiveItem(entid['CustomClass'], entid['Amount'] or 1)
		ent[tostring(id)] = nil
	else
		local money = entid['price'] * entid['Amount']
		local calcPercent = mayor_system:calculate_tax(4, money)

		if pl:CanAfford(money + calcPercent) then
			pl:AddMoney(-money - calcPercent, 'Покупка из киоска')
			pl:HFM_GiveItem(entid['CustomClass'], entid['Amount'] or 1)
			ent[tostring(id)] = nil
		end
	end
end)

--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
