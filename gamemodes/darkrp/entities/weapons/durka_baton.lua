--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

AddCSLuaFile()
DEFINE_BASECLASS('baton_base')

SWEP.Spawnable = true
SWEP.Category = "Палка"

if CLIENT then
	SWEP.PrintName = 'Палка дурка-легкая'
	SWEP.SlotPos = 5
	SWEP.Instructions = ''

	local function ss( w )
	    return w * ( ScrW() / 1920 )
	end
	
	local function LerpColor( fr, cstart, cend )
	    return Color( Lerp(fr, cstart.r, cend.r), Lerp(fr, cstart.g, cend.g), Lerp(fr, cstart.b, cend.b), Lerp(fr, cstart.a, cend.a) )
	end
	
	local function drawIcon( mat, x, y, w, h, clr )
	    clr = clr or 255
	    surface.SetMaterial( Material( ("justmayor/%s.png"):format( mat ) ) )
	    surface.SetDrawColor( clr, clr, clr )
	    surface.DrawTexturedRect( x, y, w, h )
	end
	
	local btn_theme = Color(26,26,26)
	local btn_stheme = Color(26,26,26)
	
	local themeHover = Color(255,255,255)
	local sThemeHover = Color(200,200,200)
	local textHover = Color(0,0,0)
	
	local lBar, tMarg, titleL, titleT = ss(52), ss(91), ss(40), ss(36)
	local addl, marginBoth = ss(5), ss(37)
	local textY = ss(119)
	local function voenkomRequest()
	    if(IsValid(monMenu)) then monMenu:Remove() end
	
	    monMenu = vgui.Create("EditablePanel")
	    monMenu:SetSize( ss(556), ss(323) )
	    monMenu:Center()
	    monMenu:MakePopup()
	    monMenu:DockPadding( ss(28) , 0, ss(28), ss(31))
	
	    local wrapped = string.Wrap('just::phone::type', 'Желаете ли вы оздоровиться в санатории "dYркA"?\n- Вы получите +100 единиц здоровья;', monMenu:GetWide()-marginBoth*2)
	    monMenu.Paint = function(self, w, h)
	        draw.RoundedBox(16,0,0,w,h,Color(22,22,22))
	
	        draw.RoundedBox(0,lBar,tMarg,w-lBar*2,2,Color(29,29,29))
	
	        draw.SimpleText('Лечение', "just::mayor::title", titleL, titleT, color_white)
	
	        local y = 0
	        for k,v in pairs(wrapped) do
	            local _, _y = draw.SimpleText(v, "just::phone::type", marginBoth, textY+y, color_white)
	            y = y + _y
	        end
	    end
	    surface.SetFont("just::phone::type")
	    local _, _y = surface.GetTextSize("A")
	    monMenu:SetTall(textY+_y*#wrapped+ss(38)+ss(60)+ss(37))
	
	    local btn = vgui.Create("DPanel", monMenu)
	    btn:SetSize(ss(252-10), ss(60))
	    btn:SetPos(ss(26), monMenu:GetTall()-ss(60)-ss(38))
	    btn:InvalidateParent(true)
	    btn:SetCursor"hand"
	    btn.lerpHover = 0
	
	    local margin, size, leftmargin = ss(10), ss(38), ss(65)
	    btn.Paint = function(self,w,h)
	        self.lerpHover = math.Clamp(self:IsHovered() and self.lerpHover + FrameTime()*3 or self.lerpHover - FrameTime()*3, 0, 1)
	
	        draw.RoundedBox(8,0,0,w,h,LerpColor(self.lerpHover,btn_theme,themeHover))
	
	        draw.RoundedBox(6,margin,margin,size,size,LerpColor(self.lerpHover,btn_stheme,sThemeHover))
	        drawIcon("plus", margin,margin,size,size,Lerp(self.lerpHover,255,0))
	
	        draw.SimpleText("Да (-500 рублей)", "just::mayor::lockdown", leftmargin, h*.5, LerpColor(self.lerpHover, color_white, color_black), 0, 1)
	    end
	    btn.OnMousePressed = function()
	    	net.Start("durka-ez::plus")
	    	net.SendToServer()
	        if(IsValid(monMenu)) then monMenu:Remove() end
	    end
	
	    local btn = vgui.Create("DPanel", monMenu)
	    btn:SetSize(ss(252-10), ss(60))
	    btn:SetPos(ss(26+252+10), monMenu:GetTall()-ss(60)-ss(38))
	    btn:InvalidateParent(true)
	    btn:SetCursor"hand"
	    btn.lerpHover = 0
	
	    local margin, size, leftmargin = ss(10), ss(38), ss(65)
	    btn.Paint = function(self,w,h)
	        self.lerpHover = math.Clamp(self:IsHovered() and self.lerpHover + FrameTime()*3 or self.lerpHover - FrameTime()*3, 0, 1)
	
	        draw.RoundedBox(8,0,0,w,h,LerpColor(self.lerpHover,btn_theme,themeHover))
	
	        draw.RoundedBox(6,margin,margin,size,size,LerpColor(self.lerpHover,btn_stheme,sThemeHover))
	        drawIcon("x", margin,margin,size,size,Lerp(self.lerpHover,255,0))
	
	        draw.SimpleText("Нет", "just::mayor::lockdown", leftmargin, h*.5, LerpColor(self.lerpHover, color_white, color_black), 0, 1)
	    end
	    btn.OnMousePressed = function()
	        if(IsValid(monMenu)) then monMenu:Remove() end
	    end
	end

	net.Receive("durka-ez", voenkomRequest)
else
	util.AddNetworkString('durka-ez')
	util.AddNetworkString('durka-ez::plus')

	net.Receive("durka-ez::plus", function(_,ply)
		if(!ply.durka_uz) then return end

		if(!ply:CanAfford(500)) then ply.durka_uz = nil return end
		ply:AddMoney(-500, 'Выкупился из легкой дурки')
		if(IsValid(ply.durka_uz)) then ply.durka_uz:AddMoney(500, 'Получил за выкуп из легкой дурки') end

		ply:SetPos( Vector(-14397.713867, -7275.818359, 145.015076))
		timer.Simple(60, function()
			if(!IsValid(ply)) then return end
			ply:SetPos( Vector(-14737.844726562, -8183.0029296875, 65.03125))
			ply:SetHealth(100)
		end)

		eui.battlepass.AddProgress(ply.durka_uz, 5)

		ply.durka_uz = nil
	end)
end

SWEP.Color = Color(255, 128, 0, 255)

function SWEP:Initialize()
	self:SetHoldType(self.HoldType)
	self._Reload.Sound = Sound('npc/combine_soldier/vo/coverme.wav')
end

function SWEP:PrimaryAttack()
	if not IsValid(self.Owner) then return end
	BaseClass.PrimaryAttack(self)
	if CLIENT then return end
	-- self.Owner:LagCompensation(true)
	local ent = self.Owner:GetEyeTrace().Entity
	-- self.Owner:LagCompensation(false)
	if not IsValid(ent) then return end
	if not ent:IsPlayer() and not ent:IsArrested() then return end
	if self.Owner:GetPos():Distance(ent:GetPos()) > self.HitDistance then return end
	if IsValid(ent.durka_uz) then
		rp.Notify(self.Owner,1,'Его уже отправили в дурка')
		return
	end
	if self.Owner.lastDurkaez and self.Owner.lastDurkaez > CurTime() then
		rp.Notify(self.Owner,1,'Вы уже отправляли в дурку недавно')
		return
	end

	net.Start("durka-ez")
	net.Send(ent)
	ent.durka_uz = self.Owner
	self.Owner.lastDurkaez = CurTime() + 120

	rp.Notify(ent, NOTIFY_SUCCESS, '# предложил вам отправиться в дурку', self.Owner)
	rp.Notify(self.Owner, NOTIFY_SUCCESS, 'Вы предложили отправиться в дурку #', ent)
end

function SWEP:SecondaryAttack()
	self:SetNextSecondaryFire(CurTime() + self.Primary.Delay)
end

--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
