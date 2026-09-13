--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

eui.nets = eui.nets or {}

local nets = eui.nets

function nets.WriteTable(tbl)
    assert(tbl, 'Долбаеб, у тебя tbl - nil, ты аргумент не ввел сука')
    assert(istable(tbl), 'Долбаеб, у тебя блять tbl - не таблица сука конченый')

    local encoded = pon.encode(tbl)
    local int = #encoded

    net.WriteUInt(int, 32)
    net.WriteData(encoded, int)
end

function nets.ReadTable()
    local int = net.ReadUInt(32)
    local data = net.ReadData(int)
    local success, decoded = pcall(pon.decode, data)

    if success then
        return decoded
    end

    return {}
end

--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
