Orbit_Register(8, "Blood", function(ply)
    local t = CurTime()

    for i = 1, 3 do
        local pos, a = Orbit_Pos(ply, i, 1.35, 64, 50, 9)
        Orbit_Comet(pos, a, 38, Color(210, 22, 42), Color(255, 210, 210), 34)

        if Orbit_GetQuality() then
            Orbit_SetGlow()
            for k = 1, 7 do
                local p = pos + Vector(math.sin(t * 3 + k + i) * 9, math.cos(t * 2 + k) * 9, -k * 6)
                render.DrawSprite(p, 8 - k * 0.45, 8 - k * 0.45, Color(190, 15, 35, 155 - k * 13))
            end
        end
    end
end)
