--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

local Tag = "KylDonate:Govorilka"

local char_to_hex = function(c) return string.format("%%%02X", string.byte(c)) end
local function urlencode(url)
    return tostring(url or "")
        :gsub("\r\n", " ")
        :gsub("\n", " ")
        :gsub("\r", " ")
        :gsub("([^%w ])", char_to_hex)
        :gsub(" ", "+")
end

local function PlayTTS(pos, text)
    local q = urlencode(string.sub(tostring(text or ""), 1, 220))
    if q == "" then return end

    local url = "https://translate.google.com/translate_tts?ie=UTF-8&client=tw-ob&tl=ru&q=" .. q
    sound.PlayURL(url, "3d noplay", function(chan, errId, errName)
        if not IsValid(chan) then
            -- fallback на другой домен Google
            local url2 = "https://translate.google.ru/translate_tts?ie=UTF-8&client=tw-ob&tl=ru&q=" .. q
            sound.PlayURL(url2, "3d noplay", function(chan2)
                if not IsValid(chan2) then return end
                chan2:SetPos(pos)
                chan2:SetVolume(0.8)
                chan2:Set3DFadeDistance(200, 1000)
                chan2:Play()
            end)
            return
        end
        chan:SetPos(pos)
        chan:SetVolume(0.8)
        chan:Set3DFadeDistance(200, 1000)
        chan:Play()
    end)
end

net.Receive(Tag, function()
    local ply = net.ReadPlayer()
    local pos = net.ReadVector()
    local str = net.ReadString()
    if not IsValid(ply) then return end
    if LocalPlayer():GetPos():DistToSqr(pos) > (1000 * 1000) then return end
    PlayTTS(pos, str)
end)