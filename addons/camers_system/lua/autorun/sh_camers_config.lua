CamersSystem = CamersSystem or {}

CamersSystem.CAMERAS = {
    { name = "ВОКЗАЛ",              pos = Vector(-2064.421875, -754.540222, -56.751419),   ang = Angle(9.960951, -81.808960, 0) },
    { name = "ПОЛИЦЕЙСКИЙ УЧАСТОК", pos = Vector(-1498.300781, -109.615128, 18.353390),    ang = Angle(25.084938, 139.172943, 0) },
    { name = "ПЛЯЖ",                pos = Vector(4290.242188, -4627.738770, -90.165268),   ang = Angle(11.793899, 98.551865, 0) },
    { name = "ЭЛИТНЫЙ РАЙОН",       pos = Vector(-2252.920410, -7315.103516, -11.175114),  ang = Angle(16.265081, 111.359001, 0) },
    { name = "ПЛОЩАДКА",            pos = Vector(2374.313721, 7641.370605, 29.879814),     ang = Angle(19.036394, 45.842365, 0) },
}

CamersSystem.CAM_COUNT = #CamersSystem.CAMERAS
for i = 1, CamersSystem.CAM_COUNT do CamersSystem.CAMERAS[i].broken = false end

CamersSystem.REPAIR_DIST_SQR = 250 * 250
CamersSystem.REPAIR_TIME     = 5
CamersSystem.AUTO_REPAIR     = 300
CamersSystem.YAW_LIMIT       = 60
CamersSystem.FOV_MIN         = 40
CamersSystem.FOV_MAX         = 90
CamersSystem.FOV_DEF         = 70

function CamersSystem.IsPolice(ply)
    if ply.isCP then return ply:isCP() end
    local tn = team.GetName(ply:Team()):lower()
    return tn:find("police") ~= nil or tn:find("полиц") ~= nil
end

if CLIENT then
    surface.CreateFont("CamSys_Title",   { font = "Roboto",      size = 13, weight = 900, antialias = true })
    surface.CreateFont("CamSys_Btn",     { font = "Roboto",      size = 13, weight = 700, antialias = true })
    surface.CreateFont("CamSys_HUD",     { font = "Courier New", size = 13, weight = 700, antialias = true })
    surface.CreateFont("CamSys_Disc",    { font = "Courier New", size = 36, weight = 900, antialias = true, italic = true })
    surface.CreateFont("CamSys_ZoomBtn", { font = "Roboto",      size = 12, weight = 700, antialias = true })
    surface.CreateFont("CamSys_Repair",  { font = "Roboto",      size = 18, weight = 700, antialias = true })
    surface.CreateFont("CamSys_Marker",  { font = "Roboto",      size = 16, weight = 700, antialias = true })
    surface.CreateFont("CamSys_Term",    { font = "Roboto",      size = 16, weight = 700, antialias = true })
    surface.CreateFont("CamSys_TermSm",  { font = "Roboto",      size = 13, weight = 500, antialias = true })
    surface.CreateFont("CamSys_Access",  { font = "Roboto",      size = 28, weight = 900, antialias = true })
    surface.CreateFont("CamSys_Label",   { font = "Roboto",      size = 18, weight = 900, antialias = true })
    surface.CreateFont("CamSys_Field",   { font = "Roboto",      size = 16, weight = 700, antialias = true })
    surface.CreateFont("CamSys_Status",  { font = "Roboto",      size = 14, weight = 500, antialias = true })
    surface.CreateFont("CamSys_Interact",  { font = "Roboto", size = 48, weight = 700, antialias = true })
    surface.CreateFont("CamSys_InteractSm", { font = "Roboto", size = 32, weight = 500, antialias = true })
end

print("[CAMERS SYSTEM] Loaded v1.0")
