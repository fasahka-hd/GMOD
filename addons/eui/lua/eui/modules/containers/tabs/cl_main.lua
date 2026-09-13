local scrW, scrH = ScrW(), ScrH()

hook.Add('OnScreenSizeChanged', 'eui.container.Main:OnScreenSizeChanged', function(_, _, w, h)
	scrW, scrH = w, h
end)

local roundedBox = paint.roundedBoxes.roundedBox
local drawOutline = paint.outlines.drawOutline

local sw, sh = eui.ScaleWide, eui.ScaleTall

local function panelCount(layout)
	local children = layout:GetChildren()
	local count = 0
	for _, panel in ipairs(children) do
		if not IsValid(panel) then continue end
		local x, y = panel:GetPos()
		if count == 0 or x > children[count]:GetPos() then
			count = count + 1
		end
	end
	return count
end

local function switchPanel(oldPage, page)
	local panel1 = oldPage
	panel1:MoveTo(panel1:GetX(), scrH, 0.6)

	local panel = page
	panel:SetY(fromback and panel1:GetTall() or -panel1:GetTall())
	panel:MoveTo(panel1:GetX(), panel1:GetY(), 0.6)
end

function eui.container.mainPage(frame, tbl)
	local scroll = frame:Add('eui.ScrollPanel')
	scroll:SetSize(scrW - sh(83), sh(776))
	scroll:SetPos(sw(50), sh(239))

	local title = scroll:Add('eui.Label')
	title:Dock(TOP)
	title:SetInfo('Контейнеры:', eui.Font('20:Medium'))
	title:SetColor(eui.Color('FFFFFF', 50))

	local layout = scroll:Add('DIconLayout')
	layout:Dock(FILL)
	layout:Margin(0, sh(15))
	layout:SetSpaceX(sw(16))
	layout:SetSpaceY(sh(28))

	for k, v in next, eui.container.containers do
		if not tbl[k] then continue end

		local item = layout:Add('eui.container:Item')
		item:SetSize(348, 227)
		item:SetRarity(v.rarity)
		item:SetName('Контейнер №' .. k)
		item:SetTime(tbl[k])
		function item:PerformLayout(w, h)
			local count = panelCount(layout)
			local size = 5 * sh(348) + 6 * sw(16)
			local dif = layout:GetWide() - size
			local wsize = dif / 5 - scroll:GetVBar():GetWide()
			local sz = sh(348) + wsize
			self:SetSize(sz, sz * 0.7)
		end
		function item:DoClick()
			if IsValid(frame.scroll) then return end
			switchPanel(scroll, eui.container.placeBid(frame, v, k, tbl))
		end
	end

	return scroll
end
