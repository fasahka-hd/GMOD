--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

local path = "weapons/tfa_ins2_rgd5/"
local pref = "Weapon_RGD5"
local hudcolor = Color(255, 255, 255, 255)

TFA.AddWeaponSound(pref .. ".PinPull", path .. "rgo_pinpull.wav")
TFA.AddWeaponSound(pref .. ".ArmThrow", path .. "rgo_throw.wav")
TFA.AddWeaponSound(pref .. ".ArmDraw", path .. "rgo_armdraw.wav")


if killicon and killicon.Add then
	killicon.Add("tfa_nam_rgd5", "vgui/hud/tfa_nam_rgd5", hudcolor)
        killicon.Add("tfa_nam_rgd5_entities", "vgui/hud/tfa_nam_rgd5", hudcolor)
end

--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
