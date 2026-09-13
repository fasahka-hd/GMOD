--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

cvar.Register 'RecentlyUsedEmotes'

	:SetDefault({':SUP:'}, true)



local PANEL = {}

local selectedChatTag = ''



function PANEL:Init()

	self:SetText('')

end



function PANEL:OnMousePressed(code)

	if code == MOUSE_LEFT then

		self:DoClick()

	elseif code == MOUSE_RIGHT then

		self:DoRightClick()

	end

end



function PANEL:UpdateRecentEmotes()

	local recentEmotes = cvar.GetValue 'RecentlyUsedEmotes'



	for k, v in ipairs(recentEmotes) do

		if (v == self.EmoteString) then

			table.remove(recentEmotes, k)

			break

		end

	end



	table.insert(recentEmotes, 1, self.EmoteString)



	if recentEmotes[6] then

		recentEmotes[6] = nil

	end



	cvar.SetValue('RecentlyUsedEmotes', recentEmotes)

end



function PANEL:DoClick()

	self:UpdateRecentEmotes()



	CHATBOX.txtEntry:SetText(CHATBOX.txtEntry:GetValue() .. self.EmoteString)



	CHATBOX.txtEntry:RequestFocus()

	CHATBOX.txtEntry:SetCaretPos(#CHATBOX.txtEntry:GetText())



	CHATBOX.emotesList:SetVisible(false)

end



function PANEL:DoRightClick()

	if not self.Emote then

		return

	end



	self:UpdateRecentEmotes()



	if selectedChatTag == self.EmoteString then

		selectedChatTag = ''

		chat.RequestClearChatTag()

	else

		selectedChatTag = self.EmoteString

		chat.RequestChatTag(selectedChatTag)

	end

end



function PANEL:Paint(w, h)

	draw.RoundedBox(5, 0, 0, w, h, ui.col.Background)



	if selectedChatTag == self.EmoteString then

		draw.RoundedBox(5, 0, 0, w, h, ui.col.OffWhite)

	end



	if self:IsHovered() then

		draw.RoundedBox(5, 1, 1, w - 2, h - 2, ui.col.Hover)

	end



	surface.SetDrawColor(255, 255, 255, 255)



	if (not self.Emote.mat) or self.Emote.matloading then

		local t = SysTime() * 5

		draw.NoTexture()

		surface.DrawArc(w*0.5, h*0.5, 7.5, 10, t*80, t*80+180, 20)



		if (not self.Emote.matloading) then

			ba.LoadSingleEmote(self.Emote)

		end

	else

		surface.SetMaterial(self.Emote.mat)

		local s = w - 4

		surface.DrawTexturedRect(2, 2, s, s)

	end

end



vgui.Register('ba_emotes_preview', PANEL, 'ui_button')





local PANEL = {}



Derma_Hook(PANEL, 'Paint', 'Paint', 'Panel')



local recentEmotesCont

function PANEL:AddRecents()

	local recentEmotes = cvar.GetValue 'RecentlyUsedEmotes'



	if (#recentEmotes == 0) then return end



	if IsValid(recentEmotesCont) then

		for k, v in ipairs(recentEmotesCont:GetChildren()) do

			v:Remove()

		end



		recentEmotesCont.EmoteString = ''

	else

		recentEmotesCont =  ui.Create('DPanel', function(s)

			s:SetTall(34)

			s.EmoteString = ''

		end)

		recentEmotesCont.Paint = function() end



		self.List:AddCustomRow(recentEmotesCont)

	end



	local chattag = LocalPlayer():GetChatTag()

	local i = 0



	for _, k in pairs(recentEmotes) do

		local v = ba.chatEmotes[k]



		if v then

			ui.Create('ba_emotes_preview', function(s)

				s.EmoteString = k

				s.Emote = v

				s:SetSize(33, 33)

				s:Dock(LEFT)

			end, recentEmotesCont)



			recentEmotesCont.EmoteString = recentEmotesCont.EmoteString .. k

		end



		i = i + 1

	end

end



function PANEL:Init()

	self.Search = ui.Create('DTextEntry', self)

	self.Search.OnChange = function(s)

		self.List:Search(s:GetValue())

	end

	self.Search:SetPlaceholderText('Искать...')



	self.List = ui.Create('ui_listview', self)

	self.List:SetNoResultsMessage('Нету!')

	self.List.FilterSearchResult = function(s, row, value)

		return row.EmoteString and (string.find(row.EmoteString:lower(), value:lower(), 1, true) ~= nil)

	end

	self.List:SetSpacing(1)



	self.List:AddSpacer('Недавно'):SetTall(25)

	self:AddRecents()

	self.List:AddSpacer('Эмодзи'):SetTall(25)



	local chattag = LocalPlayer():GetChatTag()



	local cont

	local i = 0

	for k, v in pairs(ba.chatEmotes) do

		if (not IsValid(cont)) or (i == 5) then

			cont = ui.Create('DPanel', function(s)

				s:SetTall(36)

				s.EmoteString = ''

				s.Paint = function() end

			end)



			self.List:AddCustomRow(cont)



			i = 0

		end



		ui.Create('ba_emotes_preview', function(s)

			s.EmoteString = k

			s.Emote = v

			s:SetSize(33, 33)

			s:Dock(LEFT)

		end, cont)



		cont.EmoteString = cont.EmoteString .. k

		i = i + 1

	end

end



function PANEL:PerformLayout(w, h)

	self.Search:SetPos(5, 5)

	self.Search:SetSize(w - 10, 25)



	self.List:SetPos(5, 35)

	self.List:SetSize(w - 10, h - 40)

end


function PANEL:Think()

	self:SetMouseInputEnabled(true)

	self:SetKeyboardInputEnabled(true)

end



vgui.Register('ba_emotes_list', PANEL, 'Panel')





if (CHATBOX) then CHATBOX:Remove() CHATBOX = ba.CreateChatBox() end



--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
