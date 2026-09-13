--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

net.Receive("Refs::OpenMenu", function()
	local ply = LocalPlayer()
	if rewardsframe then rewardsframe:Remove() end
	local tbl = net.ReadTable()
	local promo = tbl[1].refcode
	local counts = tbl[1].count
	local takerub = tbl[1].uses
	local donate = tbl[1].donate
	local active = tbl[1].pickup
	local totalcount = 0
	local rub
	if takerub <= 0 then
		rub = counts * 150
	else
		rub = counts * 150 - takerub
	end

	if ply:GetPlayTime() >= 24 * 3600 then
		totalcount = totalcount + 1
	end

	if donate != "none" then
		totalcount = totalcount + 1
	end

	rewardsframe = vgui.Create("DFrame")
	rewardsframe:SetSize(796, 578)
	rewardsframe:Center()
	rewardsframe:MakePopup()
	rewardsframe:SetTitle(' ')
	rewardsframe:ShowCloseButton(false)
	rewardsframe.Paint = function(self, w, h)
		draw.RoundedBox(10, 0, 0, w, h, Color(26, 26, 26))
	end

	local closebut = vgui.Create("DButton", rewardsframe)
	closebut:SetSize(30, 30)
	closebut:SetPos(770, 15)
	closebut:SetText(' ')
	closebut.DoClick = function()
		surface.PlaySound("garrysmod/ui_click.wav")
		if IsValid(rewardsframe) then
			rewardsframe:Remove()
		end
	end
	closebut.Paint = function(self, w, h)
		draw.SimpleText("X", GetFont(10), 5, 10, Color( 111, 111, 111, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end

	local codeframe = vgui.Create("DPanel", rewardsframe)
	codeframe:SetSize(385, 181)
	codeframe:SetPos(40, 40)
	codeframe.Paint = function(self, w, h)
		draw.RoundedBox(10, 0, 0, w, h, Color(30, 30, 30))
	end

	local code = vgui.Create("DPanel", codeframe)
	code:SetSize(161, 58)
	code:SetPos(25, 25)
	code.Paint = function(self, w, h)
		draw.RoundedBox(10, 0, 0, w, h, Color(37, 37, 37))
		draw.SimpleText(string.upper(promo), GetFont(10), w/2, h/3.2, Color( 74, 74, 74 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
	end

	local frecode = vgui.Create("DTextEntry", codeframe)
	frecode:SetSize(264, 58)
	frecode:SetPos(25, 98)
	frecode:SetPlaceholderText('ВВЕСТИ КОД ДРУГА')
	frecode:OnTextChanged( true )
	frecode.Paint = function(self, w, h)
		draw.RoundedBox(10, 0, 0, w, h, Color(37, 37, 37))
		draw.SimpleText(self:GetPlaceholderText(), GetFont(10), w/2, h/3.2, Color( 111, 111, 111 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
		draw.SimpleText(self:GetValue(), GetFont(10), w/2, h/3.2, Color( 111, 111, 111 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
	end
	frecode.OnMousePressed = function()
		frecode:SetPlaceholderText(' ')
	end

	local refreshcode = vgui.Create("DButton", codeframe)
	refreshcode:SetSize(161, 58)
	refreshcode:SetPos(199, 25)
	refreshcode:SetText(' ')
	refreshcode:SetCursor("hand")
	refreshcode.Paint = function(self, w, h)
		draw.RoundedBox(10, 0, 0, w, h, Color(45, 45, 45))
		draw.SimpleText("КОПИРОВАТЬ", GetFont(10), w/2, h/3.2, Color( 111, 111, 111 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
	end
	refreshcode.OnMousePressed = function()
		surface.PlaySound("garrysmod/ui_click.wav")
		SetClipboardText(string.upper(promo))
		ply:ChatPrint('Вы успешно скопировали свой промокод!')
		if IsValid(rewardsframe) then
			rewardsframe:Remove()
		end
	end

	local acceptbut = vgui.Create("DPanel", codeframe)
	acceptbut:SetSize(58, 58)
	acceptbut:SetPos(302, 98)
	acceptbut:SetText(' ')
	acceptbut:SetCursor("hand")
	acceptbut.Paint = function(self, w, h)
		draw.RoundedBox(6, 0, 0, w, h, Color(82, 179, 135))
	end
	acceptbut.OnMousePressed = function()
		surface.PlaySound("garrysmod/ui_click.wav")
		if frecode:GetValue() != '' then
			net.Start('Refs::UsePromo')
			net.WriteString(tostring(frecode:GetValue()))
			net.SendToServer()
		else
			ply:ChatPrint('Вы не ввели промокод!')
			return
		end
		if IsValid(rewardsframe) then
			rewardsframe:Remove()
		end
	end

	local acceptimg = vgui.Create("DImage", acceptbut)
	acceptimg:SetSize(16, 12)
	acceptimg:SetPos(21, 23)
	acceptimg:SetCursor("hand")
	acceptimg:SetImage("materials/referals/yes.png")
	acceptimg.OnMousePressed = function()
		surface.PlaySound("garrysmod/ui_click.wav")
		--print(frecode:GetValue())
		if frecode:GetValue() != '' then
			net.Start('Refs::UsePromo')
			net.WriteString(tostring(frecode:GetValue()))
			net.SendToServer()
		else
			ply:ChatPrint('Вы не ввели промокод!')
			return
		end
		if IsValid(rewardsframe) then
			rewardsframe:Remove()
		end
	end


	local textframe = vgui.Create("DPanel", rewardsframe)
	textframe:SetSize(385, 96)
	textframe:SetPos(40, 241)
	textframe.Paint = function(self, w, h)

		draw.RoundedBox(10, 0, 0, w, h, Color(30, 30, 30))
		draw.SimpleText("ПРИГЛАШАЙ", GetFont(10), w/10, h/4, Color(82, 179, 135, 100), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
		draw.SimpleText("ДРУЗЕЙ И", GetFont(10), w/2.4, h/4, Color(74, 74, 74, 100), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
		draw.SimpleText("ПОЛУЧАЙ", GetFont(10), w/1.5, h/4, Color(239, 174, 93, 100), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
		draw.SimpleText("ПО", GetFont(10), w/4.6, h/2, Color(74, 74, 74, 100), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
		draw.SimpleText("150 RUB", GetFont(10), w/3.4, h/2, Color(239, 174, 93, 100), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
		draw.SimpleText("ЗА КАЖДОГО", GetFont(10), w/2.05, h/2, Color(74, 74, 74, 100), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
	end

	local totalframe = vgui.Create("DPanel", rewardsframe)
	totalframe:SetSize(385, 181)
	totalframe:SetPos(40, 357)
	totalframe.Paint = function(self, w, h)
		draw.RoundedBox(10, 0, 0, w, h, Color(30, 30, 30))
	end

	local userframe = vgui.Create("DPanel", totalframe)
	userframe:SetSize(58, 58)
	userframe:SetPos(25, 25)
	userframe.Paint = function(self, w, h)
		draw.RoundedBox(10, 0, 0, w, h, Color(82, 179, 135))
	end

	local userimg = vgui.Create("DImage", userframe)
	userimg:SetSize(20, 20)
	userimg:SetPos(19, 19)
	userimg:SetImage("materials/referals/user.png")

	local totaluser = vgui.Create("DPanel", totalframe)
	totaluser:SetSize(264, 58)
	totaluser:SetPos(96, 25)
	totaluser.Paint = function(self, w, h)
		draw.RoundedBox(10, 0, 0, w, h, Color(30, 37, 33))
		draw.SimpleText(counts.." ПРИГЛАШЕНО", GetFont(10), w/2, h/3.2, Color(82, 179, 135), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
	end

	local rubpanel = vgui.Create("DPanel", totalframe)
	rubpanel:SetSize(200, 58)
	rubpanel:SetPos(25, 98)
	rubpanel.Paint = function(self, w, h)
		draw.RoundedBox(6, 0, 0, w, h, Color(41, 36, 30))
		draw.SimpleText(rub.." RUB", GetFont(10), w/2, h/3.2, Color(239, 174, 93), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
	end

	local rubbutton = vgui.Create("DButton", totalframe)
	rubbutton:SetSize(122, 58)
	rubbutton:SetPos(238, 98)
	rubbutton:SetText(' ')
	rubbutton.Paint = function(self, w, h)
		draw.RoundedBox(6, 0, 0, w, h, Color(239, 174, 93))
		draw.SimpleText("ЗАБРАТЬ", GetFont(10), w/2, h/3.2, Color(26, 26, 26), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
	end
	rubbutton.DoClick = function()
		surface.PlaySound("garrysmod/ui_click.wav")
		net.Start("Refs::TakeMoney")
		net.SendToServer()
		if IsValid(rewardsframe) then
			rewardsframe:Remove()
		end
	end

	local kfestframe = vgui.Create("DPanel", rewardsframe)
	kfestframe:SetSize(311, 498)
	kfestframe:SetPos(445, 40)
	kfestframe.Paint = function(self, w, h)
		draw.RoundedBox(0, 0, 0, w, h, Color(26, 26, 26))
	end

	if counts < 2 then
		local onekfest = vgui.Create("DPanel", kfestframe)
		onekfest:SetSize(311, 83)
		onekfest:SetPos(0, 0)
		onekfest.Paint = function(self, w, h)
			draw.RoundedBox(10, 0, 0, w, h, Color(30, 30, 30, 100))
			draw.SimpleText("Отыграть 24 часа", GetFont(10), w/2, h/3, Color(248, 123, 123, 30), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
		end

		local twokfest = vgui.Create("DPanel", kfestframe)
		twokfest:SetSize(311, 83)
		twokfest:SetPos(0, 100)
		twokfest.Paint = function(self, w, h)
			draw.RoundedBox(10, 0, 0, w, h, Color(30, 30, 30, 100))
			draw.SimpleText("Купить что нибудь в донате", GetFont(10), w/2, h/3, Color(248, 123, 123, 30), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
		end

		local prize = vgui.Create("DPanel", kfestframe)
		prize:SetSize(311, 219)
		prize:SetPos(0, 200)
		prize.Paint = function(self, w, h)
			draw.RoundedBox(10, 0, 0, w, h, Color(30, 30, 30, 100))
		end

		local prizeicon = vgui.Create("DImage", prize)
		prizeicon:SetSize(219, 219)
		prizeicon:SetPos(46, 0)
		prizeicon:SetImageColor(Color(239, 174, 93, 100))
		prizeicon:SetImage("materials/referals/rewardok.png")

		local prizebut = vgui.Create("DPanel", kfestframe)
		prizebut:SetSize(311, 58)
		prizebut:SetPos(0, 430)
		prizebut.Paint = function(self, w, h)
			draw.RoundedBox(7, 0, 0, w, h, Color(239, 174, 93, 50))
			draw.SimpleText("ВЫПОЛНЕНО 0 ИЗ 2", GetFont(10), w/2, h/3.2, Color(239, 174, 93, 50), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
		end

		local lockimg = vgui.Create("DImage", kfestframe)
		lockimg:SetSize(100, 100)
		lockimg:SetPos(105, 140)
		lockimg:SetImage("materials/referals/deny.png")

		local textneed = vgui.Create("DPanel", kfestframe)
		textneed:SetSize(261, 85)
		textneed:SetPos(25, 273)
		textneed.Paint = function(self, w, h)
			draw.RoundedBox(10, 0, 0, w, h, Color(41, 36, 30))
			draw.SimpleText("Пригласите 2-ух друзей,", GetFont(10), w/2, h/4, Color(239, 174, 93), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
			draw.SimpleText("чтобы получить доступ", GetFont(10), w/2.02, h/2, Color(239, 174, 93), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
		end
	elseif active != "true" then
		local onekfest = vgui.Create("DPanel", kfestframe)
		onekfest:SetSize(311, 83)
		onekfest:SetPos(0, 0)
		onekfest.Paint = function(self, w, h)
			if ply:GetPlayTime( ) < 24 * 3600 then
				draw.RoundedBox(10, 0, 0, w, h, Color(248, 123, 123, 50))
				draw.SimpleText("ОТЫГРАТЬ 24 ЧАСА", GetFont(10), w/2, h/2.8, Color(248, 123, 123, 135), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
			else
				draw.RoundedBox(10, 0, 0, w, h, Color(82, 179, 135, 50))
				draw.SimpleText("У ВАС ОТЫГРАНО 24 ЧАСА", GetFont(10), w/2, h/2.8, Color(82, 179, 135), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
			end
		end

		local twokfest = vgui.Create("DPanel", kfestframe)
		twokfest:SetSize(311, 83)
		twokfest:SetPos(0, 100)
		twokfest.Paint = function(self, w, h)
			if donate == "none" then
				draw.RoundedBox(10, 0, 0, w, h, Color(248, 123, 123, 50))
				draw.SimpleText("КУПИТЬ ЧТО-НИБУДЬ В ДОНАТЕ", GetFont(10), w/2, h/2.8, Color(248, 123, 123, 135), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
			else
				draw.RoundedBox(10, 0, 0, w, h, Color(82, 179, 135, 50))
				draw.SimpleText("ВЫ КУПИЛИ ВЕЩЬ В ДОНАТЕ", GetFont(10), w/2, h/2.8, Color(82, 179, 135), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
			end
		end

		local prize = vgui.Create("DPanel", kfestframe)
		prize:SetSize(311, 219)
		prize:SetPos(0, 200)
		prize.Paint = function(self, w, h)
			draw.RoundedBox(10, 0, 0, w, h, Color(30, 30, 30, 100))
		end

		local prizeicon = vgui.Create("DImage", prize)
		prizeicon:SetSize(219, 219)
		prizeicon:SetPos(46, 0)
		prizeicon:SetImage("materials/referals/reward.png")

		local prizebut = vgui.Create("DPanel", kfestframe)
		prizebut:SetSize(311, 58)
		prizebut:SetPos(0, 440)
		if totalcount >= 2 then
			prizebut:SetCursor("hand")
		end
		prizebut.Paint = function(self, w, h)
			if totalcount < 2 then
				draw.RoundedBox(7, 0, 0, w, h, Color(239, 174, 93, 10))
				draw.SimpleText("ВЫПОЛНЕНО "..totalcount.. " ИЗ 2", GetFont(10), w/2, h/3.2, Color(239, 174, 93), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
			else
				draw.RoundedBox(7, 0, 0, w, h, Color(239, 174, 93))
				draw.SimpleText("ЗАБРАТЬ 500 RUB", GetFont(10), w/2, h/3.2, Color(26, 26, 26), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
			end
		end
		prizebut.OnMousePressed = function()
			if totalcount >= 2 then
				surface.PlaySound("garrysmod/ui_click.wav")
				net.Start('Refs::OnTakeMoney')
				net.SendToServer()
				if IsValid(rewardsframe) then
					rewardsframe:Remove()
				end
			end
		end
	end

	if active == 'true' then
		local onekfest = vgui.Create("DPanel", kfestframe)
		onekfest:SetSize(311, 83)
		onekfest:SetPos(0, 0)
		onekfest.Paint = function(self, w, h)
			if ply:GetPlayTime( ) < 24 * 3600 then
				draw.RoundedBox(10, 0, 0, w, h, Color(248, 123, 123, 5))
				draw.SimpleText("ОТЫГРАТЬ 24 ЧАСА", GetFont(10), w/2, h/2.8, Color(248, 123, 123, 10), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
			else
				draw.RoundedBox(10, 0, 0, w, h, Color(82, 179, 135, 5))
				draw.SimpleText("У ВАС ОТЫГРАНО 24 ЧАСА", GetFont(10), w/2, h/2.8, Color(82, 179, 100, 10), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
			end
		end

		local twokfest = vgui.Create("DPanel", kfestframe)
		twokfest:SetSize(311, 83)
		twokfest:SetPos(0, 100)
		twokfest.Paint = function(self, w, h)
			if donate == "none" then
				draw.RoundedBox(10, 0, 0, w, h, Color(248, 123, 123, 5))
				draw.SimpleText("КУПИТЬ ЧТО-НИБУДЬ В ДОНАТЕ", GetFont(10), w/2, h/2.8, Color(248, 123, 123, 10), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
			else
				draw.RoundedBox(10, 0, 0, w, h, Color(82, 179, 135, 5))
				draw.SimpleText("ВЫ КУПИЛИ ВЕЩЬ В ДОНАТЕ", GetFont(10), w/2, h/2.8, Color(82, 179, 100, 10), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
			end
		end

		local prize = vgui.Create("DPanel", kfestframe)
		prize:SetSize(311, 219)
		prize:SetPos(0, 200)
		prize.Paint = function(self, w, h)
			draw.RoundedBox(10, 0, 0, w, h, Color(30, 30, 30, 100))
		end

		local prizeicon = vgui.Create("DImage", prize)
		prizeicon:SetSize(219, 219)
		prizeicon:SetPos(46, 0)
		prizeicon:SetImageColor(Color(239, 174, 93, 100))
		prizeicon:SetImage("materials/referals/reward.png")

		local prizebut = vgui.Create("DPanel", kfestframe)
		prizebut:SetSize(311, 58)
		prizebut:SetPos(0, 440)
		prizebut.Paint = function(self, w, h)
			if totalcount < 2 then
				draw.RoundedBox(7, 0, 0, w, h, Color(239, 174, 93, 5))
				draw.SimpleText("ВЫПОЛНЕНО "..totalcount.. " ИЗ 2", GetFont(10), w/2, h/3.2, Color(239, 174, 93, 10), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
			else
				draw.RoundedBox(7, 0, 0, w, h, Color(239, 174, 93, 5))
				draw.SimpleText("ЗАБРАТЬ 500 RUB", GetFont(10), w/2, h/3.2, Color(26, 26, 26, 200), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
			end
		end
		--local yesimg = vgui.Create("DImage", kfestframe)
		--yesimg:SetSize(75, 75)
		--yesimg:SetPos(115, 155)
		--yesimg:SetImageColor(Color(82, 179, 135)
		--yesimg:SetImage("materials/referals/yes.png")

		local textyes = vgui.Create("DPanel", kfestframe)
		textyes:SetSize(261, 85)
		textyes:SetPos(25, 210)
		textyes.Paint = function(self, w, h)
			draw.RoundedBox(10, 0, 0, w, h, Color(30, 37, 33))
			draw.SimpleText("Вы уже забрали все", GetFont(10), w/2, h/4, Color(82, 179, 135), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
			draw.SimpleText("главные призы", GetFont(10), w/2.02, h/2, Color(82, 179, 135), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
		end
	end
end)

--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
