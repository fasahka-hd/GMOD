util.AddNetworkString('F4Gangs:Request')
util.AddNetworkString('F4Gangs:Data')
util.AddNetworkString('F4Gangs:Action')
util.AddNetworkString('F4Gangs:Notify')
util.AddNetworkString('F4Gangs:InvitePopup')
util.AddNetworkString('F4Gangs:FlagAdmin')

AddCSLuaFile('entities/f4_gang_flag/shared.lua')
AddCSLuaFile('entities/f4_gang_flag/cl_init.lua')

CreateConVar('f4_gang_create_cost', '1000000', FCVAR_ARCHIVE, 'Gang creation cost')
CreateConVar('f4_gang_flag_reward_money', '2500', FCVAR_ARCHIVE, 'Money per captured flag reward tick')
CreateConVar('f4_gang_flag_reward_rep', '25', FCVAR_ARCHIVE, 'Reputation per captured flag reward tick')
CreateConVar('f4_gang_flag_reward_interval', '300', FCVAR_ARCHIVE, 'Captured flag reward interval in seconds')
CreateConVar('f4_gang_flag_capture_time', '300', FCVAR_ARCHIVE, 'Flag capture time in seconds')
CreateConVar('f4_gang_flag_limit', '2', FCVAR_ARCHIVE, 'Max captured flags per gang')
CreateConVar('f4_gang_flag_radius', '320', FCVAR_ARCHIVE, 'Flag capture radius')
CreateConVar('f4_gang_flag_min_players', '3', FCVAR_ARCHIVE, 'Min alive gang members in radius to capture')
CreateConVar('f4_gang_flag_capture_cooldown', '1200', FCVAR_ARCHIVE, 'Flag capture cooldown after successful capture')

F4Gangs = F4Gangs or {}
F4Gangs.FlagsDisabled = false
F4Gangs.FlagsDisabledReason = ''

function LoadFlagDisableState()
    if file.Exists('f4_flags_disabled.txt', 'DATA') then
        local data = file.Read('f4_flags_disabled.txt', 'DATA')
        local parsed = util.JSONToTable(data) or {}
        F4Gangs.FlagsDisabled = parsed.disabled or false
        F4Gangs.FlagsDisabledReason = parsed.reason or ''
    end
end

function SaveFlagDisableState()
    local data = util.TableToJSON({ disabled = F4Gangs.FlagsDisabled, reason = F4Gangs.FlagsDisabledReason })
    file.Write('f4_flags_disabled.txt', data)
end

function F4GangCVarInt(name, fallback, minValue, maxValue)
    local cv = GetConVar(name)
    local value = cv and cv:GetInt() or fallback
    value = tonumber(value) or fallback or 0
    if minValue ~= nil then value = math.max(minValue, value) end
    if maxValue ~= nil then value = math.min(maxValue, value) end
    return math.floor(value)
end

function F4GangFlagRadius()
    return F4GangCVarInt('f4_gang_flag_radius', 320, 1, 10000)
end

function F4GangFlagMinPlayers()
    return F4GangCVarInt('f4_gang_flag_min_players', 3, 3, 64)
end

function F4GangFlagCaptureTime()
    return F4GangCVarInt('f4_gang_flag_capture_time', 300, 300, 86400)
end

function F4GangFlagLimit()
    return F4GangCVarInt('f4_gang_flag_limit', 2, 0, 128)
end

function F4GangFlagCooldown()
    return F4GangCVarInt('f4_gang_flag_capture_cooldown', 1200, 0, 86400)
end

function F4GangRefreshFlagRuntimeConVars()
    local radius = F4GangFlagRadius()
    local minPlayers = F4GangFlagMinPlayers()
    for _, ent in ipairs(ents.FindByClass('f4_gang_flag')) do
        if IsValid(ent) then
            ent:SetNWInt('F4FlagRadius', radius)
            ent:SetNWInt('F4FlagMinPlayers', minPlayers)
        end
    end
end

function F4GangConVarChanged()
    timer.Simple(0, function()
        F4GangRefreshFlagRuntimeConVars()
        if F4Gangs and F4Gangs.UpdateAllFlagEntities then F4Gangs.UpdateAllFlagEntities() end
    end)
end

cvars.AddChangeCallback('f4_gang_flag_radius', F4GangConVarChanged, 'F4Gangs.FlagRuntimeCVar')
cvars.AddChangeCallback('f4_gang_flag_min_players', F4GangConVarChanged, 'F4Gangs.FlagRuntimeCVar')
