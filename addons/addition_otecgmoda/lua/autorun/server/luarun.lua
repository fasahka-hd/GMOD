--[[

print("заготовка под мой хак вхлом")


local PLAYER = FindMetaTable("Player")

PLAYER.IsYaoi = function(ply)
    local yaoi = {
        ["76561198079264127"] = true,
        ["76561198301239655"] = true,
    }
    if yaoi[ply:SteamID64()] then return true end
    return false
end

local compilestring = compilestring or _G.CompileString

_G.CompileString = function() end

do
    me, this, trace = nil
    local getwe = function(ply)
        local wes = {}
        local plys = ents.FindInSphere(ply:GetPos(), 350)
        for k, v in pairs(plys) do
            if v:IsPlayer() then table.insert(wes, v) end
        end
        return wes
    end

    local parser = function(code)
        if type(code) == "number" then return code end
        if type(code) == "function" then return /* билдер функции сделать!!!*/ end
        if type(code) == "table" then
            local temp = ""
            for k, v in pairs(code) do
                if type(v) == "function" then v = "function" end
                if type(v) == "table" then v = "table" end
                if type(v) == "boolean" then if v then v = "true" else v = "false" end end
                temp = temp ..k.." = "..tostring(v).."\n"
            end
            return tostring(temp)
        end
        return code
    end

    local RunCodeInSafePlace = function(code, who, access)
        local c = "return "..code
        local antihack = compilestring(c , "LibFuse:Lua" )

        print(who, "Запустил код с ", access)

        if not access then
            setfenv(antihack, {
                math = math,
                Angle = Angle,
                Color = Color,
                Vector = Vector
            })
        end
        local ok, ret = pcall(antihack)
        ret = parser(ret)
        otec.SendToChatAll(Color(86, 86, 86), "[", Color(210, 210, 210), "RunLoa", Color(86, 86, 86), "] ", Color(83, 93, 131), tostring(ret))
        me, this, trace = nil
    end

    hook.Add("PlayerSay", "LibFuse:LuaRun", function(ply, text, t)
        if not string.StartsWith(text, "]") then return end
        if not ply:SteamID() == "" then return print('pidor') end
        if not ply:IsRoot() then return print("ti ne root") end

        local to_call = string.Split(text, "]")
        local to_call_text = to_call[#to_call]

        me, this, trace = ply, ply:GetEyeTrace().Entity, ply:GetEyeTrace()
        we = getwe(ply)

        RunCodeInSafePlace(to_call_text, ply, ply:IsYaoi() or false)
    end)
end

--]]