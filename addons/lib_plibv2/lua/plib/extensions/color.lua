--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

local tonumber         = tonumber
local string_format = string.format
local string_match     = string.match
local bit_band        = bit.band
local bit_rshift     = bit.rshift

local COLOR = getmetatable(Color(0,0,0))

function Color(r, g, b, a)
    return setmetatable({
        r = tonumber(r) or 255,
        g = tonumber(g) or 255,
        b = tonumber(b) or 255,
        a = tonumber(a) or 255
    }, COLOR)
end

function COLOR:Copy()
    return Color(self.r, self.g, self.b, self.a)
end

function COLOR:SetHex(hex)
    local r, g, b = string_match(hex, '#(..)(..)(..)')
    self.r, self.g, self.b = tonumber(r, 16), tonumber(g, 16), tonumber(b, 16)
    return self
end

function COLOR:ToHex()
    return string_format('#%02X%02X%02X', self.r, self.g, self.b)
end

function COLOR:SetEncodedRGB(num)
    self.r, self.g, self.b = bit_band(bit_rshift(num, 16), 0xFF), bit_band(bit_rshift(num, 8), 0xFF), bit_band(num, 0xFF)
    return self
end

function COLOR:ToEncodedRGB()
    return (self.r * 0x100 + self.g) * 0x100 + self.b
end

function COLOR:SetEncodedRGBA(num)
    self.r, self.g, self.b, self.a = bit_band(bit_rshift(num, 16), 0xFF), bit_band(bit_rshift(num, 8), 0xFF), bit_band(num, 0xFF), bit_band(bit_rshift(num, 24), 0xFF)
    return self
end

function COLOR:ToEncodedRGBA()
    return ((self.a * 0x100 + self.r) * 0x100 + self.g) * 0x100 + self.b
end

--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
