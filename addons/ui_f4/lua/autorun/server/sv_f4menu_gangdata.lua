function GetContext(pl, cb)
    if not IsValid(pl) then return end
    local sid = pl:SteamID64()
    GQuery('SELECT m.gang_id,m.rank_id,g.name AS gang_name,g.owner,g.bank,g.reputation,g.description,g.created,r.name AS rank_name,r.weight,r.perms FROM f4_gang_members m JOIN f4_gangs g ON g.id=m.gang_id LEFT JOIN f4_gang_ranks r ON r.id=m.rank_id WHERE m.steamid="' .. GEscape(sid) .. '" LIMIT 1', function(rows)
        local row = rows[1]
        if not row then cb(nil) return end
        local gid = tonumber(row.gang_id) or 0
        pl.F4GangID = gid
        cb({
            gang = { id = gid, name = row.gang_name or '', owner = tostring(row.owner or ''), bank = tonumber(row.bank) or 0, reputation = tonumber(row.reputation) or 0, description = tostring(row.description or ''), created = tonumber(row.created) or 0 },
            member = { steamid = sid, rank_id = tonumber(row.rank_id) or 0 },
            rank = { id = tonumber(row.rank_id) or 0, name = row.rank_name or 'Участник', weight = tonumber(row.weight) or 1, perms = row.perms or '{}' }
        })
    end)
end

function GetDefaultMemberRank(gangID, cb)
    GQuery('SELECT id FROM f4_gang_ranks WHERE gang_id=' .. tonumber(gangID) .. ' ORDER BY weight ASC LIMIT 1', function(rows)
        cb(rows[1] and tonumber(rows[1].id) or 0)
    end)
end

function AttachFlagsAndSend(pl, payload)
    payload.flags = {}
    GQuery('SELECT f.id,f.name,f.gang_id,f.captured_time,g.name AS gang_name FROM f4_gang_flags f LEFT JOIN f4_gangs g ON g.id=f.gang_id WHERE f.map="' .. GEscape(game.GetMap()) .. '" ORDER BY f.id ASC', function(flagRows)
        for _, r in ipairs(flagRows or {}) do
            payload.flags[#payload.flags + 1] = {
                id = tonumber(r.id) or 0,
                name = r.name or 'Флаг',
                gang_id = tonumber(r.gang_id) or 0,
                gang_name = r.gang_name or '',
                captured_time = tonumber(r.captured_time) or 0
            }
        end
        if IsValid(pl) then
            net.Start('F4Gangs:Data')
                net.WriteString(util.TableToJSON(payload) or '{}')
            net.Send(pl)
        end
    end)
end

function SendGangData(pl)
    if not IsValid(pl) then return end
    local sid = pl:SteamID64()
    GetContext(pl, function(ctx)
        local payload = { ok = true, create_cost = GetConVar('f4_gang_create_cost'):GetInt(), online = {}, top = {}, invites = {} }
        local onlineIDs = {}
        for _, p in ipairs(player.GetAll()) do
            local psid = p:SteamID64()
            onlineIDs[#onlineIDs + 1] = '"' .. GEscape(psid) .. '"'
            payload.online[#payload.online + 1] = { steamid = psid, name = p:Name(), gang_id = 0 }
        end

        local function finishWithData()
            if not ctx then
                GQuery('SELECT i.gang_id,g.name,i.inviter,i.time FROM f4_gang_invites i JOIN f4_gangs g ON g.id=i.gang_id WHERE i.steamid="' .. GEscape(sid) .. '" ORDER BY i.time DESC', function(invRows)
                    for _, r in ipairs(invRows or {}) do
                        payload.invites[#payload.invites + 1] = { gang_id = tonumber(r.gang_id), name = r.name or '', inviter = tostring(r.inviter or ''), time = tonumber(r.time) or 0 }
                    end
                    AttachFlagsAndSend(pl, payload)
                end)
                return
            end

            payload.gang = ctx.gang
            payload.my = { steamid = sid, rank_id = ctx.member.rank_id, rank = ctx.rank.name, weight = ctx.rank.weight, perms = ParsePerms(ctx.rank.perms), is_owner = ctx.gang.owner == sid }

            GQuery('SELECT id,name,weight,perms FROM f4_gang_ranks WHERE gang_id=' .. ctx.gang.id .. ' ORDER BY weight DESC,id ASC', function(rankRows)
                payload.ranks = {}
                for _, r in ipairs(rankRows or {}) do
                    payload.ranks[#payload.ranks + 1] = { id = tonumber(r.id), name = r.name or '', weight = tonumber(r.weight) or 0, perms = ParsePerms(r.perms) }
                end

                GQuery('SELECT m.steamid,m.name,m.rank_id,m.joined,r.name AS rank_name,r.weight FROM f4_gang_members m LEFT JOIN f4_gang_ranks r ON r.id=m.rank_id WHERE m.gang_id=' .. ctx.gang.id .. ' ORDER BY r.weight DESC,m.joined ASC', function(memberRows)
                    payload.members = {}
                    for _, r in ipairs(memberRows or {}) do
                        payload.members[#payload.members + 1] = { steamid = tostring(r.steamid), name = r.name or '', rank_id = tonumber(r.rank_id) or 0, rank = r.rank_name or 'Участник', weight = tonumber(r.weight) or 0, online = IsValid(GangPlayerBy64(tostring(r.steamid))) }
                    end

                    GQuery('SELECT steamid,inviter,time FROM f4_gang_invites WHERE gang_id=' .. ctx.gang.id .. ' ORDER BY time DESC', function(invRows)
                        payload.invites = {}
                        for _, r in ipairs(invRows or {}) do
                            local ip = GangPlayerBy64(tostring(r.steamid))
                            payload.invites[#payload.invites + 1] = { steamid = tostring(r.steamid), name = IsValid(ip) and ip:Name() or tostring(r.steamid), inviter = tostring(r.inviter), time = tonumber(r.time) or 0 }
                        end
                        AttachFlagsAndSend(pl, payload)
                    end)
                end)
            end)
        end

        local function loadTopThenFinish()
            GQuery('SELECT id,name,bank,reputation FROM f4_gangs ORDER BY reputation DESC,bank DESC LIMIT 5', function(topRows)
                for _, r in ipairs(topRows or {}) do
                    payload.top[#payload.top + 1] = { id = tonumber(r.id), name = r.name or '', bank = tonumber(r.bank) or 0, reputation = tonumber(r.reputation) or 0 }
                end
                finishWithData()
            end)
        end

        if ctx and HasPerm(ctx, 'invite') and #onlineIDs > 0 then
            GQuery('SELECT steamid,gang_id FROM f4_gang_members WHERE steamid IN (' .. table.concat(onlineIDs, ',') .. ')', function(memberRows)
                local map = {}
                for _, r in ipairs(memberRows or {}) do map[tostring(r.steamid)] = tonumber(r.gang_id) or 0 end
                for _, op in ipairs(payload.online) do op.gang_id = map[tostring(op.steamid)] or 0 end
                loadTopThenFinish()
            end)
        else
            loadTopThenFinish()
        end
    end)
end

function RefreshGang(gangID)
    if not gangID then return end
    GQuery('SELECT steamid FROM f4_gang_members WHERE gang_id=' .. tonumber(gangID), function(rows)
        for _, r in ipairs(rows or {}) do
            local p = GangPlayerBy64(tostring(r.steamid))
            if IsValid(p) then SendGangData(p); LoadPlayerGangNW(p) end
        end
    end)
end
