CLADMEN = CLADMEN or {}
CLADMEN.OrderCooldownMin = 180
CLADMEN.OrderCooldownMax = 420
CLADMEN.DropTime = 300
CLADMEN.DropHoldTime = 3
CLADMEN.SupplyHoldTime = 1.5
CLADMEN.Reward = 2000
CLADMEN.DropsPerOrder = 3
CLADMEN.MaxActiveDrops = 3
CLADMEN.SupplyModel = "models/props_junk/cardboard_box003a.mdl"
CLADMEN.JobCheck = function(ply)
    if not IsValid(ply) then return false end
    if TEAM_CLADMEN and ply:Team() == TEAM_CLADMEN then return true end
    return false
end
CLADMEN.SupplySpawns = {
    {pos = Vector(-1702.604, -422.241, -132.969), ang = Angle(-1.056, 151.166, 0.000)},
}
CLADMEN.DropSpawns = {
    {pos = Vector(-3392.371, -4413.314, -92.743), ang = Angle(6.864, -176.232, 0.000)},
    {pos = Vector(-218.162, -4352.079, -135.969), ang = Angle(7.788, -83.435, 0.000)},
    {pos = Vector(-288.183, -1791.587, -132.469), ang = Angle(-1.584, -42.515, 0.000)},
    {pos = Vector(806.329, 1933.754, -131.969), ang = Angle(4.620, 178.621, 0.000)},
    {pos = Vector(-2220.308, -32.947, -139.969), ang = Angle(4.752, -100.066, 0.000)},
}
CLADMEN.ColorMain = Color(130, 70, 200)
CLADMEN.ColorWarn = Color(255, 80, 80)
CLADMEN.Notify = function(ply, msg, type)
    if not IsValid(ply) then return end
    if DarkRP and DarkRP.notify then
        DarkRP.notify(ply, type or 0, 6, msg)
    else
        ply:ChatPrint("[Кладмен] " .. msg)
    end
end
