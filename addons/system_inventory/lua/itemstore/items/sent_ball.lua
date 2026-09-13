--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

--[[
addons/rp_itemstore/lua/itemstore/items/sent_ball.lua
--]]
ITEM.Name = "Mining Base"
ITEM.Model = "models/error.mdl"
ITEM.Base = "base_entity"
 
function ITEM:Initialize()
 
end
 
function ITEM:GetName()
    return "Erz - "..self:GetData("OreType")
end
 
function ITEM:GetDescription()
    return ""
end
 
function ITEM:CanMerge(item)
    if item:GetClass() != self:GetClass() then return false end
    if self.MaxStack < self:GetAmount() + item:GetAmount() then return false end
    return true
end
 
function ITEM:Merge(amount)
    local item = self:Copy()
    self:SetAmount(self:GetAmount() + 1)
    return item
end
 
function ITEM:Split( amount )
    self:SetAmount(self:GetAmount()-amount)
 
    local item = self:Copy()
    item:SetAmount(amount)
 
    return item
end
 
function ITEM:SaveData(ent)
    self:SetData("OreType", "butts" )
end
 
function ITEM:LoadData(ent)
    ent:SetModel("models/props_junk/rock001a.mdl")
    --ent:SetOreType(self:GetData("OreType"))
 
    function ent:Initialize()
        self:PhysicsInit(SOLID_VPHYSICS)
        self:SetMoveType(MOVETYPE_VPHYSICS)
        self:SetSolid(SOLID_VPHYSICS)
        self:SetUseType(SIMPLE_USE)
        self:GetPhysicsObject():Wake()
 
        self:SetColor(Mining.Rocks[self:GetData("OreType")])
 
        self:SetCollisionGroup(COLLISION_GROUP_INTERACTIVE_DEBRIS)
    end
end



--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
