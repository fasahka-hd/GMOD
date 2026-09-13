local GLASS_NAMES = {}
table.insert(GLASS_NAMES, 'ws')
for i = 1, 196 do
    table.insert(GLASS_NAMES, 'ws' .. i)
end
local function RestoreGlass(glassName)
    local oldGlass = ents.FindByName(glassName)[1]
    if not IsValid(oldGlass) then return end
    local pos = oldGlass:GetPos()
    local ang = oldGlass:GetAngles()
    oldGlass:Remove()
    timer.Simple(180, function()
        local newGlass = ents.Create('func_breakable_surf')
        if IsValid(newGlass) then
            newGlass:SetName(glassName)
            newGlass:SetPos(pos)
            newGlass:SetAngles(ang)
            newGlass:Spawn()
            newGlass:Activate()
        end
    end)
end
hook.Add('GlassBroken', 'RestoreGlassHook', function(glassName)
    for _, name in ipairs(GLASS_NAMES) do
        if name == glassName then
            RestoreGlass(glassName)
            return
        end
    end
end)