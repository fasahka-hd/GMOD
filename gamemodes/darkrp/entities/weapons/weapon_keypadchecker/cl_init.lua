--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

include("shared.lua")

local DrawData = {}

net.Receive("DarkRP_keypadData", function(len)
	DrawData = net.ReadTable()
end)

local lineMat = Material("cable/chain")

function SWEP:DrawHUD()
	draw.WordBox(2, 10, ScrH() / 2, "Кейпад или фд покажет к чему он привязан.", "HudFont", Color(0,0,0,120), Color(255, 255, 255, 255))
	draw.WordBox(2, 10, ScrH() / 2 + 20, "Снимайте исчезающую дверь/двигатель/что угодно, чтобы увидеть, какие кейпады подключены к ней.", "HudFont", Color(0,0,0,120), Color(255, 255, 255, 255))
	draw.WordBox(2, 10, ScrH() / 2 + 40, "Щелкните правой кнопкой мыши, чтобы прекратить просмотр.", "HudFont", Color(0,0,0,120), Color(255, 255, 255, 255))

	local entMessages = {}
	for k,v in pairs(DrawData or {}) do
		if not IsValid(v.ent) or not IsValid(v.original) then continue end
		entMessages[v.ent] = (entMessages[v.ent] or 0) + 1
		local pos = v.ent:LocalToWorld(v.ent:OBBCenter()):ToScreen()

		local name = (v.name and ": " .. v.name:gsub("onDown", "ON"):gsub("onUp", "OFF") or "")

		draw.WordBox(2, pos.x, pos.y + entMessages[v.ent] * 16, (v.delay and v.delay .. " seconds " or "") .. v.type .. name, "ChatFont", Color(0,0,0,120), Color(255, 255, 255, 255))

		cam.Start3D(EyePos(), EyeAngles())
			render.SetMaterial(lineMat)
			render.DrawBeam(v.original:GetPos(), v.ent:GetPos(), 2, 0.01, 20, Color(0, 255, 0, 255))
		cam.End3D()
	end
end

function SWEP:SecondaryAttack()
	DrawData = {}
end

--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
