include("shared.lua")

local color_white = ui.col.White:Copy()
local color_black = ui.col.Black:Copy()
local complex_off = Vector(0, 0, 9)
local simple_off = Vector(0, 0, 75)
local ang = Angle(0, 90, 90)

function ENT:Draw()
	self:DrawModel()
	local pos
	local bone = self:LookupBone('ValveBiped.Bip01_Head1')
	if bone then
		pos = self:GetBonePosition(bone) + complex_off
	else
		pos = self:GetPos() + simple_off
	end
	ang.y = (LocalPlayer():EyeAngles().y - 90)
	local inView, dist = self:InDistance(150000)
	if (not inView) then return end
	local alpha = 255 - (dist/590)
	color_white.a = alpha
	color_black.a = alpha
	local x = math.sin(CurTime() * math.pi) * 30
	if self:GetDTInt(0) - CurTime() > 0 then
		cam.Start3D2D(pos, ang, 0.03)
		draw.SimpleTextOutlined('Мусорный бак', '3d2d', 0, 1100 + x, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM, 1, color_black)
		draw.SimpleTextOutlined(string.FormattedTime(self:GetDTInt(0) - CurTime(), "%01i:%02i"), '3d2d', 0, 1250 + x, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM, 1, color_black)
	cam.End3D2D()
		else
	cam.Start3D2D(pos, ang, 0.03)
		draw.SimpleTextOutlined('Мусорный бак', '3d2d', 0, 1100 + x, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM, 1, color_black)
	cam.End3D2D()
end
end