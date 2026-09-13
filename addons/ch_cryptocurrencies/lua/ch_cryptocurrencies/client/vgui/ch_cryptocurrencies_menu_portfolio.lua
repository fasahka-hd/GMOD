--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

local box = draw.RoundedBox
local text = draw.SimpleText
local setmat, setcolor, setsize = surface.SetMaterial, surface.SetDrawColor, surface.DrawTexturedRect
local function LerpColor(fr, cstart, cend)
    return Color(Lerp(fr, cstart.r, cend.r), Lerp(fr, cstart.g, cend.g), Lerp(fr, cstart.b, cend.b), Lerp(fr, cstart.a, cend.a))
end

local function ss(w)
    return w * (ScrW() / 1920)
end

local materials = {
    ['bg'] = Material('jmaterials/models_background.png'),
    ['logo'] = Material('jmaterials/logo_without_bg.png'),
    ['yes'] = Material('jmaterials/option_yes.png'),
    ['no'] = Material('jmaterials/option_no.png'),
}

local colors = {
    ['white_1'] = Color(255, 255, 255, 2),
    ['white_25'] = Color(255, 255, 255, 25),
    ['black_25'] = Color(0, 0, 0, 150),
    ['white_51'] = Color(255, 255, 255, 80),
    ['main'] = Color(1, 89, 224),
    ['green'] = Color(119, 237, 41),
    ['red'] = Color(1, 89, 224),
}

function CH_CryptoCurrencies.PortfolioMenu()
	local TotalBalance = 0
    local ply = LocalPlayer()
    local GUI_CryptoFrame = vgui.Create('DFrame')
    GUI_CryptoFrame:SetTitle('')
    GUI_CryptoFrame:SetSize(ss(1480), ss(835))
    GUI_CryptoFrame:DockPadding(ss(30), ss(30), ss(30), ss(30))
    GUI_CryptoFrame:Center()
    GUI_CryptoFrame.Paint = function(self, w, h) box(20, 0, 0, w, h, enc.clrs.inbg) end
    GUI_CryptoFrame:MakePopup()
    GUI_CryptoFrame:SetDraggable(false)
    GUI_CryptoFrame:ShowCloseButton(false)
    GUI_CryptoFrame.Think = function()
        if input.IsKeyDown(KEY_ESCAPE) then
            GUI_CryptoFrame:AlphaTo(0, 0.2, 0, function() GUI_CryptoFrame:Remove() end)
            gui.HideGameUI()
        end
    end

    local panel_top = vgui.Create('EditablePanel', GUI_CryptoFrame)
    panel_top:Dock(TOP)
    panel_top:DockPadding(ss(44), ss(30), ss(44), ss(30))
    panel_top:SetTall(ss(120))
    panel_top.Paint = function(s, w, h)
        box(20, 0, 0, w, h, colors['white_1'])
        setmat(materials['logo'])
        setcolor(color_white)
        setsize(ss(44), ss(30), ss(60), ss(60))
        box(0, ss(114), ss(45), ss(1), ss(30), colors['white_25'])
        text('Добро пожаловать,', 'M_18', ss(134), h * .5 - ss(10), colors['white_25'], TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
        text(ply:Nick(), 'MSB_30', ss(134), h * .5 + ss(10), color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
    end

    local close = vgui.Create('EditablePanel', panel_top)
    close:Dock(RIGHT)
    close:DockMargin(0, ss(5), 0, ss(5))
    close:SetWide(ss(140))
    close:SetCursor'hand'
    close.lerpHover = 0
    close.Paint = function(self, w, h)
        self.lerpHover = math.Clamp(self:IsHovered() and self.lerpHover + FrameTime() * 3 or self.lerpHover - FrameTime() * 3, 0, 1)
        box(6, 0, 0, w, h, LerpColor(self.lerpHover, Color(255, 255, 255, 0), color_white))
        box(5, w - h, 0, h, h, color_white)
        text('Выход', 'MSB_20', (w - h) * .5, h * .5, LerpColor(self.lerpHover, color_white, color_black), TEXT_ALIGN_CENTER, 1)
        text('Esc', 'MSB_20', w - h * .25, h * .5, color_black, 2, 1)
    end

    close.OnMousePressed = function() GUI_CryptoFrame:Remove() end
    local GUI_PortfolioFrameBtn = vgui.Create('DButton', panel_top)
    GUI_PortfolioFrameBtn:Dock(RIGHT)
    GUI_PortfolioFrameBtn:DockMargin(0, ss(5), ss(42), ss(5))
    GUI_PortfolioFrameBtn:SetWide(ss(225))
    GUI_PortfolioFrameBtn:SetTextColor(Color(0, 0, 0, 255))
    GUI_PortfolioFrameBtn:SetText('')
    GUI_PortfolioFrameBtn.Paint = function(s, w, h)
        box(10, 0, 0, w, h, s:IsHovered() and colors['main'] or colors['white_1'])
        text(CH_CryptoCurrencies.LangString('Portfolio'), 'MSB_20', w * .5, h * .5, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end

    if CH_CryptoCurrencies.Config.EnableSQL then
        GUI_TransactionsFrameBtn = vgui.Create('DButton', panel_top)
        GUI_TransactionsFrameBtn:Dock(RIGHT)
        GUI_TransactionsFrameBtn:DockMargin(0, ss(5), ss(42), ss(5))
        GUI_TransactionsFrameBtn:SetWide(ss(225))
        GUI_TransactionsFrameBtn:SetTextColor(Color(0, 0, 0, 255))
        GUI_TransactionsFrameBtn:SetText('')
        GUI_TransactionsFrameBtn.Paint = function(self, w, h)
            box(8, 0, 0, w, h, CH_CryptoCurrencies.Colors.DarkGray)
            if IsValid(GUI_PortfolioFrame) then
                box(8, 0, h * 0.8, w, h * 0.2, CH_CryptoCurrencies.Colors.GMSBlue, false, false, true, true)
            elseif self:IsHovered() then
                box(8, 0, h * 0.8, w, h * 0.2, CH_CryptoCurrencies.Colors.GMSBlue, false, false, true, true)
            end

            text(CH_CryptoCurrencies.LangString('Transactions'), 'MSB_20', w * .5, h * .5, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        end

        GUI_TransactionsFrameBtn.DoClick = function()
            GUI_CryptoFrame:Remove()
            CH_CryptoCurrencies.TransactionsMenu()
        end
    end

    local GUI_BuyCryptoFrameBtn = vgui.Create('DButton', panel_top)
    GUI_BuyCryptoFrameBtn:Dock(RIGHT)
    GUI_BuyCryptoFrameBtn:DockMargin(0, ss(5), ss(42), ss(5))
    GUI_BuyCryptoFrameBtn:SetWide(ss(225))
    GUI_BuyCryptoFrameBtn:SetTextColor(Color(0, 0, 0, 255))
    GUI_BuyCryptoFrameBtn:SetText('')
    GUI_BuyCryptoFrameBtn.Paint = function(s, w, h)
        box(10, 0, 0, w, h, s:IsHovered() and colors['main'] or colors['white_1'])
        text('Крипта', 'MSB_20', w * .5, h * .5, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end
	GUI_BuyCryptoFrameBtn.DoClick = function()
        GUI_CryptoFrame:Remove()
		CH_CryptoCurrencies.CryptoMenu()
	end

    local panel_balance = vgui.Create('DPanel', GUI_CryptoFrame)
    panel_balance:Dock(TOP)
    panel_balance:DockMargin(0, ss(35), 0, ss(35))
    panel_balance:SetTall(ss(60))
    panel_balance.Paint = function(s, w, h)
        text('Ваш баланс:', 'MM_20', 0, 0, colors['white_25'], TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
        text(CH_CryptoCurrencies.FormatMoney(TotalBalance), 'MSB_36', 0, h, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM)
    end

    local panel_info = vgui.Create('DPanel', GUI_CryptoFrame)
    panel_info:Dock(TOP)
    panel_info:DockMargin(0, 0, 0, ss(10))
    panel_info:SetTall(ss(45))
    panel_info.Paint = function(s, w, h)
        box(10, 0, 0, w, h, colors['white_1'])
        text('Крипта', 'MM_18', ss(65), h * .5, colors['white_25'], TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
        text('Баланс', 'MM_18', (w - ss(208)) * .5, h * .5, colors['white_25'], TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        text('Цена за 1', 'MM_18', w - ss(274), h * .5, colors['white_25'], TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
        text('Передать', 'MM_18', w - ss(65), h * .5, colors['white_25'], TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
    end

    local GUI_CryptoList = vgui.Create('DScrollPanel', GUI_CryptoFrame) --------------------------
    GUI_CryptoList:Dock(FILL)
    GUI_CryptoList.Paint = function(self, w, h) box(0, 0, 0, w, h, CH_CryptoCurrencies.Colors.Invisible) end
    if GUI_CryptoList.VBar then
        GUI_CryptoList.VBar.Paint = function(self, w, h)
            box(0, 0, 0, w, h, CH_CryptoCurrencies.Colors.Invisible) -- BG
        end

        GUI_CryptoList.VBar.btnUp.Paint = function(self, w, h) box(0, 0, 0, w, h, CH_CryptoCurrencies.Colors.Invisible) end
        GUI_CryptoList.VBar.btnGrip.Paint = function(self, w, h) box(6, 0, 0, w, h, colors['main']) end
        GUI_CryptoList.VBar.btnDown.Paint = function(self, w, h) box(0, 0, 0, w, h, CH_CryptoCurrencies.Colors.Invisible) end
    end
    for index, crypto in ipairs(CH_CryptoCurrencies.CryptosCL) do
        local prefix = crypto.Currency
        local player_owns = math.Round(ply.CH_CryptoCurrencies_Wallet[prefix].Amount, 7)
        local crypto_worth = math.Round(player_owns * crypto.Price)
        TotalBalance = TotalBalance + crypto_worth -- Update total balance for the frame
        if CH_CryptoCurrencies.CryptoIconsCL[prefix] and player_owns > 0 then -- Check if this exists. If this doesn't exist it means we have some coins that are no longer available on the server and thus we don't show that.
            local GUI_CryptoPortfolioPanel = vgui.Create('DPanelList', GUI_CryptoList)
            GUI_CryptoPortfolioPanel:Dock(TOP)
            GUI_CryptoPortfolioPanel:DockMargin(0, 0, ss(10), ss(10))
            GUI_CryptoPortfolioPanel:SetTall(ss(82))
            GUI_CryptoPortfolioPanel.Paint = function(self, w, h)
                local price_change = crypto.Change
                local price_change_color = colors['green']
                if price_change < 0 then price_change_color = colors['red'] end
                local no_change = false
                box(8, 0, 0, w - ss(184), h, CH_CryptoCurrencies.Colors.DarkGray) -- Background
                surface.SetDrawColor(color_white) -- Coin Icon
                surface.SetMaterial(crypto.Icon)
                surface.DrawTexturedRect(ss(14), ss(14), ss(54), ss(54))
                text(crypto.Name, 'MSB_22', ss(78), ss(20), color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
                text(crypto.Currency, 'MM_18', ss(78), ss(62), color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM)
                if price_change == 0 then no_change = true end
                text(crypto.Price .. ' RUB', 'MM_20', w - ss(198), not no_change and ss(20) or h * .5, color_white, TEXT_ALIGN_RIGHT, not no_change and TEXT_ALIGN_TOP or TEXT_ALIGN_CENTER)
                if not no_change then text(price_change .. '%', 'MM_18', w - ss(198), ss(62), price_change_color, TEXT_ALIGN_RIGHT, TEXT_ALIGN_BOTTOM) end
                text(string.format('%f', player_owns) * crypto.Price .. ' RUB', 'MM_20', (w - ss(184)) * .5, ss(20), color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
                text(string.format('%f ', player_owns) .. crypto.Currency, 'MM_18', (w - ss(184)) * .5, ss(62), CH_CryptoCurrencies.Colors.WhiteAlpha2, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM)
            end
            local GUI_SendCrypto = vgui.Create('DButton', GUI_CryptoPortfolioPanel)
            GUI_SendCrypto:Dock(RIGHT)
            GUI_SendCrypto:SetWide(ss(174))
            GUI_SendCrypto:SetTextColor(Color(0, 0, 0, 255))
            GUI_SendCrypto:SetText('')
            GUI_SendCrypto.Paint = function(self, w, h)
                box(10, 0, 0, w, h, CH_CryptoCurrencies.Colors.DarkGray)
                text('--->', 'MSB_20', w * .5, h * .5, self:IsHovered() and color_white or colors['white_25'], TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
            end
            GUI_SendCrypto.DoClick = function()
                CH_CryptoCurrencies.SendCryptoMenu(index)
                GUI_CryptoFrame:Remove()
            end
        end
    end
end

--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
