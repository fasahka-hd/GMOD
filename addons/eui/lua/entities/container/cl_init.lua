include('shared.lua')

ENT.RenderGroup = RENDERGROUP_OPAQUE

local color_gray_trans = Color(20, 20, 20, 235)

function ENT:Draw()
	self:DrawModel()

	if LocalPlayer():GetPos():DistToSqr(self:GetPos()) >= (CH_CryptoCurrencies and CH_CryptoCurrencies.Config and CH_CryptoCurrencies.Config.DistanceTo3D2D or 100000) then
		return
	end

	local Ang = self:GetAngles()
	local AngEyes = LocalPlayer():EyeAngles()

	Ang:RotateAroundAxis(Ang:Forward(), 90)
	Ang:RotateAroundAxis(Ang:Right(), -90)

	cam.Start3D2D(self:GetPos() + self:GetUp() * 85, Angle(0, AngEyes.y - 90, 90), 0.08)
		draw.RoundedBox(6, -140, 40, 350, 110, color_gray_trans)
		draw.SimpleText('Контейнеры', 'MSB_30', -120, 80, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
		draw.SimpleText('Нажми "E", чтобы взаимодействовать', 'MM_20', -120, 110, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
	cam.End3D2D()
end
