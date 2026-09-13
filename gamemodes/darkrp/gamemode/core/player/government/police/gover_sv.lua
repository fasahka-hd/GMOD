--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

util.AddNetworkString('rp.GovernmentRequare_vec')
util.AddNetworkString('rp.GovernmentRequare')

rp.AddCommand('911', function(ply, text)
	if text == '' then rp.Notify(ply,1,'Не указана причина!') return end
	if ply:IsCP() then rp.Notify(ply,1,'Нельзя полиции') return end
	if ply.cdcp == nil then ply.cdcp = CurTime() end
	if ply.cdcp > CurTime() then rp.Notify(ply,1,'Попробуйте через '..math.Round(ply.cdcp - CurTime())..' сек.') return end
	if string.len(text) > 60 then
		rp.Notify(ply, 1, 'Вы указали слишком большую причину!')
		return
	end
	rp.Notify(ply,3,'Вы вызвали полицию')
	ply.cdcp = 300 + CurTime()

	for k,v in pairs(player.GetAll()) do
		if !v:IsCP() then continue end
		net.Start('rp.GovernmentRequare')
		net.WriteEntity(ply)
		net.WriteString(text)
		net.Send(v)
	end
end):AddParam(cmd.STRING)

function CP_Call(vec,str)
	for k,v in pairs(player.GetAll()) do
		if !v:IsCP() then continue end
		net.Start('rp.GovernmentRequare_vec')
		net.WriteVector(vec)
		net.WriteString(str)
		net.Send(v)
	end
end


--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
