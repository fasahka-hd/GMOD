--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

nw.Register('IsBanned', {
    Read     = net.ReadBool,
    Write    = net.WriteBool,
    LocalVar = true
})

nw.Register('BanReason', {
    Read     = net.ReadString,
    Write    = net.WriteString,
    LocalVar = true
})

nw.Register('BanAdmin', {
    Read     = net.ReadString,
    Write    = net.WriteString,
    LocalVar = true
})

nw.Register('BanAdminSteamID', {
    Read     = net.ReadString,
    Write    = net.WriteString,
    LocalVar = true
})

local entGetNetVar = FindMetaTable('Entity').GetNetVar

function PLAYER:IsBanned()
    return (entGetNetVar(self, 'IsBanned') == true)
end


--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
