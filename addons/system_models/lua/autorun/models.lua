--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

just_models = just_models or {}

local function IncludeDir(path)
    local f,d = file.Find(path..'/*','LUA')

    for k, v in ipairs(f) do 
        local a = path..'/'..v

        local pref = v:sub(1,3)
        if pref == 'cl_' then 
            if CLIENT then 
                include(a)
            else 
                AddCSLuaFile(a)
            end
        elseif pref == 'sv_' then
            include(a)
        else 
            AddCSLuaFile(a)
            include(a)
        end
    end

    for k,v in ipairs(d) do 
        IncludeDir(path..'/'..v)
    end
end

hook.Add('OnGamemodeLoaded', 'just_models.loaded', function()
    IncludeDir('models')
end)

--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
