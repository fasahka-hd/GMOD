TOOL.Command = nil
TOOL.ConfigName = ''

local HUMAN_MINS = Vector(-16, -16, 0)
local HUMAN_MAXS = Vector(16, 16, 72)

TOOL.Category = 'ARZRP'
TOOL.Name = '#tool.spawn_robbery_system_v1.name'

TOOL.Information = {
	{name = 'left'},
	{name = 'right'},
	{name = 'reload'},
}

TOOL.ClientConVar = {
	['model'] = '',
	['polices'] = '0',
	['robbers'] = '0',
	['name'] = '',
	['radius'] = '0',
	['soundscape'] = '',
	['time'] = '0',
	['data'] = '',
}

for k, v in pairs(TOOL.ClientConVar) do
	CreateClientConVar('spawn_robbery_system_v1_' .. k, v, false, true)
end

if CLIENT then
	language.Add('tool.spawn_robbery_system_v1.name', 'Точки ограблений')
	language.Add('tool.spawn_robbery_system_v1.desc', 'Создавайте или изменяйте точки ограблений')
	language.Add('tool.spawn_robbery_system_v1.left', 'Создать точку ограбления')
	language.Add('tool.spawn_robbery_system_v1.right', 'Удалить точку ограбления')
	language.Add('tool.spawn_robbery_system_v1.reload', 'Настроить инструмент')
else
	util.AddNetworkString('openMenuPon')
end

function TOOL:LeftClick(trace)
	local owner = self:GetOwner()
	if not owner:IsRoot() then return end

	local hitPos = trace.HitPos
	local model = owner:GetInfo('spawn_robbery_system_v1_model')
	local polices = owner:GetInfo('spawn_robbery_system_v1_polices')
	local robbers = owner:GetInfo('spawn_robbery_system_v1_robbers')
	local name = owner:GetInfo('spawn_robbery_system_v1_name')
	local radius = owner:GetInfo('spawn_robbery_system_v1_radius')
	local soundscape = owner:GetInfo('spawn_robbery_system_v1_soundscape')
	local time = owner:GetInfo('spawn_robbery_system_v1_time')
	local data = owner:GetInfo('spawn_robbery_system_v1_data')

	if spawns.list then
		for _, data in ipairs(spawns.list) do
			local dataPos = Vector(data.position)
			if dataPos:Distance(hitPos) < math.abs(HUMAN_MAXS.x * 2) then
				return false
			end
		end
	end

	if SERVER then
		spawns:Create(model, polices, robbers, name, radius, soundscape, hitPos, time, data)
		hook.Call('spawns.PlayerCreated', spawns.events, owner, model, polices, false, hitPos)
	end

	for k, v in pairs(self.ClientConVar) do
		RunConsoleCommand('spawn_robbery_system_v1_' .. k, v)
	end

	return true
end

function TOOL:RightClick(trace)
	local hitPos = trace.HitPos
	local owner = self:GetOwner()
	if not owner:IsRoot() then return end

	local foundIndex, foundData
	for index, data in pairs(spawns.list or {}) do
		local dataPos = Vector(data.position)
		if dataPos:Distance(hitPos) < math.abs(HUMAN_MAXS.x * 2) then
			foundIndex = index
			foundData = data
			break
		end
	end

	if foundIndex then
		if SERVER then
			local can, reason = hook.Call('spawns.CanDelete', spawns.events, owner, foundData, foundIndex)
			if can == true then
				hook.Call('spawns.PlayerDeleted', spawns.events, owner, foundData)
				spawns:Delete(foundIndex)
			else
				owner:ChatPrint(reason or 'Недоступно.')
			end
		end
		return true
	end
end

function TOOL:Reload(trace)
	if not self:GetOwner():IsRoot() then return end

	net.Start('openMenuPon')
	net.Send(self:GetOwner())
end

function TOOL.BuildCPanel(panel)
	panel:AddControl('Header', {Text = 'PermaProps', Description = 'PermaProps\n\nSaves entities across map changes\n'})
	panel:AddControl('Button', {Label = 'Open Configuration Menu', Command = 'pp_cfg_open'})
end

if CLIENT then
	local angle_zero = Angle(0, 0, 0)
	local previewModel = nil
	local lastModel = ''

	function TOOL:DrawToolScreen(w, h)
		surface.SetDrawColor(color_black)
		surface.DrawRect(0, 0, w, h)

		local idValue = (GetConVar('spawn_robbery_system_v1_model') and GetConVar('spawn_robbery_system_v1_model'):GetString() or '')
		local namePoint = (GetConVar('spawn_robbery_system_v1_name') and GetConVar('spawn_robbery_system_v1_name'):GetString() or '')
		local polices = (GetConVar('spawn_robbery_system_v1_polices') and GetConVar('spawn_robbery_system_v1_polices'):GetInt() or 0)
		local robbers = (GetConVar('spawn_robbery_system_v1_robbers') and GetConVar('spawn_robbery_system_v1_robbers'):GetInt() or 0)

		local typeName = namePoint == '' and 'НЕ ВЫБРАНО' or namePoint
		local typeColor = Color(129, 217, 255)
		local valueName = idValue == '' and 'НЕ ВЫБРАНО' or idValue

		local _, textH = draw.SimpleText(typeName, 'spawn_robbery_system_v1.font00', w * 0.5, h * 0.5, typeColor, 1, 4)

		draw.SimpleText(polices, 'spawn_robbery_system_v1.font_medium', w * 0.5 - 16, h * 0.5 - textH, Color(129, 217, 255), 1, 4)
		draw.SimpleText(':', 'spawn_robbery_system_v1.font_medium', w * 0.5, h * 0.5 - textH, Color(255, 248, 166), 1, 4)
		draw.SimpleText(robbers, 'spawn_robbery_system_v1.font_medium', w * 0.5 + 16, h * 0.5 - textH, Color(255, 129, 129), 1, 4)

		surface.SetFont('spawn_robbery_system_v1.font_medium')
		local textW = surface.GetTextSize(valueName)

		if textW > w then
			local exploded = string.Explode(' ', valueName)
			local combined = table.concat(exploded, '\n')
			draw.DrawText(combined, 'spawn_robbery_system_v1.font2', w * 0.5, h * 0.5, color_white, 1, 0)
		else
			draw.SimpleText(valueName, 'spawn_robbery_system_v1.font_medium', w * 0.5, h * 0.5, color_white, 1, 0)
		end
	end

	function TOOL:Think()
		local mdl = LocalPlayer():GetInfo('spawn_robbery_system_v1_model')
		if mdl == lastModel and IsValid(previewModel) then return end
		lastModel = mdl
		if IsValid(previewModel) then previewModel:Remove() end
		previewModel = ClientsideModel(mdl)
		if IsValid(previewModel) then
			previewModel:SetNoDraw(true)
		end
	end

	function TOOL:DrawHUD()
		local spawns = spawns.list
		local hitPos = LocalPlayer():GetEyeTrace().HitPos
		local hidePreview = false
		local radius = tonumber(LocalPlayer():GetInfo('spawn_robbery_system_v1_radius')) or 0

		if istable(spawns) then
			for index, data in pairs(spawns) do
				local pos = Vector(data.position)
				local pos2d = pos:ToScreen()
				local polices = data.polices
				local robbers = data.robbers
				local name = data.name
				local typeColor = Color(255, 129, 129)
				local bSelected = hitPos:Distance(pos) < 32

				if bSelected then
					hidePreview = true
				end

				draw.SimpleTextOutlined(name, 'spawn_robbery_system_v1.ui_font0', pos2d.x, pos2d.y, typeColor, 1, 1, 1, Color(0, 0, 0, 175))
				draw.SimpleTextOutlined(string.format('Полиция: %i  Бандиты: %i', polices, robbers), 'spawn_robbery_system_v1.ui_font1', pos2d.x, pos2d.y + ScreenScale(6), Color(255, 129, 129), 1, 1, 1, Color(0, 0, 0, 175))

				cam.Start3D()
				render.DrawWireframeBox(pos, angle_zero, Vector(-radius, -radius, -radius), Vector(radius, radius, radius), bSelected and Color(255, 129, 129) or color_white, false)
				cam.End3D()
			end
		end

		if hitPos and not hidePreview then
			if IsValid(previewModel) then
				local tr = util.TraceLine({
					start = hitPos,
					endpos = hitPos + Vector(0, 0, -100),
					mask = MASK_SOLID_BRUSHONLY,
				})

				previewModel:SetPos(tr.HitPos + Vector(0, 0, -previewModel:OBBMins().z))
				previewModel:SetAngles(Angle(0, 0, 0))

				cam.Start3D()
				previewModel:DrawModel()
				render.DrawWireframeBox(tr.HitPos + Vector(0, 0, -previewModel:OBBMins().z), Angle(0, 0, 0), Vector(-radius, -radius, -radius), Vector(radius, radius, radius), color_white, false)
				cam.End3D()
			end
		end
	end

	local function openMenu()
		local fontButton = 'HudDefault'
		local colorRed = Color(255, 104, 104)
		local keybindActivateTime = RealTime() + 1

		local frame = vgui.Create('DFrame')
		frame:SetSize(ScrW() * 0.35, ScrH() * 0.6)
		frame:SetTitle('Система ограблений')
		frame:SetAlpha(0)
		frame:AlphaTo(255, 0.1)
		frame:MakePopup()
		frame:Center()
		frame.Think = function(panel)
			if input.IsKeyDown(KEY_R) and keybindActivateTime <= RealTime() then
				panel:Remove()
			end
		end

		local content = frame:Add('Panel')
		content:Dock(FILL)

		local optionSelector = content:Add('DComboBox')
		optionSelector:Dock(TOP)
		optionSelector:SetValue('Выберите тип награды')
		optionSelector:AddChoice('Оружие')
		optionSelector:AddChoice('Деньги')

		local modelEntry = content:Add('DTextEntry')
		modelEntry:SetPlaceholderText('Выберите модель...')
		modelEntry:SetTall(ScreenScale(10.5))
		modelEntry:Dock(TOP)
		modelEntry:DockMargin(0, 0, 0, ScreenScale(2))
		modelEntry:SetUpdateOnType(true)
		modelEntry:SetText(GetConVar('spawn_robbery_system_v1_model'):GetString())
		modelEntry.OnValueChange = function(panel, value)
			RunConsoleCommand('spawn_robbery_system_v1_model', value)
		end

		local nameEntry = content:Add('DTextEntry')
		nameEntry:SetPlaceholderText('Выберите название...')
		nameEntry:SetTall(ScreenScale(10.5))
		nameEntry:Dock(TOP)
		nameEntry:DockMargin(0, 0, 0, ScreenScale(2))
		nameEntry:SetUpdateOnType(true)
		nameEntry:SetText(GetConVar('spawn_robbery_system_v1_name'):GetString())
		nameEntry.OnValueChange = function(panel, value)
			RunConsoleCommand('spawn_robbery_system_v1_name', value)
		end

		local soundEntry = content:Add('DTextEntry')
		soundEntry:SetPlaceholderText('Музыка при ограблении...')
		soundEntry:SetTall(ScreenScale(10.5))
		soundEntry:Dock(TOP)
		soundEntry:DockMargin(0, 0, 0, ScreenScale(2))
		soundEntry:SetUpdateOnType(true)
		soundEntry:SetText(GetConVar('spawn_robbery_system_v1_soundscape'):GetString())
		soundEntry.OnValueChange = function(panel, value)
			RunConsoleCommand('spawn_robbery_system_v1_soundscape', value)
		end

		local policeSlider = content:Add('DNumSlider')
		policeSlider:SetText('Количество полицейских')
		policeSlider:SetMin(1)
		policeSlider:SetMax(10)
		policeSlider:SetDecimals(0)
		policeSlider:SetConVar('spawn_robbery_system_v1_polices')
		policeSlider:Dock(TOP)

		local robberSlider = content:Add('DNumSlider')
		robberSlider:SetText('Количество бандитов')
		robberSlider:SetMin(1)
		robberSlider:SetMax(10)
		robberSlider:SetDecimals(0)
		robberSlider:SetConVar('spawn_robbery_system_v1_robbers')
		robberSlider:Dock(TOP)

		local radiusSlider = content:Add('DNumSlider')
		radiusSlider:SetText('Радиус')
		radiusSlider:SetMin(1)
		radiusSlider:SetMax(10000)
		radiusSlider:SetDecimals(0)
		radiusSlider:SetConVar('spawn_robbery_system_v1_radius')
		radiusSlider:Dock(TOP)

		local timeSlider = content:Add('DNumSlider')
		timeSlider:SetText('Время в секундах')
		timeSlider:SetMin(1)
		timeSlider:SetMax(1000)
		timeSlider:SetDecimals(0)
		timeSlider:SetConVar('spawn_robbery_system_v1_time')
		timeSlider:Dock(TOP)

		local rewardPanel = content:Add('Panel')
		rewardPanel:Dock(FILL)

		optionSelector.OnSelect = function(_, index, value)
			rewardPanel:Clear()
			if value == 'Оружие' then
				local list = rewardPanel:Add('DListView')
				list:SetSize(250, 300)
				list:SetMultiSelect(false)
				list:AddColumn('Название')
				list:AddColumn('ID')
				list:AddColumn('Выбрано')
				list:Dock(FILL)

				local weapons = weapons.GetList()
				local selected = {}
				for _, weapon in pairs(weapons) do
					local line = list:AddLine(weapon.PrintName, weapon.ClassName, '')
					line.weapon = weapon
				end

				list.OnRowSelected = function(_, index, row)
					local weapon = row.weapon
					if not selected[weapon.ClassName] then
						selected[weapon.ClassName] = true
						row:SetColumnText(3, '+')
					else
						selected[weapon.ClassName] = nil
						row:SetColumnText(3, '')
					end

					timer.Simple(0, function()
						RunConsoleCommand('spawn_robbery_system_v1_data', util.TableToJSON(selected))
					end)
				end
			elseif value == 'Деньги' then
				local dataEntry = rewardPanel:Add('DTextEntry')
				dataEntry:SetPlaceholderText('Введите сумму...')
				dataEntry:SetTall(ScreenScale(10.5))
				dataEntry:Dock(TOP)
				dataEntry:DockMargin(0, 0, 0, ScreenScale(2))
				dataEntry:SetUpdateOnType(true)
				dataEntry.OnChange = function(panel, value)
					local value = panel:GetText()
					local data = {amount = value}
					data = util.TableToJSON(data)
					RunConsoleCommand('spawn_robbery_system_v1_data', data)
				end
			end
		end

		return frame
	end

	net.Receive('openMenuPon', openMenu)

	surface.CreateFont('spawn_robbery_system_v1.font00', {
		font = 'Overpass Bold',
		size = 32,
		extended = true
	})

	surface.CreateFont('spawn_robbery_system_v1.font_medium', {
		font = 'Overpass',
		size = 50,
		extended = true
	})

	surface.CreateFont('spawn_robbery_system_v1.font2', {
		font = 'Overpass',
		size = 32,
		extended = true
	})

	surface.CreateFont('spawn_robbery_system_v1.ui_font0', {
		font = 'Overpass Bold',
		size = ScreenScale(7),
		extended = true
	})

	surface.CreateFont('spawn_robbery_system_v1.ui_font1', {
		font = 'Overpass',
		size = ScreenScale(6),
		extended = true
	})
end

function TOOL:Deploy()
	if CLIENT then return end
	local owner = self:GetOwner()
	spawns:SendPoints(owner)
end
