--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

eui.fonts = {}
eui.colors = eui.colors or {}

do // perf update
    local Lerp = Lerp
    local FrameTime = FrameTime 

    function eui.Lerp(from, to)
        return Lerp(FrameTime() * 8, from, to)
    end
end

function eui.Accessor(obj, name, default)
    if istable(name) then
        for accessorName, accessorDefault in next, name do 
            eui.Accessor(obj, accessorName, accessorDefault) 
        end 
        
        return 
    end

    obj['Get' .. name] = function(self)
        if self[name] == nil and default then self[name] = default end 

        return self[name] 
    end

    obj['Set' .. name] = function(self, value)
        self[name] = value
    end

    if default then obj[name] = default end 

    return obj
end

local scrW, scrH = ScrW(), ScrH()
hook.Add('OnScreenSizeChanged', 'eui.ChangedScreenSize', function(oldW, oldH, newW, newH)
    scrW, scrH = newW, newH
end)

do
    local roundedBox = paint.roundedBoxes.roundedBox
    
    function eui.DrawBlur(rounded, x, y, w, h, color, color2)
        paint.roundedBoxes.roundedBox(rounded, x, y, w, h, color or color_white, paint.blur.getBlurMaterial(), x / scrW, y / scrH, (x + w) / scrW, (y + h) / scrH)

        if not color2 then return end
        paint.roundedBoxes.roundedBox(rounded, x, y, w, h, color2)
    end
end

do
    local setMaterial = surface.SetMaterial
    local setDrawColor = surface.SetDrawColor
    local drawTexturedRect = surface.DrawTexturedRect

    function eui.DrawMaterial(mat, x, y, w, h, color)
        color = color or color_white

        setMaterial(mat)
        setDrawColor(color)
        drawTexturedRect(x, y, w, h)
    end
end

do
    local setMaterial = surface.SetMaterial
    local setDrawColor = surface.SetDrawColor
    local drawTexturedRect = surface.DrawTexturedRectRotated

    function eui.DrawRotateMaterial(mat, x, y, w, h, rotation, alpha)
        alpha = alpha or 255

        setMaterial(mat)
        setDrawColor(255, 255, 255, alpha)
        drawTexturedRect(x, y, w, h, rotation)
    end
end

do
    local setFont = surface.SetFont
    local getTextSize = surface.GetTextSize
    
    function eui.GetTextSize(text, font)
        setFont(font)
        
        return getTextSize(text)
    end
end

do
    local round = math.Round

    function eui.ScaleWide(w, max)
        max = max or 1920
        
        return round(w / max * scrW)
    end

    function eui.ScaleTall(h, max)
        max = max or 1080

        return round(h / max * scrH)
    end
end

do
    local createFont = surface.CreateFont
    function eui.Font(name, blur, sizing)
        blur = blur or 0

        local tblName = name .. '.' .. blur .. '.' .. tostring(sizing)
        if eui.fonts[tblName] then
            return eui.fonts[tblName]
        end

        local size, font = string.match(name, '(.*):(.*)')
        font = 'Montserrat ' .. font

        eui.fonts[tblName] = 'eui.font.' .. size .. '.' .. font .. '.' .. blur .. '.' .. tostring(sizing)

        createFont(eui.fonts[tblName], {
            font = font,
            size = sizing and eui.ScaleWide(size + 2) or eui.ScaleTall(size + 2),
            weight = 500,
            antialias = true,
            extended = true,
            blursize = blur
        })

        return eui.fonts[tblName]
    end
end

do
    function eui.Mask(drawMask, draw)
        render.ClearStencil()
        render.SetStencilEnable(true)

        render.SetStencilWriteMask(1)
        render.SetStencilTestMask(1)

        render.SetStencilFailOperation(STENCIL_REPLACE)
        render.SetStencilPassOperation( STENCIL_REPLACE)
        render.SetStencilZFailOperation(STENCIL_KEEP)
        render.SetStencilCompareFunction(STENCIL_ALWAYS)
        render.SetStencilReferenceValue(1)

        drawMask()

        render.SetStencilFailOperation(STENCIL_KEEP)
        render.SetStencilPassOperation(STENCIL_REPLACE)
        render.SetStencilZFailOperation(STENCIL_KEEP)
        render.SetStencilCompareFunction(STENCIL_EQUAL)
        render.SetStencilReferenceValue(1)

        draw()

        render.SetStencilEnable(false)
        render.ClearStencil()
    end 
end

do
    function eui.MaskInverted(drawMask, draw)
        render.ClearStencil()
        render.SetStencilEnable(true)
    
        render.SetStencilWriteMask(1)
        render.SetStencilTestMask(1)
    
        render.SetStencilFailOperation(STENCILOPERATION_REPLACE)
        render.SetStencilPassOperation(STENCILOPERATION_ZERO)
        render.SetStencilZFailOperation(STENCILOPERATION_ZERO)
        render.SetStencilCompareFunction(STENCILCOMPARISONFUNCTION_NEVER)
        render.SetStencilReferenceValue(1)
    
        drawMask()
    
        render.SetStencilFailOperation(STENCILOPERATION_ZERO)
        render.SetStencilPassOperation(STENCILOPERATION_REPLACE)
        render.SetStencilZFailOperation(STENCILOPERATION_ZERO)
        render.SetStencilCompareFunction(STENCILCOMPARISONFUNCTION_NOTEQUAL)
        render.SetStencilReferenceValue(1)
    
        draw()
    
        render.SetStencilEnable(false)
        render.ClearStencil()
    end
end

do
    local roundedBox = paint.roundedBoxes.roundedBox

    function rotateBox(rounded, x, y, w, h, angle)
        local m = Matrix()
        
        local center = Vector(x + w / 2, y + h / 2)
    
        m:Translate(center)
        m:Rotate(Angle(0, angle))
        m:Translate(-center)
        
        render.PushFilterMag(TEXFILTER.ANISOTROPIC)
        render.PushFilterMin(TEXFILTER.ANISOTROPIC)
    
            cam.PushModelMatrix( m )
                roundedBox(rounded, x, y, w, h, color_white)
            cam.PopModelMatrix()
    
        render.PopFilterMag()
        render.PopFilterMin()
    end
end

do
    local setFont = surface.SetFont
    local getTextSize = surface.GetTextSize
    local explode = string.Explode

    function eui.Wrap(font, text, width)
        setFont(font)
            
        local sw = getTextSize(' ')
        local ret = {}
            
        local w = 0
        local s = ''

        local t = explode('\n', text)
        for i = 1, #t do
            local t2 = explode(' ', t[i], false)
            for i2 = 1, #t2 do
                local neww = getTextSize(t2[i2])
                    
                if (w + neww >= width) then
                    ret[#ret + 1] = s
                    w = neww + sw
                    s = t2[i2] .. ' '
                else
                    s = s .. t2[i2] .. ' '
                    w = w + neww + sw
                end
            end
            ret[#ret + 1] = s
            w = 0
            s = ''
        end
            
        if (s ~= '') then
            ret[#ret + 1] = s
        end

        return ret
    end
end

function eui.Color(color, alpha)
    if not alpha then
        alpha = 255
    else
        alpha = alpha * 255 / 100
    end

    alpha = math.floor(alpha)
    color = color:gsub('#', '')

    local name = color .. '.' .. alpha

    if eui.colors[name] then
        return eui.colors[name]
    end

    local r = tonumber('0x' .. color:sub(1, 2))
    local g = tonumber('0x' .. color:sub(3, 4))
    local b = tonumber('0x' .. color:sub(5, 6))

    eui.colors[name] = Color(r, g, b, alpha)

    return eui.colors[name]
end

do
    local simpleText = draw.SimpleText
    local getTextSize = eui.GetTextSize

    function eui.SimpleText(font, x, y, alignx, aligny, ...)
        local args = {}
        local tbl = {...}
        local totalWidth = 0

        for i = 1, #tbl do
            local v = tbl[i]
            if IsColor(v) then
                args[#args + 1] = {color = v, text = ''}
            else
                args[#args].text = v
                totalWidth = totalWidth + getTextSize(v, font)
            end
        end

        if alignx == 1 then
            x = x - totalWidth / 2
        elseif alignx == 2 then
            x = x - totalWidth
        end

        for _, v in next, args do
            local textWidth, textHeight = getTextSize(v.text, font)
            local yOffset = 0

            if aligny == 1 then
                yOffset = -textHeight / 2
            elseif aligny == 4 then
                yOffset = -textHeight
            end

            simpleText(v.text, font, x, y + yOffset, v.color, 0, 3)
            x = x + textWidth
        end

        return totalWidth
    end
end

--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
