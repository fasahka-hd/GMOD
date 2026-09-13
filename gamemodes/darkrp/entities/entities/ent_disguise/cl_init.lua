--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

include 'shared.lua'
function ENT:Draw()
	self:DrawModel()
end

local PANEL = {}

function PANEL:Init()
	self:SetText('')
	self:SetTall(50)

	self.Model = ui.Create('rp_modelicon', self)
	self.Model.DoClick = function(s)
		s.DoClick(self)
	end
end

function PANEL:Paint(w, h)
	draw.OutlinedBox(0, 0, w, h, self.job.color, ui.col.Outline)
	
	if self:IsHovered() then
		draw.OutlinedBox(0, 0, w, h, self.job.color, (self.job.vip) and ui.col.Gold or ui.col.White)
	end

	local x = 60
	if self.job.vip then
		x = x + draw.SimpleTextOutlined('[ВИП]', 'ui.22', x, h * 0.5, ui.col.Gold, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, ui.col.Black) + 5
	end

	if self.job.playtime and (LocalPlayer():GetPlayTime() < self.job.playtime) then
		x = x + draw.SimpleTextOutlined('[' .. math.Round(self.job.playtime/3600 - LocalPlayer():GetPlayTime()/3600, 2) .. 'ч Игровое время] или [ВИП]', 'ui.22', x, h * 0.5, ui.col.Gold, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, ui.col.Black) + 5
	end

	draw.SimpleTextOutlined(self.job.name, 'ui.22', x, h * 0.5, ui.col.White, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, ui.col.Black)
	draw.SimpleTextOutlined(#team.GetPlayers(self.job.team) .. '/' .. ((self.job.max == 0) and '∞' or self.job.max), 'ui.22', w - 10, h * 0.5, ui.col.White, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER, 1, ui.col.Black)
end

function PANEL:PerformLayout()
	self.Model:SetPos(0, 0)
	self.Model:SetSize(50, 50)
end

function PANEL:OnCursorEntered()
	self.Parent.job = self.job

	local model = cvar.GetValue('TeamModel' .. self.job.name)
	self.Parent.ModelKey = (isnumber(model) and self.job.model[model]) and model or 1
	self.Parent.ModelPath = istable(self.job.model) and self.job.model[self.Parent.ModelKey] or self.job.model
	self.Preview:SetModel(self.Parent.ModelPath)
	self.Preview:FindSequence()
end

function PANEL:DoClick()
	cmd.Run('model', self.job.model[self.Parent.ModelKey])

	if self.Parent.DoClick then
		self.Parent.DoClick(self)
		return
	end

	if self.job.vote then
		local command = self.job.command
		cmd.Run('vote' .. command)
	elseif self.job.CannotOwnDoors then
		local command = self.job.command
		ui.BoolRequest("Продать двери", self.job.name .. ' не может владеть дверями! Сменив работу, все ваши двери будут проданы. Продолжить?', function(ans)
			if (ans == true) then
				cmd.Run(command)
			end
		end)
	else
		cmd.Run(self.job.command)
	end

	rp.ToggleF4Menu()
end

function PANEL:SetJob(job)
	self.job = job
	self.job.color = Color(job.color.r, job.color.g, job.color.b, 125)
	self.ModelPath = istable(job.model) and job.model[1] or job.model
	self.Model:SetModel(self.ModelPath)
end

vgui.Register('rp_jobbutton', PANEL, 'Button')


PANEL = {}

local mat_checked = Material 'icon16/tick.png'
local mat_unchecked = Material 'icon16/cross.png'
function PANEL:Init()
	self.job = rp.teams[1]
	self.job.color = Color(self.job.color.r, self.job.color.g, self.job.color.b, 125)

	self.ModelKey = math.Clamp((cvar.GetValue('TeamModel' .. self.job.name) or 1), 1, #self.job.model)
	self.ModelPath = istable(self.job.model) and self.job.model[self.ModelKey] or self.job.model
	cmd.Run('model', self.ModelPath)

	self.JobList = ui.Create('ui_scrollpanel', self)

	local function checkValue(self, w, y, value, canStr, cannotStr)
		draw.OutlinedBox(0, y, w, 40, ui.col.FlatBlack, ui.col.Outline)
		draw.OutlinedBox(0, y, 40, 40, ui.col.FlatBlack, ui.col.Outline)

		local isMaybe = isstring(value)

		surface.SetDrawColor(value and (isMaybe and ui.col.Yellow or ui.col.Green) or ui.col.Red)
		surface.SetMaterial(value and mat_checked or mat_unchecked)
		surface.DrawTexturedRect(5, y + 5, 30, 30)

		draw.SimpleTextOutlined((value and canStr or cannotStr) .. (isMaybe and (': ' .. value) or ''), 'ui.22', 45, y + 20, ui.col.White, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, ui.col.Black)
	end

	self.Info = ui.Create('ui_panel', self)
	self.Info.Paint = function(s, w, h)
		draw.OutlinedBox(0, 0, w, 50, self.job.color, ui.col.Outline)
		draw.SimpleTextOutlined(self.job.name, 'ui.24', w * 0.5, 25, ui.col.White, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, ui.col.Black)

		local y = 49
		checkValue(self, w, y, self.job.CanRaid, 'Рейды разрешены', 'Рейды запрещены')
		
		y = 88
		checkValue(self, w, y, self.job.CanMug, 'Разрешены грабежи', 'Запрещены грабежи')
		
		y = 127
		checkValue(self, w, y, self.job.CanHostage, 'Разрешено брать заложников', 'Запрещено брать заложников')
		
		y = 166

		local relations = self.job.GetRelationships and self.job.GetRelationships() or false

		checkValue(self, w, y, relations, 'Имеет RP отношения к', 'Не имеет RP отношений')

		if relations and (#relations > 0) and (not isstring(relations)) then
			y = 205

			for k, v in ipairs(relations) do
				local t = rp.teams[v]

				if (v == self.job.team) and (t.max == 1) then continue end

				draw.OutlinedBox(0, y, w, 40, Color(t.color.r, t.color.g, t.color.b, 125), ui.col.Outline)
				draw.SimpleTextOutlined(t.name, 'ui.22', w * 0.5, y + 20, ui.col.White, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, ui.col.Black)

				y = y + 39
			end
		end
	end

	self.Model = ui.Create('rp_playerpreview', self)
	self.Model:SetFOV(50)
	self.Model:SetModel(istable(self.job.model) and self.ModelPath or self.job.model)

	self.BackModel = ui.Create('DButton', self)
	self.BackModel:SetText('<')
	self.BackModel.Think = function(s)
		if (not istable(self.job.model)) or (#self.job.model == 1) or (self.ModelKey <= 1) then
			s:SetDisabled(true)
		else
			s:SetDisabled(false)
		end
	end
	self.BackModel.DoClick = function()
		self.ModelKey = self.ModelKey - 1
		self.ModelPath = istable(self.job.model) and self.job.model[self.ModelKey] or self.job.model
		self.Model:SetModel(self.ModelPath)
		cvar.SetValue('TeamModel' .. self.job.name, self.ModelKey)
	end

	self.NextModel = ui.Create('DButton', self)
	self.NextModel:SetText('>')
	self.NextModel.Think = function(s)
		if (not istable(self.job.model)) or (#self.job.model == 1) or (self.ModelKey >= #self.job.model) then
			s:SetDisabled(true)
		else
			s:SetDisabled(false)
		end
	end
	self.NextModel.DoClick = function()
		self.ModelKey = self.ModelKey + 1
		self.ModelPath = istable(self.job.model) and self.job.model[self.ModelKey] or self.job.model
		self.Model:SetModel(self.ModelPath)
		cvar.SetValue('TeamModel'  .. self.job.name, self.ModelKey)
	end


	local teams = {}
	for k, v in ipairs(rp.teams) do
		if ((not v.customCheck) or v.customCheck(LocalPlayer())) and (k ~= LocalPlayer():Team()) and not (v.nodisguise) then
			local cat = v.catagory or 'Гражданские/Другие'
			if (not teams[cat]) then teams[cat] = {} end
			teams[cat][#teams[cat] + 1] = v
		end
	end

	for cat, jobs in SortedPairs(teams) do
		self:AddCat(cat)
		for _, job in ipairs(jobs) do
			self:AddJob(job)
		end
	end
end


function PANEL:AddCat(cat)
	self.JobList:AddItem(ui.Create('DButton', function(self, p)
		self:SetText(cat)
		self:SetTall(50)
		self:SetDisabled(true)
	end))
end

function PANEL:AddJob(job)
	local btn = ui.Create('rp_jobbutton')
	btn:SetJob(job)
	btn.Parent 	= self
	btn.Preview = self.Model
	self.JobList:AddItem(btn)
end

function PANEL:PerformLayout()
	self.JobList:SetPos(5, 5)
	self.JobList:SetSize(self:GetWide() * 0.5 - 7.5, self:GetTall() - 10)

	self.Info:SetPos(self:GetWide() * 0.5 + 2.5, 5)
	self.Info:SetSize(self:GetWide() * 0.5 - 7.5, self:GetTall() * 0.5)

	self.Model:SetPos(self:GetWide() * 0.5 + 2.5, self:GetTall() * 0.5)
	self.Model:SetSize(self:GetWide() * 0.5 - 7.5, self:GetTall() * 0.5 - 35)

	self.BackModel:SetPos(self:GetWide() * 0.75 - 52.5, self:GetTall() - 30)
	self.BackModel:SetSize(50, 25)

	self.NextModel:SetPos(self:GetWide() * 0.75 + 2.5, self:GetTall() - 30)
	self.NextModel:SetSize(50, 25)
end

vgui.Register('rp_jobslistds', PANEL, 'Panel')

function rp.DisguiseMenu()
	local ent = net.ReadEntity()

	local fr = ui.Create('ui_frame', function(self, p)
		self:SetSize(ScrW() * 0.65, ScrH() * 0.6)
		self:SetTitle('Маскировка')
		self:Center()
		self:MakePopup()
	end)

	ui.Create('rp_jobslistds', function(self, p)
		self:SetPos(5,25)
		self:SetSize(p:GetWide() - 10, p:GetTall() - 30)
		self.DoClick = function()
			if IsValid(ent) then
				net.Start('DisguiseToServer')
					net.WriteEntity(ent)
					net.WriteInt(self.job.team, 8)
				net.SendToServer()
			else
				net.Start('PlayerDisguise')
					net.WriteInt(self.job.team, 8)
				net.SendToServer()
			end
			fr:Remove()
		end
	end, fr)
end
net.Receive('DisguiseMenu', rp.DisguiseMenu)

--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
