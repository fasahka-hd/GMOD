--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

NotificationTable_Venatuss = NotificationTable_Venatuss or {}

function UE_Notif( msg, time )
	
	local time = time or 10
	
	NotificationTable_Venatuss[#NotificationTable_Venatuss + 1] = {
		text = msg,
		apptime = CurTime() + 0.2,
		timeremove = CurTime() + 0.2 + 1 + time,
		type = "uber",
	}

end

local iconMat = Material( "materials/uber_eats/gps.png" )

hook.Add("HUDPaint", "GmodEats.HUDNotifications", function()
		
	for k, v in pairs( NotificationTable_Venatuss ) do
		if v.type == "uber" then
			if v.timeremove - CurTime() < 0 then table.remove(NotificationTable_Venatuss,k) continue end
		
			local alpha = ( math.Clamp(CurTime() - v.apptime, 0 , 1) )
			local posy = ScrH() - 200 - 60 * k - 40 * ( 1 - ( math.Clamp(CurTime() - v.apptime, 0 , 1) ) )
			local posx = math.Clamp(v.timeremove - CurTime(),0,0.25) * 4 * 30 + (0.25 - math.Clamp(v.timeremove - CurTime(),0,0.25)) * 4 * - 340
			
			surface.SetFont( "UberEatFont6" )
			local x,y = surface.GetTextSize( v.text ) 
			
			draw.RoundedBox( 5, posx, posy , 60, 40, Color(0, 136, 0,255 * alpha ) )	
			
			surface.SetDrawColor( 255, 255, 255, 255 * alpha )
			surface.DrawRect( posx + 50, posy, 20 + x, 40 )
		
			surface.SetMaterial( iconMat )
			surface.DrawTexturedRect( posx + 10, posy + 5, 30, 30 )
			
			
			surface.SetTextPos( posx + 50 + 10, posy + 40/2-y/2 )
			surface.SetTextColor( 0, 0, 0, 255 * alpha)
			surface.DrawText( v.text )
		end
	end	
	
end)

net.Receive("GmodEats.NotifyPlayer", function()
	local msg = net.ReadString()
	local time = net.ReadInt( 32 )
	UE_Notif( msg, time )
end)

--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
