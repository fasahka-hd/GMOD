--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

local triggers = {}

local function Save( )
    cookie.Set( "autoMute", util.TableToJSON( triggers ) )
end
local function Load( )
    triggers = util.JSONToTable( cookie.GetString( "autoMute", "" ) ) or {
        "t.me/urbanichka",
        "connect",
        "сервер говно",
        "создатель даун",
    }
end
Load( )

if ba and ba.cmd then
    ba.cmd.Create('AutoMute', function( ply )
        net.Start( "autoMuteMenu" )
            net.WriteTable( triggers )
        net.Send( ply )
    end)
    :SetFlag('*')
    :SetHelp('Manage Auto Mute triggers')
end

util.AddNetworkString( "autoMuteMenu" )
net.Receive( "autoMuteMenu", function( len, ply )
    if !ply:IsRoot( ) then return end

    if net.ReadBool( ) then // add new?
        table.insert( triggers, string.utf8lower( net.ReadString( ) ) )
        Save( )
    else
        table.remove( triggers, net.ReadUInt( 8 ) )
        Save( )
    end
end )

local reason = "Автомут"
local time = 30
local string_find = string.find
hook.Add( "cmd.CanRunCommand", "autoMute", function( ply, cmdObject, args )
    local name = cmdObject:GetName()
    if name != "ooc" and name != "advert" and name != "broadcast" then
        return
    end
    
    local ok, lower = pcall( string.utf8lower, table.concat( args, " " ) )
    if !ok then return end

    local IPMatch = string.match( lower, "%d+.%d+.%d+.%d+:%d+" )
    if IPMatch then
        //ba.notify_staff(term.Get('AdminMutedPlayer'), NULL, ply, time .. "mi", reason .. "(" .. IPMatch .. ")")
        ba.notify(ply, term.Get('AdminMutedYou'), NULL, time .. "mi", reason)

        ply:ChatMute(time * 60, function()
            ba.notify(ply, term.Get('YouAreUnmuted'))
        end)

        return false
    end

    for k, v in ipairs( triggers ) do
        if string_find( lower, v ) then
            //ba.notify_staff(term.Get('AdminMutedPlayer'), NULL, ply, time .. "mi", reason .. "(" .. v .. ")")
            ba.notify(ply, term.Get('AdminMutedYou'), NULL, time .. "mi", reason)

            ply:ChatMute(time * 60, function()
                ba.notify(ply, term.Get('YouAreUnmuted'))
            end)

            return false
        end
    end
end )

--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
