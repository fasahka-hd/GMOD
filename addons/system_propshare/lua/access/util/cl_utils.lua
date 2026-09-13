--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

local newfont = surface.CreateFont
local hook_Add = hook.Add
local math_Round = math.Round

do 
    local scrw, scrh = ScrW()/1920, ScrH()/1080
    hook_Add('OnScreenSizeChanged', 'enc.sizescreen', function()
        scrw, scrh = ScrW()/1920, ScrH()/1080
    end)

    function enc.h(px)
        return math_Round(px * scrh)
    end

    function enc.w(px)
        return math_Round(px * scrw)
    end
end

do
    local errorMat = Material("error")
    local WebImageCache = {}
    if !file.IsDir('dudework', 'DATA') then
        file.CreateDir('dudework')
    end
    function http.DownloadMaterial(url, path, callback)
        if WebImageCache[url] then return callback(WebImageCache[url]) end

        local data_path = "data/dudework/".. path
        if file.Exists('dudework/'..path, "DATA") then
            WebImageCache[url] = Material(data_path, "smooth", "noclamp")
            callback(WebImageCache[url])
        else
            http.Fetch(url, function(img)
                if img == nil or string.find(img, "<!DOCTYPE HTML>", 1, true) then return callback(errorMat) end
                
                file.Write('dudework/'..path, img)
                WebImageCache[url] = Material(data_path, "smooth", "noclamp")
                callback(WebImageCache[url])
            end, function()
                callback(errorMat)
            end)
        end
    end
end

do
	newfont('MM_10', {
		font = 'Montserrat Medium',
		size = enc.h(12),
		weight = 500,
		extended = true,
	})
	newfont('M_12', {
		font = 'Montserrat',
		size = enc.h(14),
		weight = 500,
		extended = true,
	})
    newfont('MM_12', {
		font = 'Montserrat Medium',
		size = enc.h(14),
		weight = 500,
		extended = true,
	})		
    newfont('M_10', {
		font = 'Montserrat',
		size = enc.h(12),
		weight = 500,
		extended = true,
	})	
	newfont('M_8', {
		font = 'Montserrat',
		size = enc.h(10), -- ХИХИХИХИХИ, Я УВЕРЕН ЧТО ЭТО БУДУ МЕНЯТЬ ЕПТА
		weight = 500,
		extended = true,
	})	
	newfont('MB_30', {
		font = 'Montserrat Bold',
		size = enc.h(32),
		weight = 500,
		extended = true,
	})	
	newfont('M_20', {
		font = 'Montserrat',
		size = enc.h(22),
		weight = 500,
		extended = true,
	})
	newfont('MB_8', {
		font = 'Montserrat Bold',
		size = enc.h(12),
		weight = 500,
		extended = true,
	})
	newfont('MB_8', {
		font = 'Montserrat Bold',
		size = enc.h(10),
		weight = 500,
		extended = true,
	})		
	newfont('MB_28', {
		font = 'Montserrat Bold',
		size = enc.h(30),
		weight = 500,
		extended = true,
	})	
	newfont('MB_24', {
		font = 'Montserrat Bold',
		size = enc.h(26),
		weight = 500,
		extended = true,
	})	
	newfont('MB_13', {
		font = 'Montserrat Bold',
		size = enc.h(15),
		weight = 500,
		extended = true,
	})	
	newfont('MB_20', {
		font = 'Montserrat Bold',
		size = enc.h(22),
		weight = 500,
		extended = true,
	})
	newfont('MB_14', {
		font = 'Montserrat Bold',
		size = enc.h(16),
		weight = 500,
		extended = true,
	})	
	newfont('M_14', {
		font = 'Montserrat',
		size = enc.h(16),
		weight = 500,
		extended = true,
	})
	newfont('M_16', {
		font = 'Montserrat',
		size = enc.h(18),
		weight = 500,
		extended = true,
	})
end

--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
