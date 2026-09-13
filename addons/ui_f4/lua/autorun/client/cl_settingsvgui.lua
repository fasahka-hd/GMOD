
local mat1 = Material("crosshair/krest.png", "smooth mips")
local mat2 = Material("crosshair/circle.png", "smooth mips")
local mat3 = Material("crosshair/polucircle.png", "smooth mips")

local clr = {
	white = Color(255,255,255),
	bg = Color(38,38,38),
	rose = Color(1,89,224),
	red = Color(143,0,0),
	xz = Color(13,14,14),
	bgr = Color(86,86,86),
	bgra = Color(62, 62, 62, 240),
	desc = Color(11, 11, 11),
	xxz = Color(139,139,140),
}

local crostbl = {
	[1] = mat2,
	[2] = mat3,
	[3] = mat1
}

local crosshairTbl = {
	{
		Name = 'РАЗМЕР ПРИЦЕЛА',
		slider = true,
		key = 1,
		min = 5,
		max = 20,
	},
	{
		Name = 'ТИП ПРИЦЕЛА',
		Type = {
			{
				name = 'КРУГ',
			},
			{
				name = 'КРУГ ПУСТОЙ',
			},
			{
				name = 'КРЕСТ',
			},
		}
	},
	{
		Name = 'КРАСНЫЙ',
		slider = true,
		key = 2,
		min = 0,
		max = 255,
	},
	{
		Name = 'ЗЕЛЕНЫЙ',
		slider = true,
		key = 3,
		min = 0,
		max = 255,
	},
	{
		Name = 'СИНИЙ',
		slider = true,
		key = 4,
		min = 0,
		max = 255,
	},
}

local function s(y)
    local scrW, scrH = ScrW(), ScrH()

    return math.Round(y * math.min(scrW, scrH) / 1080)
end

local defaultBinds = {
	{
		Key = KEY_H,
		Cmd = '/yell Это ограбление!',
		Type = 'Сообщение'
	},
	{
		Key = KEY_O,
		Cmd = 'net_graph 0',
			Type = 'Консольная команда'
	},
	{
		Key = KEY_P,
		Cmd = 'net_graph 1',
		Type = 'Консольная команда'
	}
}

cvar.Register 'custom_binds'
	:SetDefault {
		Profile = 'Default',
		Default = defaultBinds
	}
	function AddInitCallback(self)
		local binds = self:GetValue()

		if (not binds.Profile) then
			binds.Profile = 'Default'
		end

		binds.Default = binds.Default or {}
		for k, v in ipairs(binds) do
			binds[k] = nil
			binds.Default[#binds.Default + 1] = v
		end

		self:SetValue(binds)
	end

local function saveBind(key, cmd, type)
	local binds = cvar.GetValue 'custom_binds'
	local profile = binds[binds.Profile]
	local index = #profile + 1

	for k, v in ipairs(profile) do
		if (v.Key == key) then
			index = k
			break
		end
	end

	profile[index] = {
		Key 	= key,
		Cmd 	= cmd or '',
		Type 	= type or 'Custom'
	}

	cvar.SetValue('custom_binds', binds)
end

local function removeBind(key)
	local binds = cvar.GetValue 'custom_binds'
	local profile = binds[binds.Profile]

	for k, v in ipairs(profile) do
		if (v.Key == key) then
			table.remove(profile, k)
			break
		end
	end

	cvar.SetValue('custom_binds', binds)
end

local PANEL = {}

local bindsCommand = {
	['ЧАТ'] = 'Сообщение',
	['КОНСОЛЬНАЯ КОМАНДА'] = 'Консольная команда',
}

function PANEL:Init()
	self:SetTall(s(100))
	self.Paint = function(s,w,h)
		draw.RoundedBox(5,0,0,w,h,clr.xz)
	end

	self.Binder = vgui.Create('DButton', self)
	self.Binder:SetText '...'
	self.Binder:SetTextColor(clr.white)
	self.Binder:SetFont('fFont64')
	self.Binder.Paint = function(s,w,h)
		draw.RoundedBox(5,0,0,w,h,clr.bg)
	end
	self.Binder.DoClick = function(s)
		input.StartKeyTrapping()
		s.Trapping = true
		s:SetText '...'
	end
	self.Binder.Think = function(s)
		if input.IsKeyTrapping() and s.Trapping then
			local key = input.CheckKeyTrapping()
			if key then
				removeBind(self.Key)

				s:SetText(input.GetKeyName(key):upper())
				s.Trapping = false

				self.Key = key
				saveBind(key, self.Cmd, self.Type)
			end
		end
	end

	self.butList = vgui.Create('Panel',self)

	surface.SetFont('fFont3')
	for k,v in pairs(bindsCommand) do
		local x = surface.GetTextSize(k)
		self.butList.but = vgui.Create('DButton',self.butList)
		self.butList.but:Dock(LEFT)
		self.butList.but:DockMargin(s(5),0,0,0)
		self.butList.but:SetWide(x+s(30))
		self.butList.but:SetText('')
		self.butList.but.Paint = function(s,w,h)
			draw.RoundedBox(5,0,0,w,h,clr.bg)
			draw.SimpleText(k,'fFont3',w/2,h/2,self.Type == v and clr.rose or clr.white,1,1)
		end
		self.butList.but.DoClick = function(s)
			self.Type = v
			saveBind(self.Key, self.Cmd, self.Type)
		end
	end

	self.Custom = ui.Create('DTextEntry', self)
	self.Custom:SetPlaceholderText('Command...')
	self.Custom:SetFont('fFont3')
	self.Custom:SetTextColor(clr.white)
	self.Custom.OnChange = function(s)
		self.Cmd = s:GetValue()
		saveBind(self.Key, self.Cmd, self.Type)
	end

	self.Unbind = ui.Create('ui_button', self)
	self.Unbind:SetText 'УДАЛИТЬ'
	self.Unbind:SetFont('fFont3')
	self.Unbind:SetTextColor(clr.white)
	self.Unbind.DoClick = function(s)
		removeBind(self.Key)
		self:Remove()
	end
	self.Unbind.Paint = function(s, w, h)
		draw.RoundedBox(5,0,0,w,h,clr.red)
	end
end

function PANEL:PerformLayout()
	self.Binder:SetPos(0, 0)
	self.Binder:SetSize(s(100), s(100))

	self.butList:SetPos(s(115),s(20))
	self.butList:SetSize(s(333),s(25))

	self.Custom:SetPos(s(120), s(55))
	self.Custom:SetSize(self:GetWide() - s(140), s(25))

	self.Unbind:SetSize(s(106), s(25))
	self.Unbind:SetPos(self:GetWide() - s(106+18), s(20))
end

function PANEL:SetBind(inf)
	self.Key = inf.Key
	self.Cmd = inf.Cmd
	self.Type = inf.Type
	
	self.Binder:SetText(input.GetKeyName(self.Key):upper())
	self.Custom:SetValue(self.Cmd)
end

vgui.Register('rp_keybinders', PANEL, 'ui_panel')

local PANEL = {}

function PANEL:Init()
	local binds = cvar.GetValue 'custom_binds'

	self.KeyBinds = ui.Create('ui_listview', self)
	self.KeyBinds:SetPadding(-1)
	self.KeyBinds.Paint = function(s, w, h)
	end
	binds.Profile = 'Default'

	cvar.SetValue('custom_binds', binds)
	for k, v in ipairs(binds['Default']) do
		self.KeyBinds:AddItem(ui.Create('rp_keybinders', function(self)
			self:SetBind(v)
		end))
	end

	self.AddBinding = vgui.Create('DButton', self)
	self.AddBinding:SetText('ДОБАВИТЬ БИНД')
	self.AddBinding:SetTextColor(clr.white)
	self.AddBinding:SetFont('fFont')
	self.AddBinding.Paint = function(s,w,h)
		draw.RoundedBox(5,0,0,w,h,clr.xz)
	end
	self.AddBinding.DoClick = function(s)
		self.KeyBinds:AddItem(ui.Create 'rp_keybinders')
	end
end

function PANEL:PerformLayout(w, h)
	self.KeyBinds:Dock(FILL)
	
	self.AddBinding:Dock(BOTTOM)
	self.AddBinding:DockMargin(s(30),0,s(30),s(20))
	self.AddBinding:SetTall(s(40))
end

vgui.Register('f4_bind', PANEL, 'Panel')

local lastkey = 0
local nextcall = 0

hook('Think', 'rp.KeyBinds.Think', function()
	local a, b = gui.MousePos()
	local binds = cvar.GetValue 'custom_binds'

	if (a == 0) and (b == 0) and binds then
		local profile = binds[binds.Profile]
		if profile then
			for k, v in ipairs(profile) do
				if v.Key and v.Cmd and v.Type and input.IsKeyDown(v.Key) then
					if (lastkey ~= v.Key) and (nextcall < CurTime()) then
						if (v.Type == 'Сообщение') then
							LocalPlayer():ConCommand('say ' .. v.Cmd)
						elseif (v.Type == 'Команда') then
							LocalPlayer():ConCommand('rp ' .. v.Cmd)
						elseif (v.Type == 'Консольная команда') then
							LocalPlayer():ConCommand(v.Cmd)
						end

						nextcall = CurTime() + 0.33
						continue
					end
					nextcall = CurTime() + 0.33
				end
			end
		end
	end
end)

local PANEL = {}

function PANEL:SetSetting(setting)
	self.setting = setting
end

function PANEL:Init()
	self.Settings = ui.Create('ui_settingspanel', self)
	self.Settings.Paint = function(s, w, h)
	end
	timer.Simple(.1,function()
		self.Settings:Populate(self.setting)
	end)
end

function PANEL:PerformLayout(w, h)
	self.Settings:SetPos(0,0)
	self.Settings:SetSize(self:GetWide(), self:GetTall())
end

vgui.Register('f4_set', PANEL, 'Panel')

local PANEL = {}

function PANEL:Init()
	surface.SetFont('fFont4')

	local tbl = {}
	for k, v in ipairs(cvar.GetOrderedTable()) do
		if v:GetMetadata('Menu') or v:GetCustomElement() then
			local cat = v:GetMetadata('Category') or v:GetMetadata('Catagory') or 'Other'
			if cat == 'Прицел' then
				if (not tbl[cat]) then
					tbl[cat] = {}
				end
				tbl[cat][#tbl[cat] + 1] = v
			end
		end
	end

	tbl = tbl['Прицел']
	for k,v in ipairs(crosshairTbl) do
		self.crosshairSet = vgui.Create('Panel',self)
		self.crosshairSet:Dock(TOP)
		self.crosshairSet:DockMargin(0,0,0,s(5))
		self.crosshairSet:SetTall(s(52))
		self.crosshairSet.Paint = function(ss,w,h)
			draw.RoundedBox(5,0,0,w,h,clr.xz)
			draw.SimpleText(v.Name,'fFont4',s(18),h/2,clr.white,0,1)
		end
	
		if v.slider then
			ui.Create('DNumSlider', function(self, p)
				self:SetDecimals( 0 )
				self:Dock(RIGHT)
				self:DockMargin(0,s(19),s(27),s(18))
				self:SetWide(s(280))
				self:SetMinMax(v.min,v.max)
				self:SetValue(tbl[v.key]:GetValue())
				self.Paint = function(slider, w, h)
					draw.RoundedBox(5, 0, s(3), w, s(15), clr.bg)

					local x = self.Slider.Knob:GetPos()

					draw.RoundedBoxEx(5, 0, s(3), x, s(15), clr.rose,true,false,true,false)
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
				self.ValueChanged = function(s,value)
					tbl[v.key]:SetValue(value)
				end
			end, self.crosshairSet)

			self.crosshairSet.text = vgui.Create('Panel',self.crosshairSet)
			self.crosshairSet.text:Dock(RIGHT)
			self.crosshairSet.text:DockMargin(0,s(17),s(7),s(17))
			self.crosshairSet.text.Paint = function(s,w,h)
				draw.SimpleText(math.floor(tbl[v.key]:GetValue()),'fFont3',w/2,h/2,clr.white,1,1)
			end
		else
			self.crosshairSet.Type = vgui.Create('Panel',self.crosshairSet)
			self.crosshairSet.Type:Dock(RIGHT)
			self.crosshairSet.Type:DockMargin(0,s(15),s(15),s(12))
			self.crosshairSet.Type:SetWide(s(299))
			
			for k,v in ipairs(v.Type) do
				local x = surface.GetTextSize(v.name)

				self.setType = vgui.Create('DButton', self.crosshairSet.Type)
				self.setType:Dock(RIGHT)
				self.setType:DockMargin(s(5),0,0,0)
				self.setType:SetWide(x+s(30))
				self.setType:SetText(v.name)
				self.setType:SetFont('fFont4')
				self.setType:SetTextColor(clr.white)
				self.setType.Paint = function(s,w,h)
					draw.RoundedBox(5,0,0,w,h,s.Hovered and clr.rose or tbl[5]:GetValue() == k and clr.rose or clr.bg)
				end
				self.setType.DoClick = function(s)
					tbl[5]:SetValue(k)
				end
			end
		end
	end

	self.crosshairView = vgui.Create('Panel',self)
	self.crosshairView:Dock(TOP)
	self.crosshairView:DockMargin(0,s(10),0,s(5))
	self.crosshairView:SetTall(s(120))
	self.crosshairView.Paint = function(ss,w,h)
		surface.SetMaterial(crostbl[tbl[5]:GetValue()])
		surface.SetDrawColor(tbl[2]:GetValue(),tbl[3]:GetValue(),tbl[4]:GetValue())
		surface.DrawTexturedRect(w/2 - tbl[1]:GetValue()/2,h/2 - tbl[1]:GetValue()/2,tbl[1]:GetValue(),tbl[1]:GetValue())
	end
end

vgui.Register('f4_crosshair', PANEL, 'Panel')

local PANEL = {}

local tbl = {
	{
		name = 'ЦВЕТ ПЕРСОНАЖА',
		def = Vector(GetConVarString('cl_playercolor')),
		change = function(s)
			local vec = s:GetVector()
			local vecstr = tostring(vec)

			timer.Create('rp.PlayerColor', 0.25, 1, function()
				RunConsoleCommand('cl_playercolor', vecstr)
				cmd.Run('playercolor', vec.x, vec.y, vec.z)
			end)
		end
	},
	{
		name = 'ЦВЕТ ФИЗГАНА',
		def = Vector(GetConVarString('cl_weaponcolor')),
		change = function(s)
			local vec = s:GetVector()
			local vecstr = tostring(vec)

			timer.Create('rp.WeaponnColor', 0.25, 1, function()
				RunConsoleCommand('cl_weaponcolor', vecstr)
				cmd.Run('physcolor', vec.x, vec.y, vec.z)
			end)
		end
	}
}
function PANEL:Init()
	for k,v in ipairs(tbl) do
		self.header = vgui.Create('Panel', self)
		self.header:Dock(TOP)
		self.header:DockMargin(0,0,0,s(4))
		self.header:SetTall(s(52))
		function self.header:Paint(w,h)
			draw.RoundedBox(5,0,0,w,h,clr.xz)
			draw.SimpleText(v.name,'fFont4',s(18),h/2,clr.white,0,1)
		end

		self.color = vgui.Create('DColorMixer', self)
		self.color:Dock(TOP)
		self.color:DockMargin(0,0,0,s(4))
		self.color:SetTall(s(200))
		self.color:SetAlphaBar(false)
		self.color:SetVector(v.def)
		self.color:SetPalette(false)
		self.color:SetWangs(false)
		self.color.ValueChanged = v.change
	end

	self.pizdecbut = vgui.Create('DButton', self)
	self.pizdecbut:Dock(TOP)
	self.pizdecbut:SetTall(s(50))
	self.pizdecbut:SetText('')
	function self.pizdecbut:Paint(w,h)
		local isHovered = self:IsHovered()
		local firstColor = isHovered and color_black or color_white
		local secondColor = isHovered and color_white or enc.clrs.rose

		draw.RoundedBox(5,0,0,w,h,Color(1,89,224))
		draw.SimpleText('СУМАСШЕДШИЙ ЦВЕТ ФИЗГАНА','fFont3',w/2,h/2,firstColor,1,1)
	end
	function self.pizdecbut.DoClick()
		local min = math.Rand(10,100000000)
		local max = math.Rand(10,100000000)

		local a = math.Rand(-min, max)
		min = math.Rand(10,100000000)
		max = math.Rand(10,100000000)

		local b = math.Rand(-min, max)
		min = math.Rand(10,100000000)
		max = math.Rand(10,100000000)

		local c = math.Rand(-min, max)

		local vec = Vector(a,b,c)

		RunConsoleCommand('cl_weaponcolor', tostring(vec))

		cmd.Run('physcolor', vec.x, vec.y, vec.z)
	end
end

vgui.Register('f4_colors', PANEL, 'Panel')
