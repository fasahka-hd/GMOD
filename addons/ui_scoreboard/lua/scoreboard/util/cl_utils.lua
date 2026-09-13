local newfont = surface.CreateFont

local function n(o)
    local p, q = ScrW(), ScrH()
    local min = math.min
    return math.Round(o * min(p, q) / 1080)
end

do
    newfont('Exo2Font15', {
        font      = 'Tahoma',
        weight    = 600,
        size      = n(15),
        extended  = true,
        antialias = true,
    })
end

do
    newfont('IB_24', {
        font      = 'Tahoma',
        weight    = 500,
        size      = enc.h(26),
        extended  = true,
        antialias = true,
    })

    newfont('IB_20', {
        font      = 'Tahoma',
        weight    = 500,
        size      = enc.h(20),
        extended  = true,
        antialias = true,
    })

    newfont('MB_12', {
        font      = 'Tahoma',
        weight    = 500,
        size      = enc.h(14),
        extended  = true,
        antialias = true,
    })

    newfont('M_12', {
        font      = 'Tahoma',
        weight    = 500,
        size      = enc.h(14),
        extended  = true,
        antialias = true,
    })
end
