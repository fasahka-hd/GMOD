Orbit_Register(6, "Void", function(ply)
    for i = 1, 3 do
        local pos, a = Orbit_Pos(ply, i, 0.85, 72, 52, 8)

        render.SetColorMaterial()
        render.DrawSphere(pos, 9, 10, 10, Color(8, 0, 18, 255))

        Orbit_Comet(pos, a, 35, Color(120, 45, 255), Color(55, 15, 115), 38)
        Orbit_Sparks(pos, 9, 34, Color(160, 90, 255, 115), 7, 1.3, i * 3)
    end
end)
