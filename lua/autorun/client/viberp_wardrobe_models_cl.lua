if SERVER then return end

local function applyByWsid(ply, wsid)
    if not (wardrobe and wardrobe.getAddon and wardrobe.setModel) then return end
    wardrobe.getAddon(wsid, function(_, info, path, mdls, meta)
        if not IsValid(ply) then return end
        if not mdls or #mdls == 0 then return end
        local mdl = mdls[1].name
        local hands
        if meta and meta[1] then hands = meta[1][2] end
        wardrobe.setModel(ply, mdl, wsid, hands)
    end, true)
end

net.Receive("VibeRP_WModel", function()
    local uid = net.ReadUInt(16)
    local wsid = net.ReadUInt(32)
    local ply = Player(uid)
    if not IsValid(ply) then return end

    if wsid == 0 then
        if wardrobe and wardrobe.setModel then
            wardrobe.setModel(ply)
        end
        return
    end

    if not wardrobe then return end
    applyByWsid(ply, wsid)
end)
