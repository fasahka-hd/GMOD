Orbit_Register(1, "Matrix", function(ply)
    local center = ply:GetPos()
    local t = CurTime()

    for i = 1, 4 do
        local pos, a = Orbit_Pos(ply, i, 1.15, 66, 44 + i * 3, 7)
        Orbit_Comet(pos, a, 30, Color(35, 255, 90), Color(220, 255, 225), 34)
        Orbit_Sparks(pos, 5, 22, Color(40, 255, 110, 110), 6, -1.1, i)
    end

    if not Orbit_GetQuality() then return end

    local ang = EyeAngles()
    ang:RotateAroundAxis(ang:Right(), 90)
    ang:RotateAroundAxis(ang:Up(), -90)

    for i = 1, 9 do
        local a = t * 0.6 + i * 0.698
        local p = center + Vector(math.cos(a) * 82, math.sin(a) * 82, 82 - ((t * 32 + i * 16) % 72))
        cam.Start3D2D(p, ang, 0.1)
            draw.SimpleText(i % 2 == 0 and "01" or "10", "DermaDefaultBold", 0, 0, Color(60, 255, 120, 135), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        cam.End3D2D()
    end
end)
