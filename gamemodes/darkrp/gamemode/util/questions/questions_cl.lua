--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher


rp.question = rp.question || {Queue={}} 
if IsValid(rp.question.Container) then 
	rp.question.Container:Remove() 
	rp.question.Container = nil end;
	function rp.question.Create(a,b,c)
		if!IsValid(LocalPlayer()) then return end;
		local d = {Question=a,Time=b,Uid=c}
		d.End = d.Time + CurTime()
		if!IsValid(rp.question.Container)then rp.question.Container = ui.Create('ui_scrollpanel',function(self)
			self.Think=function(self)
			local e = table.Count(rp.question.Queue)
			if e == 0 then 
				self:Remove() return end;
				local f,g = chat.GetChatBoxPos()
				local h,i = chat.GetChatBoxSize()
				local j,k = f + h + 10, ScrH() - 10; 
				self:SetSize(h*0.5,math.min(105*table.Count(rp.question.Queue),210))
				self:SetPos(j,k-self:GetTall())
			end 
		end)
	end;
	local l = ui.Create('rp_question_panel',function(self)
		self:SetQuestion(d)
	end)
	rp.question.Container:AddItem(l)
	rp.question.Queue[d.Uid] = d;
	return l 
end;

function rp.question.Destroy(c)
	local d = rp.question.Queue[c]
	if IsValid(d.Panel)
		then d.Panel:Remove()
	end;
rp.question.Queue[c] = nil end;
net('rp.question.Ask',function()
	rp.question.Create(net.ReadString(),net.ReadUInt(16),net.ReadString())
end)
net('rp.question.Destroy',function()
	local c = net.ReadString()
	if rp.question.Exists(c) then 
		rp.question.Destroy(c)
	end 
end)
local m = {}
local n = Material'sup/hud/button.png'
function m:Init()
	self.Label = ui.Label('QUESTION?','ui.18',0,0,self)
	self.BtnYes = ui.Create('ui_button',self)
	self.BtnYes:SetText('Yes')
	self.BtnYes.DoClick = function()
	self:Answer(true)end;
	self.BtnNo = ui.Create('ui_button',self)
	self.BtnNo:SetText('No')
	self.BtnNo.DoClick = function()self:Answer(false)
end;
	self:SetTall(105)
	self:ShowCloseButton(false)
	self.Blur = false;
	LocalPlayer():EmitSound('Town.d1_town_02_elevbell1',100,100)end;
	function m:PerformLayout()
		self.BaseClass.PerformLayout(self)
		local j,k = self:GetDockPos()
		local o,p = self:GetWide(), self:GetTall()
		self.Label:SetSize(o-10,p-k-30)
		self.Label:SetPos(j,k)
		self.BtnYes:SetSize(o*0.5-7.5,25)
		self.BtnYes:SetPos(j,p-self.BtnYes:GetTall()-5)
		self.BtnNo:SetSize(o*0.5-7.5,25)
		self.BtnNo:SetPos(j+self.BtnNo:GetWide()+5,p-self.BtnNo:GetTall()-5)
	end;
		local q = ui.col.SUP:Copy()
		q.a = 175;
		function m:Paint(o,p)
			self.BaseClass.Paint(self,o,p)
			-- print(self.Question.End, self.Question.Time, CurTime())
			draw.RoundedBox(5,0,0,o*(self.Question.End-CurTime())/self.Question.Time,self:GetTitleHeight()-5,q)
		end;
		function m:OnClose()
			rp.question.Queue[self.Question.Uid] = nil end;
			function m:Answer(r)
				net.Start'rp.question.Answer'
				net.WriteString(self.Question.Uid)
				net.WriteBool(r)
				net.SendToServer()
				self:Close()
			end;
			local s = false;
			function m:Think()
				self.BaseClass.Think(self)
				local b = self.Question.End - CurTime()
				if b<=0 then 
					if self.DefaultAnswer != nil then 
						self:Answer(self.DefaultAnswer)
					else 
						self:Remove()
					end;
					return 
				end;
					self:SetTitle('Time: '..math.ceil(b))
					self.lblTitle:SizeToContents()
					local t,u = false,math.huge;
					if rp.question.Queue then
						for v,w in pairs(rp.question.Queue) do 
							if w.End < u then 
								u = w.End;
								t = w.Uid == self.Question.Uid 
							end 
						end;
					end
					if t then 
						if !self.HasUpdatedText then 
							self.BtnYes:SetText('Yes (F1)')
							self.BtnNo:SetText('No (F2)')
							self.HasUpdatedText = true end;
							if input.IsKeyDown(KEY_F1) then 
								if s then 
									if self.BtnYes.HasConfirmed then 
										self:Answer(true)
									else 
										self.BtnYes:SetText('Confirm (F1)')
										self.BtnYes.HasConfirmed = true;
										timer.Simple(2,function()
											if IsValid(self) then 
												self.BtnYes:SetText('Yes (F1)')
												self.BtnYes.HasConfirmed = nil 
											end 
										end)
									end 
								end;
								s = false 
							elseif 
								input.IsKeyDown(KEY_F2) then 
									local x = LocalPlayer():GetEyeTrace().Entity;
									if s&&(!IsValid(x)||!x:IsDoor()) then 
										if self.BtnNo.HasConfirmed then 
											self:Answer(false) 
										else 
											self.BtnNo:SetText('Confirm (F2)')
											self.BtnNo.HasConfirmed = true;
											timer.Simple(2,function()
												if IsValid(self) then 
													self.BtnNo:SetText('No (F2)') 
													self.BtnNo.HasConfirmed = nil 
												end 
											end)
										end 
									end;
									s = false 
								else 
									s=true 
								end 
							end 
						end;
						function m:SetQuestion(d) 
							self.Question = d; 
							self.Label:SetText(d.Question)
							d.Panel = self 
						end;
						vgui.Register('rp_question_panel',m,'ui_frame')

--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
