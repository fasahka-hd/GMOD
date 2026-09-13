--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

local ss = function(y)
	return y * (ScrH()/1080)
end

local function createFonts()
	surface.CreateFont('ba_new_menu_font_log', {
		name = 'Inter Bold',
		weight = 500,
		extended = true,
		size = ss(18)
	})

	surface.CreateFont('ba_new_menu_font_log_legend', {
		name = 'Inter Bold',
		weight = 400,
		extended = true,
		size = ss(14)
	})

	surface.CreateFont('ba_new_menu_font_log_utc', {
		name = 'Inter Bold',
		weight = 500,
		extended = true,
		size = ss(18)
	})

	surface.CreateFont('ba_new_menu_font_log_data', {
		name = 'Inter Bold',
		weight = 600,
		extended = true,
		size = ss(18)
	})
end

createFonts()

function ba.ui.OpenNewLogMenu()
	if IsValid(pnl) then return end

	pnl = vgui.Create('ba_new_menu_log')

	pnl:SetSize(ba.ui.NewMenuScreenScale(1380, 832))
	pnl:Center()
	pnl:MakePopup()

	pnl.OnScreenSizeChanged = createFonts
	
	pnl.OnKeyCodeReleased = function(self, keyCode)
		if keyCode == KEY_ESCAPE then
			pnl:Remove()
			gui.HideGameUI()
			return true
		end 
	end
end

--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
