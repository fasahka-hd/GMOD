include('shared.lua')

function ENT:Initialize()
end

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
		draw.SimpleText('Ограбление', 'MSB_30', -120, 80, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
		draw.SimpleText('Нажми "E", чтобы взаимодействовать', 'MM_20', -120, 110, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
	cam.End3D2D()
end

function ENT:Think()
end

local frame

local function openMenuRobbery()
	local ent = net.ReadEntity()
	if IsValid(frame) then return end

	frame = vgui.Create('eui.Frame')
	frame:SetSize(705, 773)
	frame:MakePopup()
	frame:RunAnimation()
	frame:SetCloseButton(KEY_ESCAPE)
	frame.Paint = function(self, w, h)
		draw.RoundedBox(8, 0, 0, w, h, Color(22, 22, 22, 255))
	end

	local name = frame:Add('eui.Label')
	name:SetPos(33, 40)
	name:SetInfo('Ограбление', eui.Font('32:SemiBold'))

	local desc = frame:Add('eui.Label')
	desc:SetPos(33, 80)
	desc:SetInfo('Оружейный склад', eui.Font('18:Medium'))
	desc:SetColor(eui.Color('FFFFFF', 50))

	local close = frame:Add('eui.Close')
	close:SetPos(frame:GetWide() - close:GetWide() - 32, 46)
	close:SetFrame(frame)

	local icon = Material('ui/crime.png')
	local drawing = frame:Add('Panel')
	drawing:SetSize(640, 190)
	drawing:SetPos(33, 115)
	function drawing:Paint(w, h)
		eui.DrawMaterial(icon, 0, 0, w, h)
	end

	local conditions = frame:Add('eui.Label')
	conditions:SetPos(33, 339)
	conditions:SetInfo('Условия:', eui.Font('18:Medium'))
	conditions:SetColor(eui.Color('FFFFFF', 50))

	local icon = Material('ui/group_user.png')
	local condition = frame:Add('eui.NewPanel')
	condition:SetPos(33, 367)
	condition:SetTall(54)
	condition:SetMaterial(icon, 24, color_white, 14)
	condition:SetInfo('Необходимо ' .. ent:GetNWInt('Robbers') .. ' участника', eui.Font('15:Medium'), color_white, 30)
	condition:SetColor(eui.Color('1E1E1E'))
	condition:SetAlign(0)
	condition:SetOffset(17)
	condition:SizeToContent()

	local condition2 = frame:Add('eui.NewPanel')
	timer.Simple(0.1, function()
		condition2:SetPos(47 + condition:GetWide(), 367)
	end)
	condition2:SetTall(54)
	condition2:SetMaterial(icon, 24, color_white, 14)
	condition2:SetInfo('Время ограбления ' .. ent:GetNWInt('Time') .. ' сек.', eui.Font('15:Medium'), color_white, 30)
	condition2:SetColor(eui.Color('1E1E1E'))
	condition2:SetAlign(0)
	condition2:SetOffset(17)
	condition2:SizeToContent()

	local rewards = frame:Add('eui.Label')
	rewards:SetPos(33, 445)
	rewards:SetInfo('Награда:', eui.Font('18:Medium'))
	rewards:SetColor(eui.Color('FFFFFF', 50))

	local scroll = frame:Add('DHorizontalScroller')
	scroll:SetPos(33, 483)
	scroll:SetSize(640, 172)
	scroll:SetOverlap(-11)
	function scroll.btnLeft:Paint(w, h) end
	function scroll.btnRight:Paint(w, h) end

	local data = ent:GetNWString('Data')
	data = util.JSONToTable(data) or {}

	for k, v in next, data do
		local panel = scroll:Add('Panel')
		panel:Dock(LEFT)
		panel:SetWide(206)
		panel:DockMargin(0, 0, 11, 0)
		function panel:Paint(w, h)
			draw.RoundedBox(8, 0, 0, w, h, eui.Color('FFFFFF', 5))
			draw.RoundedBox(8, 1, 1, w - 2, h - 2, eui.Color('1D1D1D'))
		end

		local name = panel:Add('eui.Label')
		name:SetPos(11, 11)
		name:SetInfo(isbool(v) and weapons.Get(k).PrintName or v, eui.Font('20:SemiBold'))

		local model = panel:Add('DModelPanel')
		model:Dock(FILL)
		model:DockMargin(20, 50, 20, 20)
		model:SetModel(isbool(v) and weapons.Get(k).WorldModel or 'models/props/cs_assault/money.mdl')

		local size = 122
		local mn, mx = model.Entity:GetRenderBounds()
		size = math.max(size, math.abs(mn.x) + math.abs(mx.x))
		size = math.max(size, math.abs(mn.y) + math.abs(mx.y))
		size = math.max(size, math.abs(mn.z) + math.abs(mx.z))

		model:SetFOV(10)
		model:SetCamPos(Vector(size, size, size))
		model:SetLookAt((mn + mx) * 0.85)
		model:NoClipping(true)
		model.LayoutEntity = function(s, ent) return end

		scroll:AddPanel(panel)
	end

	local start = frame:Add('eui.Button')
	start:SetPos(33, 689)
	start:SetSize(640, 59)
	start:SetInfo('Начать ограбление', eui.Font('18:SemiBold'))
	function start:Paint(w, h)
		local bgColor = self:IsHovered() and Color(1, 89, 224) or Color(30, 30, 30)
		draw.RoundedBox(8, 0, 0, w, h, bgColor)
		draw.SimpleText(self:GetText(), eui.Font('18:SemiBold'), w / 2, h / 2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		return true
	end
	function start:DoClick()
		net.Start('eui.startGrab')
		net.WriteEntity(ent)
		net.SendToServer()
	end
end

net.Receive('handler_robbery_system_v1', openMenuRobbery)

hook.Add('HUDPaint', 'grab', function()
	local remaining = (LocalPlayer():GetNetVar('grab') or 0) - CurTime()
	if remaining > 0 then
		local w = eui.GetTextSize('Ограбление: ' .. math.floor(remaining) .. ' сек.', eui.Font('14:Medium'))
		draw.RoundedBox(8, 20, 20, w + 20, 50, eui.Color('131313'))
		draw.SimpleText('Ограбление: ' .. math.floor(remaining) .. ' сек.', eui.Font('14:Medium'), 30, 45, color_white, 0, 1)
	end
end)
