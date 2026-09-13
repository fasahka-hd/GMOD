--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

local PANEL = {}

local function resizeElements(pnl)
end

PANEL.PerformLayout = resizeElements

do
	function PANEL:Init()
		self.player = self:Add('ba_new_menu_player')
		self.player.steamid = true
		self.player.checkbox:Hide()
		self.player:Hide()

		self.player:Dock(TOP)
		self.player:SetTall(select(2, ba.ui.NewMenuScreenScale(nil, 63)))
		self:SizeToChildren(false, true)

		self.args = {}
	end
end

function PANEL:SetPlayer(ply)
	if IsValid(ply) then
		self.player:SetPlayer(ply)
		self.player:Show()
	else
		self.player:Hide()
	end

	self:UpdateSize()
end

function PANEL:UpdateSize()
	local h = self.player:IsVisible() and self.player:GetTall() or 0

	for k, v in ipairs(self.args) do
		h = h + v:GetTall() + (select(2, v:GetDockMargin())) 
	end

	self:SetTall(h)
end

--[[ 
			for k, v in pairs(ba.ranks.GetTable()) do
				if num > #ba.ranks.GetTable() then break end
				if (LocalPlayer():GetImmunity() > v:GetImmunity()) then
					self:AddChoice(ba.str.Capital(v:GetName()))
				end
				num = num + 1
			end--]] 

local overrides = {
	string = function(parent, param)
		parent:SetText('Значение: ' .. param.Key)

		local textInput = parent:Add('ba_new_menu_textinput')
		textInput:Dock(TOP)
		textInput:SetMultiline(false)
		textInput:SetTabbingDisabled(true)
		textInput:SetTall(select(2, ba.ui.NewMenuScreenScale(nil, 53)))

		parent.child = textInput
	end,
	rank = function(parent, param)
		parent:SetText('Ранк: ' .. param.Key)

		local comboBox = parent:Add('ba_new_menu_combobox')
		comboBox:Dock(TOP)
		comboBox:SetValue('Введите ранк.')

		local ply = LocalPlayer()
		for k, v in ipairs(ba.ranks.GetTable()) do
			if ply:GetImmunity() > v:GetImmunity() then
				comboBox:AddChoice(ba.str.Capital(v:GetName()))
			end
		end

		comboBox:SetTall(select(2, ba.ui.NewMenuScreenScale(nil, 53)))

		parent.child = comboBox
	end,

	time = function(parent, param)
		parent:SetText('Время: ' .. param.Key)

		local panel = parent:Add('PANEL')
		panel:SetTall(select(2, ba.ui.NewMenuScreenScale(nil, 53)))
		panel:Dock(TOP)

		panel.number = panel:Add('ba_new_menu_combobox')
		panel.number:Dock(LEFT)

		panel.literal = panel:Add('ba_new_menu_combobox')
		panel.literal:Dock(FILL)
		panel.literal:SetValue('Unit')

		for i = 1, 30 do
			panel.number:AddChoice(i)
		end

		for k, v in pairs(ba.NumberUntits) do
			panel.literal:AddChoice(k)
		end

		panel.GetValue = function()
			return panel.number:GetValue() .. panel.literal:GetValue()
		end

		panel.PerformLayout = function(pnl, x)
			local margin = ba.ui.NewMenuScreenScale(5)
			
			pnl.literal:DockMargin(margin, 0, 0, 0)
			pnl.number:SetWide(x*0.5 - margin)
		end

		parent.child = panel
	end
}

function PANEL:SetArgs(cmd)
	for k, v in ipairs(self.args) do
		v:Remove()
	end

	local args = {}

	if cmd then
		for k, v in pairs(cmd:GetArgs()) do
			local override = overrides[v.Param]
			if override then
				local argPanel = self:Add('ba_new_menu_arg')
				argPanel:Dock(TOP)

				local _, yMarg = ba.ui.NewMenuScreenScale(nil, 5)
				argPanel:DockMargin(0, yMarg, 0, 0)

				override(argPanel, v)

				argPanel:SizeToChildren(false, true)

				local w, h = argPanel:GetSize()
				local wp, hp = ba.ui.NewMenuScreenScale(11, 54)
				local _, hp2 = ba.ui.NewMenuScreenScale(nil, 12)

				argPanel:SetTall(h+hp+hp2)

				args[#args+1] = argPanel
			end
		end
	end

	self.args = args
	self:UpdateSize()
end

vgui.Register('ba_new_menu_args', PANEL)

--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
