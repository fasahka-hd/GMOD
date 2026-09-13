plib.IncludeSH 'shared.lua'

local color_white = ui.col.White:Copy()
local mat_overhead_icon = Material( "testhud/brickscrafting/icons/quest.png", "noclamp smooth" )
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

		surface.SetDrawColor( color_white )
		surface.SetMaterial( mat_overhead_icon )
		surface.DrawTexturedRect( -200, 65, 60, 60 )

		draw.SimpleText( 'Адвокат', "MSB_30", -120, 80, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
		draw.SimpleText( 'Нажми "E", чтобы взаимодействовать', "MM_20", -120, 110, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
	cam.End3D2D()
end

net.Receive('rp.OpenBail', function()
	local fr = ui.Create('ui_frame', function(self)
		self:SetSize(500, 400)
		self:SetTitle('Освобдить заключнных за деньги')
		self:Center()
		self:MakePopup()
	end)

	local list = ui.Create('ui_listview', function(self, p)
		local x, y = p:GetDockPos()
		self:SetPos(x, y)
		self:SetSize(p:GetWide() - 10, p:GetTall() - y - 35)
	end, fr)

	local tbl 	= {}
	local count = net.ReadUInt(8)

	for i=1, count do 
		local pl 	= net.ReadEntity()
		local price = net.ReadUInt(16)
		if IsValid(pl) then
			list:AddPlayer(pl).Info = {Name = pl:Name(), Price = (LocalPlayer():IsMayor() and 0 or price), SteamID = pl:SteamID()}
		end
	end

	if (count == 0) then
		list:AddSpacer('Нет заключенных!')
	end

	local btn = ui.Create('ui_button', function(self, p)
		self:SetText('Список Заключенных')
		self:SetPos(5, p:GetTall() - 30)
		self:SetSize(p:GetWide() - 10, 25)

		function self:Think()
			if (list:GetSelected() ~= nil) then
				local name 	= list:GetSelected().Info.Name
				local price = list:GetSelected().Info.Price

				if LocalPlayer():IsMayor() or (LocalPlayer():GetMoney() >= price) then
					self:SetText('Заплатить залог за ' .. name .. ' (' .. rp.FormatMoney(price) .. ')')
					self:SetDisabled(false)
				else
					self:SetText('Недостаточно средств!')
					self:SetDisabled(true)
				end
			else
				self:SetText('Заключенный не выбран')
				self:SetDisabled(true)
			end
		end

		function self:DoClick()
			cmd.Run('bail', list:GetSelected().Info.Name)
			fr:Close()
		end
	end, fr)
end)