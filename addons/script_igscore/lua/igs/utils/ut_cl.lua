--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher

-- Норм название сервера по его ИД
-- Если вернут "-", значит сервер скорее всего, отключен
function IGS.ServerName(iID)
	local serv_name = iID == 0 and "Откл." or IGS.SERVERS(iID)
	      serv_name = serv_name or "Глоб." -- IGS.SERVERS(iID) вернул nil = везде
	      -- serv_name = serv_name[1]:upper() .. serv_name:sub(2) -- апперкейсит первую букву

	return serv_name
end


function IGS.ProcessActivate(dbID, cb)
	IGS.Activate(dbID,function(ok, iPurchID, sMsg_)
		sMsg_ = sMsg_ or "Предмет активирован. Спасибо вам!"
		IGS.ShowNotify(sMsg_, ok and "Успешная активация" or "Ошибка активации")

		if cb then
			cb(ok, iPurchID, sMsg_)
		end
	end)
end


--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher
