--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

AddCSLuaFile('cl_init.lua')
AddCSLuaFile('shared.lua')

include('shared.lua')

util.AddNetworkString('openItemShop')
util.AddNetworkString("BuyItemFromShop")

function ENT:Initialize()
	self:SetModel('models/Humans/Group01/Female_02.mdl')

	self:SetHullType(HULL_HUMAN)
	self:SetHullSizeNormal()
	self:SetNPCState(NPC_STATE_SCRIPT)
	self:SetSolid(SOLID_BBOX)
	self:CapabilitiesAdd(CAP_ANIMATEDFACE)
	self:SetUseType(SIMPLE_USE)
	self:SetCollisionGroup(COLLISION_GROUP_DEBRIS_TRIGGER )
	self:SetMaxYawSpeed(90)
end
local cc = {
	[1] = {TEAM_COOK},
	[2] = {TEAM_FERMER}
}

-- for z, x in ipairs(ents.FindInSphere(Entity(2):GetPos(), 100)) do
-- 	if x:GetClass() == 'base_seed' then
-- 		x:Remove()
-- 	end
-- end

function ENT:AcceptInput(input, activator, caller)
	-- print(TEAM_COOK, activator:Team())
	if (input == 'Use') and activator:IsPlayer() and table.HasValue(cc[self.id], activator:Team()) then
		net.Start('openItemShop')
			net.WriteInt(self.id, 15)
		net.Send(activator)
	end
end

local function LOAD()
	timer.Simple(1.5,function()
	for k, v in ipairs(rp.cfg.ShopItems) do
		-- print(k)
		local npc = ents.Create('npc_shop')
		npc:SetPos(v.pos)
		npc:SetAngles(v.ang)
		npc:SetNWString("ShopName", v.name)
		npc.CustomCheck = v.CustomCheck
		npc.id = k
		npc:Spawn()
	end
	end)
end

hook.Add("InitPostEntity", "LoadEnt", LOAD)
hook.Add("PostCleanupMap", "LoadEnt", LOAD)

-- local meta = debug.getregistry().Player
local meta = FindMetaTable("Player")

function meta:HFM_GiveItemS(luaname, amount)
	local item = GenerateSeedItem( luaname, amount )
	self.Inventory:AddItem( item, false )
	self:EmitSound( "items/itempickup.wav" )
end


net("BuyItemFromShop", function(len, ply)
    local ids = net.ReadInt(15)
    local name = net.ReadString()
    local tbl = rp.cfg.ShopItems[ids].items[name]
    if tbl.type == "food" then
        if ply:CanAfford(tbl.Cost) then
            ply:HFM_GiveItem( tbl.ent )
            ply:AddMoney(-tbl.Cost, 'Покупка ингридиента' .. tbl.ent)
            DarkRP.notify(ply, 3, 4, "Вы купили ингридиент за $"..tbl.Cost.."")
        end
    elseif tbl.type == "seed" then
        if ply:CanAfford(tbl.Cost) then
            ply:HFM_GiveItemS( tbl.ent )
            ply:AddMoney(-tbl.Cost, 'Покупка семена' .. tbl.ent)
            DarkRP.notify(ply, 3, 4, "Вы купили семя за $"..tbl.Cost.."")
        end
    end
end)

-- Entity(1):HFM_GiveItemS( 'potato' )

--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
