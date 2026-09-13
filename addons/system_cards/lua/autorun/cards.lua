enc = enc or {}
enc.cardsmenu = enc.cardsmenu or {}

if SERVER then
    resource.AddWorkshop('3114345982')
end

local function IncludeDir(path)
    local f,d = file.Find(path..'/*','LUA')

    for k, v in ipairs(f) do 
        local a = path..'/'..v

        local pref = v:sub(1,3)
        if pref == 'cl_' then 
            if CLIENT then 
                include(a)
            else 
                AddCSLuaFile(a)
            end
        elseif pref == 'sv_' then
            include(a)
        else 
            AddCSLuaFile(a)
            include(a)
        end
    end

    for k,v in ipairs(d) do 
        IncludeDir(path..'/'..v)
    end
end

hook.Add('OnGamemodeLoaded', 'enc.cards.loaded', function()
    IncludeDir('cards')
end)
