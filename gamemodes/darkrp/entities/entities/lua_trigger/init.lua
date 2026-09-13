--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

AddCSLuaFile('cl_init.lua')
AddCSLuaFile('shared.lua')
include('shared.lua')

local Tag = "LibFuse:LuaTrigger"

util.AddNetworkString(Tag)

function ENT:Initialize()

    self:SetModel("models/hunter/plates/plate.mdl")
    self:SetSolid( SOLID_BBOX )
    self:SetTrigger( true )

    self.name = "luatrigger_basic"
end

function ENT:SetTriggerName(name)

    self.name = name

end

function ENT:SetTriggerModel(mdl)

    self:SetModel(mdl)

end

function ENT:SetTriggerCollisionBox(vec1, vec2)
    
    self:SetCollisionBoundsWS(vec1, vec2)

end

function ENT:SetTriggerNetworking(bool)

    self.networking_trigger = tobool(bool) 

end

function ENT:StartTouch(ent)
    hook.Run("LibFuse:LuaTrigger:Join", self.name, ent, self) 

    if ent:IsPlayer() and self.networking_trigger then
        net.Start(Tag)
            net.WriteString(self.name)
        net.Send(ent)
    end
end

function ENT:Touch(ent)
    hook.Run("LibFuse:LuaTrigger:Still", self.name, ent, self)
end

function ENT:EndTouch(ent)
    hook.Run("LibFuse:LuaTrigger:Leave", self.name, ent, self)

    if ent:IsPlayer() and self.networking_trigger then
        net.Start(Tag)
            net.WriteString(self.name)
        net.Send(ent)
    end
end


// ПЕРЕНЕСТИ ЭТО В ОТДЕЛЬНЫЙ ЛУЕ ФАЙЛ

--[[
    ДОКУМЕНТАЦИЯ К LUE Triggers

        ХУКИ: 
            
            hook.Add("LibFuse:LuaTrigger:Join", "YourTriggerName", function(name, player, self)
                Что то вошло в триггер ( Player, Entity )
            end)

            hook.Add("LibFuse:LuaTrigger:Still", "YourTriggerName", function(name, player, self)
                После входа осталось в нем еще пока не вышло ( Player, Entity )
            end)

            hook.Add("LibFuse:LuaTrigger:Leave", "YourTriggerName", function(name, player, self)
                Вышло из триггера (Player, Entity )
            end)

        Что возвращают хуки:
            name - Название тригера
            player - ентити
            self - ентити луа тригера

        Функции:
            Entity:SetTriggerName("Название луа тригера хз где оно тебе понадобится")
            Entity:SetTriggerModel("Модель тригера если нужен по размеру пропа???")
            Entity:SetTriggerCollisionBox(Vec1, Vec2) Используется если нужен не по размеру пропа, а по векторам как в ents.FindInBox
            Entity:SetTriggerNetworking(true or false) TRUE - Передает инфу клиенту о входе в себя, FALSE - Только сервер знает о входе.
]] --


--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
