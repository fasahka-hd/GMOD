nw.Register('enc.cards')
    :Write(net.WriteTable)
    :Read(net.ReadTable)
    :SetLocalPlayer()

do
    local meta = FindMetaTable('Player')

    function meta:GetMyDay()
        local data = self:GetNetVar('enc.cards')
        if not data then return os.time() + 86400 end
        return data.day
    end

    function meta:GetTakes()
        local data = self:GetNetVar('enc.cards')
        if not data then return 0 end
        return data.takes
    end

    function meta:GetPrizesCount()
        local data = self:GetNetVar('enc.cards')
        if not data then return {} end
        return util.JSONToTable(data.shop) or {}
    end

    function meta:GetFrags()
        local data = self:GetNetVar('enc.cards')
        if not data then return 0 end
        return data.frags
    end
end

function GetCardByName(name)
    for k, v in ipairs(enc.cardsmenu) do
        if v.name == name then
            return v
        end
    end
    return false
end

do
    local cmd = ba.cmd.Create('luck')
    cmd:RunOnClient(function(args)
        enc.CardsOpenMenu()
    end)
    cmd:SetHelp('Открыть Cards меню')
end
