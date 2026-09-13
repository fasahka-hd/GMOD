--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

local PANEL = {}

--[[---------------------------------------------------------
   Name: Paint
-----------------------------------------------------------]]
function PANEL:Init()

	self.IsLayedOut = {}

	self:Populate()
	self:SetFadeTime(0)

end


--[[---------------------------------------------------------
   Name: Paint
-----------------------------------------------------------]]
-----------------------------------------------------------]]
function PANEL:Populate()

	local tabs = spawnmenu.GetCreationTabs()

	for k, v in SortedPairsByMemberValue(tabs, "Order") do

		if self.IsLayedOut[k] or (v.CustomCheck and (v.CustomCheck() == false)) then continue end

		self.IsLayedOut[k] = true

		--
		-- Here we create a panel and populate it on the first paint
		-- that way everything is created on the first view instead of
		-- being created on load.
		--
		local pnl = vgui.Create("Panel")

		self:AddSheet(k, pnl, v.Icon, nil, nil, v.Tooltip)

		--
		-- On paint, remove the paint function and populate the panel
		--
		pnl.Paint = function()

			pnl.Paint = nil

			local childpnl = v.Function()
			childpnl:SetParent(pnl)
			childpnl:Dock(FILL)

		end


	end

end

vgui.Register("CreationMenu", PANEL, "DPropertySheet")

--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
