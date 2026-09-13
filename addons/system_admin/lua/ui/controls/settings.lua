
local function s(y)
    local scrW, scrH = ScrW(), ScrH()

    return math.Round(y * math.min(scrW, scrH) / 1080)
end

local clr = {
	white = Color(255,255,255),
	bg = Color(38,38,38),
	rose = Color(1,89,224),
}
--[[
addons/badmin_1/lua/ui/controls/settings.lua
--]]
local CVAR = FindMetaTable 'Cvar'

function CVAR:ShouldShow()
	return true
end

function CVAR:SetShouldShow(func)
	self.ShouldShow = func
	return self
end

function CVAR:SetDescription(txt)
	self.Description = txt
	return self
end

function CVAR:GetDescription()
	return self.Description
end

function CVAR:SetCustomElement(elementName)
	self:AddMetadata('Type', 'Custom')
	self.CustomElementName = elementName
	return self
end

function CVAR:GetCustomElement()
	return self.CustomElementName
end

local PANEL = {}

Derma_Hook(PANEL, 'Paint', 'Paint', 'Panel')

function PANEL:Populate(sortOrder)
	local tbl = {}
	for k, v in ipairs(cvar.GetOrderedTable()) do
		if v:GetMetadata('Menu') or v:GetCustomElement() then
			local cat = v:GetMetadata('Category') or v:GetMetadata('Catagory') or 'Other'
			if (not tbl[cat]) then
				tbl[cat] = {}
			end
			tbl[cat][#tbl[cat] + 1] = v
		end
	end
	local function doCategory(k, v)
		self:SetSpacing(s(5))
		for k, v in ipairs(v) do
			if v:ShouldShow() then
				local pnl
				local typ = v:GetMetadata('Type') or 'bool'
				if (typ == 'bool') then
					pnl = self:AddItem(ui.Create('DPanel', function(self, p)
						self:SetTall(s(52))
						ui.Create('DLabel', function(self, p)
							self:SetPos(s(18),s(17))
							self:SetText(v:GetMetadata('Menu'))
							self:SetFont('fFont4')
							self:SizeToContents()
						end,self)
						ui.Create('ui_checkbox', function(self, p)
							self:Dock(RIGHT)
							self:DockMargin(0,s(14),s(27),s(15))
							self:SetText('')
							self:SetConVar(v:GetName())
							self:SizeToContents()
						end, self)
					end))
				elseif (typ == 'number') then
					pnl = self:AddItem(ui.Create('DPanel', function(self, p)
						self:SetTall(s(52))

						ui.Create('DLabel', function(self, p)
							self:SetPos(s(18),s(17))
							self:SetText(v:GetMetadata('Menu'))
							self:SetFont('fFont4')
							self:SizeToContents()
						end,self)

						ui.Create('DNumSlider', function(self, p)
							self:SetDecimals( 0 )
							self:SetValue(v:GetValue())
							self:Dock(RIGHT)
							self:DockMargin(0,s(19),s(27),s(18))
							self:SetWide(s(280))
							self.Paint = function(slider, w, h)
								draw.RoundedBox(5, 0, s(3), w, h-s(3), clr.bg)

								local x = self.Slider.Knob:GetPos()

								draw.RoundedBoxEx(5, 0, s(3), x, h-s(3), clr.rose,true,false,true,false)
							end
							self.PerformLayout = function()
								self:GetTextArea():SetWide(0)
								self.Label:SetWide(0)
								self.Slider:SetPos(0,0)
								self.Slider.Knob:SetSize(s(5),s(21))
								self.Slider.Paint = function( self, w, h ) 
								end
								self.Slider.Knob.Paint = function( self, w, h )
									draw.RoundedBox(5, 0, 0, w, h, clr.white)
								end
							end
							self.ValueChanged = function(s, val)
								print(val)
								v:SetValue(val)
								print(v:GetValue())
							end
						end, self)

						ui.Create('Panel', function(self, p)
							self:Dock(RIGHT)
							self:DockMargin(0,s(19),0,s(18))
							function self:Paint(w,h)
								draw.SimpleText(math.Round(v:GetValue(),2)*100 .. '%','fFont4',w/2,h/2,clr.white,1,1)
							end
						end,self)
					end))
				elseif (typ == 'Custom') then
					pnl = self:AddItem(ui.Create(v:GetCustomElement(), function(self)
						self:SetCvar(v)
					end))
				end

				if IsValid(pnl) and v:GetDescription() then
					ui.Create('DLabel', function(self, p)
						self:Dock(BOTTOM)
						self:SetFont('ui.12')
						self:SetText(v:GetDescription())
						self:SetTextInset(5, 0)
						self:SetTextColor(ui.col.LightGrey)
						p:SetTall(p:GetTall() + 15)
					end, pnl)
				end
			end
		end
	end
	for k, v in pairs(tbl) do
		if istable(sortOrder) then
			for tk, tv in pairs(sortOrder) do
				if k == tv then
					doCategory(k,v)
				end
			end	
		end
		if k ~= sortOrder then continue end
		doCategory(k, v)
	end

	hook.Call('ba.LayoutSettingsPanel', nil, self)
end

function PANEL:DockToFrame()
	local p = self:GetParent()
	local x, y = p:GetDockPos()
	self:SetPos(x, y)
	self:SetSize(p:GetWide() - 10, p:GetTall() - (y + 5))
end

vgui.Register('ui_settingspanel', PANEL, 'ui_listview')