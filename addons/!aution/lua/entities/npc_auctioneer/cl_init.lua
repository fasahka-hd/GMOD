include('shared.lua')
ENT.RenderGroup = RENDERGROUP_BOTH

local function InverseLerp( pos, p1, p2 )
    local range = 0
    range = p2-p1

    if range == 0 then return 1 end
    return ((pos - p1)/range)
end

local color_white = ui.col.White:Copy()
local color_black = ui.col.Black:Copy()

local complex_off = Vector(0, 0, 9)
local simple_off = Vector(0, 0, 75)

local ang = Angle(0, 90, 90)
local foodshop = Material 'materials/hud/scrutiny.png'
	
function ENT:Draw()
	self:DrawModel()

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

	cam.Start3D2D(pos, ang, 0.03)
		surface.SetDrawColor(255, 255, 255, alpha)

		surface.SetMaterial(foodshop)
		surface.DrawTexturedRect(-55, -246 + x - 10, 128, 128)
		draw.SimpleTextOutlined('Аукцион', '3d2d', 0, x-10, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM, 1, color_black)
	cam.End3D2D()

end