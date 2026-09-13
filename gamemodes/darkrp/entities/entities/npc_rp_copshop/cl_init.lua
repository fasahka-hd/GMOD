--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

plib.IncludeSH 'shared.lua'

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

		draw.SimpleText( 'Арсенал', "MSB_30", -120, 80, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
		draw.SimpleText( 'Нажми "E", чтобы взаимодействовать', "MM_20", -120, 110, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
	cam.End3D2D()
end
local fr
net('rp.CopshopMenu', function()
	if IsValid(fr) then fr:Close() end

	local w, h = ScrW() * .3, ScrH() * .6

	fr = ui.Create('ui_frame', function(self)
		self:SetTitle('Арсенал полиции')
		self:SetSize(w, h)
		self:Center()
		self:MakePopup()
	end)


	local x, y = fr:GetDockPos()

	local lbl = ui.Create('DLabel', function(self, p)
		self:SetFont('ui.18')
		self:SetPos(x, 50)
		self:SetWide(p:GetWide() - 10)
	--	self:SetAutoStretchVertical(true)
		self:SetWrap(true)
		if isGov then
			self:SetTall(700)
			self:SetText('')
		else
			self:SetTall(700)
			self:SetText('')
		end



		p:SetTall(x + 5 + self:GetTall())

	end, fr)


	local list = ui.Create('ui_scrollpanel', function(self, p)
		self:SetSpacing(2)
		self:DockToFrame()
		self:PerformLayout()
	end, fr)

	for k, v in pairs(rp.CopItems) do
		list:AddItem(ui.Create('rp_shopbutton', function(self)
			self:SetTall(150)
			self:SetInfo(v.Model, v.Name, v.Price, function()
				-- self:SetSize(list:GetWide(), 100)
				cmd.Run('copbuy', v.Name)
			end)
		end))
	end
end)



--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
