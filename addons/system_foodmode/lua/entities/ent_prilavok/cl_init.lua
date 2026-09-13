--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

include('shared.lua')

local mat1 = Material("justmayor/plus.png", "smooth mips")

local function LerpColor( fr, cstart, cend )
    return Color( Lerp(fr, cstart.r, cend.r), Lerp(fr, cstart.g, cend.g), Lerp(fr, cstart.b, cend.b), Lerp(fr, cstart.a, cend.a) )
end
local function ss( w )
    return w * ( ScrW() / 1920 )
end
local addl, marginBoth = ss(5), ss(37)

local box = draw.RoundedBox
local text = draw.SimpleText
local setmat = surface.SetMaterial
local setcolor = surface.SetDrawColor
local setsize = surface.DrawTexturedRect

local color_white = ui.col.White:Copy()
local color_black = ui.col.Black:Copy()
local complex_off = Vector(0, 0, 9)
local simple_off = Vector(0, 0, 75)
local ang = Angle(0, 90, 90)

function ENT:Draw()
	self:DrawModel()
	local pos
	local bone = self:LookupBone('ValveBiped.Bip01_Head1')
	if bone then
		pos = self:GetBonePosition(bone) + complex_off
	else
		pos = self:GetPos() + simple_off
	end
	ang.y = (LocalPlayer():EyeAngles().y - 90)
	local inView, dist = self:InDistance(150000)
	if (not inView) then return end
	local alpha = 255 - (dist/590)
	color_white.a = alpha
	color_black.a = alpha
	local x = math.sin(CurTime() * math.pi) * 30
	cam.Start3D2D(pos, ang, 0.05)
		draw.SimpleTextOutlined('Прилавок', '3d2d', 0, x+200, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM, 1, color_black)
	cam.End3D2D()
end

local frame, inv
net.Receive( "openPrilavok", function()
	if IsValid(frame) then return end 
	if not LocalPlayer():UniqueID() then return end 
	if not LocalPlayer():GetEyeTrace().Entity:GetNWString("PP_Owner_Uid") then return end

	local ReadItemsTable = net.ReadTable()
	local own = net.ReadString()

	local uid = LocalPlayer():UniqueID()
	local ownuid = LocalPlayer():GetEyeTrace().Entity:GetNWString("PP_Owner_Uid")

	frame = vgui.Create('EditablePanel')
	frame:SetSize(enc.w(792), enc.h(854))
	frame:Center()
	frame:MakePopup()
	function frame:Paint(w,h)
		box(16,0,0,w,h,enc.clrs.bg)
	end
	function frame:Think()
        if input.IsKeyDown(KEY_ESCAPE) then
            frame:Remove()
            gui.HideGameUI()
        end
    end
	
	do
    local closebtn = vgui.Create("DPanel", frame)
    closebtn:SetSize( ss(90)+addl, ss(26) )
    closebtn:SetPos( frame:GetWide()-ss(29)-ss(90), ss(35) )
    closebtn:SetCursor"hand"
    closebtn:SetZPos(30)
    
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
        frame:Remove()
    end
    closebtn.Think = function()
        if(input.IsKeyDown(KEY_ESCAPE) || gui.IsGameUIVisible()) then
            gui.HideGameUI()
            frame:Remove()
        end
    end
	end

	do
		local lbpanel = vgui.Create('Panel',frame)
		lbpanel:Dock(TOP)
		lbpanel:DockMargin(enc.w(41),enc.h(37),0,0)
		lbpanel:SetTall(enc.h(38))

		local title = vgui.Create('DLabel', lbpanel)
		title:Dock(LEFT)
		title:DockMargin(0,0,0,0)
		title:SetText('Прилавок')
		title:SetFont('MB_30')
		title:SetTextColor(enc.clrs.white)
		title:SizeToContentsX()

		local owner = vgui.Create('DLabel', lbpanel)
		owner:Dock(LEFT)
		owner:DockMargin(enc.w(9),0,0,0)
		owner:SetText(own)
		owner:SetFont('MB_30')
		owner:SetTextColor(enc.clrs.whitea)
		owner:SizeToContentsX()

		local stitle = vgui.Create('DLabel', frame)
		stitle:Dock(TOP)
		stitle:DockMargin(enc.w(41),enc.h(15),0,0)
		stitle:SetText('Покупайте нужные вам предметы')
		stitle:SetFont('M_20')
		stitle:SetTextColor(enc.clrs.whitea)
		stitle:SizeToContentsY()
	end

	do
		local line = vgui.Create('Panel', frame)
		line:Dock(TOP)
		line:DockMargin(enc.w(55),enc.h(39),enc.w(55),0)
		line:SetTall(enc.h(2))
		function line:Paint(w,h)
			box(0,0,0,w,h,enc.clrs.line)
		end
	end

	local scroll
	do
		scroll = vgui.Create('DScrollPanel',frame)
		scroll:Dock(FILL)
		scroll:DockMargin(enc.w(55),enc.h(22),enc.w(40),uid ~= ownuid and enc.h(34) or enc.h(16))
		scroll.Paint = function() end
		local scrolls = scroll:GetVBar()
		scrolls:SetWide(enc.w(2))
		scrolls.Paint = function(this, w, h) 
			box(0,0,0,w,h,enc.clrs.search)
		end
		scrolls.btnUp.Paint = function(this, w, h) end 
		scrolls.btnDown.Paint = function(this, w, h) end
		scrolls.btnGrip.Paint = function(this, w, h) 
			box(0,0,0,w,h,enc.clrs.scroll)
		end

		for k,v in pairs(ReadItemsTable) do
			local panel = scroll:Add( "Panel" )
			panel:Dock(TOP)
			panel:DockMargin(0,0,enc.w(15),enc.h(16))
			panel:SetTall(enc.h(116))
			function panel:Paint( w, h )
				box(8,0,0,w,h,enc.clrs.close)
				box(4,enc.w(16),enc.h(8),enc.w(100),enc.h(100),enc.clrs.search)
			end

			local senditemd = vgui.Create( "DModelPanel", panel ) 
			senditemd:SetSize( enc.w(100), enc.h(100) )
			senditemd:SetPos(enc.w(16),enc.h(8))
			senditemd:SetModel( v.model )
			local prevmins, prevmax = senditemd:GetEntity():GetRenderBounds()
			senditemd:SetCamPos(prevmins:Distance(prevmax)*Vector(0.55, 0.55, 0.5))
			senditemd:SetLookAt((prevmax + prevmins)/2)

			local name = vgui.Create("DLabel", panel)
			name:SetPos(enc.w(136),enc.h(22))
			name:SetColor(enc.clrs.white) 
			name:SetFont("MB_20")
			name:SetText(v.CustomClass) 
			name:SizeToContents() 

			local cost = vgui.Create("DLabel", panel)
			cost:SetPos(enc.w(136),enc.h(50))
			cost:SetColor(enc.clrs.whitea) 
			cost:SetFont("MB_20")
			cost:SetText(v.Amount .. ' штук') 
			cost:SizeToContents() 

			local money = vgui.Create("DLabel", panel)
			money:SetPos(enc.w(136),enc.h(78))
			money:SetColor(enc.clrs.green) 
			money:SetFont("MB_20")
			money:SetText(rp.FormatMoney(v.price)) 
			money:SizeToContents() 

			local send = ui.Create( "ui_button", panel)
			send:SetFont("MM_12")
			if uid == ownuid then
				send:SetText( "Снять предмет" ) 
			else
				send:SetText( "Купить предмет" ) 
			end
			send:Dock(RIGHT)
			send:DockMargin(0,enc.h(60),enc.w(19),enc.h(14))
			send:SetWide(enc.w(130))
			send.DoClick = function()
				net.Start( "BuyItemFromKiosk" )
				net.WriteInt(v.id,32)
				net.SendToServer()
				
				frame:Remove()
			end
			send.Paint = function(s,w,h)
				box(4,0,0,w,h,enc.clrs.search)
			end 
		end
	end

	do
		if uid == ownuid then
			inv = vgui.Create('Panel', fr)
			inv:SetSize(enc.w(380), enc.h(691))
			function inv:Paint(w,h)
				box(16,0,0,w,h,enc.clrs.inbg)
			end
			function inv:Think()
				if IsValid(frame) then
					local x, y = frame:GetPos()
					inv:SetX( frame:GetPos() - inv:GetWide() - 10)
					inv:CenterVertical()
				else
					inv:Remove()
				end
			end
		
			do
				local title = vgui.Create('DLabel', inv)
				title:Dock(TOP)
				title:DockMargin(enc.w(31),enc.h(33),0,0)
				title:SetText('Инвентарь')
				title:SetFont('MB_20')
				title:SetTextColor(enc.clrs.white)
				title:SizeToContentsY()
			end
		
			do
				local slot = vgui.Create('ItemStoreContainer', inv)
				slot:Dock(TOP)
				slot:DockMargin(enc.w(36),enc.h(32),0,0)
				slot:SetContainerID( LocalPlayer().InventoryID )
			end
				-- inv = vgui.Create( "ItemStoreContainerWindow" )
				-- inv:SetContainerID( LocalPlayer().InventoryID )
				-- inv:SetTitle( itemstore.Translate( "inventory" ) )
				-- inv:ShowCloseButton( false )
				-- inv:MakePopup()
				-- inv:InvalidateLayout( true )
				-- inv:ParentToHUD()
				-- function inv:Think()
				-- 	if IsValid(frame) then
				-- 		local x, y = frame:GetPos()
				-- 		inv:SetPos( frame:GetPos() + ( frame:GetWide() / 2 - inv:GetWide() / 2 ),y + frame:GetTall() + 10 )
				-- 	else
				-- 		inv:Remove()
				-- 	end
				-- end

			local newitem = vgui.Create('Panel', scroll)
			newitem:Dock(TOP)
			newitem:DockMargin(0,0,enc.w(15),enc.h(16))
			newitem:SetTall(enc.h(116))

			local visModel

			local senditem = vgui.Create('Panel', newitem)
			senditem:Dock(LEFT)
			senditem:SetWide(enc.w(116))
			function senditem:Paint(w,h)
				box(8,0,0,w,h,enc.clrs.close)

				if not visModel then 
					setmat(mat1)
					setcolor(255,255,255)
					setsize(enc.w(33),enc.h(33),enc.w(50),enc.h(50))
				end
			end

			senditem:Receiver( "ItemStore", function( receiver, droppable, dropped )
				if dropped and  droppable[ 1 ].Item != nil  then
					local source = droppable[ 1 ]:GetContainerID()
					local sourceslot = droppable[ 1 ]:GetSlot()
					local globalsourceitem = droppable[ 1 ].Item
					local globalsourceslot = sourceslot
			
					local sendmodel = vgui.Create( "DModelPanel", senditem ) 
					sendmodel:Dock(TOP)
					sendmodel:DockMargin(0,0,enc.w(15),enc.h(16))
					sendmodel:SetTall(enc.h(116))
					sendmodel:SetModel( globalsourceitem:GetModel() )
					sendmodel:IsMouseInputEnabled(false)
					local PrevMins, PrevMaxs = sendmodel:GetEntity():GetRenderBounds()
					sendmodel:SetCamPos(PrevMins:Distance(PrevMaxs)*Vector(0.75, 0.75, 0.5))
					sendmodel:SetLookAt((PrevMaxs + PrevMins)/2)
					visModel = true 

					ui.StringRequest("Выставить на продажу", "Цена", '', function(a)
						local prikol = tonumber(a)
						if  (prikol != "") and (globalsourceitem != nil) then
							if isnumber(tonumber(prikol)) then 
								if tonumber(prikol) > 150000 or tonumber(prikol) < 10 then
									LocalPlayer():ChatPrint( "Минимальная стоимость 10, а максимальная 150 000!" )
								else
									net.Start( "AddItemToKiosk" )
										net.WriteString(util.TableToJSON(globalsourceitem.Data))
										net.WriteString(prikol)
										net.WriteString(globalsourceitem:GetClass())
										net.WriteString(globalsourceslot)
										net.WriteString(droppable[ 1 ]:GetContainerID())
									net.SendToServer()
									frame:Remove()
								end
							end
						end
					end)
				end
			end)
		end
	end
end)

--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
