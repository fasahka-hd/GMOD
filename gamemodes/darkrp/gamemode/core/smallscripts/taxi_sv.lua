--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

util.AddNetworkString('just_taxi:SendMenu')
util.AddNetworkString('just_taxi:SendCost')

hook.Add('PlayerButtonDown', 'Taxi::Bind::P', function(ply, button)
    if button != KEY_P then return end

    net.Start('just_taxi:SendMenu')
        net.WriteTable(ply:GetVehicle():VC_getPlayers())
    net.Send(ply)
end)

net.Receive('just_taxi:SendCost', function(_, ply)
    if not IsValid(ply) then return end

    if ply:Team() != TEAM_TAXI then ply:ChatPrint('Ты не таксист') return end
    if ply:GetVehicle():CPPIGetOwner() != ply and ply:GetVehicle():GetModel() != 'models/crsk_autos/hyundai/solaris_2010_taxi.mdl' then ply:ChatPrint('Ты не в машине такси / маши не твоя') return end
    local target = net.ReadEntity()
    local cost = net.ReadFloat()

    if not IsValid(target) then return end
    for _, v in ipairs(ply:GetVehicle():VC_getPlayers()) do
        if v != target then continue end
        if not v:CanAfford(cost) then ply:ChatPrint(v:Name() .. ' не может позволить себе такие цены!') return end

        GAMEMODE.ques:Create('Вам предложили оплатить за поездку\n' .. rp.FormatMoney(cost) .. '\nБудете оплачивать?', 'fine' .. v:SteamID64(), target, 20,
        function(ans, ent, initiator, _, TimeIsUp)
            if tobool(ans) then
                if v:CanAfford(cost) then
                    v:TakeMoney(cost, 'Оплатил поездку на такси ' .. ply:SteamID64())
                    v:ChatPrint('Вы успешно оплатили поездку на сумму: ' .. rp.FormatMoney(cost))
                    ply:AddMoney(cost, 'Получил за оплату поездки ' .. v:SteamID64())
                    ply:ChatPrint( v:Name() .. ' Оплатил поездку: ' .. rp.FormatMoney(cost))
                else
                    ply:ChatPrint(v:Name() .. ' не стал оплачивать поездку!')
                    v:ExitVehicle()
                end
            else
                ply:ChatPrint(v:Name() .. ' не стал оплачивать поездку!')
                v:ExitVehicle()
            end

            if TimeIsUp then
                ply:ChatPrint(v:Name() .. ' не стал оплачивать поездку!')
                v:ExitVehicle()
            end
        end)
    end

end)

hook.Add('VC_canEnterPassengerSeat', 'Cost', function(pass, seat, veh)
    -- for _, v in ipairs(ply:GetVehicle()) do
    --     print(v)
    -- end

    if veh:GetModel() == 'models/crsk_autos/paz/3205.mdl' then
        local ply = veh:CPPIGetOwner()
        local cost = 500

        if pass == ply then return end
        
        GAMEMODE.ques:Create('Вам предложили оплатить поездку за\n' .. rp.FormatMoney(cost) .. '\nБудете оплачивать?', 'bus' .. pass:SteamID64(), pass, 10,
            function(ans, ent, initiator, _, TimeIsUp)
                if tobool(ans) then
                    if pass:CanAfford(cost) then
                        pass:TakeMoney(cost, 'Оплатил поездку на автобусе ' .. ply:SteamID64())
                        pass:ChatPrint('Вы успешно оплатили поездку на автобусе на сумму: ' .. rp.FormatMoney(cost))
                        ply:AddMoney(cost, 'Получил за оплату поездки на автобусе ' .. pass:SteamID64())
                        ply:ChatPrint( pass:Name() .. ' Оплатил поездку на автобусе: ' .. rp.FormatMoney(cost))
                    else
                        ply:ChatPrint(pass:Name() .. ' не стал оплачивать поездку автобусе!')
                        pass:ExitVehicle()
                    end
                else
                    ply:ChatPrint(pass:Name() .. ' не стал оплачивать поездку автобусе!')
                    pass:ExitVehicle()
                end

                if TimeIsUp then
                    ply:ChatPrint(pass:Name() .. ' не стал оплачивать поездку автобусе!')
                    pass:ExitVehicle()
                end
            end)
    end
    return true
end)

--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
