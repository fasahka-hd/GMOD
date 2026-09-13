--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

include( "shared.lua" )

local poss = Vector(0,0,0)
local angg = Angle(0,0,0)

local sentences = GmodEats.Config.Lang
local lang = GmodEats.Config.Language

function ENT:Initialize()

	self.npc3D2D = {
		[1] = {
			sx = 300,
			sy = 320,
			scale = 0.1,
			pos = {
				right = -60,
				forward = 20,
				up = 0,
			},
			angleRotate = {
				forward = 0,
				right = -90,
				up = 90,
			},
			angle = Angle(0,-30,0),
			Texts = {
				[1] = {
					posx = 10,
					posy = 50,
					text = sentences["Hello! Do you want to work for Gmod Eat today? You will have to pay your backpack"][lang].." $"..GmodEats.Config.PriceBag..", "..sentences["but if you get it back to me you'll be refunded."][lang]
				},
			},
			buttons = {
				[1] = {
					sizex = 300,
					sizey = 50,
					text = sentences["No thanks"][lang],
					posx = 0,
					posy = 320-50,
					color = Color(0,176,206,255),
					hovColor = Color(0,176,206,230),
					onClick = function()
						gui.EnableScreenClicker( false )
						GmodEats.EntCenter = nil
						GmodEats.infosView = nil
					end,
					ex1 = true,
				},
				[2] = {
					sizex = 300,
					sizey = 50,
					text = sentences["Yes! Give me the backpack!"][lang],
					posx = 0,
					posy = 320-101,
					color = Color(0,176,206,255),
					hovColor = Color(0,176,206,230),
					onClick = function(ent)
						gui.EnableScreenClicker( false )
						GmodEats.EntCenter = nil
						GmodEats.infosView = nil
						
						net.Start("GmodEats.GiveBag")
							net.WriteEntity(ent)
						net.SendToServer()
					end
				},
				[3] = {
					sizex = 300,
					sizey = 1,
					text = "",
					posx = 0,
					posy = 320-51,
					color = Color(0,146-20,176-20,255),
					hovColor = Color(0,146-20,176-20,255),
					onClick = function()
						gui.EnableScreenClicker( false )
						GmodEats.EntCenter = nil
						GmodEats.infosView = nil
					end
				},
			},
		},
		[2] = {
			sx = 300,
			sy = 320,
			scale = 0.1,
			pos = {
				right = -60,
				forward = 20,
				up = 0,
			},
			angleRotate = {
				forward = 0,
				right = -90,
				up = 90,
			},
			angle = Angle(0,-30,0),
			Texts = {
				[1] = {
					posx = 10,
					posy = 50,
					text = sentences["Hello! Do you want to give me back your backpack, and be refunded your"][lang].." $"..GmodEats.Config.PriceBag.."?"
				},
			},
			buttons = {
				[1] = {
					sizex = 300,
					sizey = 50,
					text = sentences["No thanks"][lang],
					posx = 0,
					posy = 320-50,
					color = Color(0,176,206,255),
					hovColor = Color(0,176,206,230),
					onClick = function()
						gui.EnableScreenClicker( false )
						GmodEats.EntCenter = nil
						GmodEats.infosView = nil
					end,
					ex1 = true,
				},
				[2] = {
					sizex = 300,
					sizey = 50,
					text = sentences["Yes, take the backpack!"][lang],
					posx = 0,
					posy = 320-101,
					color = Color(0,176,206,255),
					hovColor = Color(0,176,206,230),
					onClick = function(ent)
						gui.EnableScreenClicker( false )
						GmodEats.EntCenter = nil
						GmodEats.infosView = nil
						
						net.Start("GmodEats.GetBackBag")
							net.WriteEntity(ent)
						net.SendToServer()
					end
				},
				[3] = {
					sizex = 300,
					sizey = 1,
					text = "",
					posx = 0,
					posy = 320-51,
					color = Color(0,146-20,176-20,255),
					hovColor = Color(0,146-20,176-20,255),
					onClick = function()
						gui.EnableScreenClicker( false )
						GmodEats.EntCenter = nil
						GmodEats.infosView = nil
					end
				},
			},
		}
	}

end

local color_white = ui.col.White:Copy()
local mat_overhead_icon = Material( "jmaterials/logo_without_bg.png", "noclamp smooth" )
local color_gray_trans = Color( 20, 20, 20, 235 )

function ENT:DrawTranslucent()
	self:DrawModel()
	
	if LocalPlayer():GetPos():DistToSqr( self:GetPos() ) >= CH_CryptoCurrencies.Config.DistanceTo3D2D then
		return
	end
	
	local Ang = self:GetAngles()
	local AngEyes = LocalPlayer():EyeAngles()

	Ang:RotateAroundAxis( Ang:Forward(), 90 )
	Ang:RotateAroundAxis( Ang:Right(), -90 )
	
	cam.Start3D2D( self:GetPos() + self:GetUp() * 85, Angle( 0, AngEyes.y - 90, 90 ), 0.08 )
		draw.RoundedBox( 6, -225, 40, 450, 110, color_gray_trans )

		-- Wallet icon
		surface.SetDrawColor( color_white )
		surface.SetMaterial( mat_overhead_icon )
		surface.DrawTexturedRect( -200, 65, 60, 60 )

		draw.SimpleText( 'Работник Доставки', "MSB_30", -120, 80, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
		draw.SimpleText( 'Нажми "E", чтобы взаимодействовать', "MM_20", -120, 110, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
	cam.End3D2D()
end

--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
