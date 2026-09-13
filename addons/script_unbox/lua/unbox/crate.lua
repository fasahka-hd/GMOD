--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher


local CustomIcons = BUC2.CustomCrateIcons

local crateMat = Material("bu2/case.png","smooth noclamp")
local keyMat = Material("bu2/key.png","smooth noclamp")
local itemShadowMat = Material("bu2/item_shadow.png","smooth noclamp")

local color_white = Color( 255, 255, 255 )

return {
	Base = "EditablePanel",
	Init = function( self )
		self.outlinec = Color(0,0,0)
		self.PaintCase = true
	end,
	Set = function( self, itemTable )
		self.itemTable = itemTable
		self.itemType = itemTable.itemType

		self:SetToolTip( itemTable.name2 or "" )
	end,
	PaintBackground = function( self, w, h )
		-- surface.SetDrawColor( color_white )
		-- surface.SetMaterial( itemShadowMat )
		-- surface.DrawTexturedRect( 0, 0, 180, 180 )

		--[[ local col = self.itemTable.color

		surface.SetDrawColor(col)
		surface.SetMaterial(itemBannerMat)
		surface.DrawTexturedRect(0,180,180,40)--]] 

		--Draw text

		-- draw.SimpleText( self.itemTable.name1, "ub2_1", w/2, 2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP )
		--draw.SimpleText(self.itemTable.name2,"ub2_2",5,200,Color(255,255,255))
	end,
	Paint = function( self, w, h )
		self:PaintBackground( w, h )

		if self.itemType == "Crate" then

			local customIcon = CustomIcons[ self.itemTable.name1 ]
			if customIcon then
				local size = h
				surface.SetDrawColor( color_white )
				surface.SetMaterial( customIcon )
				surface.DrawTexturedRect( w/2 - size/2 + 20*1.3, h/2 - size/2 + 28*1.3, size - 40*1.3, size - 40*1.3 )
			else
				local size = h
				surface.SetDrawColor( self.PaintCase and self.itemTable.color or color_white )
				surface.SetMaterial( crateMat )
				surface.DrawTexturedRect( w/2 - size/2*1.3, h/2 - size/2 + 15*1.3, size*1.3, size*1.3 )
			end

		elseif self.itemType == "Key" then
			
			surface.SetDrawColor( self.itemTable.color )
			surface.SetMaterial( keyMat )
			surface.DrawTexturedRect( 0, 0, 180*1.3, 180*1.3 )

		end

	end
}

--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher
