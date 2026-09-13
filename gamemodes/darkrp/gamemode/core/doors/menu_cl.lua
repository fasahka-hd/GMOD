--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

local adminMenu
local fr
local ent
local doorOptions = {
	{
		Name 	= 'Продать',
		DoClick = function()
			cmd.Run('selldoor')
			fr:Close()
		end,
	},
	--{
	--	Name 	= 'Добавить надпись',
	--	DoClick = function()
	--		ui.StringRequest('Надпись', 'Напишите текст который будет на двери', '', function(a)
	--			RunConsoleCommand('settitle', tostring(a))
	--		end)
	--	end
	--},
	{
		Name 	= 'Добавить сожителя',
		Check 	= function()
			return true --(player.GetCount() > 1)
		end,
		DoClick = function()
			ui.PlayerRequest(player.GetAll(), function(pl)
				RunConsoleCommand("addcoowner",pl:SteamID())
			end)
		end,
	},
	{
		Name 	= 'Удалить сожителя',
		Check 	= function()
			return (ent:DoorGetCoOwners() ~= nil) and (#ent:DoorGetCoOwners() > 0)
		end,
		DoClick = function()
			ui.PlayerRequest(ent:DoorGetCoOwners(), function(pl)
				RunConsoleCommand('removecoowner', pl:SteamID())
			end)
		end,

},

	}

local hotelOwnerOptions = {
	{
		Name 	= 'Поселить',
		Check 	= function()
			return LocalPlayer():Team() == TEAM_HOTEL
		end,
		DoClick = function()
			local ent = fr.ent

			ui.PlayerRequest(table.Filter(player.GetAll(), function(v)
				return (not v:GetTeamTable().CannotOwnDoors) and ( not ent:DoorCoOwnedBy(v) )
			end), function(pl)
				RunConsoleCommand("addtennant",pl:SteamID())
			end)
		end,
	},
	{
		Name 	= 'Выселить',
		Check 	= function()
			return LocalPlayer():Team() == TEAM_HOTEL
		end,
		DoClick = function()
			ui.PlayerRequest(table.Filter(player.GetAll(), function(v)
				return (true) and (not v:GetTeamTable().CannotOwnDoors) and ( ent:DoorCoOwnedBy(v) )
			end), function(pl)
				RunConsoleCommand("idi_nax",pl:SteamID())
			end)
		end,
	}
}

local hotelUserOptions = {
	{
		Name = "Съехать",
		Check = function() return ent:DoorCoOwnedBy( LocalPlayer() ) end,
		DoClick = function() RunConsoleCommand("sell_hotel") end
	}
}

local function ss( w )
	return w * ( ScrW() / 1920 )
end

local function LerpColor( fr, cstart, cend )
	return Color( Lerp(fr, cstart.r, cend.r), Lerp(fr, cstart.g, cend.g), Lerp(fr, cstart.b, cend.b), Lerp(fr, cstart.a, cend.a) )
end

surface.CreateFont("door::exit", {
	extended = true,
	font = "Inter Bold",
	size = ss(17),
	weight = 1,
})

surface.CreateFont("door::btn", {
	extended = true,
	font = "Montserrat Medium",
	size = ss(24),
	weight = 1,
})

local bgTheme = Color(22,22,22)
local btnTheme = Color(26,26,26)
local barTheme = Color(36,36,36)

local function makeFrame(ent, opts)
	fr = vgui.Create("DFrame")
	fr:SetTitle("")
	fr:Center()
	fr:SetWide(ss(548))
	fr:MakePopup()
	fr:ShowCloseButton(false)
	fr.Think = function(self)
		ent = LocalPlayer():GetEyeTrace().Entity
		if not IsValid(ent) or (ent:GetPos():DistToSqr(LocalPlayer():GetPos()) > 13225) then
			self:Close()
		end
	end
	local topM, lStep = ss(123), ss(52)

	local lM, tM, t2M = ss(40), ss(36), ss(77)
	fr.Paint = function(self,w,h)
		draw.RoundedBox(16,0,0,w,h,bgTheme)
		draw.RoundedBox(0,lStep,topM,w-lStep*2,2,barTheme)

		draw.SimpleText("Опции", "just::mayor::title", lM, tM, color_white)
		draw.SimpleText("Управляйте дверьми", "just::mayor::desc", lM, t2M, Color(255,255,255,50))
	end

	local addl = ss(5)
	local closebtn = vgui.Create("DPanel", fr)
	closebtn:SetSize( ss(90)+addl, ss(26) )
	closebtn:SetPos( fr:GetWide()-ss(29)-ss(90), ss(35) )
	closebtn:SetCursor"hand"

	local _w, rM = ss(38), ss(7)
	closebtn.lerpHover = 0

	closebtn.Paint = function(self,w,h)
        self.lerpHover = math.Clamp(self:IsHovered() and self.lerpHover + FrameTime()*3 or self.lerpHover - FrameTime()*3, 0, 1)
        draw.RoundedBox(6,0,0,w,h, LerpColor(self.lerpHover,Color(255,255,255,0),color_white) )

        draw.RoundedBox(5,w-_w,0,_w,h,color_white)

        draw.SimpleText("Выход", "door::exit", addl, h*.5, LerpColor(self.lerpHover,color_white,color_black), 0, 1)
        draw.SimpleText("Esc", "door::exit", w-rM, h*.5, color_black, 2, 1)
	end
	closebtn.OnMousePressed = function()
		fr:Remove()
	end
	closebtn.Think = function()
		if(input.IsKeyDown(KEY_ESCAPE) || gui.IsGameUIVisible()) then
			gui.HideGameUI()
			fr:Remove()
		end
	end


	fr.ent = ent

	local count = -1
	
	local ubtnW, ubtnH, ubtnMargin, downMargin = ss(475), ss(60), ss(70), ss(26)
	local x, y = ss(37), ss(151)
	for k, v in ipairs(opts) do
		if (v.Check == nil) or (v.Check(ent) == true) then
			count = count + 1
			fr:SetTall(((count+1) * ubtnMargin) + y + downMargin)
			fr:Center()
			
			local ubtn = vgui.Create("DButton", fr)
			ubtn:SetPos(x, (count * ubtnMargin) + y)
			ubtn:SetSize(ubtnW, ubtnH)
			//ubtn:SetText(v.Name)
			ubtn:SetText''
			ubtn.lerpHover = 0

			ubtn.Paint = function(self,w,h)
				self.lerpHover = math.Clamp(self:IsHovered() and self.lerpHover + FrameTime()*3 or self.lerpHover - FrameTime()*3, 0, 1)

				draw.RoundedBox(6,0,0,w,h,LerpColor(self.lerpHover,btnTheme,color_white))
				draw.SimpleText(v.Name, "door::btn", w*.5, h*.5, LerpColor(self.lerpHover,color_white,color_black), 1, 1)
			end
			ubtn.DoClick = function()
				v.DoClick(v)
				fr:Close()
			end
		end
	end

	return fr
end

local function showDeed(ent)

	fr = ui.Create('ui_frame', function(self)

		self:SetTitle(ent:GetPropertyName() .. ' Deed')

		self:SetSize(ScrW() * 0.2, ScrH() * 0.25)

		self:Center()

		self:MakePopup()



		self.Think = function(self)

			ent = LocalPlayer():GetEyeTrace().Entity

			if not IsValid(ent) or (ent:GetPos():DistToSqr(LocalPlayer():GetPos()) > 13225) then

				fr:Close()

			end

		end

	end)

		fr.ent = ent



	ui.Create('ui_listview', function(self)

		self:DockToFrame()

		self:AddSpacer('Владелец')

		self:AddPlayer(ent:GetPropertyOwner())

		self:AddSpacer('Со жителей')

		for k, v in ipairs(ent:GetPropertyCoOwners()) do

			if IsValid(v) then

				self:AddPlayer(v)

			end

		end

	end, fr)

end

local function keysMenu()
	if IsValid(fr) then fr:Close() end

	ent = LocalPlayer():GetEyeTrace().Entity

	if IsValid(ent) and ent:IsDoor() and (ent:GetPos():DistToSqr(LocalPlayer():GetPos()) < 13225) then
		if (ent:GetNWEntity("ownor") == LocalPlayer()) then
			makeFrame(ent, doorOptions)
		elseif ent:IsPropertyOwnable() then
			cmd.Run('buydoor')
		elseif ent:DoorCoOwnedBy( LocalPlayer() ) then  
			makeFrame(ent,hotelUserOptions)
		elseif ent:IsPropertyHotelOwned() and LocalPlayer():GetTeamTable().HotelManager then
			makeFrame(ent, hotelOwnerOptions)
		end
	end
end

net('rp.keysMenu', keysMenu)
GM.ShowTeam = keysMenu

--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
