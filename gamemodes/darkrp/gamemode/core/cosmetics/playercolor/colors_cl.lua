--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

local function makeTab(tabs)

	local tab = ui.Create('ui_panel')

	tab:SetSize(tabs:GetParent():GetWide() - 60, tabs:GetParent():GetTall() - 35)



	local w, h = (tab:GetWide() * 0.9) - 7.5, ((tab:GetTall() - 115) * 0.5)



	ui.Create('ui_button', function(self, p)

		self:SetPos(5, 5)

		self:SetSize(w, 30)

		self:SetText('Цвет персонажа')

		self:SetDisabled(true)

	end, tab)



	ui.Create('DColorMixer', function(self, p)

		self:SetAlphaBar(false)

		self:SetSize(w, h)

		self:SetPos(5, 40)

		self:SetVector(Vector(GetConVarString('cl_playercolor')))

		self.ValueChanged = function()

			local vec = self:GetVector()

			local vecstr = tostring(vec)

			timer.Create('rp.PlayerColor', 0.25, 1, function()

				RunConsoleCommand('cl_playercolor', vecstr)

				cmd.Run('playercolor', vec.x, vec.y, vec.z)

			end)

		end

	end, tab)



	ui.Create('ui_button', function(self, p)

		self:SetPos(5, h + 45)

		self:SetSize(w, 30)

		self:SetText('Цвет Физ-Гана')

		self:SetDisabled(true)

	end, tab)



	ui.Create('DColorMixer', function(self, p)

		self:SetAlphaBar(false)

		self:SetSize(w, h)

		self:SetPos(5, h + 80)

		self:SetVector(Vector(GetConVarString('cl_weaponcolor')))

		self.ValueChanged = function()

			local vec = self:GetVector()

			local vecstr = tostring(vec)

			timer.Create('rp.WeaponnColor', 0.25, 1, function()

				RunConsoleCommand('cl_weaponcolor', vecstr)

				cmd.Run('physcolor', vec.x, vec.y, vec.z)

			end)

		end

	end, tab)



	ui.Create('ui_button', function(self, p)

		self:SetSize(w, 30)

		self:SetPos(5, p:GetTall() - 30)

		self:SetText('Секретный цвет Физ-Гана')

		self.DoClick = function()

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

	end, tab)





	return tab

end



hook('PopulateF4Tabs', 'rp.cosmetrics.Tabs', function(tabs)

	tabs:AddTab('Цвета', function(self)

		return makeTab(tabs)

	end):SetIcon 'sup/gui/f4/cosmeticsf4.png'

end)



--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
