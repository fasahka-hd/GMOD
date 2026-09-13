--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

plib.IncludeSH 'shared.lua'

local color_white = ui.col.White:Copy()
local color_black = ui.col.Black:Copy()

local complex_off = Vector(0, 0, 9)

local ang = Angle(0, 90, 90)

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
	
	cam.Start3D2D( self:GetPos() + self:GetUp() * 85, Angle( 0, AngEyes.y - 90, 90 ), 0.08 )
		draw.RoundedBox( 6, -140, 40, 350, 110, color_gray_trans )


		draw.SimpleText( 'Секретарь мэра', "MSB_30", -120, 80, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
		draw.SimpleText( 'Нажми "E", чтобы взаимодействовать', "MM_20", -120, 110, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
	cam.End3D2D()
end

local fr
net('rp.BuyLic', function()
	ui.BoolRequest("Купить лицензию",'С вашего счета будет снято '.. rp.FormatMoney(GetGlobalInt('pricetolic')) ..' Продолжить?', function(ans)
		if (ans == true) then
			net.Start('rp.BuyLicSV')
			net.SendToServer()
		end
	end)
end)

net('rp.SetLic', function()
	ui.BoolRequest("Цена лицензии",'В данный момент цена лицензии '.. rp.FormatMoney(GetGlobalInt('pricetolic')) ..' вы хотите её сменить?', function(ans)
		if (ans == true) then
			ui.StringRequest('Количество', 'Сколько вы хотите за лицензию? (100$ - 15.000$)', '', function(a)
				net.Start('rp.SetLicSV')
				net.WriteInt(tonumber(a),32)
				net.SendToServer()
			end)
		end
	end)
end)

--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
