
cvar.Register 'size_crosshair'
	:SetDefault(10)
	:AddMetadata('Catagory', 'Прицел')
	:AddMetadata('Menu', 'Размер прицела')
	:AddMetadata('Type', 'number')

cvar.Register 'red_crosshair'
	:SetDefault(255)
	:AddMetadata('Catagory', 'Прицел')
	:AddMetadata('Menu', 'Красный прицела')
	:AddMetadata('Type', 'number')

cvar.Register 'green_crosshair'
	:SetDefault(255)
	:AddMetadata('Catagory', 'Прицел')
	:AddMetadata('Menu', 'Зеленый прицела')
	:AddMetadata('Type', 'number')

cvar.Register 'blue_crosshair'
	:SetDefault(255)
	:AddMetadata('Catagory', 'Прицел')
	:AddMetadata('Menu', 'Синий прицела')
	:AddMetadata('Type', 'number')

cvar.Register 'type_crosshair'
	:SetDefault(1)
	:AddMetadata('Catagory', 'Прицел')
	:AddMetadata('Menu', 'Тип прицела')
	:AddMetadata('Type', 'number')

cvar.Register 'disable_crosshair'
	:SetDefault(true, true)
	:AddMetadata('Catagory', 'Худ')
	:AddMetadata('Menu', 'Включить прицел')

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

local mat1 = Material("crosshair/krest.png", "smooth mips")
local mat2 = Material("crosshair/circle.png", "smooth mips")
local mat3 = Material("crosshair/polucircle.png", "smooth mips")

local crostbl = {
	[1] = mat2,
	[2] = mat3,
	[3] = mat1
}

local function crosshair()
	local tbl = {}
	for k, v in ipairs(cvar.GetOrderedTable()) do
		if v:GetMetadata('Menu') or v:GetCustomElement() then
			local cat = v:GetMetadata('Category') or v:GetMetadata('Catagory') or 'Other'
			if cat == 'Прицел' then
				if (not tbl[cat]) then
					tbl[cat] = {}
				end
				tbl[cat][#tbl[cat] + 1] = v
			end
		end
	end
	tbl = tbl['Прицел']
	if cvar.GetValue('disable_crosshair') then
		if crostbl[tbl[5]:GetValue()] then
			surface.SetMaterial(crostbl[tbl[5]:GetValue()])
			surface.SetDrawColor(tbl[2]:GetValue(),tbl[3]:GetValue(),tbl[4]:GetValue())
			surface.DrawTexturedRect(ScrW()/2 - tbl[1]:GetValue()/2,ScrH()/2 - tbl[1]:GetValue()/2,tbl[1]:GetValue(),tbl[1]:GetValue())
		end
	end
end

hook.Add('HUDPaint','enc.hud.crosshair',crosshair)
