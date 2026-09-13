--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

nw.Register'Skills':Write(function(v)
    net.WriteUInt(table.Count(v), 4)

    for k, v in pairs(v) do
        net.WriteUInt(k, 4)
        net.WriteUInt(v, 4)
    end
end):Read(function()
    local tbl = {}

    for i = 1, net.ReadUInt(4) do
        tbl[net.ReadUInt(4)] = net.ReadUInt(4)
    end

    return tbl
end):SetLocalPlayer()
nw.Register'TheLaws_Tbl':Write(net.WriteTable):Read(net.ReadTable):SetGlobal()
nw.Register 'TheLaws'
    :Write(net.WriteString)
    :Read(net.ReadString)
    :SetGlobal()
nw.Register'CarriedItem':Write(net.WriteEntity):Read(net.ReadEntity):SetLocalPlayer():SetHook('NetPlayerDropItem')
nw.Register'lockdown':Write(net.WriteBool):Read(net.ReadBool):SetGlobal()
nw.Register'lockdown_kd':Write(net.WriteUInt, 32):Read(net.ReadUInt, 32):SetGlobal()
nw.Register'lockdown_left':Write(net.WriteUInt, 32):Read(net.ReadUInt, 32):SetGlobal()
nw.Register'lockdown_reason':Write(net.WriteString):Read(net.ReadString):SetGlobal()
nw.Register'mayorGrace':Write(net.WriteUInt, 32):Read(net.ReadUInt, 32):SetGlobal()
nw.Register'PM_Allow':Write(net.WriteBool):Read(net.ReadBool):SetPlayer()
nw.Register'HasGunlicense':Write(net.WriteBool):Read(net.ReadBool):SetPlayer()
nw.Register'Name':Write(net.WriteString):Read(net.ReadString):SetPlayer()
nw.Register'Money':Write(net.WriteUInt, 32):Read(net.ReadUInt, 32):SetLocalPlayer()
nw.Register'Energy':Write(net.WriteUInt, 32):Read(net.ReadUInt, 32):SetLocalPlayer()
nw.Register'job':Write(net.WriteString):Read(net.ReadString):SetPlayer()
nw.Register'Hat':Write(net.WriteUInt, 6):Read(net.ReadUInt, 6):SetPlayer()
nw.Register("BPChallanges")
    :Write(net.WriteTable)
    :Read(net.ReadTable)
    :SetPlayer()

nw.Register("BPClaimed")
    :Write(net.WriteTable)
    :Read(net.ReadTable)
    :SetPlayer()

nw.Register("FirstJoin")
    :Write(net.WriteUInt, 32)
    :Read(net.ReadUInt, 32)
    :SetPlayer()

nw.Register'HatData':Write(function(v)
    net.WriteUInt(#v, 6)

    for k, v in ipairs(v) do
        net.WriteString(v)
    end
end):Read(function()
    local tbl = {}

    for i = 1, net.ReadUInt(6) do
        tbl[i] = net.ReadString()
    end

    return tbl
end):SetLocalPlayer()

nw.Register'HatData':Write(function(v)
    net.WriteUInt(#v, 6)

    for k, v in ipairs(v) do
        net.WriteString(v)
    end
end):Read(function()
    local tbl = {}

    for i = 1, net.ReadUInt(6) do
        tbl[i] = net.ReadString()
    end

    return tbl
end):SetLocalPlayer()

nw.Register'ActiveApparel':Write(function(v)
    for i = 1, 4 do
        local isSet = (v[i] ~= nil)
        net.WriteBool(isSet)

        if isSet then
            net.WriteString(v[i])
        end
    end
end):Read(function()
    local tbl = {}

    for i = 1, 4 do
        if net.ReadBool() then
            tbl[i] = net.ReadString()
        end
    end

    return tbl
end):SetPlayer()

nw.Register'OwnedApparel':Write(function(v)
    net.WriteUInt(table.Count(v), 6)

    for k, v in pairs(v) do
        net.WriteString(k)
    end
end):Read(function()
    local tbl = {}

    for i = 1, net.ReadUInt(6) do
        tbl[net.ReadString()] = true
    end

    return tbl
end):SetLocalPlayer()

nw.Register'EmployeePrice':Write(net.WriteUInt, 32):Read(net.ReadUInt, 32):SetPlayer()
nw.Register'Employee':Write(net.WritePlayer):Read(net.ReadPlayer):SetLocalPlayer()
nw.Register'Employer':Write(net.WritePlayer):Read(net.ReadPlayer):SetPlayer()
nw.Register'DisguiseTeam':Write(net.WriteUInt, 6):Read(net.ReadUInt, 6):SetPlayer()
nw.Register'ShareProps':Write(net.WriteTable):Read(net.ReadTable):SetLocalPlayer()
nw.Register'PropIsOwned':Write(net.WriteBool):Read(net.ReadBool):Filter(function(self) return self:CPPIGetOwner() end):SetNoSync()
nw.Register'IsWanted':Write(net.WriteBool):Read(net.ReadBool):SetPlayer()
nw.Register'WantedReason':Write(net.WriteString):Read(net.ReadString):SetLocalPlayer()

nw.Register'ArrestedInfo':Write(function(v)
    net.WriteUInt(v.Release, 32)
    net.WriteString(v.Reason or '')
end):Read(function()
    return {
        Release = net.ReadUInt(32),
        Reason = net.ReadString()
    }
end):SetLocalPlayer()

nw.Register'Credits':Write(net.WriteUInt, 32):Read(net.ReadUInt, 32):SetLocalPlayer()

nw.Register'Upgrades':Write(function(v)
    net.WriteUInt(#v, 8)

    for k, upgid in ipairs(v) do
        net.WriteUInt(upgid, 8)
    end
end):Read(function()
    local ret = {}

    for i = 1, net.ReadUInt(8) do
        local obj = rp.shop.Get(net.ReadUInt(8))
        ret[obj:GetUID()] = true
    end

    return ret
end):SetLocalPlayer()

nw.Register'DoorID':Write(net.WriteUInt, 32):Read(net.ReadUInt, 32)
nw.Register'DisguiseTeam':Write(net.WriteUInt, 6):Read(net.ReadUInt, 6):SetPlayer()
nw.Register'DisguiseTime':Write(net.WriteUInt, 32):Read(net.ReadUInt, 32):SetLocalPlayer()
nw.Register'DoorLocked':Write(net.WriteBool):Read(net.ReadBool)
nw.Register'Ziptied':Write(net.WriteBool):Read(net.ReadBool):SetPlayer():SetHook('ZiptieStatusChanged')

nw.Register'ZiptieCarrying':Write(function(arg)
    net.WriteUInt(arg:EntIndex(), 8)
end):Read(net.ReadUInt, 8):SetPlayer()

nw.Register'ZiptieCarrier':Write(function(arg)
    net.WriteUInt(arg:EntIndex(), 8)
end):Read(net.ReadUInt, 8):SetPlayer()

-- :SetHook('ZiptieCarrierChanged')
nw.Register'ZiptieCutting':Write(net.WriteFloat):Read(net.ReadFloat):SetLocalPlayer()

--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher