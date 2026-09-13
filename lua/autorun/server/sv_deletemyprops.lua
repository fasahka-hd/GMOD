--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

resource.AddWorkshop('3114345982')
resource.AddWorkshop('3114346762')

local function isprop(ent, check)
    return string.match(ent:GetClass(), check)
end

local function DeleteEnts(ply, props)
    local tab = ents.GetAll()
    for i=1,#tab do
        local ent = tab[i]
        if (ent:CPPIGetOwner() == ply or ent.ItemOwner and ent.ItemOwner == ply) and ent:IsVehicle() then continue end
        if (ent:CPPIGetOwner() == ply or ent.ItemOwner and ent.ItemOwner == ply) and (props == 1 and isprop(ent, "prop_") or not isprop(ent, "prop_") and props == 0 or props == 2 and isprop(ent, "item_")) then
            ent:Remove()
        end
    end
end

hook.Add("PlayerSay", "RP.ChatDeleteMyEnts", function(ply, text)
    if text == "/udalitent" and ply:Alive() then
        DeleteEnts(ply, 0)
        ply:Notify(NOTIFY_CLEANUP, "Вы очистили свои энтити.")
        return ""
    elseif text == "/udalitpropi" and ply:Alive() then
        DeleteEnts(ply, 1)
        ply:Notify(NOTIFY_CLEANUP, "Вы очистили свои пропы.")
        return ""
    elseif text == "/udalitros" and ply:Alive() then
        DeleteEnts(ply, 2)
        ply:Notify(NOTIFY_CLEANUP, "Вы очистили свои хилки.")
        return ""
    end
end)

--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
