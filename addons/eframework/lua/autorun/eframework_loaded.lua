--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

eui = eui or {}

function eui:Print(msg, clr)
    clr = clr or Color(255, 255, 255)

	MsgC(Color(48, 156, 255), '[enc framework] ', clr, msg .. '\n')
end

do
    local blockedFile = {}
    local deblockedFile = {}

    function eui:IncludeDir(fileDir)
        local files, dirs = file.Find(fileDir .. '*', 'LUA')

        for _, fileName in ipairs(files) do
            if string.match(fileName, '.lua') and not blockedFile[fileName] and not deblockedFile[fileDir .. fileName] then
                local prefix = string.sub(fileName, 1, 2)

                if SERVER and prefix ~= 'sv' then
                    deblockedFile[fileDir .. fileName] = true
                    AddCSLuaFile(fileDir .. fileName)
                    eui:Print('Adding File: ' .. fileDir .. fileName, Color(0, 255, 0))
                end

                if CLIENT and prefix ~= 'sv' then
                    include(fileDir .. fileName)
                    deblockedFile[fileDir .. fileName] = true
                    eui:Print('Including File: ' .. fileDir .. fileName, Color(0, 255, 0))
                end
                
                if SERVER and prefix ~= 'cl' then
                    include(fileDir .. fileName)
                    deblockedFile[fileDir .. fileName] = true
                    eui:Print('Including File: ' .. fileDir .. fileName, Color(0, 255, 0))
                end
            end
        end

        for _, dir in ipairs(dirs) do
            self:IncludeDir(fileDir .. dir .. '/')
        end
    end
end

if CLIENT and BRANCH ~= 'x64-86' then
	local vec = Vector()
	local vecSetUnpacked = vec.SetUnpacked


	mesh.OldPosition = mesh.OldPosition or mesh.Position

    function mesh.Position(x, y, z)
		if y == nil then
			mesh.OldPosition(x)
			return
		end

        vecSetUnpacked(vec, x, y, z)
		mesh.OldPosition(vec)
	end
end

local function load(path)
	AddCSLuaFile(path)
	if CLIENT then
		include(path)
	end
end

load('paint/main_cl.lua')
load('paint/batch_cl.lua')
load('paint/lines_cl.lua')
load('paint/rects_cl.lua')
load('paint/rounded_boxes_cl.lua')
load('paint/outlines_cl.lua')
load('paint/blur_cl.lua')
load('paint/circles_cl.lua')

hook.Add('OnGamemodeLoaded', 'eui:LoadedMain', function()
    load('paint/main_cl.lua')
    load('paint/batch_cl.lua')
    load('paint/lines_cl.lua')
    load('paint/rects_cl.lua')
    load('paint/rounded_boxes_cl.lua')
    load('paint/outlines_cl.lua')
    load('paint/blur_cl.lua')
    load('paint/circles_cl.lua')

    eui:IncludeDir('eframework/')
    eui:IncludeDir('eui/')
    eui:Print('Coded by Encoded', Color(0, 255, 0))
    
    hook.Call('eui.Loaded')
end)

--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
