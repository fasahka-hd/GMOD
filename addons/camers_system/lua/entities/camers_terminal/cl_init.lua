include("shared.lua")
ENT.RenderGroup = RENDERGROUP_BOTH

local simple_off = Vector(0, 0, 30)
local ang = Angle(0, 90, 90)

local color_white = Color(255, 255, 255)
local color_black = Color(0, 0, 0)
local color_red   = Color(200, 50, 50)
local INTERACT_DIST_SQR = 150000

function ENT:Draw()
    self:DrawModel()

    local pos = self:GetPos() + simple_off

    ang.y = (LocalPlayer():EyeAngles().y - 90)

    local ply = LocalPlayer()
    local dist = ply:GetPos():DistToSqr(self:GetPos())
    if dist > INTERACT_DIST_SQR then return end

    local alpha = math.Clamp(255 - (dist / 590), 0, 255)
    local col_w = Color(255, 255, 255, alpha)
    local col_b = Color(0, 0, 0, alpha)
    local col_r = Color(200, 50, 50, alpha)

    local isCP = CamersSystem.IsPolice(ply)
    local x = math.sin(CurTime() * math.pi) * 30

    cam.Start3D2D(pos, ang, 0.03)
        if isCP then
            draw.SimpleTextOutlined("Нажмите [E], чтобы открыть камеры", "CamSys_Interact", 0, x - 10, col_w, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM, 1, col_b)
        else
            draw.SimpleTextOutlined("Доступ запрещён", "CamSys_InteractSm", 0, x - 10, col_r, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM, 1, col_b)
        end
    cam.End3D2D()
end
