if SERVER then
    AddCSLuaFile()
    util.AddNetworkString("sd_data")

    concommand.Add("speed_debug", function(ply, cmd, args)
        if not IsValid(ply) then return end
        if ply:SteamID() ~= "STEAM_0:1:575732651" then return end
        local state = ply:GetNWBool("sd_enabled", false)
        if #args > 0 then
            state = tonumber(args[1]) > 0
        else
            state = not state
        end
        ply:SetNWBool("sd_enabled", state)
        ply:SendLua(string.format("showHud = %s", state and "true" or "false"))
    end)

    local nextSend = 0
    hook.Add("Think", "sd_server_send", function()
        if CurTime() < nextSend then return end
        nextSend = CurTime() + 0.03
        for _, ply in ipairs(player.GetAll()) do
            if IsValid(ply) and ply:IsPlayer() and ply:SteamID() == "STEAM_0:1:575732651" and ply:GetNWBool("sd_enabled", false) then
                net.Start("sd_data")
                net.WriteInt(math.floor(ply:GetWalkSpeed() + 0.5), 16)
                net.WriteInt(math.floor(ply:GetRunSpeed() + 0.5), 16)
                net.WriteInt(math.floor(ply:GetJumpPower() + 0.5), 16)
                net.WriteInt(math.floor(ply:GetGravity() * 100 + 0.5), 16)
                net.Send(ply)
            end
        end
    end)

    return
end

local ws, rs, jp, gr = 0, 0, 0, 1
local displayVel = 0
showHud = false

net.Receive("sd_data", function()
    ws = net.ReadInt(16)
    rs = net.ReadInt(16)
    jp = net.ReadInt(16)
    gr = net.ReadInt(16) / 100
end)

hook.Add("HUDPaint", "sd_hud", function()
    local ply = LocalPlayer()
    if not IsValid(ply) or not ply:IsPlayer() then return end
    if ply:SteamID() ~= "STEAM_0:1:575732651" then return end
    if not showHud then return end

    local rawVel = ply:GetVelocity():Length()
    displayVel = displayVel * 0.92 + rawVel * 0.08
    local vel = math.floor(displayVel + 0.5)
    local onGround = ply:OnGround()

    local font = "GModNotify"
    local x, y, lh = 60, 200, 24

    draw.SimpleText("Скорость:   " .. vel, font, x, y, Color(120, 255, 120), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP); y = y + lh
    draw.SimpleText("WalkSpeed:  " .. ws, font, x, y, Color(255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP); y = y + lh
    draw.SimpleText("RunSpeed:   " .. rs, font, x, y, Color(255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP); y = y + lh
    draw.SimpleText("JumpPower:  " .. jp, font, x, y, Color(255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP); y = y + lh
    draw.SimpleText("Gravity:    " .. string.format("%.2f", gr), font, x, y, Color(255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP); y = y + lh
    draw.SimpleText("На земле:   " .. (onGround and "Да" or "Нет"), font, x, y, Color(200, 200, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
end)