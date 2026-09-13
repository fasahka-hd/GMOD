Orbit_Register(7, "Holy", function(ply)
    for i = 1, 3 do
        local pos, a = Orbit_Pos(ply, i, 0.95, 64, 53, 7)
        Orbit_Orb(pos, 43, Color(255, 212, 95), Color(255, 255, 245))

        if Orbit_GetQuality() then
            Orbit_Beam(pos + Vector(0, 0, 8), pos + Vector(0, 0, 34), 3, Color(255, 240, 160, 110))
            Orbit_Beam(pos + Vector(-13, 0, 22), pos + Vector(13, 0, 22), 2, Color(255, 245, 190, 95))
            Orbit_Sparks(pos, 8, 26, Color(255, 245, 170, 125), 7, 0.9, i)
        end
    end
end)
