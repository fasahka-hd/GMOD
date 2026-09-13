
term.Add('StaffReqSent', 'Жалоба отправлена!')
term.Add('StaffReqPend', 'У вас есть активная жалоба!')
term.Add('StaffReqLonger', 'Пожалуйста, напишите причину (<10+ символов)!')
term.Add('AdminTookPlayersRequest', '# ответил на жалобу #.')
term.Add('AdminTookYourRequest', '# откликнулся на вашу жалобу и скоро с вами свяжется.')
term.Add('AdminClosedPlayersRequest', '# отклонил жалобу #.')
term.Add('AdminClosedYourRequest', '# отклонил вашу жалобу.')
term.Add('AdminClosedYourComplaint', 'Админ # закрыл вашу жалобу!')
term.Add('AdminClosedComplaintOf', 'Вы закрыли жалобу игрока #!')
ba.cmd.Create('Report', function(pl, args)
	if (hook.Call('PlayerCanUseAdminChat', ba, pl) ~= false) then
		text = args.text
				
		if pl:HasStaffRequest() or pl:GetBVar("StaffRequestAdmin") then
			ba.notify_err(pl, term.Get('StaffReqPend'))
		elseif (text:len() < 10) then
			ba.notify_err(pl, term.Get('StaffReqLonger'))
		else
			net.Start('ba.ReportAdmin')
				net.WriteEntity(pl)
				net.WriteString(pl:SteamID())
				net.WriteString(text)
				net.WriteFloat(CurTime())
			net.Send(player.GetStaff())
					
			ba.notify(pl, term.Get('StaffReqSent'))
			pl:SetBVar('StaffRequest', true)
			pl:SetBVar('StaffRequestReason', text)
			pl:SetBVar('StaffRequestTime', CurTime())
						
			hook.Call("PlayerSitRequestOpened", GAMEMODE, pl, text)
		end
	end
end)
:AddParam('string', 'text')

ba.cmd.Create('Remove Rating', function(pl, args)
	local targ = ba.InfoTo64(args.target)
	local db = ba.data.GetDB()
	if not tonumber(args.amount) then return end
	db:query_ex('UPDATE ba_rating SET rate = rate - ? WHERE steamid = ?', {tonumber(args.amount), targ})
end)
:AddParam('player_steamid', 'target')
:AddParam('string', 'amount')
:SetFlag('C')

ba.cmd.Create('Delete Rating', function(pl, args)
	local targ = ba.InfoTo64(args.target)
	local db = ba.data.GetDB()
	db:query_ex('DELETE FROM `ba_rating` WHERE `steamid` = ?', {targ})
end)
:AddParam('player_steamid', 'target')
:SetFlag('C')

if (SERVER) then
	util.AddNetworkString 'ba.AdminChat'
	util.AddNetworkString 'ba.ReportAdmin'
	util.AddNetworkString 'ba.AdminChatDelayed'
	util.AddNetworkString 'ba.GetStaffRequest'
	util.AddNetworkString 'ba.PurgeStaffRequests'
	util.AddNetworkString 'OpenMenuAdmin'
	util.AddNetworkString 'OpenMenuUser'
	util.AddNetworkString 'CloseMenusWow'
	util.AddNetworkString 'ba.openRatingPlayer'
	
	function PLAYER:HasStaffRequest()
		return (self:GetBVar('StaffRequest') and (CurTime() - self:GetBVar('StaffRequestTime') < 600))
	end

	hook.Add('PlayerSay', 'ba.AdminChat', function(pl, text)
		if (text[1] == '@') then
			if (hook.Call('PlayerCanUseAdminChat', ba, pl) ~= false) then
				text = text:sub(2):Trim()
				
				if pl:HasStaffRequest() or (pl:GetBVar("StaffRequestAdmin") and not pl:IsAdmin()) then
					ba.notify_err(pl, term.Get('StaffReqPend'))
				elseif (not pl:IsAdmin() and text:len() < 10) then
					ba.notify_err(pl, term.Get('StaffReqLonger'))
				else
					net.Start('ba.AdminChat')
						net.WriteEntity(pl)
						net.WriteString(pl:SteamID())
						net.WriteString(text)
						net.WriteFloat(CurTime())
					net.Send(player.GetStaff())
					
					if (not pl:IsAdmin()) then
						ba.notify(pl, term.Get('StaffReqSent'))
						pl:SetBVar('StaffRequest', true)
						pl:SetBVar('StaffRequestReason', text)
						pl:SetBVar('StaffRequestTime', CurTime())
						
						hook.Call("PlayerSitRequestOpened", GAMEMODE, pl, text)
					end
				end
				
				return ''
			end
		end
	end)
	
	hook.Add('playerRankLoaded', 'ba.NetworkRequests', function(pl)
		if (!pl:IsAdmin()) then return end
		
		for k, v in ipairs(player.GetAll()) do
			if (v:HasStaffRequest()) then
				net.Start('ba.AdminChatDelayed')
					net.WriteUInt(v:EntIndex(), 8)
				net.Send(pl)
			end
		end
	end)
	
	hook.Add('PlayerDisconnected', 'ba.PurgeStaffRequests', function(pl)
		if (pl:HasStaffRequest()) then
			net.Start('ba.PurgeStaffRequests')
				net.WriteString(pl:SteamID())
			net.Send(player.GetStaff())
		end
	end)
	
	net.Receive('ba.GetStaffRequest', function(len, pl)
		local targ = net.ReadEntity()
		
		if (!IsValid(targ) or !pl:IsAdmin() or !targ:HasStaffRequest()) then return end
		
		net.Start('ba.AdminChat')
			net.WriteEntity(targ)
			net.WriteString(targ:SteamID())
			net.WriteString(targ:GetBVar('StaffRequestReason'))
			net.WriteFloat(targ:GetBVar('StaffRequestTime'))
		net.Send(pl)
	end)
else		
	local color_white = Color(235,235, 235)
	local fr
	local req_bg = Color(42, 43, 46)
	local req_btn_accept = Color(78, 170, 104)
	local req_btn_accept_hover = Color(90, 190, 118)
	local req_btn_decline = Color(218, 62, 68)
	local req_btn_decline_hover = Color(232, 78, 84)
	local req_btn_neutral = Color(58, 59, 63)
	local req_btn_neutral_hover = Color(72, 73, 78)
	local grad_mat = Material("vgui/gradient_down")
	local PANEL = {}
	function PANEL:Init()
		local w, h = chat.GetChatBoxSize()
		local x, y = chat.GetChatBoxPos()
		h = h * .75
		y = y - (h + 5)
		
		self.w, self.h = math.max(w * .56, 316), math.max(h, 213)
		self.gap = 24
		self.side_w = math.max(self.w * 0.72, 230)
		self.h3 = self.h * 1.5

		self.Requests = {}
		self.Visible = true

		self.btnMaxim:Remove()
		self.btnMinim:Remove()
		self.btnClose:Remove()
		
		self.lblTitle:SetText('Жалобы:')
		
		self.PlayerList = ui.Create('ui_scrollpanel', self)
		self.PlayerList:SetPadding(-1)

		self:SetSkin('bAdmin')
		self:SetDraggable(true)

		self:SetSize(self.w, self.h)
		self:SetPos(x, y)
	end

	function PANEL:PerformLayout()
		self.lblTitle:SizeToContents()
		self.lblTitle:SetPos(5, 4)

		self.PlayerList:SetPos(5, 32)
		self.PlayerList:SetSize(self.w - 10, self.h - 37)
	end

		function PANEL:ApplySchemeSettings()
			self.lblTitle:SetTextColor(ui.col.Close)
			self.lblTitle:SetFont('ui.22')
		end

		function PANEL:Paint(w, h)
			local lw = math.min(self.w, w)
			draw.RoundedBox(15, 0, 0, lw, h, req_bg)
			surface.SetDrawColor(218, 62, 68, 10)
			surface.SetMaterial(grad_mat)
			surface.DrawTexturedRectUV(0, 0, lw, h, 0, 1, 1, 0)
		end

		function PANEL:SetStage(state)
			if (state == 1) then
				self:SizeTo(self.w, self.h, 0.175, 0, 0.25, cback)
			elseif (state == 2) then
				self:SizeTo(self.w + self.gap + self.side_w, self.h, 0.175, 0, 0.25, cback)
			else
				self:SizeTo(self.w + self.gap + self.side_w, self.h3, 0.175, 0, 0.25)
			end
		end

	function PANEL:AddRequest(pl, msg, startTime)
		local pnl = ui.Create('ba_menu_player')
		pnl.SteamID = pl:SteamID()
		pnl:SetPlayer(pl)
		pnl:SetStartTime(startTime)
		pnl.Paint = function(s, w, h)
			local isSelected = s.Selected
			local bg = isSelected and Color(82, 83, 88) or Color(255, 255, 255, 24)
			draw.RoundedBox(12, 0, 0, w, h, bg)
		end
		pnl.Name:SetTextColor(color_white)
		pnl.Checkbox.Paint = function(s, w, h)
			draw.RoundedBox(6, 0, 0, w, h, pnl.Selected and Color(218, 62, 68) or Color(70, 71, 76))
		end
		pnl.Checkbox.DoClick = function()
			if (self.Player ~= pnl) then
				if (self.Player ~= nil and IsValid(self.Player)) then
					self.Player.Selected = false
				end
				self.Player = pnl
				pnl.Selected = true
				self:OpenRequest(pnl.ID)
				self:SetStage(2)
			else
				self.Player = nil
				pnl.Selected = false
				if IsValid(self.CurRequest) then
					self.CurRequest:Remove()
					self.CurRequest = nil
				end
				self:SetStage(1)
			end
			self.ID = pnl.ID
		end
		pnl.OT = pnl.Think
		pnl.Think = function(s)
			if (not self.Requests[s.ID]) or (CurTime() - startTime >= 600) then
				self:RemoveRequest(s.ID)
				return
			end
			
			s:OT()
		end
		self.PlayerList:AddItem(pnl)
		pnl.ID = #self.Requests + 1
		pnl.Message = msg
		self.Requests[pnl.ID] = pnl
	end

	function PANEL:RemoveRequest(id)
		if not self.Requests[id] then return end
		self.Requests[id]:Remove()
		table.remove(self.Requests, id)
		if IsValid(self.CurRequest) and self.ID == id then
			self.CurRequest:Remove()
			self.CurRequest = nil
		end
		self.Player = nil
		if (self.ID == id) then
			self.ID = nil
			self:SetStage(1)
		end
		
		for k, v in ipairs(self.Requests) do
			v.ID = k
		end
	end

	function PANEL:OpenRequest(id)
		if IsValid(self.CurRequest) then self.CurRequest:Remove() end

		local pnl = self.Requests[id]
		if !pnl then return end

		self.CurRequest = ui.Create('ui_panel', function(s, p)
			s:SetPos(self.w + self.gap, 0)
			s:SetSize(self.side_w, self.h)
			s.Paint = function(_, w, h)
				draw.RoundedBox(15, 0, 0, w, h, req_bg)
				surface.SetDrawColor(218, 62, 68, 10)
				surface.SetMaterial(grad_mat)
				surface.DrawTexturedRectUV(0, 0, w, h, 0, 1, 1, 0)
			end
		end, self)

		ui.Create('DButton', function(s, p)
			s:SetPos(10, p:GetTall() - 38)
			s:SetSize((p:GetWide() - 30) * .5, 28)
			s:SetText('Принять')
			s.Paint = function(btn, w, h)
				draw.RoundedBox(10, 0, 0, w, h, btn:IsHovered() and req_btn_accept_hover or req_btn_accept)
			end
			s.DoClick = function()
				if (IsValid(pnl.Player)) then
					RunConsoleCommand('ba', 'Treq', pnl.Player:SteamID())
				end
			end
		end, self.CurRequest)
		ui.Create('DButton', function(s, p)
			s:SetPos(20 + (p:GetWide() - 30) * .5, p:GetTall() - 38)
			s:SetSize((p:GetWide() - 30) * .5, 28)
			s:SetText('Отклонить')
			s.Paint = function(btn, w, h)
				draw.RoundedBox(10, 0, 0, w, h, btn:IsHovered() and req_btn_decline_hover or req_btn_decline)
			end
			s.DoClick = function()
				if (IsValid(pnl.Player)) then
					RunConsoleCommand('ba', 'Rreq', pnl.Player:SteamID())
				end
			end
		end, self.CurRequest)

		local l = ba.ui.Label(pnl.Message or '', self.CurRequest, {font = 'ba.ui.22', color = ui.col.Close, wrap = true})
		l:SetContentAlignment(7)
		l:SetSize(self.CurRequest:GetWide() - 20, self.CurRequest:GetTall() - 78)
		l:SetPos(10, 10)
	end
	vgui.Register('ba_adminchat', PANEL, 'DFrame')

	local staffRequestQueue = {}
	hook.Add('Think', 'AdminChat.Think', function()
		if IsValid(fr) then
			if (#fr.Requests <= 0) and fr.Visible then
				fr.Visible = false
				fr:SetVisible(fr.Visible)
			elseif (#fr.Requests > 0) and (not fr.Visible) then
				fr.Visible = true
				fr:SetVisible(fr.Visible)
			end
		end
		
		for k, v in ipairs(staffRequestQueue) do
			local pl
			if (type(v) == 'string') then
				pl = player.Find(v)
			else
				pl = ents.GetByIndex(v)
			end
			
			if (IsValid(pl)) then
				net.Start('ba.GetStaffRequest')
					net.WriteEntity(pl)
				net.SendToServer()
			
				table.remove(staffRequestQueue, k)
				
				return
			end
		end
	end)
	
	net.Receive('ba.PurgeStaffRequests', function()
		if (!IsValid(fr)) then return end
		
		local stid = net.ReadString()
		for k, v in ipairs(fr.Requests) do
			if (v.SteamID == stid) then
				fr:RemoveRequest(k)
			end
		end
	end)

	net.Receive('ba.AdminChat', function()
		if !ui or !ui.Create then return end
		fr = fr or ui.Create('ba_adminchat')
		local pl = net.ReadEntity()
		local stid = net.ReadString()
		if IsValid(pl) then
			if (pl:IsAdmin()) then
				local msg = net.ReadString()
				
				if (IsValid(CHATBOX)) then CHATBOX.DoEmotes = pl:IsVIP() end
				chat.AddText(Color(255,100,100), '[Админ чат] ', color_white, pl:GetUserGroup() .. ' ', pl, color_white, ': ', msg)
				hook.Call("PlayerUseAdminChat", GAMEMODE, pl, msg)
			elseif IsValid(fr) then
				fr:AddRequest(pl, net.ReadString(), net.ReadFloat())
			end
		else
			table.insert(staffRequestQueue, stid)
		end
	end)
	
	net.Receive('ba.ReportAdmin', function()
		if !ui or !ui.Create then return end
		fr = fr or ui.Create('ba_adminchat')
		local pl = net.ReadEntity()
		local stid = net.ReadString()

		surface.PlaySound("HL1/fvox/bell.wav")

		if IsValid(pl) then
			if IsValid(fr) then
				fr:AddRequest(pl, net.ReadString(), net.ReadFloat())
			end
		else
			table.insert(staffRequestQueue, stid)
		end
	end)
	
	net.Receive('ba.AdminChatDelayed', function()
		table.insert(staffRequestQueue, net.ReadUInt(8))
	end)
	
	concommand.Add('adr', function(pl, cmd, args)
		fr = fr or ui.Create('ba_adminchat')
		fr:AddRequest(pl, table.concat(args, ' '), CurTime())
	end)
	
	concommand.Add('rer', function(pl, cmd, args)
		fr = fr or ui.Create('ba_adminchat')
		local id = tonumber(args[1] or 0)
		
		if (!fr.Requests[id]) then return end
		
		fr:RemoveRequest(id)
	end)
end

ba.cmd.Create('Treq', function(pl, args)
	if IsValid(args.target) and pl == args.target then return end

	if args.target:HasStaffRequest() and not pl:GetBVar("StaffRequestAdmin") then
		net.Start 'ba.PurgeStaffRequests'
			net.WriteString(args.target:SteamID())
		net.Send(player.GetStaff())
		ba.notify_staff(term.Get('AdminTookPlayersRequest'), pl, args.target)
		ba.notify(args.target, term.Get('AdminTookYourRequest'), pl)
		args.target:SetBVar('StaffRequest', nil)
		args.target:SetBVar('StaffRequestTime', nil)
		args.target:SetBVar('StaffRequestReason', nil)
		
		args.target:SetBVar('StaffRequestAdmin', pl)
		pl:SetBVar('StaffRequestAdmin', args.target)
		
		net.Start("OpenMenuUser")
			net.WriteEntity(pl)
			net.WriteFloat(CurTime())
		net.Send(args.target)
		
		net.Start("OpenMenuAdmin")
			net.WriteEntity(args.target)
			net.WriteFloat(CurTime())
		net.Send(pl)
		
		hook.Call("PlayerSitRequestTaken", GAMEMODE, args.target, pl)
	end
end)
:AddParam('player_entity', 'target')
:SetFlag('M')
:SetHelp('Принять жалобу')

ba.cmd.Create('Creq', function(pl, args)
	if IsValid(args.target) and pl == args.target then return end

	if args.target:GetBVar("StaffRequestAdmin") then
		net.Start 'ba.PurgeStaffRequests'
			net.WriteString(args.target:SteamID())
		net.Send(player.GetStaff())
		ba.notify(args.target, term.Get('AdminClosedYourComplaint'), pl)
		net.Start 'ba.openRatingPlayer'
			net.WriteString(pl:Name())
			net.WriteString(pl:SteamID())
		net.Send(args.target)
		ba.notify(pl, term.Get('AdminClosedComplaintOf'), args.target)

		args.target:SetBVar('StaffRequestAdmin', nil)
		pl:SetBVar('StaffRequestAdmin', nil)
		args.target.ratingUsing = true
		
		net.Start("CloseMenusWow")
		net.Send( { pl, args.target } )
		
		hook.Call("PlayerSitRequestClosedSucc", GAMEMODE, args.target, pl)
	end
end)
:AddParam('player_entity', 'target')
:SetFlag('M')
:SetHelp('Закрыть жалобу')

ba.cmd.Create('Rreq', function(pl, args)
	if args.target:HasStaffRequest() then
		net.Start 'ba.PurgeStaffRequests'
			net.WriteString(args.target:SteamID())
		net.Send(player.GetStaff())
		ba.notify_staff(term.Get('AdminClosedPlayersRequest'), pl, args.target)
		ba.notify(args.target, term.Get('AdminClosedYourRequest'), pl)
		args.target:SetBVar('StaffRequest', nil)
		args.target:SetBVar('StaffRequestReason', nil)
		args.target:SetBVar('StaffRequestTime', nil)
		
		hook.Call("PlayerSitRequestClosed", GAMEMODE, args.target, pl)
	end
end)
:AddParam('player_entity', 'target')
:SetFlag('M')
:SetHelp('Отменить жалобу')