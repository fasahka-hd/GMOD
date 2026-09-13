if SERVER then
    AddCSLuaFile()
end


local function syncToPanel(target_sid32, ITEM, pl)
    if not SERVER then return end
    if not VibeRP or not VibeRP.Config or not VibeRP.Config.PanelURL then return end

    local cat = ITEM:Category()
    local ep, act
    local payload = {
        steamid32 = target_sid32,
        title = ITEM:Name(),
        by = IsValid(pl) and pl:Nick() or "Server Console",
    }

    if cat == "Профессии" then
        ep, act = "/api/jobs_sync", "grant_job"
        payload.job_command = ITEM:UID()
    elseif cat == "Оружие" then
        ep, act = "/api/weapons_sync", "grant_weapon"
        payload.weapon_class = ITEM:UID()
    elseif cat == "Модели" then
        ep, act = "/api/models_sync", "grant_model"
        payload.model_path = ITEM:UID()
    else
        return
    end

    payload.action = act
    HTTP({
        url = VibeRP.Config.PanelURL .. ep,
        method = "POST",
        body = util.TableToJSON(payload),
        type = "application/json",
        headers = {
            ["X-API-Password"] = VibeRP.Config.Secret,
            ["Content-Type"] = "application/json",
        },
    })
end

local function syncRevokeToPanel(target_sid32, item_uid, pl)
    if not SERVER then return end
    if not VibeRP or not VibeRP.Config or not VibeRP.Config.PanelURL then return end
    if not target_sid32 or target_sid32 == "" then return end
    if not item_uid or item_uid == "" then return end

    local ITEM = IGS.GetItemByUID(item_uid)
    if not ITEM or ITEM.isnull then return end

    local cat = ITEM:Category()
    local ep, act
    local payload = {
        steamid32 = target_sid32,
        by = IsValid(pl) and pl:Nick() or "Server Console",
    }

    if cat == "Профессии" then
        ep, act = "/api/jobs_sync", "revoke_job"
        payload.job_command = item_uid
    elseif cat == "Оружие" then
        ep, act = "/api/weapons_sync", "revoke_weapon"
        payload.weapon_class = item_uid
    elseif cat == "Модели" then
        ep, act = "/api/models_sync", "revoke_model"
        payload.model_path = item_uid
    else
        return
    end

    payload.action = act
    HTTP({
        url = VibeRP.Config.PanelURL .. ep,
        method = "POST",
        body = util.TableToJSON(payload),
        type = "application/json",
        headers = {
            ["X-API-Password"] = VibeRP.Config.Secret,
            ["Content-Type"] = "application/json",
        },
    })
end


local cangivecredits = {
    ["STEAM_0:1:22093009"] = true,
    ["STEAM_0:0:562541572"] = true,
    ["STEAM_0:1:575732651"] = true,
    ["STEAM_0:1:452003092"] = true,
    ["STEAM_0:0:910679003"] = true,
}

local function canGive(pl)
    if not IsValid(pl) then return true end
    return cangivecredits[pl:SteamID()] == true
end


local function InitDonateCommands()
    if not ba or not ba.cmd then return false end

    ba.cmd.Create('adddonate', function(pl, args)
        if not canGive(pl) then
            if IsValid(pl) then pl:ChatPrint('Ошибка доступа!') end
            return
        end

        local item_uid = args.uid
        local ITEM = IGS.GetItemByUID(item_uid)
        if not ITEM or ITEM.isnull then
            local errMsg = "Ошибка: услуга с UID '" .. tostring(item_uid) .. "' не найдена!"
            if IsValid(pl) then pl:ChatPrint(errMsg) else print(errMsg) end
            return
        end

        if IsValid(args.target) and args.target:IsPlayer() then
            IGS.PlayerActivateItem(args.target, item_uid, function(id)
                local successMsg = 'Вы успешно выдали ' .. ITEM:Name() .. ' игроку ' .. args.target:GetName() .. ' (' .. id .. ')'
                if IsValid(pl) then
                    pl:ChatPrint(successMsg)
                else
                    print(successMsg)
                end
                args.target:ChatPrint('Вам выдали ' .. ITEM:Name() .. '!')
                syncToPanel(args.target:SteamID(), ITEM, pl)

                if IsValid(args.target) then
                    net.Start('f4_purchase_update')
                    net.WriteString(item_uid)
                    net.WriteBool(true)
                    net.Send(args.target)
                end

                timer.Simple(0.5, function()
                    if not IsValid(args.target) then return end
                    if IGS.SyncPurchases then
                        IGS.SyncPurchases(args.target)
                    elseif IGS.LoadPurchases then
                        IGS.LoadPurchases(args.target)
                    end
                end)
            end)
            return
        end

        local target_sid = tostring(args.target)
        IGS.StoreLocalPurchase(util.SteamIDTo64(target_sid), item_uid, nil, function(id)
            local successMsg = 'Вы успешно выдали ' .. ITEM:Name() .. ' игроку ' .. target_sid .. ' (' .. id .. ')'
            if IsValid(pl) then
                pl:ChatPrint(successMsg)
            else
                print(successMsg)
            end
            syncToPanel(target_sid, ITEM, pl)
        end)
    end)
    :AddParam('player_steamid', 'target')
    :AddParam('string', 'uid')
    :SetFlag('*')
    :SetHelp('Выдать донат игроку')

    local function DoRevoke(pl, target_sid, target_sid64, targetPly, item_uid)
        if not item_uid or item_uid == "" then
            local errMsg = "Ошибка: не указан UID услуги"
            if IsValid(pl) then pl:ChatPrint(errMsg) else print(errMsg) end
            return
        end

        IGS.GetPurchases(function(purchases)
            local found_id
            if purchases then
                for _, p in ipairs(purchases) do
                    if p.Item == item_uid then
                        found_id = p.ID
                        break
                    end
                end
            end

            if not found_id then
                local msg = 'У игрока ' .. target_sid .. ' нет активной покупки "' .. item_uid .. '"'
                if IsValid(pl) then pl:ChatPrint(msg) else print(msg) end
                syncRevokeToPanel(target_sid, item_uid, pl)
                return
            end

            IGS.DisablePurchase(found_id, function(bDisabled)
                if not bDisabled then
                    local errMsg = 'Не удалось отключить покупку "' .. item_uid .. '" у ' .. target_sid
                    if IsValid(pl) then pl:ChatPrint(errMsg) else print(errMsg) end
                    return
                end

                local who = IsValid(pl) and pl:Name() or "Сервер"
                local successMsg = 'Вы успешно забрали услугу "' .. item_uid .. '" у игрока ' .. target_sid
                if IsValid(pl) then pl:ChatPrint(successMsg) else print(successMsg) end

                if IsValid(targetPly) then
                    targetPly:ChatPrint('Администратор ' .. who .. ' забрал у вас услугу: ' .. item_uid)
                    net.Start('f4_purchase_update')
                    net.WriteString(item_uid)
                    net.WriteBool(false)
                    net.Send(targetPly)

                    timer.Simple(0.5, function()
                        if not IsValid(targetPly) then return end
                        if IGS.SyncPurchases then
                            IGS.SyncPurchases(targetPly)
                        elseif IGS.LoadPurchases then
                            IGS.LoadPurchases(targetPly)
                        end
                    end)
                end

                syncRevokeToPanel(target_sid, item_uid, pl)
            end)
        end, {
            sid = target_sid64,
            only_active = 1,
        })
    end

    ba.cmd.Create('removedonate', function(pl, args)
        if not canGive(pl) then
            if IsValid(pl) then pl:ChatPrint('Ошибка доступа!') end
            return
        end

        local targetPly = nil
        local target_sid = ""
        if IsValid(args.target) and args.target:IsPlayer() then
            targetPly = args.target
            target_sid = targetPly:SteamID()
        else
            target_sid = tostring(args.target or "")
        end

        if target_sid == "" then
            local errMsg = "Ошибка: не указан игрок"
            if IsValid(pl) then pl:ChatPrint(errMsg) else print(errMsg) end
            return
        end

        local target_sid64
        if IsValid(targetPly) then
            target_sid64 = targetPly:SteamID64()
        else
            target_sid64 = util.SteamIDTo64(target_sid)
            if not target_sid64 or target_sid64 == "0" then
                local errMsg = "Ошибка: некорректный SteamID '" .. target_sid .. "'"
                if IsValid(pl) then pl:ChatPrint(errMsg) else print(errMsg) end
                return
            end
        end

        DoRevoke(pl, target_sid, target_sid64, targetPly, args.uid)
    end)
    :AddParam('player_steamid', 'target')
    :AddParam('string', 'uid')
    :SetFlag('*')
    :SetHelp('Забрать донат-услугу у игрока (STEAMID UID)')

    local function MakeRevokeAlias(name)
        ba.cmd.Create(name, function(pl, args)
            if not canGive(pl) then
                if IsValid(pl) then pl:ChatPrint('Ошибка доступа!') end
                return
            end
            local target = IsValid(args.target) and args.target or tostring(args.target or "")
            ba.cmd.Run(IsValid(pl) and pl or NULL, 'removedonate ' .. target .. ' ' .. tostring(args.uid or ""))
        end)
        :AddParam('player_steamid', 'target')
        :AddParam('string', 'uid')
        :SetFlag('*')
        :SetHelp('Алиас для removedonate')
    end
    MakeRevokeAlias('takedonate')
    MakeRevokeAlias('del_donate')

    ba.cmd.Create('donatelogs', function(pl, args)
        if CLIENT then return end
        if not canGive(pl) then
            if IsValid(pl) then pl:ChatPrint('Ошибка доступа!') end
            return
        end

        local sid64
        local plyEnt = NULL

        if IsValid(args.target) and args.target:IsPlayer() then
            sid64 = args.target:SteamID64()
            plyEnt = args.target
        else
            sid64 = util.SteamIDTo64(args.target)
        end

        if not sid64 or sid64 == "0" then
            local errMsg = 'Некорректный SteamID или игрок не найден'
            if IsValid(pl) then pl:ChatPrint(errMsg) else print(errMsg) end
            return
        end

        IGS.GetPurchases(function(purchases)
            if not IsValid(pl) then
                print("Донат логи для " .. sid64 .. ":")
                PrintTable(purchases)
                return
            end
            net.Start('igsClientMenu')
            net.WriteTable(purchases)
            net.WriteEntity(plyEnt)
            net.WriteString(sid64)
            net.Send(pl)
        end, {
            sid = sid64,
            only_active = 1,
        })
    end)
    :AddParam('player_steamid', 'target')
    :SetFlag('*')
    :SetHelp('Информация о донате игрока')

    return true
end

if not InitDonateCommands() then
    hook.Add('Initialize', 'InitDonateCommands', function()
        timer.Simple(5, function()
            if not InitDonateCommands() then
                timer.Simple(10, InitDonateCommands)
            end
        end)
    end)
end


if CLIENT then

    surface.CreateFont('DonateTitle', { font = 'Roboto', size = 22, weight = 700, antialias = true })
    surface.CreateFont('DonateItem',  { font = 'Roboto', size = 17, weight = 600, antialias = true })
    surface.CreateFont('DonateSmall', { font = 'Roboto', size = 14, weight = 500, antialias = true })

    local bgTop       = Color(22, 24, 30, 250)
    local bgBot       = Color(28, 30, 38, 250)
    local cardBg      = Color(32, 34, 42, 245)
    local cardBgHov   = Color(42, 44, 54, 245)
    local iconBg      = Color(20, 22, 28, 245)

    local borderDim   = Color(60, 64, 78, 180)
    local borderLite  = Color(90, 94, 110, 220)

    local accent      = Color(70, 130, 220, 255)
    local accentDim   = Color(50, 90, 160, 255)

    local textPri     = Color(235, 235, 240, 255)
    local textSec     = Color(170, 172, 185, 255)
    local textDim     = Color(120, 122, 138, 255)

    local success     = Color(80, 195, 120, 255)
    local warning     = Color(225, 175, 65, 255)
    local danger      = Color(210, 75, 75, 255)
    local dangerHov   = Color(230, 90, 90, 255)

    local function drawBox(x, y, w, h, col)
        surface.SetDrawColor(col.r, col.g, col.b, col.a)
        surface.DrawRect(x, y, w, h)
    end

    local function drawOutline(x, y, w, h, col, thickness)
        thickness = thickness or 1
        surface.SetDrawColor(col.r, col.g, col.b, col.a)
        for i = 0, thickness - 1 do
            surface.DrawOutlinedRect(x + i, y + i, w - i * 2, h - i * 2, 1)
        end
    end

    local function formatExpire(seconds)
        if not seconds or seconds <= 0 then return "Истёк", danger end
        local days = math.floor(seconds / 86400)
        if days > 30 then
            return string.format("%d мес.", math.floor(days / 30)), success
        elseif days >= 1 then
            return string.format("%d дн.", days), days > 7 and success or warning
        else
            local h = math.floor(seconds / 3600)
            return h > 0 and (string.format("%d ч.", h)) or "Менее часа", danger
        end
    end

    net.Receive('igsClientMenu', function()
        if igsFrameDonate then igsFrameDonate:Remove() end

        local donate_all = net.ReadTable()
        local ply = net.ReadEntity()
        local targetSID = net.ReadString()

        if #donate_all == 0 then
            chat.AddText(Color(170, 172, 185), "[VibeRP] ", Color(255, 255, 255),
                "У данного игрока нет активных покупок.")
            return
        end

        local display_name = (IsValid(ply) and ply:IsPlayer()) and ply:GetName() or targetSID
        local totalActive = #donate_all

        local fr = vgui.Create('DFrame')
        fr:SetSize(math.min(ScrW() * 0.55, 820), math.min(ScrH() * 0.7, 600))
        fr:Center()
        fr:MakePopup()
        fr:SetTitle('')
        fr:ShowCloseButton(false)
        fr:DockPadding(0, 0, 0, 0)

        fr.Paint = function(self, w, h)
            drawBox(0, 0, w, h, bgTop)
            drawOutline(0, 0, w, h, borderDim, 1)
            drawBox(0, 0, 3, h, accent)
        end

        local titleBar = vgui.Create('DPanel', fr)
        titleBar:Dock(TOP)
        titleBar:SetTall(50)
        titleBar:DockMargin(0, 0, 0, 0)
        titleBar.Paint = function(self, w, h)
            drawBox(0, 0, w, h, Color(36, 38, 48, 250))
            drawBox(0, h - 1, w, 1, Color(50, 52, 64, 255))

            draw.SimpleText('Донат игрока: ' .. display_name, 'DonateTitle',
                18, h * 0.5, textPri, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)

            local countText = totalActive .. ' активных'
            drawBox(w - 180, h * 0.5 - 14, 140, 28, Color(28, 30, 38, 245))
            drawOutline(w - 180, h * 0.5 - 14, 140, 28, borderDim, 1)
            draw.SimpleText(countText, 'DonateSmall',
                w - 180 + 70, h * 0.5, textSec, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        end

        local closeBtn = vgui.Create('DButton', fr)
        closeBtn:SetSize(34, 34)
        closeBtn:SetPos(fr:GetWide() - 44, 8)
        closeBtn:SetText('')
        closeBtn.Paint = function(self, w, h)
            local hov = self:IsHovered()
            drawBox(0, 0, w, h, hov and Color(60, 30, 30, 240) or Color(45, 47, 58, 220))
            drawOutline(0, 0, w, h, hov and danger or borderDim, 1)
            draw.SimpleText('X', 'DonateTitle', w * 0.5, h * 0.5,
                hov and danger or textSec, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        end
        closeBtn.DoClick = function() fr:Remove() end

        local body = vgui.Create('DPanel', fr)
        body:Dock(FILL)
        body:DockMargin(0, 0, 0, 0)
        body.Paint = function(self, w, h)
            drawBox(0, 0, w, h, bgBot)
        end

        local Scroll = vgui.Create('DScrollPanel', body)
        Scroll:Dock(FILL)
        Scroll:DockMargin(8, 8, 8, 0)
        local sbar = Scroll:GetVBar()
        sbar:SetWide(6)
        sbar:SetHideButtons(true)
        sbar.Paint = function(self, w, h)
            drawBox(0, 0, w, h, Color(20, 22, 28, 200))
        end
        sbar.btnGrip.Paint = function(self, w, h)
            drawBox(0, 0, w, h, accent)
        end

        for _, v in ipairs(donate_all) do
            local item_name = v.Item
            local ITEM = IGS.GetItemByUID(v.Item)
            if ITEM and not ITEM.isnull then item_name = ITEM:Name() end

            local card = Scroll:Add('DPanel')
            card:Dock(TOP)
            card:DockMargin(0, 4, 0, 4)
            card:SetTall(104)
            card.Paint = function(self, w, h)
                local hov = self:IsHovered()
                local bg = hov and cardBgHov or cardBg

                drawBox(0, 0, w, h, bg)
                drawOutline(0, 0, w, h, hov and borderLite or borderDim, 1)
                drawBox(0, 0, 3, h, hov and accent or accentDim)

                local iconX, iconY, iconW, iconH = 14, 14, 76, 76
                drawBox(iconX, iconY, iconW, iconH, iconBg)
                drawOutline(iconX, iconY, iconW, iconH, borderDim, 1)

                if ITEM and ITEM.icon then
                    if ITEM.icon.isModel then
                        local mp = vgui.Create('DModelPanel', card)
                        mp:SetPos(iconX + 2, iconY + 2)
                        mp:SetSize(iconW - 4, iconH - 4)
                        mp:SetModel(ITEM.icon.icon)
                        if IsValid(mp.Entity) then
                            local mn, mx = mp.Entity:GetRenderBounds()
                            local size = math.max(
                                math.abs(mn.x) + math.abs(mx.x),
                                math.abs(mn.y) + math.abs(mx.y),
                                math.abs(mn.z) + math.abs(mx.z)
                            )
                            mp:SetFOV(45)
                            mp:SetCamPos(Vector(size, size, size))
                            mp:SetLookAt((mn + mx) * 0.5)
                        end
                        mp.LayoutEntity = function() end
                    elseif IGS and IGS.GetIconURL then
                        local img = vgui.Create('HTMLView', card)
                        img:SetPos(iconX + 2, iconY + 2)
                        img:SetSize(iconW - 4, iconH - 4)
                        local url = IGS.GetIconURL(ITEM.icon.icon)
                        if url then img:SetHTML('<img src="' .. url .. '" width="100%" height="100%"/>') end
                    end
                end

                local textX = iconX + iconW + 16
                draw.SimpleText(item_name, 'DonateItem', textX, 12,
                    textPri, TEXT_ALIGN_LEFT)

                draw.SimpleText('UID: ' .. tostring(v.Item or ''), 'DonateSmall', textX, 36,
                    textDim, TEXT_ALIGN_LEFT)

                draw.SimpleText('ID покупки: ' .. tostring(v.ID or ''), 'DonateSmall', textX, 54,
                    textDim, TEXT_ALIGN_LEFT)

                local expireText, expireColor = "Перманентно", success
                if v.ExpireDate then
                    expireText, expireColor = formatExpire(v.ExpireDate - os.time())
                end
                draw.SimpleText('Срок: ' .. expireText, 'DonateSmall', textX, 72,
                    expireColor, TEXT_ALIGN_LEFT)

                local btnW, btnH = 130, 36
                local btnX = w - btnW - 14
                local btnY = h * 0.5 - btnH * 0.5

                local mx, my = gui.MousePos()
                local lx, ly = self:ScreenToLocal(mx, my)
                local btnHov = lx >= btnX and lx <= btnX + btnW
                    and ly >= btnY and ly <= btnY + btnH

                local btnCol = btnHov and dangerHov or danger
                drawBox(btnX, btnY, btnW, btnH, btnCol)
                drawOutline(btnX, btnY, btnW, btnH,
                    btnHov and Color(255, 130, 130, 220) or Color(140, 50, 50, 220), 1)
                draw.SimpleText('Забрать', 'DonateItem', btnX + btnW * 0.5, btnY + btnH * 0.5,
                    Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

                self._btnArea = { x = btnX, y = btnY, w = btnW, h = btnH }
            end

            card.OnMousePressed = function(self, key)
                if key ~= MOUSE_LEFT then return end
                local mx, my = gui.MousePos()
                local lx, ly = self:ScreenToLocal(mx, my)
                local area = self._btnArea
                if not area then return end
                if lx >= area.x and lx <= area.x + area.w
                    and ly >= area.y and ly <= area.y + area.h then
                    Derma_Query(
                        "Забрать услугу \"" .. item_name .. "\" у " .. display_name .. "?",
                        "Подтверждение",
                        "Да", function()
                            if IsValid(igsFrameDonate) then igsFrameDonate:Remove() end
                            net.Start('igs.RemoveMenu')
                            net.WriteEntity(ply)
                            net.WriteUInt(v.ID, IGS.BIT_PURCH_ID)
                            net.WriteString(item_name)
                            net.WriteString(v.Item)
                            net.SendToServer()
                        end,
                        "Отмена", function() end
                    )
                end
            end

            card:SetCursor("hand")
        end

        local footer = vgui.Create('DPanel', fr)
        footer:Dock(BOTTOM)
        footer:SetTall(40)
        footer:DockMargin(0, 0, 0, 0)
        footer.Paint = function(self, w, h)
            drawBox(0, 0, w, h, Color(24, 26, 34, 250))
            drawBox(0, 0, w, 1, Color(50, 52, 64, 255))
            draw.SimpleText('VibeRP Admin · Donate Logs', 'DonateSmall',
                14, h * 0.5, textDim, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
            draw.SimpleText('Клик по кнопке "Забрать" отключает покупку в IGS и на сайте',
                'DonateSmall', w - 14, h * 0.5, textDim, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
        end

        igsFrameDonate = fr

        hook.Add("Think", "igsDonateCloseKey", function()
            if not IsValid(fr) then
                hook.Remove("Think", "igsDonateCloseKey")
                return
            end
            if input.IsKeyDown(KEY_ESCAPE) then
                fr:Remove()
            end
        end)
    end)
end


if SERVER then
    util.AddNetworkString('igsClientMenu')
    util.AddNetworkString('igs.RemoveMenu')
    util.AddNetworkString('f4_purchase_update')

    net.Receive('igs.RemoveMenu', function(_, pl)
        if not cangivecredits[pl:SteamID()] then return end

        local user      = net.ReadEntity()
        local id        = net.ReadUInt(IGS.BIT_PURCH_ID)
        local item_name = net.ReadString()
        local item_uid  = net.ReadString()

        IGS.DisablePurchase(id, function(bDisabled)
            if not bDisabled then return end

            if IsValid(pl) then
                local target_nick = IsValid(user) and user:Name() or "Оффлайн игрок"
                pl:ChatPrint('Услуга "' .. item_name .. '" успешно отключена у ' .. target_nick)
            end

            if IsValid(user) then
                user:ChatPrint('Администратор ' .. pl:Name() .. ' аннулировал вашу услугу: ' .. item_name)

                net.Start('f4_purchase_update')
                net.WriteString(item_uid)
                net.WriteBool(false)
                net.Send(user)

                timer.Simple(0.5, function()
                    if not IsValid(user) then return end
                    if IGS.SyncPurchases then
                        IGS.SyncPurchases(user)
                    elseif IGS.LoadPurchases then
                        IGS.LoadPurchases(user)
                    end
                end)

                syncRevokeToPanel(user:SteamID(), item_uid, pl)
            end
        end)
    end)
end
