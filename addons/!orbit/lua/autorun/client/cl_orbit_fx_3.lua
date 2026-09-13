Orbit_Register(3, "Neon", function(ply)
    local lastA
    local lastB

    for i = 1, 4 do
        local p1, a1 = Orbit_Pos(ply, i, 1.85, 58, 35 + i * 8, 5, 0)
        local p2, a2 = Orbit_Pos(ply, i, -1.85, 58, 75 - i * 8, 5, math.pi)

        Orbit_Orb(p1, 27, Color(255, 45, 255), Color(255, 230, 255))
        Orbit_Orb(p2, 27, Color(35, 230, 255), Color(230, 255, 255))

        Orbit_Beam(p1, p2, 3, Color(170, 80, 255, 120))
        if lastA then Orbit_Beam(lastA, p1, 2, Color(255, 55, 255, 95)) end
        if lastB then Orbit_Beam(lastB, p2, 2, Color(45, 230, 255, 95)) end

        lastA = p1
        lastB = p2
    end
end)
