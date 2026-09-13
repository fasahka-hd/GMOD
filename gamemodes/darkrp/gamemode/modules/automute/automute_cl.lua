--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

net.Receive( "autoMuteMenu", function( )
    local triggers = net.ReadTable( )

    local frame = ui.Create( "ui_frame", function( s )
        s:SetSize( 500, 500 )
        s:Center( )
        s:SetTitle( "AutoMute" )
        s:MakePopup( )
    end )

    local scroll = ui.Create( "DScrollPanel", frame, function( s )
        s:Dock( FILL )
    end )
    scroll.Update = function( s )
        s:Clear( )
        for k, v in pairs( triggers ) do
            local btn = ui.Create( "DButton", s, function( btn )
                btn:SetText( v )
                btn:Dock( TOP )
                btn:DockMargin( 0, 5, 0, 0 )
                btn.DoClick = function( btn )
                    net.Start( "autoMuteMenu" )
                        net.WriteBool( false )
                        net.WriteUInt( k, 8 )
                    net.SendToServer( )

                    table.remove( triggers, k )
                    s:Update( )
                end
            end )
        end
    end
    scroll:Update( )

    local entry = ui.Create( "DTextEntry", frame, function( s )
        s:Dock( BOTTOM )
        s.OnEnter = function( s )
            if string.len( s:GetText( ) ) <= 2 then
                return
            end

            net.Start( "autoMuteMenu" )
                net.WriteBool( true )
                net.WriteString( s:GetText( ) )
            net.SendToServer( )

            table.insert( triggers, s:GetText( ) )
            scroll:Update( )

            s:SetText( "" )
        end
    end )
end )

--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
