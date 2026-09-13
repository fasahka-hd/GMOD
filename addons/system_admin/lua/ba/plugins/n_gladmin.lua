-------------------------------------------------
-- Panel personal access helpers
-------------------------------------------------
local function PanelAccessDB()
    return ba and ba.data and ba.data.GetDB and ba.data.GetDB() or nil
end

local function PanelAccessEnsureTable()
    local db = PanelAccessDB()
    if not db then return end
    db:query([[CREATE TABLE IF NOT EXISTS panel_player_access (
        steamid32 VARCHAR(32) NOT NULL,
        props_extra INT UNSIGNED NOT NULL DEFAULT 0,
        setmodel TINYINT(1) NOT NULL DEFAULT 0,
        issued_by VARCHAR(64) NOT NULL DEFAULT '',
        updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
        PRIMARY KEY (steamid32)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;]])
end

local function FindPlayerBySteamID32(sid)
    sid = tostring(sid or '')
    for _, v in ipairs(player.GetAll()) do
        if v:SteamID() == sid then return v end
    end
end

local function ApplyPanelAccess(pl, propsExtra, setmodelAccess)
    if not IsValid(pl) then return end
    pl.PanelExtraProps = math.max(0, tonumber(propsExtra) or 0)
    pl.PanelSetModelAccess = tonumber(setmodelAccess) == 1 or setmodelAccess == true
end

local function LoadPanelAccess(pl)
    if not IsValid(pl) then return end
    local db = PanelAccessDB()
    if not db then return ApplyPanelAccess(pl, 0, 0) end

    db:query_ex('SELECT props_extra, setmodel FROM panel_player_access WHERE steamid32="?" LIMIT 1;', { pl:SteamID() }, function(data)
        if not IsValid(pl) then return end
        local row = data and data[1] or nil
        if row then
            ApplyPanelAccess(pl, row.props_extra, row.setmodel)
        else
            ApplyPanelAccess(pl, 0, 0)
        end
    end)
end

hook.Add('Initialize', 'PanelAccess.EnsureTable', function()
    timer.Simple(3, PanelAccessEnsureTable)
end)

hook.Add('PlayerInitialSpawn', 'PanelAccess.LoadOnJoin', function(pl)
    timer.Simple(5, function()
        LoadPanelAccess(pl)
    end)
end)

timer.Create('PanelAccess.RefreshOnlinePlayers', 60, 0, function()
    for _, pl in ipairs(player.GetAll()) do
        LoadPanelAccess(pl)
    end
end)

concommand.Add('panel_setprops', function(pl, _, args)
    if IsValid(pl) then return end
    local sid = tostring(args[1] or '')
    local amount = math.max(0, tonumber(args[2]) or 0)
    local db = PanelAccessDB()
    if db and sid ~= '' then
        db:query_ex([[INSERT INTO panel_player_access (steamid32, props_extra, setmodel, issued_by)
            VALUES ("?", ?, 0, "Console")
            ON DUPLICATE KEY UPDATE props_extra=VALUES(props_extra), updated_at=CURRENT_TIMESTAMP;]], { sid, amount })
    end
    local target = FindPlayerBySteamID32(sid)
    if IsValid(target) then target.PanelExtraProps = amount end
end)

concommand.Add('panel_setmodelaccess', function(pl, _, args)
    if IsValid(pl) then return end
    local sid = tostring(args[1] or '')
    local enabled = tonumber(args[2]) == 1 and 1 or 0
    local db = PanelAccessDB()
    if db and sid ~= '' then
        db:query_ex([[INSERT INTO panel_player_access (steamid32, props_extra, setmodel, issued_by)
            VALUES ("?", 0, ?, "Console")
            ON DUPLICATE KEY UPDATE setmodel=VALUES(setmodel), updated_at=CURRENT_TIMESTAMP;]], { sid, enabled })
    end
    local target = FindPlayerBySteamID32(sid)
    if IsValid(target) then target.PanelSetModelAccess = enabled == 1 end
end)

-------------------------------------------------
-- Set Model
-------------------------------------------------
ba.cmd.Create('SetModel', function(pl, args)
    if not IsValid(pl) then
        args.target:SetModel(args.model)
        return
    end

    local hasRankAccess = pl:HasFlag('D')
    local hasPanelAccess = pl.PanelSetModelAccess == true

    if not hasRankAccess and not hasPanelAccess then
        return ba.notify_err(pl, 'У вас нет доступа к !setmodel')
    end

    if hasPanelAccess and not hasRankAccess and args.target ~= pl then
        return ba.notify_err(pl, 'Вы можете менять модель только себе')
    end

    args.target:SetModel(args.model)
end):AddParam('player_entity', 'target'):AddParam('string', 'model'):SetFlag('u'):SetHelp('Меняет модельку'):SetIcon('icon16/Heart.png')