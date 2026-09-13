--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

nw.Register'jtime':Write(net.WriteUInt, 32):Read(net.ReadUInt, 32):SetLocalPlayer()
nw.Register 'JailReason'
	:Write(net.WriteString)
	:Read(net.ReadString)
	:SetLocalPlayer()
nw.Register 'JailAdmin'
	:Write(net.WriteString)
	:Read(net.ReadString)
	:SetLocalPlayer()
nw.Register 'JailAdminSteamID'
	:Write(net.WriteString)
	:Read(net.ReadString)
	:SetLocalPlayer()

term.Add('MaxJailReached', 'Ваша привилегия не позволяет джайлить больше чем на #')

function PLAYER:IsJailed()
	return ((SERVER) and (ba.jailedPlayers[self:SteamID()] ~= nil) or (self:GetNetVar('JailReason') ~= nil))
end

local cmd = ba.cmd.Create('Jail', function(pl, args)
    -- Проверка, установлена ли точка джайла на карте
    if not ba.svar.Get('jailroom') then
        ba.notify_err(pl, term.Get('JailNotSet'))
        return
    end

    -- Проверка лимитов ранга по времени (если такая таблица есть)
    local tbl = pl:GetRankTable()
    local maxJail = tbl and tbl["MaxJail"]
    if maxJail and args.time and #maxJail > 1 then
        if args.time > maxJail[1] then
            ba.notify_err(pl, term.Get('MaxJailReached'), maxJail[2])
            return
        end
    end

    -- Логика джайла/разджайла
    if not args.target:IsJailed() then
        -- Если игрока садят, время обязательно
        if (args.time == nil or args.time <= 0) then
            ba.notify_err(pl, term.Get('MissingArgTime'))
            return
        end

        -- Если игрока садят, причина обязательна
        if (args.reason == nil or args.reason == "") then
            ba.notify_err(pl, term.Get('MissingArgReason'))
            return
        end

        -- Ограничение времени для всех, кроме супер-админов (*)
        if (args.time > 3600) and not pl:IsRoot() then
            ba.notify_err(pl, term.Get('JailTimeRestriction'))
            return
        end
        
        local adata = {}
        if IsValid(pl) then
            adata = {name = pl:Name(), steamid = pl:SteamID()}
        end

        -- Выполнение джайла
        ba.jailPlayer(args.target, adata, args.time, args.reason)
        
        -- Уведомления
        ba.notify_staff(term.Get('AdminJailedPlayer'), pl, args.target, args.raw.time, args.reason)
        ba.notify(args.target, term.Get('AdminJailedYou'), pl, args.raw.time, args.reason)
    else
        -- Если уже в джайле — выпускаем
        ba.unJailPlayer(args.target)
        ba.notify_staff(term.Get('AdminUnjailedPlayer'), pl, args.target)
        ba.notify(args.target, term.Get('AdminUnjailedYou'), pl)
    end
end)

cmd:AddParam('player_entity', 'target')
cmd:AddParam('time', 'time', 'optional')
cmd:AddParam('string', 'reason', 'optional')
cmd:SetFlag('M')
cmd:SetHelp('Jails/UnJails your target')
cmd:SetIcon('icon16/lock_add.png')


-------------------------------------------------
-- Jailroom
-------------------------------------------------
local cmd = ba.cmd.Create('SetJailRoom', function(pl, args)
	ba.svar.Set('jailroom', pon.encode({pl:GetPos()}))
	ba.notify(pl, term.Get('JailroomSet'))
end)
cmd:SetFlag('*')
cmd:SetHelp('Sets the jailroom to your current position')



--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
