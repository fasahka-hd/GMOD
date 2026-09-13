--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

net.Receive("rp.GovernmentRequare_vec", function()
	local pos = net.ReadVector()
	local reason = net.ReadString()

	chat.AddText(Color(200,0,0), "[ВЫЗОВ ПОЛИЦИИ] ", Color(255,255,125), reason .. "!")
    EmitSound( Sound( "garrysmod/balloon_pop_cute.wav" ), LocalPlayer():GetPos(), 1, CHAN_AUTO, 1, 75, 0, 100 )

    AddGPSPos(pos, 300, "Вызов: " .. reason, "icon16/sound.png")
end)

net.Receive("rp.GovernmentRequare",function()
    local ply = net.ReadEntity()
    if not ply then return end
    local reason = net.ReadString()
    if not reason then return end

    local pos = ply:GetPos()

    chat.AddText(Color(200,0,0), "[ВЫЗОВ ПОЛИЦИИ] ", ply:GetJobColor(), ply:Nick(), Color(255,255,255), " вызывает полицию: ", Color(255,255,125), reason .. "!")
    EmitSound( Sound( "garrysmod/balloon_pop_cute.wav" ), LocalPlayer():GetPos(), 1, CHAN_AUTO, 1, 75, 0, 100 )

    AddGPSPos(pos, 300, "Вызов: " .. reason, "icon16/sound.png")
end)

hook.Add("PostDrawTranslucentRenderables", "PoliceWH", function(depth, sky)
	if depth or sky then return end
	if LocalPlayer():IsCP() then
        for k, v in ipairs(player.GetAll()) do
            if not v:IsCP() then continue end
            if not v:Alive() then continue end

            local dist = v:GetPos():DistToSqr(LocalPlayer():EyePos())
            if dist > 1250000 or not v:InView() then continue end
        end
	end
end)


--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
