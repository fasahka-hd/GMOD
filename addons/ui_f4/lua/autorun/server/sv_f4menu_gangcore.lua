GANG_PERMS = {
    invite   = true,
    kick     = true,
    setrank  = true,
    ranks    = true,
    withdraw = true,
    disband  = true,
}

function GangDB()
    return ba and ba.data and ba.data.GetDB and ba.data.GetDB() or nil
end

function GEscape(v)
    local db = GangDB()
    if db and db.escape then return db:escape(tostring(v or '')) end
    return tostring(v or ''):gsub('\\', '\\\\'):gsub('"', '\\"'):gsub("'", "\\'")
end

function GQuery(q, cb)
    local db = GangDB()
    if not db then return end

    if db._db and db._db.Query then
        return db._db:Query(q, function(results)
            local res = results and results[1]
            if res and res.error then
                print('[F4Gangs SQL ERROR] ' .. tostring(res.error))
                if cb then cb({}) end
                return
            end
            if cb then cb((res and res.data) or {}) end
        end, QUERY_FLAG_ASSOC)
    end

    db:query(q, function(data)
        if cb then cb(data or {}) end
    end)
end

function GMoney(pl)
    if not IsValid(pl) then return 0 end
    if pl.GetMoney then return tonumber(pl:GetMoney()) or 0 end
    if pl.getDarkRPVar then return tonumber(pl:getDarkRPVar('money')) or 0 end
    return 0
end

function GAddMoney(pl, amount, reason)
    if not IsValid(pl) then return end
    if pl.AddMoney then pl:AddMoney(amount, reason or 'Банды') return end
    if pl.addMoney then pl:addMoney(amount) return end
end

function GCanAfford(pl, amount)
    amount = tonumber(amount) or 0
    if amount < 0 then return false end
    if pl.canAfford then return pl:canAfford(amount) end
    return GMoney(pl) >= amount
end

function GNotify(pl, ok, txt)
    if not IsValid(pl) then return end
    net.Start('F4Gangs:Notify')
        net.WriteBool(ok and true or false)
        net.WriteString(tostring(txt or ''))
    net.Send(pl)
end

function IsFlagAdmin(pl)
    if not IsValid(pl) then return true end
    return pl:IsSuperAdmin()
end

function CleanGangName(name)
    name = string.Trim(tostring(name or ''))
    name = name:gsub('[\r\n\t]', ' '):gsub('%s+', ' ')
    return string.sub(name, 1, 32)
end

function ValidateGangName(name)
    name = CleanGangName(name)

    if #name < 3 then
        return false, 'Название минимум 3 символа'
    end

    if #name > 10 then
        return false, 'Название максимум 10 символов'
    end

    if not name:match('^[A-Za-z0-9 _%-]+$') then
        return false, 'Название может содержать только английские буквы, цифры, пробел, - и _'
    end

    return true
end

function CleanRankName(name)
    name = string.Trim(tostring(name or ''))
    name = name:gsub('[\r\n\t]', ' '):gsub('%s+', ' ')
    return string.sub(name, 1, 24)
end

function ParsePerms(raw)
    if istable(raw) then return raw end
    local t = util.JSONToTable(tostring(raw or '{}')) or {}
    local out = {}
    for k in pairs(GANG_PERMS) do out[k] = t[k] and true or false end
    return out
end

function PermsJSON(perms)
    local out = {}
    perms = istable(perms) and perms or {}
    for k in pairs(GANG_PERMS) do out[k] = perms[k] and true or false end
    return util.TableToJSON(out) or '{}'
end

function HasPerm(ctx, perm)
    if not ctx or not ctx.rank then return false end
    if tonumber(ctx.rank.weight or 0) >= 100 then return true end
    local p = ParsePerms(ctx.rank.perms)
    return p[perm] == true
end

function GangPlayerBy64(sid)
    sid = tostring(sid or '')
    if player.GetBySteamID64 then return player.GetBySteamID64(sid) end
    for _, p in ipairs(player.GetAll()) do
        if IsValid(p) and p:SteamID64() == sid then return p end
    end
end

function SetPlayerGangNW(pl, gangName)
    if not IsValid(pl) then return end
    pl:SetNWString('clan', tostring(gangName or ''))
end

function LoadPlayerGangNW(pl)
    if not IsValid(pl) then return end
    local sid = pl:SteamID64()
    GQuery('SELECT g.name FROM f4_gang_members m JOIN f4_gangs g ON g.id=m.gang_id WHERE m.steamid="' .. GEscape(sid) .. '" LIMIT 1', function(rows)
        if not IsValid(pl) then return end
        SetPlayerGangNW(pl, rows[1] and rows[1].name or '')
    end)
end

function EnsureGangTables()
    GQuery([[CREATE TABLE IF NOT EXISTS f4_gangs (
        id INT NOT NULL AUTO_INCREMENT,
        name VARCHAR(32) NOT NULL,
        owner VARCHAR(20) NOT NULL,
        bank BIGINT NOT NULL DEFAULT 0,
        reputation INT NOT NULL DEFAULT 0,
        description TEXT NULL,
        created INT NOT NULL DEFAULT 0,
        PRIMARY KEY (id),
        UNIQUE KEY uq_f4_gang_name (name),
        KEY idx_f4_gang_owner (owner)
    ) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;]])

    GQuery([[CREATE TABLE IF NOT EXISTS f4_gang_ranks (
        id INT NOT NULL AUTO_INCREMENT,
        gang_id INT NOT NULL,
        name VARCHAR(24) NOT NULL,
        weight INT NOT NULL DEFAULT 1,
        perms TEXT NULL,
        PRIMARY KEY (id),
        KEY idx_f4_rank_gang (gang_id)
    ) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;]])

    GQuery([[CREATE TABLE IF NOT EXISTS f4_gang_members (
        gang_id INT NOT NULL,
        steamid VARCHAR(20) NOT NULL,
        name VARCHAR(64) NOT NULL DEFAULT '',
        rank_id INT NOT NULL DEFAULT 0,
        joined INT NOT NULL DEFAULT 0,
        PRIMARY KEY (steamid),
        KEY idx_f4_member_gang (gang_id),
        KEY idx_f4_member_rank (rank_id)
    ) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;]])

    GQuery([[CREATE TABLE IF NOT EXISTS f4_gang_invites (
        gang_id INT NOT NULL,
        steamid VARCHAR(20) NOT NULL,
        inviter VARCHAR(20) NOT NULL DEFAULT '',
        time INT NOT NULL DEFAULT 0,
        PRIMARY KEY (gang_id, steamid),
        KEY idx_f4_invite_steamid (steamid)
    ) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;]])

    GQuery([[CREATE TABLE IF NOT EXISTS f4_gang_flags (
        id INT NOT NULL AUTO_INCREMENT,
        name VARCHAR(32) NOT NULL DEFAULT 'Флаг',
        map VARCHAR(64) NOT NULL DEFAULT '',
        x DOUBLE NOT NULL DEFAULT 0,
        y DOUBLE NOT NULL DEFAULT 0,
        z DOUBLE NOT NULL DEFAULT 0,
        pitch DOUBLE NOT NULL DEFAULT 0,
        yaw DOUBLE NOT NULL DEFAULT 0,
        roll DOUBLE NOT NULL DEFAULT 0,
        gang_id INT NOT NULL DEFAULT 0,
        captured_time INT NOT NULL DEFAULT 0,
        PRIMARY KEY (id),
        KEY idx_f4_flag_map (map),
        KEY idx_f4_flag_gang (gang_id)
    ) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;]])

    GQuery("SHOW COLUMNS FROM f4_gangs LIKE 'reputation'", function(rows)
        if not rows[1] then GQuery('ALTER TABLE f4_gangs ADD COLUMN reputation INT NOT NULL DEFAULT 0') end
    end)
    GQuery("SHOW COLUMNS FROM f4_gangs LIKE 'description'", function(rows)
        if not rows[1] then GQuery('ALTER TABLE f4_gangs ADD COLUMN description TEXT NULL') end
    end)
end

hook.Add('Initialize', 'F4Gangs.InitDB', function() timer.Simple(2, function() EnsureGangTables(); LoadFlagDisableState() end) end)
timer.Simple(5, function() EnsureGangTables(); LoadFlagDisableState() end)
