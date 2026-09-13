--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

local includeFile do
    local includeTypes = {
        ['cl_'] = SERVER and AddCSLuaFile or include,
        ['sv_'] = SERVER and include or function() end,
        ['sh_'] = function(path)
            if SERVER then
                AddCSLuaFile(path)
            end
            include(path)
        end
    }

    includeFile = function(path)
        local pathSplitted = string.Explode('/', path)
        local filePrefix = pathSplitted[#pathSplitted]:sub(1, 3)

        if includeTypes[filePrefix] then 
            includeTypes[filePrefix](path)
        end
    end
end

local includeDir do
    local includePriority = {
        ['sh_'] = 2, 
        ['sv_'] = 1, 
        ['cl_'] = 0, 
    }

    local function sortByPriority(file1, file2)
        return (includePriority[file1:sub(1, 3)] or -1) > (includePriority[file2:sub(1, 3)] or -1)
    end

    includeDir = function(dir)
        dir = dir .. '/'
        local files, folders = file.Find(dir .. '*', 'LUA')

        table.sort(files, sortByPriority)

        for _, fileName in ipairs(files) do
            includeFile(dir .. fileName)
        end

        for _, folder in ipairs(folders) do 
            includeDir(dir .. folder)
        end
    end
end

includeDir('radon_misc')


--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
