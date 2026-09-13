--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

local Tag = "KylDonate:Govorilka"
util.AddNetworkString(Tag)

local function HasGovorilka(ply)
    if not IsValid(ply) then return false end
    if ply.Govorilka then return true end
    if ply:GetNWBool("GovorilkaHave", false) then return true end
    if ply.HasPurchase then
        local ok, has = pcall(function()
            return ply:HasPurchase("ttsdonate") or ply:HasPurchase("govorilka")
        end)
        if ok and has then return true end
    end
    return false
end

local function RefreshGovorilka(ply)
    if not IsValid(ply) then return end

    -- IGS-предмет из sh_additems.lua
    if ply.HasPurchase then
        local ok, has = pcall(function() return ply:HasPurchase("ttsdonate") end)
        if ok and has then
            ply.Govorilka = true
            ply:SetNWBool("GovorilkaHave", true)
        end
    end

    -- Старый KylDonate-предмет
    if KylDonate and KylDonate.HasItem then
        KylDonate.HasItem(ply, "govorilka", function(data)
            if IsValid(ply) and data then
                ply.Govorilka = true
                ply:SetNWBool("GovorilkaHave", true)
            end
        end)
    end
end

hook.Add("PlayerSay", Tag, function(ply, text, teamChat)
    if not HasGovorilka(ply) then return end
    if teamChat then return end
    if ply.IsChatMuted and ply:IsChatMuted() then return end
    if not ply:Alive() then return end

    local str = tostring(text or ""):Trim()
    if str == "" then return end
    if str:StartWith("!") or str:StartWith("@") or str:StartWith("/") then return end
    if #str > 220 then str = string.sub(str, 1, 220) end

    net.Start(Tag)
        net.WritePlayer(ply)
        net.WriteVector(ply:GetPos())
        net.WriteString(str)
    net.Broadcast()
end)

hook.Add("LibFuse:PlayerFullyLoad", "KylDonate:Govorilka", RefreshGovorilka)
hook.Add("IGS.PlayerPurchasesLoaded", "IGS:Govorilka", RefreshGovorilka)
hook.Add("PlayerInitialSpawn", "GovorilkaFallbackLoad", function(ply)
    timer.Simple(5, function()
        if IsValid(ply) then RefreshGovorilka(ply) end
    end)
end)

hook.Add("LibFuse:PlayerFullyLoad", "KylDonate:Objora", function(ply)
    KylDonate.HasItem(ply, 'objora', function(data)
        if data then
            ply.Objora = true
        end
    end)
end)

hook.Add("LibFuse:PlayerFullyLoad", "KylDonate:sumkammo", function(ply)
    KylDonate.HasItem(ply, 'sumkammo', function(data)
        if data then
            ply.SumkaPatron = true
        end
    end)
end)

hook.Add("PlayerSpawn", "KylDonate:sumkammo", function(ply)
    if ply.SumkaPatron then
        for k, v in pairs(game.GetAmmoTypes()) do
            ply:GiveAmmo(500,k)
        end
    end
end)
