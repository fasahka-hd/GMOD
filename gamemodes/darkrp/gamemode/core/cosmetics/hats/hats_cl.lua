--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

rp.hats = rp.hats or {}
rp.hats.stored = rp.hats.stored or {}

local vecneg = Vector(0, 0, -32000)

function rp.hats.Render(ent, model)
	local cfg = rp.hats.list[model]

	if cfg then
		local bonenum = ent:LookupBone('ValveBiped.Bip01_Head1')
		
		local hat = rp.hats.stored[ent] or ClientsideModel(model, RENDERGROUP_BOTH)
		rp.hats.stored[ent] = rp.hats.stored[ent] or hat
		
		if (bonenum) then
			local pos, ang = ent:GetBonePosition(bonenum)

			local offang = cfg.offang
			ang:RotateAroundAxis(ang:Forward(), offang.p + 270)
			ang:RotateAroundAxis(ang:Right(), offang.y + 270)
			ang:RotateAroundAxis(ang:Up(), offang.r - 5)

			local offpos = cfg.offpos
			pos = pos + (ang:Forward() * offpos.x) + (ang:Right() * offpos.y) + (ang:Up() * offpos.z)
				
			hat:SetModelScale(cfg.scale, 0)
					
			hat:SetPos(pos)
			hat:SetAngles(ang)
					
			hat:SetRenderOrigin(pos)
			hat:SetRenderAngles(ang)
			hat:SetupBones()
			hat:DrawModel()

			hat:SetRenderOrigin()
			hat:SetRenderAngles()

			if (model ~= hat:GetModel()) then
				hat:SetModel(model)
			end
		else
			hat:SetRenderOrigin(vecneg)
		end
	end
end

hook('PostPlayerDraw', 'hats.PostPlayerDraw', function(pl)
	if pl:GetHat() then
		if ((pl ~= LocalPlayer()) and (not pl.IsCurrentlyVisible)) or (pl == LocalPlayer() and (not (cvar.GetValue('enable_thirdperson') ~= true)) and (not IsValid(LocalPlayer():GetActiveWeapon()) and LocalPlayer():GetActiveWeapon() ~= 'gmod_camera')) then return end
		rp.hats.Render(pl, pl:GetHat())
	end
end)

hook('Think', 'hats.Think', function()
	for k, v in pairs(rp.hats.stored) do
		if (not IsValid(v)) then
			rp.hats.stored[k] = nil
		else
			if (not IsValid(k)) or (k:IsPlayer() and ((not k:Alive()) or (not k:GetHat()) or (v:GetModel() ~= k:GetHat()) or ((!(cvar.GetValue('enable_thirdperson') ~= true)) and (k == LocalPlayer())) or ((k ~= LocalPlayer()) and (not k.IsCurrentlyVisible)))) then
				v:Remove()
				rp.hats.stored[k] = nil
			end
		end
	end
end)


-- Menu
hook('PopulateF4Tabs', 'hats.PopulateF4Tabs', function(tabs)
    local cont = ui.Create('ui_panel')
	cont:SetSize(tabs:GetParent():GetWide() - 165, tabs:GetParent():GetTall() - 35)
	tabs:AddTab('Шапки', cont):SetIcon('sup/gui/f4/hatf4.png')

    local tab = ui.Create('ui_scrollpanel', function(self, p)
        self:SetPos(0, 0)
        self:SetSize(p:GetWide() * .65 - 7.5, p:GetTall() - 10)
        self:SetSpacing(2)
    end, cont)

	local prev = ui.Create('rp_playerpreview', function(self, p)
		self:SetPos((p:GetWide() * .65) + 2.5, 35)
		self:SetSize((p:GetWide() * .35) - 7.5, p:GetTall() - 115)
	end, cont)

    for k, v in SortedPairsByMemberValue(rp.hats.list, 'price', false) do
    	local pnl = ui.Create('ui_panel', function(self, p)
    		self:SetTall(65)
    	end)
    	tab:AddItem(pnl)

		ui.Create('rp_modelicon', function(self, p)
			self:SetSize(65,65)
			self:SetPos(0,0)
			self:SetModel(v.model)
			self.DoClick = function() end
		end, pnl)

		ui.Create('DLabel', function(self, p)
			self:SetText(v.name)
			self:SetFont('ui.22')
			self:SetPos(p:GetWide()/2 - self:GetWide() - 2, 5)
			self:SizeToContents()
		end, pnl)

		ui.Create('DLabel', function(self, p)
			self:SetText(rp.FormatMoney(v.price))
			self:SetFont('ui.22')
			self:SetPos(p:GetWide()/2 - self:GetWide() - 2, p:GetTall() - self:GetTall() - 5)
			self:SizeToContents()
		end, pnl)

		ui.Create('DButton', function(self, p)
			self:SetText('Примерить')
			self:SetSize(105, 25)
			self:SetPos(p:GetWide() - 110, 5)
			self.DoClick = function()
				prev:SetHat(v.model)
			end
		end, pnl)

		local hashat = table.HasValue(LocalPlayer():GetNetVar('HatData') or {}, v.model)

		if hashat then
			ui.Create('DButton', function(self, p)
				self:SetText('Надеть')
				self:SetSize(105, 25)
				self:SetPos(p:GetWide() - 110, 35)
				self.DoClick = function()
					cmd.Run('sethat', v.model) 
					prev:SetHat(v.model)			
				end
			end, pnl)
		else
			ui.Create('DButton', function(self, p)
				self:SetText('Купить')
				self:SetSize(105, 25)
				self:SetPos(p:GetWide() - 110, 35)
				self.Confirm = hashat
				self.DoClick = function()
					if self.Confirm then
						cmd.Run('buyhat', v.model) 
						prev:SetHat(v.model)
						self:SetText('Надеть')
						self.DoClick = function()
							cmd.Run('sethat', v.model) 
							prev:SetHat(v.model)			
						end
					else
						self.Confirm = true
						self:SetText('Нажмите снова')
					end		
				end
			end, pnl)
		end

    end

    ui.Create('DButton', function(self, p)
		self:SetText('Снять шапку')
		self:SetPos((p:GetWide() * .65) + 2.5, p:GetTall() - 30)
		self:SetSize((p:GetWide() * .35) - 7.5, 25)
		function self:DoClick()
			cmd.Run('removehat')
			prev:SetHat(nil)
		end
		function self:Think()
			if LocalPlayer():GetHat() then
				self:SetDisabled(false)
			else
				self:SetDisabled(true)
			end
		end
	end, cont)
end)

--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
