Orbit_Register(5, "Electro", function(ply)
    local points = {}
    local t = CurTime()

    for i = 1, 3 do
        local pos, a = Orbit_Pos(ply, i, 2.25, 66, 55, 10)
        points[i] = pos
        Orbit_Comet(pos, a, 33, Color(65, 145, 255), Color(235, 255, 255), 30)
        Orbit_Sparks(pos, 5, 22, Color(120, 220, 255, 125), 6, -2.3, i)
    end

    if Orbit_GetQuality() then
        for i = 1, 3 do
            local a = points[i]
            local b = points[(i % 3) + 1]
            local mid = (a + b) * 0.5 + Vector(math.sin(t * 9 + i) * 12, math.cos(t * 7 + i) * 12, math.sin(t * 8 + i) * 9)
            Orbit_Beam(a, mid, 3, Color(95, 200, 255, 165))
            Orbit_Beam(mid, b, 3, Color(190, 245, 255, 135))
        end
    end
end)
