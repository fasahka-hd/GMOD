--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

local PANEL = {}



function PANEL:Init()

	self:SetText('')

end



function PANEL:SetTopText(text)

	self.TopText = text

end



function PANEL:SetBottomText(text)

	self.BottomText = text

end



function PANEL:SetHoverText(text)

	self.HoverText = text

end



function PANEL:SetColor(color)

	self.Color = color

end



function PANEL:SetTextColor(color)

	self.TextColor = color

end



function PANEL:SetActive(active)

	self.Active = active

end



function PANEL:SetModel(model, skin, bodyGroups)

	if (not self.Model) then

		self.Model = ui.Create('rp_modelicon', self)

		self.Model.DoClick = function()

			self.DoClick(self)

		end

		self.Model.Paint = function() end

	end



	self.Model:SetModel(model, skin, bodyGroups)

end



function PANEL:SetMaterial(mat)

	self.Material = mat

end



function PANEL:Paint(w, h)

	local color, texCtolor = (self.Color or ui.col.Button), (self.TextColor or ui.col.White)

	

	draw.RoundedBoxEx(5, 0, 0, w-5, 20, color, true, true, false, false)

	draw.SimpleText(self.TopText, 'ui.17', w * 0.5, 10, texCtolor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)



	draw.Box(0, 20, w-5, h - 40, ui.col.Background)



	if self.Material then

		local s = h - 40

		surface.SetDrawColor(255, 255, 255)

		surface.SetTexture(self.Material)

		surface.DrawTexturedRect(0, 0, s, s)

	end

	draw.Box(0, 20, 2, h - 40, color)

	draw.Box(w-7, 20, 2, h - 40, color)

	draw.RoundedBoxEx(5, 0, h - 20, w-5, 20, color, false, false, true, true)

	draw.SimpleText(self.BottomText, 'ui.17', w * 0.5, h - 10, texCtolor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)



	if self:IsHovered() or (IsValid(self.Model) and self.Model:IsHovered()) then

		draw.RoundedBox(5, 0, 0, w-5, h, ui.col.Hover)

	end



	if self.Active then

		draw.Box(0, 20, w-5, h - 40, ui.col.Hover)

	end

end



function PANEL:PaintOver(w, h)

	if (self:IsHovered() or (IsValid(self.Model) and self.Model:IsHovered())) and self.HoverText then

		draw.SimpleText(self.HoverText, 'ui.18', w * 0.5, h * 0.5, ui.col.White, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

	end

end



function PANEL:PerformLayout(w, h)

	if self.Model then

		local s = h - 44

		self.Model:SetSize(s, s)

		local x = w * 0.5 - s * 0.5

		self.Model:SetPos(x, 22)

	end

end



function PANEL:DoClick()



end



vgui.Register('rp_modelbutton', PANEL, 'DButton')



--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
