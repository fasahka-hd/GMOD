Orbit_Register(4, "Frost", function(ply)
    for i = 1, 3 do
        local pos, a = Orbit_Pos(ply, i, -1.1, 62, 49, 8)
        Orbit_Orb(pos, 34, Color(95, 220, 255), Color(245, 255, 255))
        Orbit_Sparks(pos, 8, 27, Color(210, 255, 255, 125), 6, 1.25, i)

        if Orbit_GetQuality() then
            local s = 15
            Orbit_Beam(pos + Vector(-s, 0, 0), pos + Vector(s, 0, 0), 2, Color(210, 255, 255, 120))
            Orbit_Beam(pos + Vector(0, -s, 0), pos + Vector(0, s, 0), 2, Color(210, 255, 255, 120))
            Orbit_Beam(pos + Vector(0, 0, -s), pos + Vector(0, 0, s), 2, Color(210, 255, 255, 120))
        end
    end
end)
