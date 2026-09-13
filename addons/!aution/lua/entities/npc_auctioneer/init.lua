AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()
    local model = "models/gman_high.mdl"
    if AUCTION and AUCTION.Config and AUCTION.Config.Model then
        model = AUCTION.Config.Model
    end

    self:SetModel(model)
    self:SetHullType(HULL_HUMAN)
    self:SetHullSizeNormal()
    self:SetNPCState(NPC_STATE_SCRIPT)
    self:SetSolid(SOLID_BBOX)
    self:CapabilitiesAdd(CAP_ANIMATEDFACE)

    self:SetUseType(SIMPLE_USE)
    self:DropToFloor()
end

function ENT:AcceptInput(name, activator, caller)
    if name == "Use" and caller:IsPlayer() then
        print("[DEBUG] Нажатие E на NPC от игрока: " .. caller:Nick())

        if AUCTION then
            print("[DEBUG] Таблица AUCTION существует.")
            if AUCTION.OpenMenu then
                print("[DEBUG] Функция OpenMenu найдена. Запускаем...")
                AUCTION:OpenMenu(caller)
            else
                print("[DEBUG] ОШИБКА: Функция AUCTION.OpenMenu НЕ найдена! Файл sv_auction_core.lua не загружен?")
                caller:ChatPrint("Ошибка: Система аукциона не загрузилась полностью.")
            end
        else
            print("[DEBUG] ОШИБКА: Глобальная таблица AUCTION отсутствует!")
        end
    end
end