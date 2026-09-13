-- СЕРВЕР
if SERVER then
    util.AddNetworkString("ActivateFreeLook")

    hook.Add("PlayerButtonDown", "Server_DoubleAltCheck", function(ply, btn)
        if btn == KEY_LALT then
            local curTime = CurTime()
            if ply.LastAltPress and (curTime - ply.LastAltPress) < 0.4 then
                net.Start("ActivateFreeLook")
                net.Send(ply)
                ply.LastAltPress = nil
            else
                ply.LastAltPress = curTime
            end
        end
    end)
end

-- КЛИЕНТ
if CLIENT then
    local FreeLookActive = false
    local savedAngles = nil

    net.Receive("ActivateFreeLook", function()
        if not FreeLookActive then
            EnableFreeLook()
        else
            DisableFreeLook()
        end
    end)

    function EnableFreeLook()
        if FreeLookActive then return end
        FreeLookActive = true
        savedAngles = LocalPlayer():EyeAngles()
        hook.Add("CreateMove", "FreeLook_CreateMove", FreeLookCreateMove)
        hook.Add("Think", "FreeLook_Think", FreeLookThink)
        gui.EnableScreenClicker(true)
    end

    function DisableFreeLook()
        if not FreeLookActive then return end
        FreeLookActive = false
        hook.Remove("CreateMove", "FreeLook_CreateMove")
        hook.Remove("Think", "FreeLook_Think")
        gui.EnableScreenClicker(false)
        if savedAngles then
            LocalPlayer():SetEyeAngles(savedAngles)
        end
    end

    function FreeLookCreateMove(cmd)
        if not FreeLookActive then return end
        cmd:SetMouseX(0)
        cmd:SetMouseY(0)
        cmd:ClearMovement()
    end

    function FreeLookThink()
        if not FreeLookActive then return end
        LocalPlayer():SetEyeAngles(savedAngles or Angle(0,0,0))
    end

    hook.Add("PlayerDeath", "FreeLook_Death", function()
        if FreeLookActive then DisableFreeLook() end
    end)
end