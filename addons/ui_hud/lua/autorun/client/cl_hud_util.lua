function DrawRoundedBoxEx(cornerRadius, x, y, width, height, color, roundTopLeft, roundTopRight, roundBottomLeft, roundBottomRight)
	draw.RoundedBoxEx(cornerRadius, x, y, width, height, color, roundTopLeft, roundTopRight, roundBottomLeft, roundBottomRight)
end

function DrawRoundedBox(cornerRadius, x, y, width, height, color)
	draw.RoundedBox(cornerRadius, x, y, width, height, color)
end

local function createHudFonts()
	local function sc(v) return math.Round(v * math.min(ScrW(), ScrH()) / 1080) end
	surface.CreateFont('hFont',  {size = sc(24), weight = 350, antialias = true, extended = true, font = 'Inter Bold'})
	surface.CreateFont('hFont2', {size = sc(18), weight = 350, antialias = true, extended = true, font = 'Inter Bold'})
	surface.CreateFont('hFont3', {size = sc(36), weight = 350, antialias = true, extended = true, font = 'Inter Bold'})
	surface.CreateFont('hFont4', {size = sc(20), weight = 350, antialias = true, extended = true, font = 'Inter Bold'})
	surface.CreateFont('hFont5', {size = sc(64), weight = 350, antialias = true, extended = true, font = 'Inter Bold'})
	surface.CreateFont('hFont6', {size = sc(28), weight = 350, antialias = true, extended = true, font = 'Inter Bold'})
	surface.CreateFont('hudCardTitle', {size = sc(16), weight = 600, antialias = true, extended = true, font = 'Inter Bold'})
	surface.CreateFont('hudCardSub',   {size = sc(12), weight = 500, antialias = true, extended = true, font = 'Inter Bold'})
end

createHudFonts()

hook.Add('OnScreenSizeChanged', 'JustRP.HUD.Fonts', function()
	createHudFonts()
end)