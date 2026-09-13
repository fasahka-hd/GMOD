if not player.Iterator then
    function player.Iterator()
        local plys = player.GetAll()
        local i = 0
        return function()
            i = i + 1
            if plys[i] then
                return i, plys[i]
            end
        end
    end
end

enc = enc or {}

function enc.w(v)
    return math.Round(v * (ScrW() / 1920))
end

function enc.h(v)
    return math.Round(v * (ScrH() / 1080))
end

enc.clrs = enc.clrs or {
    white  = Color(255, 255, 255, 255),
    whitea = Color(255, 255, 255, 150),
}

if CLIENT then
    local function n(o)
        local p, q = ScrW(), ScrH()
        return math.Round(o * math.min(p, q) / 1080)
    end

    surface.CreateFont('MKfont.24', {
        font      = 'Tahoma',
        size      = n(24),
        weight    = 500,
        extended  = true,
        antialias = true,
    })

    surface.CreateFont('MKfont.16', {
        font      = 'Tahoma',
        size      = n(16),
        weight    = 500,
        extended  = true,
        antialias = true,
    })

    surface.CreateFont('MKfont.14', {
        font      = 'Tahoma',
        size      = n(14),
        weight    = 500,
        extended  = true,
        antialias = true,
    })
end

local function IncludeDir(path)
    local f, d = file.Find(path .. '/*', 'LUA')
    for k, v in ipairs(f) do
        local a = path .. '/' .. v
        local pref = v:sub(1, 3)
        if pref == 'cl_' then
            if CLIENT then
                include(a)
            else
                AddCSLuaFile(a)
            end
        elseif pref == 'sv_' then
            if SERVER then
                include(a)
            end
        else
            if SERVER then
                AddCSLuaFile(a)
            end
            include(a)
        end
    end
    for k, v in ipairs(d) do
        IncludeDir(path .. '/' .. v)
    end
end

IncludeDir('scoreboard')

if SERVER then
    resource.AddWorkshop("3114346762")
    resource.AddWorkshop("3114345982")
end
