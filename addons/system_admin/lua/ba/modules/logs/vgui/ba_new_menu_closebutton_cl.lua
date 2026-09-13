--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

-- Вообще это ещё в админ меню должно было быть, но так как заказики отдельные и я не думал что буду делать что-то в таком стиле
-- Придется это тут реализовать, чтобы потом не ебаться с этим дальше..

local PANEL = {}

do
	local btnMat = Material('menu/newclose.png', 'mips')
	local btnMatOn = Material('menu/newcloseon.png', 'mips smooth')

	local drawRoundedBox = draw.RoundedBox
	local simpleText = draw.SimpleText

	local colorWhite = Color(255, 255, 255)
	local colorBlack = Color(0, 0, 0)

	function PANEL:Paint(x, y)
		local isHovered = self:IsHovered()
		local firstColor = isHovered and colorBlack or colorWhite
		local secondColor = isHovered and colorWhite or colorBlack

		if isHovered then
			drawRoundedBox(5, 0, 0, x, y, secondColor)
		end

		simpleText('Выход', 'MKfont.18', 0.05*x, 0.25*y, firstColor)

		drawRoundedBox(5, 0.57*x, 5/36*y, 0.38*x, 26/36*y, firstColor)
		simpleText('ESC', 'MKfont.18', 0.63*x, 0.25*y, secondColor)
	end
end

function PANEL:Init()
	self:SetText('')
end

vgui.Register('ba_new_menu_closebutton', PANEL, 'DButton')

--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
