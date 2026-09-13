--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

local PANEL = {}

local function ss( w )
	return w * ( ScrW() / 1920 )
end

local addl, marginBoth = ss(5), ss(37)

do
	local function resizeElements(pnl, x, y)
		local size = pnl:Scale(nil, 36)
		local sizeX = size*(110/36)

		pnl.closeButton:SetSize(ss(90)+addl, ss(26))

		local xPos = x - pnl:Scale(23) - sizeX 
		pnl.closeButton:SetPos(pnl:GetWide()-ss(29)-ss(90), ss(35))

		pnl.leftSize:SetWide(pnl:Scale(634))
	end

	PANEL.PerformLayout = resizeElements
end

function PANEL:Scale(x ,y)
	local width, height = self:GetSize()

	if x then
		if y then
			return x*width/1380, y*height/867
		else
			return x*width/1380
		end
	elseif y then
		return y*height/867
	end
end

function PANEL:OnCommandChanged(cmd)
	self.leftSize:UpdateArgs(self.leftSize.currentPlayer, cmd)
end

do
	local btnMat = Material('menu/newclose.png', 'mips')
	local btnMatOn = Material('menu/newcloseon.png', 'mips smooth')

	local drawRoundedBox = draw.RoundedBox
	local simpleText = draw.SimpleText

	local function LerpColor( fr, cstart, cend )
	return Color( Lerp(fr, cstart.r, cend.r), Lerp(fr, cstart.g, cend.g), Lerp(fr, cstart.b, cend.b), Lerp(fr, cstart.a, cend.a) )
end

	local setMaterial = surface.SetMaterial
	local setDrawColor = surface.SetDrawColor
	local drawTexturedRect = surface.DrawTexturedRect
	local _w, rM = ss(38), ss(7)

	local function paint(btn,w,h)
		btn.lerpHover = 0
        btn.lerpHover = math.Clamp(btn:IsHovered() and btn.lerpHover + FrameTime()*3 or btn.lerpHover - FrameTime()*3, 0, 1)
        draw.RoundedBox(6,0,0,w,h, LerpColor(btn.lerpHover,Color(255,255,255,0),color_white) )

        draw.RoundedBox(5,w-_w,0,_w,h,color_white)

        draw.SimpleText("Выход", "door::exit", addl, h*.5, LerpColor(btn.lerpHover,color_white,color_black), 0, 1)
        draw.SimpleText("Esc", "door::exit", w-rM, h*.5, color_black, 2, 1)
    
	end

	function PANEL:Init()
		self.leftSize = self:Add('ba_new_menu_leftside')
		self.leftSize:Dock(LEFT)

		self.rightSide = self:Add('ba_new_menu_rightside')
		self.rightSide:Dock(FILL)

		self.closeButton = self:Add('DButton')
		self.closeButton:SetText('')

		self.closeButton.DoClick = function(btn)
			self:Remove()
		end

		self.closeButton.Paint = paint

	end
end


do
	local color = Color(42,43,46)
	local gradColor = Color(218, 62, 68, 25)
	local drawRoundedBox = draw.RoundedBox
	local gradMat = Material("vgui/gradient-u")

	local function DrawRoundedGradient(x, y, radius)
		-- Сохраняем красивый градиент, но обрезаем его по скруглённой маске.
		-- Без stencil обычный surface.DrawTexturedRect рисуется квадратом
		-- и в углах видны полупрозрачные квадратные артефакты.
		render.ClearStencil()
		render.SetStencilEnable(true)
		render.SetStencilWriteMask(1)
		render.SetStencilTestMask(1)
		render.SetStencilReferenceValue(1)
		render.SetStencilCompareFunction(STENCILCOMPARISONFUNCTION_ALWAYS)
		render.SetStencilPassOperation(STENCILOPERATION_REPLACE)
		render.SetStencilFailOperation(STENCILOPERATION_KEEP)
		render.SetStencilZFailOperation(STENCILOPERATION_KEEP)

		-- Пишем только stencil-маску, не трогая цветовой буфер.
		render.OverrideColorWriteEnable(true, false)
		drawRoundedBox(radius, 0, 0, x, y, color_white)
		render.OverrideColorWriteEnable(false)

		render.SetStencilCompareFunction(STENCILCOMPARISONFUNCTION_EQUAL)
		render.SetStencilPassOperation(STENCILOPERATION_KEEP)

		surface.SetMaterial(gradMat)
		surface.SetDrawColor(gradColor)
		surface.DrawTexturedRect(0, 0, x, y)

		render.SetStencilEnable(false)
		render.ClearStencil()
	end

	function PANEL:Paint(x, y)
		drawRoundedBox(15, 0, 0, x, y, color)
		DrawRoundedGradient(x, y, 15)
	end
end

vgui.Register('ba_new_menu', PANEL, 'EditablePanel')

--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
