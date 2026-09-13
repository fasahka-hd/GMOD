--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

local ceil = math.ceil
local function ss(x, y)
	return ceil((x or 0)*ScrW()/1920), ceil((y or 0)*ScrH()/1080)
end

ba.ui.NewMenuScreenScale = ss

local function createFonts()
	surface.CreateFont('ba_new_menu_font_title', {
		font = 'Montserrat Bold',
		size = select(2, ss(nil, 31)),
		extended = true,
		weight = 700,
	})

	surface.CreateFont('ba_new_menu_font_label', {
		font = 'Montserrat Bold',
		size = select(2, ss(nil, 18)),
		extended = true,
		weight = 400,
	})

	surface.CreateFont('ba_new_menu_font_player', {
		font = 'Montserrat Bold',
		size = select(2, ss(nil, 16)),
		extended = true,
		weight = 600,
	})

	surface.CreateFont('ba_new_menu_font_combobox', {
		font = 'Montserrat Bold',
		size = select(2, ss(nil, 20)),
		extended = true,
		weight = 500,
	})

	surface.CreateFont('ba_new_menu_font_desc', {
		font = 'Montserrat Bold',
		size = select(2, ss(nil, 14)),
		extended = true,
		weight = 400,
	})

	surface.CreateFont('ba_new_menu_font_textinput', {
		font = 'Montserrat Bold',
		size = select(2, ss(nil, 16)),
		extended = true,
		weight = 500,
	})

	surface.CreateFont('ba_new_menu_font_exec', {
		font = 'Montserrat Bold',
		size = select(2, ss(nil, 18)),
		extended = true,
		weight = 500,
	})

    surface.CreateFont('ba_new_menu_font_exit', {
        font = 'Montserrat Bold',
        size = select(2, ss(nil, 14)),
        extended = true,
        weight = 100,
    })
end

createFonts() 

local function changeSize(pnl)
	createFonts()

	local width, height = ss(1380, 867)
	pnl:SetSize(width, height)
	pnl:Center()
end

function ba.ui.OpenNewMenu()
    local panel = vgui.Create('ba_new_menu')
    changeSize(panel)

    panel.OnScreenSizeChanged = changeSize

    local lPly = LocalPlayer()

    panel.OnKeyCodeReleased = function(pnl, keyCode)
        if keyCode == KEY_ESCAPE then
            pnl:Remove()
            gui.HideGameUI()
            return true
        end 
    end

    panel:MakePopup()
end

--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
