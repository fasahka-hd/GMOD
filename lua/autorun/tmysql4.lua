if not SERVER then return end

local ok, err = pcall(require, "tmysql4")
if not ok then
    ErrorNoHalt("[TMySQL4] Module load failed: " .. tostring(err) .. "\n")
    return
end

-- Compatibility for addons written for TMySQL4 <= 4.0.
if tmysql and not isfunction(tmysql.initialize) and isfunction(tmysql.Connect) then
    tmysql.initialize = tmysql.Connect
end

-- TMySQL4 4.1+ no longer polls connections automatically.
-- Without this, SELECT callbacks (including ba_users/playtime loading) remain queued.
hook.Add("Tick", "TMySQL4.LegacyPoll", function()
    if not tmysql or not isfunction(tmysql.GetTable) then return end

    local connections = tmysql.GetTable()
    if not istable(connections) then return end

    for _, database in pairs(connections) do
        if database ~= nil then
            pcall(function()
                database:Poll()
            end)
        end
    end
end)
