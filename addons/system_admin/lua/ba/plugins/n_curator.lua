
-------------------------------------------------
-- Set Group
-------------------------------------------------
term.Add('SetRank', '# установил #\' ранг # # #')
term.Add('CantSetRankYourself', 'Вы не можете установить ранг самому себе!')

local function getAccessedRank(adminRank, userRank)
    if adminRank == '*' then return userRank end
    local stored = ba.ranks.Stored
    if not stored[userRank] then return 'user' end
    -- local max = 0
    local maxRank = 'user'
    local myImmunity = stored[adminRank].Immunity
    local userRankImmunity = stored[userRank].Immunity

    if myImmunity > userRankImmunity then return userRank end
    return nil

    -- for i, rankData in pairs(stored) do
    --     local curImmunity = rankData.Immunity
    --     if not curImmunity then continue end

    --     if myImmunity > curImmunity and curImmunity > max and curImmunity <= userRankImmunity then
    --         max = curImmunity
    --         maxRank = rankData.Name
    --     end
    -- end

    -- return maxRank
end

ba.cmd.Create('SetGroup', function(pl, args)
    if args.exp_time and args.exp_time ~= 0 and (not args.exp_rank) then
        ba.notify_err(pl, term.Get('CantSetRankYourself'))

        return
    end

    local myRank = '*'

    if IsValid(pl) then
        myRank = pl:GetUserGroup() or "User"

        if myRank ~= '*' and pl == args.target then
            ba.notify_err(pl, term.Get('MissingArg'), 'exp_rank')

            return
        end

        if IsValid(pl) and not pl:HasFlag("S") and args.target and args.target:IsValid() then
            local tar = args.target

            if tar == pl then
                ba.notify(pl, 'Себе выдать права нельзя.')

                return
            end

            -- if myRank == 'root' then goto root end;
            local tarRank = tar:GetUserGroup()

            if ba.ranks.Stored[myRank].Immunity <= ba.ranks.Stored[tarRank].Immunity then
                ba.notify(pl, 'Нет прав над данным пользователем.')

                return
            end

            if ba.ranks.Stored[myRank].Immunity <= ba.ranks.Stored[args.rank].Immunity then
                ba.notify(pl, 'Ранг на выдаче должен быть ниже вашего!')

                return
            end
        end

        if type(args.target) == 'string' then
            local SteamID64 = util.SteamIDTo64(args.target)
            local rank = ba.data.GetRank(SteamID64) or "User"

            if not pl:IsRoot() and ba.ranks.Stored[myRank].Immunity <= ba.ranks.Stored[rank].Immunity then
                ba.notify(pl, 'Нет прав над данным пользователем.')

                return
            end

            if ba.ranks.Stored[myRank].Immunity <= ba.ranks.Stored[args.rank].Immunity then
                ba.notify(pl, 'Ранг на выдаче должен быть ниже вашего!')

                return
            end
        end
    end

    local rank = getAccessedRank(myRank, args.rank)
    if not rank then
        ba.notify(pl, "Иди нахуй")
        return
    end

    ba.data.LogSetGroup(os.time(), pl, rank, not ba.IsSteamID(args.target) and args.target:SteamID64() or util.SteamIDTo64(args.target), not ba.IsSteamID(args.target) and args.target:Name() or "Unknown")
    ba.data.SetRank(args.target, rank, args.exp_rank or rank, args.exp_time and os.time() + args.exp_time or 0, function(data)
        ba.notify_all(term.Get('SetRank'), pl, args.target, rank, args.exp_rank and 'expiring to ' .. args.exp_rank or '', args.exp_time and 'in ' .. args.raw.exp_time or '')
    end)
end):AddParam('player_steamid', 'target'):AddParam('rank', 'rank'):AddParam('time', 'exp_time', 'optional'):AddParam('rank', 'exp_rank', 'optional'):SetFlag('S'):SetHelp('Изменяет ранг игрока. Пример: /setgroup (ник) (ранг)'):SetIcon('icon16/group.png')
