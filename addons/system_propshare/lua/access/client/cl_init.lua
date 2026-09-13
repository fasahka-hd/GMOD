--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

local box = draw.RoundedBox
local text = draw.SimpleText
local btnMat = Material('menu/newclose.png', 'mips')
local btnMatOn = Material('menu/newcloseon.png', 'mips smooth')
local function LerpColor( fr, cstart, cend )
    return Color( Lerp(fr, cstart.r, cend.r), Lerp(fr, cstart.g, cend.g), Lerp(fr, cstart.b, cend.b), Lerp(fr, cstart.a, cend.a) )
end
local function ss( w )
    return w * ( ScrW() / 1920 )
end
local addl, marginBoth = ss(5), ss(37)
local btn_theme = Color(26,26,26)
local btn_stheme = Color(26,26,26)

local themeHover = Color(255,255,255)
local sThemeHover = Color(200,200,200)
local textHover = Color(0,0,0)

local lBar, tMarg, titleL, titleT = ss(52), ss(91), ss(40), ss(36)
local textY = ss(119)

local fr, plyleftpanel, plyrightpanel
function enc.SharePropMenu()
    if IsValid(fr) then return end
    
	fr = vgui.Create('EditablePanel')
	fr:SetSize(enc.w(1280),enc.h(606))
	fr:Center()
	fr:MakePopup()
    fr:SetAlpha(0)
    fr:AlphaTo(255,0.2)
	function fr:Paint(w,h)
		box(16,0,0,w,h,enc.clrs.bg)
	end
    function fr:Think()
        if input.IsKeyDown(KEY_ESCAPE) then
            fr:Remove()
            gui.HideGameUI()
        end
    end

    do
    local closebtn = vgui.Create("DPanel", fr)
    closebtn:SetSize( ss(90)+addl, ss(26) )
    closebtn:SetPos( fr:GetWide()-ss(29)-ss(90), ss(35) )
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
        fr:Remove()
    end
    closebtn.Think = function()
        if(input.IsKeyDown(KEY_ESCAPE) || gui.IsGameUIVisible()) then
            gui.HideGameUI()
            fr:Remove()
        end
    end
    end
	
    refreshShareProp()
end

function refreshShareProp()
    if IsValid(plyleftpanel) then plyleftpanel:Remove() end
    if IsValid(plyrightpanel) then plyrightpanel:Remove() end

    do
        plyleftpanel = vgui.Create('enc.new.playerspanel', fr)
        plyleftpanel:Dock(LEFT)
        plyleftpanel:SetWide(enc.w(635))
        plyleftpanel:SetBool(true)
        plyleftpanel:SetMainText('Поделиться пропами')
        plyleftpanel:SetOtherText(enc.textleft)
    end

    do
        plyrightpanel = vgui.Create('enc.new.playerspanel', fr)
        plyrightpanel:Dock(LEFT)
        plyrightpanel:SetWide(enc.w(646))
        plyrightpanel:SetBool(false)
        plyrightpanel:SetPaint(enc.clrs.inbg)
        plyrightpanel:SetMainText('Удалить игрока')
        plyrightpanel:SetOtherText(enc.textright)
    end
end

--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
