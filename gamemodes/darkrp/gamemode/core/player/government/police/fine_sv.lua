--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

util.AddNetworkString('just_police:DoFine')
util.AddNetworkString('just_police:GetFine')

net.Receive('just_police:DoFine', function(_, ply)
    if not IsValid(ply) then return end

    if not rp.CivilProtection[ply:Team()] then ply:ChatPrint('Вы не полицейский.') return end
    local target = net.ReadEntity()
    local reasons = net.ReadTable()
    local cost = 0

    if ply:GetPos():DistToSqr(target:GetPos()) > 140 ^ 2 then ply:ChatPrint('Вы слишком далеко от цели!') return end

    if target == ply then ply:ChatPrint('Вы не можете выписать штраф самому себе') return end
    if rp.CivilProtection[target:Team()] then ply:ChatPrint('Вы не можете выписывать штраф государственным служащим') return end
    if target.CooldownFine then ply:ChatPrint('Этому человеку уже выписывали недавно штраф') return end
    if not IsValid(target) then ply:ChatPrint('Этот человек, недействителен!') return end

    local reason = {}

    for _, id in ipairs(reasons) do
        cost = cost + just_police.FiningPolice[id]['Price']
        reason[#reason + 1] = just_police.FiningPolice[id]['Name'] .. ' (' .. rp.FormatMoney(just_police.FiningPolice[id]['Price']) .. ')'
    end

    target.CooldownFine = true
    timer.Simple(300, function()
        target.CooldownFine = false
    end)

    ply:ChatPrint('Вы выписали штраф ' .. target:Name() .. ' в размере: ' .. rp.FormatMoney(cost))
    target:ChatPrint('Вам выписали штраф по причине: ' .. table.concat( reason, ', ' ))
    GAMEMODE.ques:Create('Вам выписали штраф!\nВ сумме на ' .. rp.FormatMoney(cost) .. '\nБудете оплачивать?', 'fine' .. target:SteamID64(), target, 60,
    function(ans, ent, initiator, _, TimeIsUp)
        if tobool(ans) then
            if target:CanAfford(cost) then
                target:TakeMoney(cost, 'Оплатил штраф в пользу ' .. ply:SteamID64())
                target:ChatPrint('Вы успешно оплатили штраф в размере: ' .. rp.FormatMoney(cost))
                ply:AddMoney(cost * .5, 'Получил за выдачу штрафа игроку ' .. target:SteamID64())
                ply:ChatPrint('Вы получили 50% от штрафа: ' .. rp.FormatMoney(cost * .5))

                popup_kazna(cost * .5, 'Штраф ' .. target:Name())
            else
                target:Wanted(ply, 'Не оплатил штраф!')
            end
        else
            target:Wanted(ply, 'Не оплатил штраф!')
        end

        if TimeIsUp then
            target:Wanted(ply, 'Не оплатил штраф!')
        end
    end)
end)

--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher