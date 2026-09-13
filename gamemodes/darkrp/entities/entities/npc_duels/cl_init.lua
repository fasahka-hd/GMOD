include("shared.lua")

local CurTime = CurTime
local LocalPlayer = LocalPlayer
local sin = math.sin
local pi = math.pi
local Start3D2D = cam.Start3D2D
local End3D2D = cam.End3D2D
local SimpleTextOutlined = draw.SimpleTextOutlined

local OFFSET = Vector(0, 0, 78)
local WHITE = Color(255, 255, 255)
local BLACK = Color(0, 0, 0)
local MAX_DISTANCE = 130000

function ENT:Draw()
	self:DrawModel()

	local pos = self:GetPos()
	local ply = LocalPlayer()
	if not IsValid(ply) then return end

	if pos:DistToSqr(ply:GetPos()) > MAX_DISTANCE then return end

	local ang = self:GetAngles()
	ang:RotateAroundAxis(ang:Forward(), 90)
	ang:RotateAroundAxis(ang:Right(), -90)
	ang:RotateAroundAxis(ang:Right(), sin(CurTime() * pi) * -45)

	Start3D2D(pos + OFFSET, ang, 0.025)
		SimpleTextOutlined("Дуэлянт", "Duels.3D2D", 0, 0, WHITE, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 1, BLACK)
	End3D2D()
end
