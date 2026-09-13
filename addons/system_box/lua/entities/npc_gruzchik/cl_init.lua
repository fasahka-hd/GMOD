--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

include('shared.lua')
local mat_overhead_icon = Material( "jmaterials/logo_without_bg.png", "noclamp smooth" )
local color_gray_trans = Color( 20, 20, 20, 235 )

function ENT:Draw()
	self:DrawModel()
	
	if LocalPlayer():GetPos():DistToSqr( self:GetPos() ) >= CH_CryptoCurrencies.Config.DistanceTo3D2D then
		return
	end
	
	local Ang = self:GetAngles()
	local AngEyes = LocalPlayer():EyeAngles()

	Ang:RotateAroundAxis( Ang:Forward(), 90 )
	Ang:RotateAroundAxis( Ang:Right(), -90 )
	
	cam.Start3D2D( self:GetPos() + self:GetUp() * 70, Angle( 0, AngEyes.y - 90, 90 ), 0.12 )
		draw.RoundedBox( 6, -225, 40, 450, 110, color_gray_trans )

		-- Wallet icon
		surface.SetDrawColor( color_white )
		surface.SetMaterial( mat_overhead_icon )
		surface.DrawTexturedRect( -200, 65, 60, 60 )

		draw.SimpleText( 'Коробка', "MSB_30", -120, 80, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
		draw.SimpleText( 'Нажми "E", чтобы поставить коробку', "MM_20", -120, 110, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
	cam.End3D2D()
end

local function DrawPosInfoFD(icon,pos, s)
	local d = math.floor(LocalPlayer():GetPos():Distance(pos)/100)
	local pos = pos:ToScreen()

	draw.RoundedBox( 6, pos.x, pos.y, 230, 82, color_gray_trans )

	surface.SetDrawColor(255, 255, 255, 255)
	surface.SetMaterial(Material(icon))
	surface.DrawTexturedRect(pos.x + 25, pos.y + 25, 32, 32)

	surface.SetFont( "MM_20" )
	surface.SetTextColor(color_white)
	surface.SetTextPos(pos.x + 72, pos.y + 20)
	surface.DrawText(s)

	local x, y = surface.GetTextSize(s)

	surface.SetFont("MM_20" )
	surface.SetTextPos(pos.x + 72, pos.y + y + 20)
	surface.DrawText("Дистанция: "..d.."m")
end

hook.Add("HUDPaint","PaintRpBoxHud_Gruzchik", function()
	if LocalPlayer():GetNWBool("TakeBox", false) and LocalPlayer():Team() == TEAM_GRUZCHIK and not LocalPlayer():IsArrested() then
		for k,v in pairs(ents.FindByClass("npc_gruzchik")) do
			DrawPosInfoFD("icon16/box.png",v:EyePos(), 'Коробка')
		end
	end
end)

--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
