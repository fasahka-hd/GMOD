--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

local SKIN = {}

SKIN.GradientUp = Material( "gui/gradient_up" )
SKIN.GradientDown = Material( "gui/gradient_down" )
SKIN.Blur = Material( "pp/blurscreen" )

local test1 = Color( 30, 30, 30, 200 )
local test2 = Color( 44, 62, 80 )
local test3 = Color( 200, 200, 200 )
local test4 = Color( 240, 240, 240 )
local test5 = Color( 230, 230, 230 )
local test6 = Color( 0, 0, 0, 150 )
local test7 = Color( 0, 0, 0, 200 )
local test8 = Color( 192, 57, 43 )
local test9 = Color( 231, 76, 60 )
local test10 = Color( 41, 128, 185 )
local test11 = Color( 52, 152, 219 )
local ScrW = ScrW()
local ScrH = ScrH()

local color_sup = ui.col.SUP
local color_gradient = ui.col.Gradient
local color_header = ui.col.Header
local color_background = ui.col.Background
local color_outline = ui.col.Outline
local color_hover = ui.col.Hover
local color_button = ui.col.Button
local color_button_hover = ui.col.ButtonHover
local color_close = ui.col.Close
local color_close_bg = ui.col.CloseBackground
local color_close_hover = ui.col.CloseHovered
local color_test = HSVToColor(CurTime() % 8 * 60, 1, 1)
local color_offwhite = ui.col.OffWhite
local color_flat_black = ui.col.FlatBlack
local color_black = ui.col.Black
local color_white = ui.col.White
local color_red = ui.col.Red
local color_green = ui.col.Green
local ui_server = ui.col.SlowRP
local mat_grad = Material'gui/gradient_down'
local mat_cecked = Material'icons/check.png'
local mat_uncecked = Material'icons/x.png'

function SKIN:PaintFrame( panel, w, h )

    draw.Blur(panel)
    draw.RoundedBox(5, 0, 0, w, h, color_background)

	draw.RoundedBox(5, 0, 0, 3, 30, color_sup)
end

function SKIN:PaintButton( panel, w, h )
	surface.SetDrawColor( test3 )
	surface.DrawRect( 0, 0, w, h )

	if not panel.Disabled then
		surface.SetMaterial( panel.Depressed and self.GradientUp or self.GradientDown )
		surface.SetDrawColor( panel.Hovered and test4 or test5 )
		surface.DrawTexturedRect( 0, 0, w, h )
	end

	surface.SetDrawColor( test6 )
	surface.DrawOutlinedRect( 0, 0, w, h )
end

function SKIN:PaintTab( panel, w, h )
	if panel:IsActive() then
		draw.RoundedBoxEx( 2, 2, 0, w - 5, h - 8, test7,
			true, true, false, false )
	else
		draw.RoundedBoxEx( 2, 2, 0, w - 5, h, test6,
			true, true, false, false )
	end
end

function SKIN:PaintPropertySheet( panel, w, h )
	surface.SetDrawColor( test7 )
	surface.DrawRect( 0, 20, w, h )
end

function SKIN:PaintCategoryList( panel, w, h )
end

function SKIN:PaintCollapsibleCategory( panel, w, h )
	surface.SetDrawColor( test6 )
	surface.DrawRect( 0, 0, w, 20 )

	surface.SetDrawColor( test6 )
	surface.DrawRect( 0, 0, w, h )
end

function SKIN:PaintWindowCloseButton( panel, w, h )
	local col = Color( 0, 0, 0, 50 )

	if not panel:GetDisabled() and panel.Hovered then
		if panel:IsDown() then
			col = test8
		else
			col = test9
		end
	end

	draw.RoundedBoxEx( 4, 0, 2, w, 18, col, true, true, true, true )
	draw.SimpleText( "r", "Marlett", w / 2, 11, color_white,
		TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
end

function SKIN:PaintWindowMaximizeButton( panel, w, h )
	if panel:GetDisabled() then return end

	if panel.Hovered then
		if panel:IsDown() then
			col = test10
		else
			col = test11
		end
	end

	draw.RoundedBoxEx( 4, 0, 2, w, 18, col, false, false, false, false )
	draw.SimpleText( "1", "Marlett", w / 2, 11, color_white,
		TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
end

function SKIN:PaintWindowMinimizeButton( panel, w, h )
	if true then return end

	local col = Color( 0, 0, 0, 50 )

	if panel.Hovered then
		if panel:IsDown() then
			col = test10
		else
			col = test11
		end
	end

	draw.RoundedBoxEx( 4, 0, 2, w, 18, col, true, false, true, false )
	draw.SimpleText( "0", "Marlett", w / 2, 11, color_white,
		TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
end

derma.DefineSkin( "itemstore", "Flat skin for ItemStore", SKIN )

--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
