ENT.Base = 'base_gmodentity'
DEFINE_BASECLASS('base_gmodentity')

ENT.AutomaticFrameAdvance = true
ENT.Type = 'anim'
ENT.PrintName = 'Складмен'
ENT.Author = 'Omni'
ENT.Spawnable = true

function ENT:AddAction(base, phrase, return_msg, func, next_step, check)
	base = base or 'main'

	if not self.dialog[base] then self.dialog[base] = {} end

	table.insert(self.dialog[base], {text = phrase, answer = return_msg, func = func, next_step = next_step, check = check})
end

function ENT:Initialize()
	local tb = {
		'Чё как?',
		'Как житуха?',
		'Привет, бро!',
		'Вассап чел!'
	}

	self.dialog = {
		['main'] = {
			welcome = table.Random(tb)
		}
	}
	self.drugs_buyer = true

	self:AddAction(nil, table.Random(tb), 'У меня тут есть одно дельце для тех кто хочет подзаработать, интересует?', nil, '2')
	self:AddAction('2', 'Интересует, что за дельце?', 'В общем, у меня есть товар который нужно доставить потребителю, всего 10 свертков. Их нужно спрятать в городе и так чтобы менты не нашли их раньше времени. Справишься?', nil, '3')
	self:AddAction('3', 'Конечно, брат!', 'Окей, но перед началом тебе нужно будет заплатить залог в размере ' .. rp.FormatMoney(rp.cladman.zalog) .. ', мало ли ты решишь меня кинуть...', nil, '4')
	self:AddAction('4', 'Окей, без проблем!', [[Такс, посмотрим что тут у нас ...

Окей, вот инструкция как тебе работать!
Сейчас ты получишь ]] .. rp.cladman.max_bags .. [[ свертков с наркотиком, тебе нужно их спрятать в пропах.
Для этого, поставь проп и нажми на него 'E'
Ты должен поставить проп в неприметное место, иначе его найдут менты и конфискуют, а тебя объявят в розыск!
После того как ты спрячешь сверток должно пройти примерно 5 мин и ты получишь свои деньги за него!]], function()
		if not LocalPlayer():CanAfford(rp.cladman.zalog) then
			notification.AddLegacy('У вас нет таких денег!', NOTIFY_ERROR, 7)
			return
		end

		if LocalPlayer():Team() ~= TEAM_CLADMEN then
			notification.AddLegacy('Эта задача только для работы Кладмен!', NOTIFY_ERROR, 7)
			return
		end

		net.Start('rp.cladman.buy')
		net.WriteEntity(self)
		net.SendToServer()
	end, '5')
	self:AddAction('4', 'У меня пока что нет таких денег', 'Когда сможешь осилить это - приходи!', nil, nil, function()
		if not LocalPlayer():CanAfford(rp.cladman.zalog) then return true end
		return false
	end)
	self:AddAction('5', 'Понял!', 'Не подведи меня!', nil)

	if SERVER then
		self:SetModel('models/player/Group03/Male_01.mdl')
		local sequence = self:LookupSequence('pose_standing_02')
		self:SetSequence(sequence or 1)
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetMoveType(MOVETYPE_VPHYSICS)
		self:SetSolid(SOLID_VPHYSICS)
		self:SetRenderMode(RENDERMODE_TRANSALPHA)
		local phys = self:GetPhysicsObject()
		if IsValid(phys) then
			phys:EnableMotion(false)
			phys:Wake()
		end
		self:DrawShadow(false)
		self:SetUseType(SIMPLE_USE)
	end
end

if CLIENT then
	if IsValid(main) then main:Remove() end

	net.Receive('rp.npc.open_dialog', function()
		local ent = net.ReadEntity()
		local dialog = ent.dialog

		if not dialog then return end

		main = vgui.Create('DPanel')
		main:SetSize(ScrW(), ScrH())
		main:SetPos(0, 0)
		main:MakePopup()
		main:SetAlpha(0)
		main:AlphaTo(255, 0.5)
		main.Paint = function(self, w, h)
			local x, y = self:LocalToScreen(0, 0)
			for i = 1, 3 do
				local blur = Material('pp/blurscreen')
				blur:SetFloat('$blur', (i / 3) * 6)
				blur:Recompute()
				render.UpdateScreenEffectTexture()
				surface.SetMaterial(blur)
				surface.SetDrawColor(255, 255, 255)
				surface.DrawTexturedRect(x * -1, y * -1, ScrW(), ScrH())
			end
			surface.SetDrawColor(0, 0, 0, 127)
			surface.DrawRect(0, 0, w, h)
			surface.SetDrawColor(Color(0, 0, 0, 175))
			surface.DrawRect(0, h * 0.8, w, h * 0.2)
		end

		main.Close = function(self)
			self:AlphaTo(0, 0.5, 0, function()
				self:Remove()
			end)
		end

		local model = vgui.Create('DModelPanel', main)
		model:SetSize(ScrW() * 0.2, ScrH() * 0.6)
		model:SetPos(0, ScrH() - model:GetTall())
		model:SetModel(ent:GetModel())
		model:SetFOV(45)
		model:SetCamPos(Vector(20, 15, 64))
		model:SetLookAt(Vector(0, 0, 64))
		if IsValid(model.Entity) then
			model.Entity:SetAngles(Angle(0, 45, 0))
		end
		function model:LayoutEntity()
			return false
		end

		model.PaintOver = function(self, w, h)
		end

		local history = vgui.Create('eui.ScrollPanel', main)
		history:SetSize(ScrW() * 0.8 - 4, ScrH() * 0.8 - 31)
		history:SetPos(model:GetWide() + 2, 29)
		history.Paint = nil

		local function AddMessage(npc, text)
			local message_main = vgui.Create('DPanel', history)
			message_main:Dock(TOP)
			message_main:SetTall(80)
			message_main:DockMargin(5, 5, history:GetWide() * 0.5, 5)
			message_main:SetAlpha(0)
			message_main:AlphaTo(255, 1)
			message_main:InvalidateParent(true)
			message_main.Paint = function(self, w, h)
				draw.RoundedBox(8, 5, 5, w - 10, h - 10, Color(44, 44, 44), true, true, not npc, npc)
			end

			local message = vgui.Create('DLabel', message_main)
			message:Dock(FILL)
			message:DockMargin(10, 10, 10, 10)
			message:SetText(text)
			message:SetFont(eui.Font('15:Medium'))
			message:SetTextColor(Color(255, 255, 255))
			message:SetExpensiveShadow(1, Color(0, 0, 0))
			message:SetWrap(true)
			message:SetAutoStretchVertical(true)
			message.PerformLayout = function(self, w, h)
				message_main:SetTall(h + 20)
			end

			message.Paint = nil
			history:ScrollToChild(message_main)
		end

		local close = vgui.Create('eui.Button', main)
		close:SetPos(ScrW() - 27, 2)
		close:SetSize(25, 25)
		close:SetInfo('✖', eui.Font('14:Medium'))
		close.DoClick = function()
			main:AlphaTo(0, 0.5, 0, function()
				main:Remove()
			end)
		end

		AddMessage(true, dialog.main.welcome)

		local bottom_bar
		function main.GenerateAnswers(step)
			if bottom_bar then bottom_bar:Remove() end

			bottom_bar = vgui.Create('eui.ScrollPanel', main)
			bottom_bar:SetSize(ScrW() * 0.8 - 4, ScrH() * 0.2)
			bottom_bar:SetPos(ScrW() * 0.2 + 2, ScrH() - bottom_bar:GetTall())
			bottom_bar.VBar:SetHideButtons(true)
			bottom_bar.Paint = nil

			for k, v in ipairs(dialog[step]) do
				if v.welcome then continue end
				if v.check and not v.check() then continue end

				local say = vgui.Create('eui.Button', bottom_bar)
				say:Dock(TOP)
				say:DockMargin(2, 5, 2, 0)
				say:SetInfo(v.text, eui.Font('14:Medium'))
				say:SetTall(bottom_bar:GetTall() / 3 - 15)

				say.DoClick = function(self)
					AddMessage(false, v.text)
					if v.answer then
						AddMessage(true, v.answer)
					end

					if v.func then
						v.func(main)
					end

					if v.next_step and dialog[v.next_step] then
						main.GenerateAnswers(v.next_step)
					else
						self:SetEnabled(false)
						timer.Simple(2, function()
							if IsValid(main) then main:Close() end
						end)
					end
				end
			end
		end

		main.GenerateAnswers('main')
	end)
end

if SERVER then
	util.AddNetworkString('rp.npc.open_dialog')

	function ENT:Use(ply)
		ply.cdC = ply.cdC or 0
		if ply.cdC > CurTime() then return end
		ply.cdC = CurTime() + 1

		if ply:Team() ~= TEAM_CLADMEN then
			rp.Notify(ply, 5, 'Я не веду дел с такими как ты!')
			return
		end

		if ply:IsWanted() then
			rp.Notify(ply, 5, 'Приходи когда за тобой перестанут бегать менты!')
			return
		end

		net.Start('rp.npc.open_dialog')
		net.WriteEntity(self)
		net.Send(ply)
	end
end
