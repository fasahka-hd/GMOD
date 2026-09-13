--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include('shared.lua')

local models = {
  'models/props_junk/garbage128_composite001a.mdl',
  'models/props_junk/garbage128_composite001b.mdl',
  'models/props_junk/garbage128_composite001c.mdl',
  'models/props_junk/garbage128_composite001d.mdl'
}

function ENT:Initialize()
    self:SetModel(models[math.random(1, #models)])
    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetMoveType(MOVETYPE_VPHYSICS)
    self:SetSolid(SOLID_VPHYSICS)
    self:SetRenderMode(RENDERMODE_TRANSALPHA)
    self.NextUse = true
    local phys = self.Entity:GetPhysicsObject()

    if (phys:IsValid()) then
        phys:EnableMotion(false)
        phys:Wake()
    end
    self:DrawShadow( false )
    self:SetUseType(SIMPLE_USE)
end

function ENT:Use(ply)
    if(self.startTrash || ply:Team() != TEAM_DVORNIK) then return end
    ply:SendLua([[chat.AddText(Color(255,255,255),"Вы начали уборку мусора")]])

    self.startTrash = true
    timer.Simple( 10, function() 
        if(IsValid(self)) then self.startTrash = false end
        if !( IsValid(self) and ply:Alive() and ply:GetPos():DistToSqr(self:GetPos()) <= 4000 and ply:GetEyeTrace().Entity == self ) then ply:SendLua([[chat.AddText(Color(255,0,0),"При уборке мусора что-то пошло не так")]]) return end
        local rand = math.random(0, 100)
        local basemoney = 75
        local money_found = math.random(70, 100)

        ply:AddMoney(basemoney, 'Чистка мусора')
        ply:SendLua([[chat.AddText(Color(255,255,255),"Вы убрали мусор и получили ", Color(0,225,0), "]] .. rp.FormatMoney(basemoney) .. [[")]])
        self:Remove()

        if rand > 70 then
          ply:AddMoney(money_found, 'Рандом мусор, деньги')
          ply:SendLua([[chat.AddText(Color(255,255,255),"Вам повезло! Убирая мусор вы нашли в нем ", Color(0,225,0), "]] .. rp.FormatMoney(money_found) .. [[")]])
        end
    end)
end


--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
