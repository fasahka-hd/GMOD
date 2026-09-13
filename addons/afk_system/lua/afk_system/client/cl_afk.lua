include("afk_system/sh_config.lua")

if not AFKSystem.IsCorrectMap() then
    print("[AFK System] Клиентская часть отключена: другая карта.")
    return
end

surface.CreateFont("AFKSystem_ZoneTitle", {
    font = "Arial",
    size = 64,
    weight = 900,
    extended = true
})

net.Receive("AFKSystem_Notify", function()
    local message = net.ReadString()
    local color = net.ReadColor()

    chat.AddText(color, message)
end)

local function DrawZoneTitle()
    if not AFKSystem.Config.DrawZone then return end

    local pos = AFKSystem.GetZoneTitlePos()
    local ang = AFKSystem.Config.ZoneTitleAngle or Angle(0, 90, 90)

    for _, yawAdd in ipairs({0, 180}) do
        local drawAng = Angle(ang.p, ang.y + yawAdd, ang.r)

        local rgb = HSVToColor((CurTime() * 120) % 360, 1, 1)

        cam.Start3D2D(pos, drawAng, 0.25)
            draw.SimpleTextOutlined(
                AFKSystem.Config.ZoneTitle or "АФК зона заработка",
                "AFKSystem_ZoneTitle",
                0,
                0,
                rgb,
                TEXT_ALIGN_CENTER,
                TEXT_ALIGN_CENTER,
                3,
                Color(0, 0, 0, 230)
            )
        cam.End3D2D()
    end
end

local function DrawZoneBox()
    if not AFKSystem.Config.DrawZone then return end
    if not AFKSystem.ZoneMins or not AFKSystem.ZoneMaxs then return end

    local mins = AFKSystem.ZoneMins
    local maxs = AFKSystem.ZoneMaxs
    local size = maxs - mins
    local center = mins + size / 2

    render.SetColorMaterial()
    render.DrawWireframeBox(
        center,
        Angle(0, 0, 0),
        -size / 2,
        size / 2,
        Color(0, 255, 0, 160),
        true
    )
end

hook.Add("PostDrawTranslucentRenderables", "AFKSystem_DrawZone", function()
    DrawZoneBox()
    DrawZoneTitle()
end)

print("[AFK System] Клиентская часть загружена!")
