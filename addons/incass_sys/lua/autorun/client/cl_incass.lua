--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

surface.CreateFont( "Incass:Title", {
    font = "Montserrat",
    size = ScreenScale(9),
    weight = 1000,
    extended = true,
})

surface.CreateFont( "Incass:SubTitle", {
    font = "Montserrat",
    size = ScreenScale(8),
    weight = 500,
    extended = true,
})

surface.CreateFont( "Incass:BSubTitle", {
    font = "Montserrat",
    size = ScreenScale(8),
    weight = 1000,
    extended = true,
})

surface.CreateFont( "Incass:Count", {
    font = "Montserrat",
    size = ScreenScale(10),
    weight = 1000,
    extended = true,
})

surface.CreateFont( "Incass:NPCTitle", {
    font = "Montserrat",
    size = ScreenScale(12),
    weight = 1000,
    extended = true,
})

surface.CreateFont( "Incass:NPCSubTitle", {
    font = "Montserrat",
    size = ScreenScale(7.5),
    weight = 1000,
    extended = true,
})

surface.CreateFont( "Incass:Text", {
    font = "Montserrat",
    size = ScreenScale(6.5),
    weight = 500,
    extended = true,
})

surface.CreateFont( "Incass:BText", {
    font = "Montserrat",
    size = ScreenScale(6.5),
    weight = 1000,
    extended = true,
})

file.CreateDir( "incass_sys" )
http.Fetch( "https://i.ibb.co/LrQvVWr/banner.png", function( body ) file.Write( "incass_sys/banner.png", body ) end)
http.Fetch( "https://i.ibb.co/0m7p0KV/wallet.png", function( body ) file.Write( "incass_sys/wallet.png", body ) end)
local bannerMat = Material( "data/incass_sys/banner.png", "noclamp" )
local walletMat = Material( "data/incass_sys/wallet.png", "noclamp mips" )

TakingBags = 0.1
local sw, sh = ScrW(), ScrH()
local blur = Material("pp/blurscreen")
local function drawBlur(panel, amount)
	local x, y = panel:LocalToScreen(0, 0)
	surface.SetDrawColor(255, 255, 255)
	surface.SetMaterial(blur)

	for i = 1, 3 do
		blur:SetFloat("$blur", (i / 3) * (amount or 6))
		blur:Recompute()
		render.UpdateScreenEffectTexture()
		surface.DrawTexturedRect(x * -1, y * -1, sw, sh)
	end
end

local function getNiceMoney( num )

    local result = ""
    local count = 0

    local str = tostring(math.Round(num))
    for i = string.len(str), 1, -1 do
        if count < 3 then
            result = result .. str[i]
            count = count + 1
        else
            result = result .. "." .. str[i]
            count = 1
        end
    end

    return string.reverse( result )

end

local function IncassMenu()

    if incassFrame then
        incassFrame:Remove()
    end
    incassFrame = vgui.Create( "EditablePanel" )

    local main = incassFrame
    main:SetSize( sw*.35, sh*.5 )
    main:SetAlpha(0)
    main:AlphaTo( 255, .1, 0 )
    main:Center()
    main:MakePopup()
    main:SetKeyboardInputEnabled( false )
    main.Paint = function( self, w, h )
        draw.RoundedBox( 10, 0, 0, w, h, Color( 30, 30, 30 ) )
        draw.SimpleText( "Вася", "Incass:NPCTitle", w*.05, h*.1, Color( 255, 255, 255 ), 0, 1 )
        draw.SimpleText( "Инкассаторы", "Incass:BSubTitle", w*.05, h*.165, Color( 130, 130, 130 ), 0, 1 )

        draw.RoundedBox( 7, w*.16, h*.078, w*.1, h*.06, Color( 255, 66, 98 ) )
        draw.SimpleText( "НПС", "Incass:NPCSubTitle", w*.1825, h*.105, Color( 255, 255, 255 ), 0, 1 )

        draw.SimpleText( "Выход", "Incass:BSubTitle", w*.75, h*.135, Color( 255, 255, 255 ), 0, 1 )

        draw.RoundedBox( 6, w*.86, h*.095, w*.07, h*.08, Color( 255, 255, 255 ) )
        draw.SimpleText( "Esc", "Incass:BSubTitle", w*.895, h*.13, Color( 0, 0, 0 ), 1, 1 )

        surface.SetDrawColor( 255, 255, 255 )
        surface.SetMaterial( bannerMat )
        surface.DrawTexturedRect( w*.1, h*.26, w*.8, h*.341 )
        draw.RoundedBoxEx( 10, w*.1, h*.6, w*.8, h*.09, Color( 40, 40, 40 ), false, false, true, true )

        surface.SetDrawColor( 255, 255, 255 )
        surface.SetMaterial( walletMat )
        surface.DrawTexturedRect( w*.112, h*.61, w*.05, h*.06 )
        
        draw.SimpleText( "Всего у вас денежных средств: ", "Incass:Text", w*.17, h*.64, Color( 255, 255, 255 ), 0, 1 )
        draw.SimpleText( getNiceMoney( Incass.MaxPrice / Incass.MaxBags * LocalPlayer():GetNWInt( "Incass:Bags", 0 ) ) .. " рублей", "Incass:BText", w*.52, h*.64, Color( 255, 255, 255 ), 0, 1 )
    end
    local mw, mh = main:GetSize()

    local close = vgui.Create( "DButton", main )
    close:SetSize( mw*.205, mh*.1 )
    close:SetPos( mw*.74, mh*.085 )
    close:SetText("")
    close.Paint = function() end
    close.DoClick = function()
        main:AlphaTo( 0, .1, 0, function()
            incassFrame:Remove()
            incassFrame = nil
        end)
    end

    local giveBags = vgui.Create( "DButton", main )
    giveBags:SetSize( mw*.8, mh*.1 )
    giveBags:SetPos( mw*.1, mh*.75 )
    giveBags:SetText("")
    giveBags.r, giveBags.g, giveBags.b = 255, 66, 98
    giveBags.Paint = function( self, w, h )
        draw.RoundedBox( 10, 0, 0, w, h, Color( self.r, self.g, self.b) )
        draw.SimpleText( "Сдать все мешки", "Incass:BSubTitle", w/2, h/2, Color( 255, 255, 255 ), 1, 1 )

        if self:IsHovered() then
            self.r = Lerp( FrameTime()*8, self.r, 61 )
            self.g = Lerp( FrameTime()*8, self.g, 179 )
            self.b = Lerp( FrameTime()*8, self.b, 104 )
        else
            self.r = Lerp( FrameTime()*8, self.r, 255 )
            self.g = Lerp( FrameTime()*8, self.g, 66 )
            self.b = Lerp( FrameTime()*8, self.b, 98 )
        end
    end
    giveBags.DoClick = function()
        net.Start( "Incass:Sell" )
        net.WriteBool( false )
        net.SendToServer()

        main:AlphaTo( 0, .1, 0, function()
            incassFrame:Remove()
            incassFrame = nil
        end)
    end

    local stealBags = vgui.Create( "DButton", main )
    stealBags:SetSize( mw*.8, mh*.09 )
    stealBags:SetPos( mw*.1, mh*.865 )
    stealBags:SetText("")
    stealBags.r, stealBags.g, stealBags.b = 40, 40, 40
    stealBags.Paint = function( self, w, h )
        draw.RoundedBox( 10, 0, 0, w, h, Color( self.r, self.g, self.b) )
        draw.SimpleText( "Украсть немного с мешков (+" .. Incass.BagsPrice .. " рублей)", "Incass:Text", w*.64, h/2, Color( 255, 255, 255 ), 2, 1 )
        draw.SimpleText( "|", "Incass:BSubTitle", w*.66, h/2, Color( 60, 60, 60 ), 1, 1 )
        draw.SimpleText( "ВОЗМОЖЕН РОЗЫСК", "Incass:Text", w*.675, h*.515, Color( 255, 255, 255 ), 0, 1 )

        if self:IsHovered() then
            self.r = Lerp( FrameTime()*8, self.r, 179 )
            self.g = Lerp( FrameTime()*8, self.g, 61 )
            self.b = Lerp( FrameTime()*8, self.b, 61 )
        else
            self.r = Lerp( FrameTime()*8, self.r, 40 )
            self.g = Lerp( FrameTime()*8, self.g, 40 )
            self.b = Lerp( FrameTime()*8, self.b, 40 )
        end
    end
    stealBags.DoClick = function()
        net.Start( "Incass:Sell" )
        net.WriteBool( true )
        net.SendToServer()

        main:AlphaTo( 0, .1, 0, function()
            incassFrame:Remove()
            incassFrame = nil
        end)
    end

end

local lp, prc
hook.Add( "HUDPaint", "Incass:BagsCount", function()

    lp = LocalPlayer()
    prc = (sw*.25*.76)/Incass.MaxBags
    if lp and lp:GetNWInt( "Incass:Bags", 0 ) > 0 then

        bags = lp:GetNWInt( "Incass:Bags" )
        if not incassBags then

            incassBags = vgui.Create( "EditablePanel" )
            local main = incassBags
            main:SetSize( sw*.25, sh*.13 )
            main:SetPos( sw/2 - sw*.25/2, sh*.05 )
            main:SetAlpha(0)
            main:AlphaTo( 255, .3, 0 )
            main.prc = 0
            main.Paint = function( self, w, h )
                drawBlur(self, 4)
                draw.RoundedBox( 0, 0, 0, w, h, Color( 40, 40, 40, 230 ) )
                draw.SimpleText( "Сумка с мешками денег", "Incass:Title", w/2, h*.3, Color( 255, 255, 255 ), 1, 1 )
                draw.SimpleText( "Отнесите его НПС", "Incass:SubTitle", w/2, h*.5, Color( 180, 180, 180 ), 1, 1 )

                draw.RoundedBox( 0, w*.12, h*.8, w*.76, h*.05, Color( 40, 40, 40 ) )
                draw.RoundedBox( 0, w*.12, h*.8, self.prc, h*.05, Color( 255, 66, 98 ) )

                draw.SimpleText( lp:GetNWInt( "Incass:Bags", 0 ), "Incass:Count", w*.1, h*.8, Color( 255, 255, 255 ), 2, 1 )
                draw.SimpleText( Incass.MaxBags, "Incass:Count", w*.9, h*.8, Color( 255, 255, 255 ), 0, 1 )

                self.prc = Lerp( FrameTime()*8, self.prc, prc*lp:GetNWInt( "Incass:Bags", 0 ) )
            end

        end 

    else
        if incassBags then
            incassBags:AlphaTo( 0, .3, 0, function()
                incassBags:Remove()
                incassBags = nil
            end)
        end
    end

end)

local function TakeBags()

    local lp = LocalPlayer()
    local ent = lp:GetEyeTrace().Entity
    if not ent or ent.cooldown or ent:GetClass() ~= "incass_bank" or lp:GetPos():Distance( ent:GetPos() ) > 60 then return end
    if lp:GetNWInt( "Incass:Bags", 0 ) == Incass.MaxBags then return end
    if not incassBagsTaking then

        incassBagsTaking = vgui.Create( "EditablePanel" )
        local main = incassBagsTaking
        main:SetSize( sw*.3, sh*.09 )
        main:Center()
        main:SetAlpha(0)
        main:AlphaTo( 255, .3, 0 )
        main.prc = 0
        main.Paint = function( self, w, h )
            drawBlur(self, 4)
            draw.RoundedBox( 0, 0, 0, w, h, Color( 40, 40, 40, 230 ) )

            draw.SimpleText( "Подождите, идет сбор денежных средств", "Incass:Title", w/2, h*.4, Color( 255, 255, 255 ), 1, 1 )
            draw.RoundedBox( 0, w*.1, h*.75, w*.8, h*.07, Color( 40, 40, 40 ) )
            draw.RoundedBox( 0, w*.1, h*.75, self.prc, h*.07, Color( 255, 66, 98 ) )
            self.prc = Lerp( FrameTime()*8, self.prc, (w*.8)/Incass.TakingTime*TakingBags )

            if tostring(TakingBags) == tostring(Incass.TakingTime+0.1) then
                timer.Remove( "Incass:TakesBags" )

                net.Start( "Incass:Take" )
                net.WriteBool( true )
                net.SendToServer()

                ent.cooldown = true
                timer.Simple( Incass.Cooldown, function()
                    if IsValid( ent ) then
                        ent.cooldown = false
                    end
                end)

                incassBagsTaking:AlphaTo( 0, .1, 0, function()
                    if incassBagsTaking then
                        incassBagsTaking:Remove()
                        incassBagsTaking = nil
                    end
                    TakingBags = 0.1
                end)
            end
        end

        net.Start( "Incass:Take" )
        net.WriteBool( false )
        net.SendToServer()

    end

    if not timer.Exists( "Incass:TakesBags" ) then
        timer.Create( "Incass:TakesBags", 0.1, 0, function()
            TakingBags = TakingBags + 0.1
        end)
    end

end

net.Receive( "Incass:Menu", function( _, pl )
    if not pl then
        IncassMenu()
    end
end)

hook.Add( "PlayerButtonDown", "Incass:TakeBags", function( pl, btn )
	if btn == KEY_E then
        if pl:Team() ~= Incass.Job then return end
        TakeBags()
    end
end)

hook.Add( "PlayerButtonUp", "Incass:TakeBagsCancel", function( pl, btn )
	if btn == KEY_E then
        if incassBagsTaking then
            incassBagsTaking:AlphaTo( 0, .1, 0, function()
                if incassBagsTaking then
                    incassBagsTaking:Remove()
                    incassBagsTaking = nil
                end
                TakingBags = 0.1
            end)
        end
        timer.Remove( "Incass:TakesBags" )
	end
end)

hook.Add( "OnPauseMenuShow", "Incass:PreventEscape", function()
	if incassFrame then
        incassFrame:AlphaTo( 0, .1, 0, function()
            incassFrame:Remove()
            incassFrame = nil
        end)
	    return false
    end
end)

--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
