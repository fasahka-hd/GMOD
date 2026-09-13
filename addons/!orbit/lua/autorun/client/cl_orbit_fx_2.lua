Orbit_Register(2, "Inferno", function(ply)
    local t = CurTime()

    for i = 1, 3 do
        local pos, a = Orbit_Pos(ply, i, 1.55, 70, 48, 12)
        Orbit_Comet(pos, a, 40, Color(255, 70, 15), Color(255, 235, 90), 42)

        if Orbit_GetQuality() then
            Orbit_SetGlow()
            for k = 1, 8 do
                local p = pos + Vector(math.sin(t * 5 + k + i) * 11, math.cos(t * 4 + k) * 11, k * 6)
                render.DrawSprite(p, 12 - k * 0.65, 12 - k * 0.65, Color(255, 100 + k * 14, 28, 155 - k * 12))
            end
        end
    end
end)
