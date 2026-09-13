AUCTION = AUCTION or {}
AUCTION.Config = {}
AUCTION.Lots = AUCTION.Lots or {}

AUCTION.Config.NPCText = "Биржа"
AUCTION.Config.Model = "models/player/eli.mdl"
AUCTION.Config.CommissionPercent = 0.05
AUCTION.Config.MinStartPrice = 1000 
AUCTION.Config.RubToGameMoney = 1000 
AUCTION.Config.MinBidStep = 1000
AUCTION.Config.MaxBidMultiplier = 3
AUCTION.Config.MaxDuration = 172800

AUCTION.Colors = {
    bg = Color(18, 18, 22, 253),
    panel = Color(24, 24, 29, 255),
    header = Color(30, 30, 35, 255),
    accent = Color(0, 120, 255),
    accent_grad = Color(0, 180, 255),
    text = Color(245, 245, 245),
    text_dim = Color(130, 130, 140),
    green = Color(40, 180, 100),
    red = Color(220, 60, 60),
    outline = Color(255, 255, 255, 5),
    input = Color(12, 12, 14, 255)
}

if CLIENT then
    local function s(y) return math.Round(y * math.min(ScrW(), ScrH()) / 1080) end
    surface.CreateFont('exFont_Big', {size = s(28), weight = 800, antialias = true, extended = true, font = 'Montserrat Bold'})
    surface.CreateFont('exFont_Med', {size = s(20), weight = 600, antialias = true, extended = true, font = 'Montserrat Medium'})
    surface.CreateFont('exFont_Small', {size = s(16), weight = 500, antialias = true, extended = true, font = 'Montserrat'})
    surface.CreateFont('exFont_Tiny', {size = s(14), weight = 500, antialias = true, extended = true, font = 'Montserrat'})
    surface.CreateFont('vibe.tab.backlogo', {font = "Montserrat", size = s(500), weight = 800, antialias = true})
end