eui.container = eui.container or {}

local scrW, scrH = ScrW(), ScrH()

hook.Add('OnScreenSizeChanged', 'eui.battlepass:OnScreenSizeChanged', function(_, _, w, h)
	scrW, scrH = w, h
end)

local roundedBox = paint.roundedBoxes.roundedBox

local sw, sh = eui.ScaleWide, eui.ScaleTall

eui.AddMaterial('materials/eui/containers/', 'auction')
eui.AddMaterial('materials/eui/containers/', 'auction 1')
eui.AddMaterial('materials/eui/bonus/', 'gift')

function eui.container.Menu()
	local tbl = eui.nets.ReadTable()

	local frame = vgui.Create('eui.Frame')
	frame:SetSize(scrW, scrH)
	frame:RunAnimation()
	frame:MakePopup()
	frame:SetCloseButton(KEY_ESCAPE)
	function frame:Paint(w, h)
		local x, y = self:LocalToScreen(0, 0)
		eui.DrawBlur(0, x, y, w, h, nil, eui.Color('000000', 78))
	end

	local header = frame:Add('Panel')
	header:Dock(TOP)
	header:Margin(sw(50), sh(37), sw(33))
	header:SetTall(sh(74))

	local titlePanel = header:Add('Panel')
	titlePanel:Dock(LEFT)
	titlePanel:SetWide(sw(19) + sw(31) + sw(25) + sh(50) + sh(205))

	local title = titlePanel:Add('eui.Label')
	title:SetPos(sw(50) + sh(50), sh(16))
	title:SetInfo('ArizonaRP', eui.Font('20:SemiBold'))

	local desc = titlePanel:Add('eui.Label')
	desc:SetPos(sw(50) + sh(50), sh(38))
	desc:SetInfo('Аукцион за контейнеры', eui.Font('16:Medium'))
	desc:SetColor(eui.Color('FFFFFF', 50))

	local close = header:Add('eui.Close')
	close:Dock(RIGHT)
	close:Margin(0, sh(10), 0, sh(10))
	close:SetFrame(frame)

	eui.container.mainPage(frame, tbl)

	return frame
end

net.Receive('eui.container.Open', eui.container.Menu)