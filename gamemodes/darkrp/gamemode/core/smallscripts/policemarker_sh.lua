--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher


--[[

~ yuck, anti cheats! ~

~ file stolen by ~
                __  .__                          .__            __                 .__               
  _____   _____/  |_|  |__ _____    _____ ______ |  |__   _____/  |______    _____ |__| ____   ____  
 /     \_/ __ \   __\  |  \\__  \  /     \\____ \|  |  \_/ __ \   __\__  \  /     \|  |/    \_/ __ \ 
|  Y Y  \  ___/|  | |   Y  \/ __ \|  Y Y  \  |_> >   Y  \  ___/|  |  / __ \|  Y Y  \  |   |  \  ___/ 
|__|_|  /\___  >__| |___|  (____  /__|_|  /   __/|___|  /\___  >__| (____  /__|_|  /__|___|  /\___  >
      \/     \/          \/     \/      \/|__|        \/     \/          \/      \/        \/     \/ 

~ purchase the superior cheating software at https://methamphetamine.solutions ~

~ server ip: 212.22.93.35_27015 ~ 
~ file: gamemodes/darkrp/gamemode/core/smallscripts/policemarker_sh.lua ~

]]

--[[
nw.Register 'PoliceMarkers'
	:Write(net.WriteTable)
	:Read(net.ReadTable)
	:SetGlobal()

if CLIENT then
    hook.Add( "HUDPaint", "Marker911", function()
        if rp.Teams[LocalPlayer():Team()].police or not nw.GetGlobal("PoliceMarkers") then
            return
        end
    end )
end
]]

local ninemat = Material("sup/hud/911.png", "smooth")

if CLIENT then
    hook.Remove( "HUDPaint", "Marker911", function()
        if not rp.teams[LocalPlayer():Team()].police then
            return
        end

        for _, ent in ipairs( ents.FindByClass( "marker911" ) ) do
            local point = ent:GetPos() + ent:OBBCenter()
            local data2D = point:ToScreen()
            local distance = math.Round(LocalPlayer():GetPos():Distance(point))

            if ( not data2D.visible ) or (distance >= 4000) or ((distance <= 100)) then continue end

            surface.SetDrawColor( 255, 255, 255, 255 )
            surface.SetMaterial( ninemat )
            surface.DrawTexturedRect( data2D.x - 24, data2D.y - 24, 48, 48 )
            draw.SimpleText( distance .. " м", "ui.15", data2D.x, data2D.y, Color( 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
        end
    end )

    /*
        МУСОРНЫЙ ФИКС ОТ ДОЛБАЕБА ОН НЕ НУЖЕН
        МУСОРНЫЙ ФИКС ОТ ДОЛБАЕБА ОН НЕ НУЖЕН
        МУСОРНЫЙ ФИКС ОТ ДОЛБАЕБА ОН НЕ НУЖЕН
        МУСОРНЫЙ ФИКС ОТ ДОЛБАЕБА ОН НЕ НУЖЕН
        МУСОРНЫЙ ФИКС ОТ ДОЛБАЕБА ОН НЕ НУЖЕН
        МУСОРНЫЙ ФИКС ОТ ДОЛБАЕБА ОН НЕ НУЖЕН
        МУСОРНЫЙ ФИКС ОТ ДОЛБАЕБА ОН НЕ НУЖЕН
    */
    -- hook.Add("InitPostEntity", "FixLockdown", function(pl)
        -- net.Start("FixLockdown")
        -- net.SendToServer()
    -- end)
else
    -- util.AddNetworkString("FixLockdown")

    -- net.Receive("FixLockdown", function(_, pl)
        -- print('eto ya')
        -- if pl:GetNetVar('lockdown') ~= nw.GetGlobal('lockdown') or pl:GetNetVar('lockdown_reason') ~= nw.GetGlobal('lockdown_reason') then
            -- if nw.GetGlobal('lockdown') ~= nil then
                -- pl:SetNetVar('lockdown', true)
                -- if nw.SetGlobal('lockdown_reason') ~= nil then
                    -- pl:SetNetVar('lockdown_reason', nw.GetGlobal('lockdown_reason'))
                -- else
                    -- pl:SetNetVar('lockdown_reason', nil)
                -- end
            -- else
                -- pl:SetNetVar('lockdown', nil)
            -- end
        -- end
    -- end)
end

--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
