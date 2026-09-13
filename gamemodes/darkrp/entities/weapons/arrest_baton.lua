AddCSLuaFile()

local BaseClass = baseclass.Get('baton_base')

if CLIENT then
	SWEP.PrintName = 'Арестовать'
	SWEP.Instructions = 'ЛКМ по игроку — выбрать срок и причину ареста'
end

SWEP.Slot = 2
SWEP.SlotPos = 1
SWEP.Spawnable = true
SWEP.Category = 'RP'
SWEP.Color = Color(255, 0, 0, 255)

local NET_ARREST = 'rp.ArrestBaton.CustomArrest'
local MAX_ARREST_TIME = 240

if SERVER then
	util.AddNetworkString(NET_ARREST)
end

local function BattlepassProgress(pl)
	if not eui or not eui.battlepass or not eui.battlepass.AddProgress then return end
	eui.battlepass.AddProgress(pl, 12)
	eui.battlepass.AddProgress(pl, 35)
end

local function CanArrestWithBaton(actor, ent)
	if not IsValid(actor) or not actor:IsPlayer() then return false end
	if not IsValid(ent) or not ent:IsPlayer() then return false end
	if not actor:IsCP() then return false, 'Вы не можете арестовывать людей.' end
	if actor:GetPos():DistToSqr(ent:GetPos()) > 22500 then return false, 'Вы слишком далеко от игрока.' end
	if not ent:GetNWBool('isHandcuffed', false) then return false, 'Игрок должен быть в наручниках, чтобы арестовать его.' end
	if (SafeZones and SafeZones.IsInZone and (SafeZones.IsInZone(actor:GetPos()) or SafeZones.IsInZone(ent:GetPos()))) then return false, 'В зеленой зоне запрещено арестовывать людей.' end
	if ent:IsCP() or ent:IsMayor() then return false, 'Вы не можете арестовывать других копов.' end
	if ent.IsAdmjob and ent:IsAdmjob() then return false, 'Администратора запрещено арестовывать.' end
	return true
end

local function DoArrest(actor, ent, arrestTime, reason)
	local ok, err = CanArrestWithBaton(actor, ent)
	if not ok then
		if err then rp.Notify(actor, NOTIFY_ERROR, err) end
		return
	end

	if ent:InVehicle() then ent:ExitVehicle() end

	arrestTime = math.Clamp(math.floor(tonumber(arrestTime) or 60), 60, MAX_ARREST_TIME)
	reason = string.Trim(tostring(reason or ''))
	if reason == '' then
		rp.Notify(actor, NOTIFY_ERROR, 'Укажите причину ареста.')
		return
	end
	reason = string.sub(reason, 1, 120)

	BattlepassProgress(actor)
	ent:Arrest(actor, reason, arrestTime)

	rp.Notify(ent, NOTIFY_ERROR, 'Вас арестовал ' .. actor:Name() .. ' на ' .. arrestTime .. ' сек. Причина: ' .. reason)
	rp.Notify(actor, NOTIFY_SUCCESS, 'Вы арестовали ' .. ent:Name() .. ' на ' .. arrestTime .. ' сек. Причина: ' .. reason)
end

if CLIENT then
	surface.CreateFont('ArrestBaton.Title', {
		font = 'Roboto',
		size = 30,
		weight = 800,
		extended = true
	})

	surface.CreateFont('ArrestBaton.Text', {
		font = 'Roboto',
		size = 18,
		weight = 600,
		extended = true
	})

	surface.CreateFont('ArrestBaton.Button', {
		font = 'Roboto',
		size = 24,
		weight = 600,
		extended = true
	})

	local panelBg = Color(42, 43, 46, 255)
	local red = Color(218, 62, 68, 255)
	local redHover = Color(235, 70, 76, 255)
	local inputBg = Color(159, 159, 159, 64)
	local inputBgHover = Color(159, 159, 159, 82)
	local sliderLine = Color(157, 118, 126, 255)
	local sliderKnob = Color(199, 150, 160, 255)
	local text = Color(255, 255, 255, 255)
	local muted = Color(136, 136, 136, 255)
	local cancelText = Color(180, 180, 180, 255)

	local function sc(v)
		return math.Round(v * math.min(ScrW(), ScrH()) / 1080)
	end

	local function DrawPanelGradient(w, h)
		-- Аккуратный градиент внутри настоящего скругления без прозрачных квадратов по углам.
		-- Не используем vgui/gradient-d, потому что у него могут быть артефакты на закруглениях.
		local radius = sc(15)
		local maxAlpha = 26

		for y = 0, h - 1 do
			local alpha = math.floor((y / h) * maxAlpha)
			if alpha <= 0 then continue end

			local inset = 0

			if y < radius then
				local dy = radius - y
				inset = radius - math.sqrt(math.max(radius * radius - dy * dy, 0))
			elseif y > h - radius then
				local dy = y - (h - radius)
				inset = radius - math.sqrt(math.max(radius * radius - dy * dy, 0))
			end

			inset = math.ceil(inset)
			surface.SetDrawColor(red.r, red.g, red.b, alpha)
			surface.DrawRect(inset, y, w - inset * 2, 1)
		end
	end

	local function PaintButton(btn, w, h, color, hoverColor, textColor)
		draw.RoundedBox(sc(5), 0, 0, w, h, btn:IsHovered() and hoverColor or color)
		draw.SimpleText(btn:GetText(), 'ArrestBaton.Button', w / 2, h / 2, textColor or text, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		return true
	end

	local function OpenArrestMenu(wep, target)
		if not IsValid(target) or not target:IsPlayer() then return end
		if IsValid(rpArrestBatonMenu) then rpArrestBatonMenu:Remove() end

		local frame = vgui.Create('DFrame')
		rpArrestBatonMenu = frame
		frame:SetSize(sc(700), sc(450))
		frame:Center()
		frame:SetTitle('')
		frame:ShowCloseButton(false)
		frame:SetDraggable(false)
		frame:MakePopup()
		frame.Paint = function(self, w, h)
			draw.RoundedBox(sc(15), 0, 0, w, h, panelBg)

			-- Нижний красный градиент без квадратных артефактов на закруглениях.
			DrawPanelGradient(w, h)

			draw.SimpleText('АРЕСТ ИГРОКА', 'ArrestBaton.Title', sc(22), sc(35), text, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
			draw.SimpleText(target:Name(), 'ArrestBaton.Text', sc(28), sc(75), text, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
		end

		local timeBox = vgui.Create('DPanel', frame)
		timeBox:SetPos(sc(78), sc(115))
		timeBox:SetSize(sc(545), sc(88))
		timeBox.Paint = function(self, w, h)
			draw.RoundedBox(sc(5), 0, 0, w, h, inputBg)
			draw.SimpleText('Срок ареста, сек.', 'ArrestBaton.Text', sc(15), sc(21), text, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
			draw.SimpleText('максимум ' .. MAX_ARREST_TIME, 'ArrestBaton.Text', w - sc(15), sc(21), muted, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
		end

		local timeSlider = vgui.Create('DNumSlider', timeBox)
		timeSlider:SetPos(sc(110), sc(38))
		timeSlider:SetSize(sc(420), sc(43))
		timeSlider:SetText('')
		timeSlider:SetMin(60)
		timeSlider:SetMax(MAX_ARREST_TIME)
		timeSlider:SetDecimals(0)
		timeSlider:SetValue(60)

		if IsValid(timeSlider.Label) then
			timeSlider.Label:SetWide(0)
			timeSlider.Label:SetText('')
		end

		if IsValid(timeSlider.TextArea) then
			timeSlider.TextArea:SetWide(sc(70))
			timeSlider.TextArea:SetTextColor(text)
			timeSlider.TextArea:SetHighlightColor(sliderKnob)
			timeSlider.TextArea:SetCursorColor(text)
			timeSlider.TextArea:SetNumeric(true)
			timeSlider.TextArea:SetContentAlignment(5)
			timeSlider.TextArea:SetFont('ArrestBaton.Text')
			timeSlider.TextArea.Paint = function(self, w, h)
				self:DrawTextEntryText(text, sliderKnob, text)
			end
		end

		if IsValid(timeSlider.Slider) then
			timeSlider.Slider.Paint = function(self, w, h)
				draw.RoundedBox(sc(100), sc(8), h / 2 - sc(2), w - sc(16), sc(4), sliderLine)
			end

			if IsValid(timeSlider.Slider.Knob) then
				timeSlider.Slider.Knob:SetText('')
				timeSlider.Slider.Knob:SetSize(sc(14), sc(14))
				timeSlider.Slider.Knob.PaintOver = function() end
				timeSlider.Slider.Knob.Paint = function(self, w, h)
					draw.NoTexture()
					surface.SetDrawColor(self:IsHovered() and Color(220, 170, 180) or sliderKnob)
					local circle = {}
					local r = math.min(w, h) / 2
					for i = 0, 32 do
						local a = math.rad((i / 32) * 360)
						circle[#circle + 1] = {x = w / 2 + math.cos(a) * r, y = h / 2 + math.sin(a) * r}
					end
					surface.DrawPoly(circle)
					return true
				end
			end
		end

		local clampLock = false
		local function ClampSliderValue()
			if clampLock or not IsValid(timeSlider) then return end
			clampLock = true

			local rawValue = IsValid(timeSlider.TextArea) and timeSlider.TextArea:GetValue() or timeSlider:GetValue()
			local value = math.Clamp(math.floor(tonumber(rawValue) or tonumber(timeSlider:GetValue()) or 60), 60, MAX_ARREST_TIME)
			timeSlider:SetValue(value)

			if IsValid(timeSlider.TextArea) then
				timeSlider.TextArea:SetText(tostring(value))
			end

			clampLock = false
			return value
		end

		timeSlider.OnValueChanged = function() end

		if IsValid(timeSlider.TextArea) then
			timeSlider.TextArea.OnEnter = ClampSliderValue
			timeSlider.TextArea.OnLoseFocus = ClampSliderValue
		end

		local reasonBox = vgui.Create('DPanel', frame)
		reasonBox:SetPos(sc(78), sc(238))
		reasonBox:SetSize(sc(545), sc(88))
		reasonBox.Paint = function(self, w, h)
			draw.RoundedBox(sc(5), 0, 0, w, h, inputBg)
			draw.SimpleText('Причина ареста', 'ArrestBaton.Text', sc(15), sc(21), text, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
		end

		local reasonEntry = vgui.Create('DTextEntry', reasonBox)
		reasonEntry:SetPos(sc(110), sc(48))
		reasonEntry:SetSize(sc(325), sc(35))
		reasonEntry:SetText('')
		reasonEntry:SetUpdateOnType(true)
		reasonEntry:SetTextColor(text)
		reasonEntry:SetHighlightColor(sliderKnob)
		reasonEntry:SetCursorColor(text)
		reasonEntry:SetFont('ArrestBaton.Text')
		reasonEntry.Paint = function(self, w, h)
			draw.RoundedBox(sc(5), 0, 0, w, h, self:HasFocus() and inputBgHover or sliderLine)
			self:DrawTextEntryText(text, sliderKnob, text)

			if self:GetValue() == '' and not self:HasFocus() then
				draw.SimpleText('Введите текст...', 'ArrestBaton.Text', w / 2, h / 2, text, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			end
		end

		local arrestButton = vgui.Create('DButton', frame)
		arrestButton:SetPos(sc(78), sc(356))
		arrestButton:SetSize(sc(218), sc(54))
		arrestButton:SetText('Арестовать')
		arrestButton.Paint = function(self, w, h)
			return PaintButton(self, w, h, red, redHover, text)
		end
		arrestButton.DoClick = function()
			if not IsValid(target) then frame:Remove() return end

			local reason = string.Trim(reasonEntry:GetValue() or '')
			if reason == '' then
				rp.Notify(NOTIFY_ERROR, 'Укажите причину ареста.')
				return
			end

			local arrestTime = ClampSliderValue()

			net.Start(NET_ARREST)
				net.WriteEntity(target)
				net.WriteUInt(arrestTime, 7)
				net.WriteString(reason)
			net.SendToServer()

			frame:Remove()
		end

		local cancelButton = vgui.Create('DButton', frame)
		cancelButton:SetPos(sc(405), sc(356))
		cancelButton:SetSize(sc(218), sc(54))
		cancelButton:SetText('Отмена')
		cancelButton.Paint = function(self, w, h)
			return PaintButton(self, w, h, inputBg, inputBgHover, cancelText)
		end
		cancelButton.DoClick = function()
			frame:Remove()
		end
	end

	function SWEP:PrimaryAttack()
		if not IsValid(self.Owner) then return end
		BaseClass.PrimaryAttack(self)

		local ent = self:GetTrace().Entity
		if IsValid(ent) and ent:IsPlayer() then
			OpenArrestMenu(self, ent)
		end
	end
else
	net.Receive(NET_ARREST, function(_, pl)
		local ent = net.ReadEntity()
		local arrestTime = net.ReadUInt(7)
		local reason = net.ReadString()

		local wep = pl:GetActiveWeapon()
		if not IsValid(wep) or wep:GetClass() ~= 'arrest_baton' then return end

		DoArrest(pl, ent, arrestTime, reason)
	end)

	function SWEP:PrimaryAttack()
		if not IsValid(self.Owner) then return end
		BaseClass.PrimaryAttack(self)

		local ent = self:GetTrace().Entity

		if ent.WantReason and self.Owner:IsCP() then
			local owner = ent.ItemOwner

			if IsValid(owner) and not owner:IsWanted() and not owner:IsArrested() then
				owner:Wanted(self.Owner, ent.WantReason)
			end

			hook.Call('PlayerArrestedEntity', nil, self.Owner, ent, owner)

			ent:Remove()
			self.Owner:AddMoney(ent.SeizeReward, 'Арестовал чувака ' .. ent:SteamID64())
			self.Owner:LVLAddExp(enc.lvls['ent_arrest'])
			rp.Notify(self.Owner, NOTIFY_SUCCESS, term.Get('ArrestBatonBonus'), rp.FormatMoney(ent.SeizeReward))
			return
		end
	end
end