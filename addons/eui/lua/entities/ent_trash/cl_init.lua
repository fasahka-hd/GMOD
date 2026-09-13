include('shared.lua')

function ENT:Draw()
	self:DrawModel()
	self:DestroyShadow()
end

local math_clamp = math.Clamp

local function DrawProgressBar(x, y, w, h, perc, color, colorbg, colorout)
	local c = color or Color(255 - (perc * 255), perc * 255, 0, 255)
	local cb = colorbg or Color(30, 30, 30, 200)
	local co = colorout or Color(0, 0, 0, 150)
	surface.SetDrawColor(cb)
	surface.DrawRect(x, y, w, h)
	surface.SetDrawColor(co)
	surface.DrawOutlinedRect(x, y, w, h)
	surface.SetDrawColor(c)
	surface.DrawRect(x + 1, y + 1, math_clamp((w * perc), 3, w - 2), h - 2)
end

local scrW, scrH = ScrW(), ScrH()
local blur = Material('pp/blurscreen')

local function framework(panel, amount)
	local x, y = panel:LocalToScreen(0, 0)
	surface.SetDrawColor(255, 255, 255)
	surface.SetMaterial(blur)

	for i = 1, 3 do
		blur:SetFloat('$blur', (i / 3) * (amount or 6))
		blur:Recompute()
		render.UpdateScreenEffectTexture()
		surface.DrawTexturedRect(x * -1, y * -1, scrW, scrH)
	end
end

net.Receive('OpenTrashDerma', function()
	local eTrash = net.ReadEntity()
	local pPlayer = LocalPlayer()

	if IsValid(MainTrash) then return end

	MainTrash = vgui.Create('DFrame')
	MainTrash:SetSize(350, 50)
	MainTrash:Center()
	MainTrash:SetTitle('')
	MainTrash:ShowCloseButton(false)
	MainTrash:SetDraggable(false)

	MainTrash.NextSound = CurTime()
	MainTrash.StartClean = CurTime()
	MainTrash.EndClean = MainTrash.StartClean + 3
	MainTrash.Dots = MainTrash.Dots or ''

	timer.Create('LockPickDots', 0.5, 0, function()
		if not IsValid(MainTrash) then
			timer.Remove('LockPickDots')
			return
		end

		local len = string.len(MainTrash.Dots)
		local dots = {[0] = '.', [1] = '..', [2] = '...', [3] = ''}

		MainTrash.Dots = dots[len]
	end)

	MainTrash.Paint = function(self, w, h)
		framework(self, 5)
		local time = self.EndClean - self.StartClean
		local status = (CurTime() - self.StartClean) / time
		DrawProgressBar(0, 0, w, h, status, Color(0, 0, 0, 175), Color(0, 0, 0, 150), Color(0, 0, 0, 100))
		draw.SimpleTextOutlined('Убираем' .. self.Dots, eui.Font('16:Medium'), w / 2, h / 2, color_white, 1, TEXT_ALIGN_CENTER, 1, color_black)
	end

	MainTrash.Think = function(self)
		local curtime = CurTime()

		if not IsValid(eTrash) and IsValid(self) then self:Remove() end

		if IsValid(eTrash) and self.NextSound < curtime then
			eTrash:EmitSound('npc/metropolice/gear' .. math.random(1, 6) .. '.wav')
			self.NextSound = CurTime() + 1
		end

		if IsValid(eTrash) and self.EndClean < curtime then
			if IsValid(self) then
				self:Remove()
			end

			net.Start('RemoveTrash')
			net.WriteEntity(eTrash)
			net.SendToServer()
		end

		if IsValid(eTrash) and pPlayer:GetEyeTrace().Entity ~= eTrash then
			if IsValid(self) then
				self:Remove()
			end
		end
	end
end)
