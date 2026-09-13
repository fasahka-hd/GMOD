if not SERVER then return end

local player_meta = FindMetaTable("Player")
if not player_meta then return end

file.CreateDir("igs_donates")

local function getFilePath(pl)
    return "igs_donates/" .. pl:SteamID64() .. ".json"
end

local function loadData(pl)
    if pl._igs_donates_cache then return pl._igs_donates_cache end
    local path = getFilePath(pl)
    if file.Exists(path, "DATA") then
        local raw = file.Read(path, "DATA")
        pl._igs_donates_cache = util.JSONToTable(raw) or {}
    else
        pl._igs_donates_cache = {}
    end
    return pl._igs_donates_cache
end

local function saveData(pl)
    if not pl._igs_donates_cache then return end
    file.Write(getFilePath(pl), util.TableToJSON(pl._igs_donates_cache))
end

function player_meta:GetDonates(key, default)
    local data = loadData(self)
    local val = data[key]
    if val == nil then return default end
    return val
end

function player_meta:SetDonates(key, value)
    local data = loadData(self)
    data[key] = value
    saveData(self)
end

hook.Add("PlayerDisconnected", "IGS_DonatesPersist_Cleanup", function(pl)
    pl._igs_donates_cache = nil
end)