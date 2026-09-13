--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

include('shared.lua')

hook.Add( "InitPostEntity", "CheckFuckNot", function()
	timer.Simple(2.5, function()
		net.Start( "ItemStoreSyncInventory" ) net.SendToServer()
	end)
end )
local function ss( w )
    return w * ( ScrW() / 1920 )
end

local addl, marginBoth = ss(5), ss(37)

local function LerpColor( fr, cstart, cend )
    return Color( Lerp(fr, cstart.r, cend.r), Lerp(fr, cstart.g, cend.g), Lerp(fr, cstart.b, cend.b), Lerp(fr, cstart.a, cend.a) )
end

local frame
net.Receive( "openItemShop", function( len)
	if IsValid(frame) then return end 
	local IdShop = net.ReadInt(15)
	local ItelListTable = gmrp.ShopItems[IdShop].items

	frame = vgui.Create('EditablePanel')
	frame:SetSize(enc.w(792), enc.h(854))
	frame:Center()
	frame:MakePopup()
	function frame:Paint(w,h)
		draw.RoundedBox(16,0,0,w,h,enc.clrs.inbg)
	end
	function frame:Think()
        if input.IsKeyDown(KEY_ESCAPE) then
            frame:Remove()
            gui.HideGameUI()
        end
    end

	do
    local close = vgui.Create("EditablePanel", frame)
    close:SetSize( ss(90)+addl, ss(26) )
    close:SetPos( frame:GetWide()-ss(29)-ss(90), ss(35) )
    close:SetCursor"hand"
    close:SetZPos(30)

    local _w, rM = ss(38), ss(7)
    close.lerpHover = 0

    close.Paint = function(self,w,h)
        self.lerpHover = math.Clamp(self:IsHovered() and self.lerpHover + FrameTime()*3 or self.lerpHover - FrameTime()*3, 0, 1)
        draw.RoundedBox(6,0,0,w,h, LerpColor(self.lerpHover,Color(255,255,255,0),color_white) )

        draw.RoundedBox(5,w-_w,0,_w,h,color_white)

        draw.SimpleText("Выход", "door::exit", addl, h*.5, LerpColor(self.lerpHover,color_white,color_black), 0, 1)
        draw.SimpleText("Esc", "door::exit", w-rM, h*.5, color_black, 2, 1)
    end
	close.OnMousePressed = function()
		frame:Remove()
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
		title:SetText('Продавец')
		title:SetFont('ba_new_menu_font_title')
		title:SetTextColor(enc.clrs.white)
		title:SizeToContentsX()

		local stitle = vgui.Create('DLabel', frame)
		stitle:Dock(TOP)
		stitle:DockMargin(enc.w(41),enc.h(15),0,0)
		stitle:SetText('Покупайте нужные вам продукты')
		stitle:SetFont('ba_new_menu_font_label')
		stitle:SetTextColor(enc.clrs.whitea)
		stitle:SizeToContentsY()
	end

	do
		local line = vgui.Create('Panel', frame)
		line:Dock(TOP)
		line:DockMargin(enc.w(55),enc.h(39),enc.w(55),0)
		line:SetTall(enc.h(2))
		function line:Paint(w,h)
			draw.RoundedBox(0,0,0,w,h,enc.clrs.line)
		end
	end

	do
		local scroll = vgui.Create('DScrollPanel',frame)
		scroll:Dock(FILL)
		scroll:DockMargin(enc.w(55),enc.h(22),enc.w(40),enc.h(34))
		scroll.Paint = function() end
		local scrolls = scroll:GetVBar()
		scrolls:SetWide(enc.w(2))
		scrolls.Paint = function(this, w, h) 
			draw.RoundedBox(0,0,0,w,h,enc.clrs.search)
		end
		scrolls.btnUp.Paint = function(this, w, h) end 
		scrolls.btnDown.Paint = function(this, w, h) end
		scrolls.btnGrip.Paint = function(this, w, h) 
			draw.RoundedBox(0,0,0,w,h,enc.clrs.scroll)
		end

		for k,v in pairs(ItelListTable) do
			local panel = scroll:Add( "Panel" )
			panel:Dock(TOP)
			panel:DockMargin(0,0,enc.w(15),enc.h(16))
			panel:SetTall(enc.h(116))
			function panel:Paint( w, h )
				draw.RoundedBox(8,0,0,w,h,enc.clrs.tovar)
				draw.RoundedBox(4,enc.w(16),enc.h(8),enc.w(100),enc.h(100),enc.clrs.search)
			end

			local senditemd = vgui.Create( "DModelPanel", panel ) 
			senditemd:SetSize( enc.w(100), enc.h(100) )
			senditemd:SetPos(enc.w(16),enc.h(8))
			senditemd:SetModel( v.Model )
			local PrevMins, PrevMaxs = senditemd:GetEntity():GetRenderBounds()
			senditemd:SetCamPos(PrevMins:Distance(PrevMaxs)*Vector(0.55, 0.55, 0.5))
			senditemd:SetLookAt((PrevMaxs + PrevMins)/2)
			
			local EntName = vgui.Create("DLabel", panel)
			EntName:SetPos(enc.w(136),enc.h(22))
			EntName:SetColor(enc.clrs.white) 
			EntName:SetFont("MKfont.20")
			EntName:SetText(k) 
			EntName:SizeToContents() 

			local CostMoney = vgui.Create("DLabel", panel)
			CostMoney:SetPos(enc.w(136),enc.h(50))
			CostMoney:SetColor(enc.clrs.pizdec) 
			CostMoney:SetFont("MKfont.20")
			CostMoney:SetText('У вас ' .. LocalPlayer():HFM_AmountItem(v.ent)) 
			CostMoney:SizeToContents() 

			local CostMoney2 = vgui.Create("DLabel", panel)
			CostMoney2:SetPos(enc.w(136),enc.h(78))
			CostMoney2:SetColor(enc.clrs.green) 
			CostMoney2:SetFont("MKfont.20")
			CostMoney2:SetText(rp.FormatMoney(v.Cost)) 
			CostMoney2:SizeToContents() 

			local SendButt2 = vgui.Create( "DButton", panel)
			SendButt2:SetFont("MKfont.15")
			SendButt2:SetText("")
			SendButt2:SetTextColor(enc.clrs.whitea)
			SendButt2:Dock(RIGHT)
			SendButt2:DockMargin(0,enc.h(60),enc.w(19),enc.h(14))
			SendButt2:SetWide(enc.w(130))
			SendButt2.DoClick = function()
				net.Start( "BuyItemFromShop" )
					net.WriteInt(IdShop,15)
					net.WriteString(k)
				net.SendToServer()
				timer.Simple(1,function()
					CostMoney:SetText('У вас ' .. LocalPlayer():HFM_AmountItem(v.ent)) 
					CostMoney:SizeToContents() 
				end)
			end
			SendButt2.Paint = function(s,w,h)
				local isHovered = s:IsHovered()
				local firstColor = isHovered and color_black or color_white
				local secondColor = isHovered and color_white or enc.clrs.search

				draw.RoundedBox(4,0,0,w,h,secondColor)
				draw.SimpleText('Купить предмет','MKfont.15',w/2,h/2,firstColor,1,1)
			end 
		end
	end
end)

local math = math
local cam, surface, draw = cam, surface, draw
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
	cam.Start3D2D(pos, ang, 0.03)
		draw.SimpleTextOutlined(self:GetNWString("ShopName"), '3d2d', 0, x, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM, 1, color_black)
	cam.End3D2D()
end

--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
