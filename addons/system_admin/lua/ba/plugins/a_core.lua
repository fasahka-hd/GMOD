ba.cmd.Create('Help'):RunOnClient(function()
    local fr = ui.Create('ui_frame', function(self)
        self:SetSize(600, ScrH() * 0.5)
        self:SetTitle('Помощь по командам.')
        self:Center()
        self:MakePopup()
    end)
    local cont = ui.Create('ui_scrollpanel', function(self, p)
        self:SetPos(5, 32)
        self:SetSize(p:GetWide() - 10, p:GetTall() - 37)
        self:SetPadding(-1)
        self:SetScrollSize(4)
    end, fr)
    for k, v in pairs(ba.cmd.GetTable()) do
        if LocalPlayer():HasFlag(v:GetFlag()) then
            local p = ui.Create('ui_panel')
            local l = ba.ui.Label(v:GetNiceName() .. ':', p, {font = 'ui.22', color = ui.col.Close})
            l:SizeToContents()
            l:SetPos(26, 5)
            local h = l:GetTall()
            l = ba.ui.Label('Help: ' .. v:GetHelp(), p, {font = 'ui.22', color = ui.col.Close})
            l:SizeToContents()
            l:SetPos(50, 25)
            h = h + l:GetTall()
            local a = ''
            for k, arg in ipairs(v:GetArgs()) do
                a = a .. arg.Key .. (k == #v:GetArgs() and '' or ', ')
            end
            if #v:GetArgs() < 1 then
                a = 'No Args'
            else
                a = 'Args: ' .. a
            end
            l = ba.ui.Label(a, p, {font = 'ui.22', color = ui.col.Close})
            l:SizeToContents()
            l:SetPos(50, 50)
            h = h + l:GetTall() + 10
            p:SetTall(h)
            ui.Create('DImage', function(self)
                self:SetPos(5, 5)
                self:SetImage(v:GetIcon())
                self:SetSize(16, 16)
            end, p)
            cont:AddItem(p)
        end
    end
end):SetHelp('Помощь по командам')

ba.cmd.Create("rules"):RunOnClient(function(args)
    local w, h = ScrW() * 0.65, ScrH() * 0.8
    local fr = ui.Create('ui_frame', function(self)
        self:SetTitle('Правила')
        self:SetSize(w, h)
        self:MakePopup()
        self:Center()
    end)
    ui.Create('HTML', function(self, p)
        self:SetPos(1, 31)
        self:SetSize(w - 1, h - 31)
        self:OpenURL('https://docs.google.com/document/d/1MX14aATrl-sQ3aGnTYIqy2juUgMBznU1EcsKNTJgQjk/edit?usp=sharing')
        self.Paint = function(self, w, h)
            draw.RoundedBox(0, 0, 0, w, h, Color(255, 255, 255))
        end
    end, fr)
end):SetHelp('Открыть правила сервера'):AddAlias('rules')

if SERVER then
    hook.Add('PhysgunPickup', 'ba.PhysgunPickup.PlayerPhysgun', function(pl, ent)
        if IsValid(ent) and ent:IsPlayer() and pl:HasAccess('M') and ba.ranks.CanTarget(pl, ent) and ba.canAdmin(pl) then
            ent:SetMoveType(MOVETYPE_NOCLIP)
            ent:SetBVar('PrePhysFrozen', ent:IsFrozen())
            ent:Freeze(true)
            pl:SetBVar('HoldingPlayer', ent)
            return true
        end
    end)
    hook.Add('PhysgunDrop', 'ba.PhysgunDrop.PlayerPhysgun', function(pl, ent)
        if IsValid(ent) and ent:IsPlayer() then
            ent:Freeze(ent:GetBVar('PrePhysFrozen') or false)
            ent:SetBVar('PrePhysFrozen', nil)
            ent:SetMoveType(MOVETYPE_WALK)
            timer.Simple(0.2, function()
                if IsValid(pl) then
                    pl:SetBVar('HoldingPlayer', nil)
                end
            end)
        end
    end)
    hook.Add('KeyRelease', 'ba.KeyRelease.PlayerPhysgun', function(pl, key)
        local held = pl:GetBVar('HoldingPlayer')
        if IsValid(held) and key == IN_ATTACK2 then
            pl:ConCommand('ba freeze ' .. held:SteamID())
        end
    end)
end

hook.Add('PlayerNoClip', 'ba.PlayerNoClip', function(pl, desiredState)
    if SERVER then
        if pl:Team() == TEAM_ADMIN then
            return true
        end
        -- head-admin и выше (флаг 'l') могут летать через adminmode без смены профессии
        if pl:GetBVar('adminmode') == true and (pl:HasAccess('l') or pl:IsRoot()) then
            return true
        end
        return false
    end
    return false
end)

ba.cmd.Create('cid'):RunOnClient(function(args)
    local ent = LocalPlayer():GetEyeTrace().Entity
    if IsValid(ent) and ent:IsPlayer() then
        LocalPlayer():ChatPrint('SteamID скопирован — ' .. ent:Nick() .. ' (' .. ent:SteamID() .. ')')
        SetClipboardText(ent:SteamID())
    else
        LocalPlayer():ChatPrint('Вы должны смотреть на игрока!')
    end
end):SetFlag('u'):SetHelp('copy steamid')

ba.cmd.Create('Go', function(pl, args)
    local ent = pl:GetEyeTrace().Entity
    local owner = IsValid(ent) and (ent:CPPIGetOwner() or ent.ItemOwner)
    if IsValid(ent) and IsValid(owner) then
        ba.notify(pl, term.Get('EntityOwnedBy'), pl:IsAdmin() and owner or owner:NameID())
    else
        ba.notify_err(pl, term.Get('EntityNoOwner'))
    end
end):SetHelp('Узнать владельца пропа')

if SERVER then
    util.AddNetworkString('ba.Lookup')
end

local fr

ba.cmd.Create('info', function(pl, args)
    local sid = ba.InfoTo64(args.steamid)
    if not sid or sid == '' then return end
    local db = ba.data.GetDB()
    local target = player.GetBySteamID64(sid)
    local q = string.format("SELECT user.name, user.playtime, user.lastseen, user.firstjoined, rank.rank FROM ba_users AS user LEFT JOIN ba_ranks rank ON rank.steamid = user.steamid WHERE user.steamid = '%s' LIMIT 1", db:escape(sid))
    db:query(q, function(data)
        if not IsValid(pl) then return end
        if not data or not data[1] or not data[1].name then
            net.Start('ba.Lookup')
            net.WriteString(util.TableToJSON({error = 'Игрок не найден'}))
            net.Send(pl)
            return
        end
        local row = data[1]
        db:query(string.format("SELECT COUNT(*) as warn_count FROM ba_warns WHERE steamid = '%s'", db:escape(sid)), function(wdata)
            local warn_count = tonumber(wdata and wdata[1] and wdata[1].warn_count) or 0
            local total_seconds = IsValid(target) and target:GetPlayTime() or tonumber(row.playtime) or 0
            local hours = math.floor(total_seconds / 3600)
            local minutes = math.floor((total_seconds % 3600) / 60)
            local seconds = math.floor(total_seconds % 60)
            local formattedTime = string.format("%02dч %02dм %02dс", hours, minutes, seconds)
            local rankName = 'Игрок'
            if ba.ranks and row.rank then
                local rankObj = ba.ranks.Get(tonumber(row.rank))
                if rankObj then rankName = rankObj:GetName() end
            end
            local tbl = {
                name = IsValid(target) and target:Name() or row.name,
                stm = util.SteamIDFrom64(sid),
                group = rankName,
                time = formattedTime,
                warns = warn_count,
                online = IsValid(target)
            }
            if not IsValid(target) and row.lastseen then
                tbl.lastseen = os.date("%d/%m/%Y", row.lastseen)
            end
            if row.firstjoined then
                tbl.firstjoined = os.date("%d/%m/%Y", row.firstjoined)
            end
            net.Start('ba.Lookup')
            net.WriteString(util.TableToJSON(tbl))
            net.Send(pl)
        end)
    end)
end):AddParam('player_steamid', 'steamid'):SetFlag('u'):SetHelp('Показывает информацию об игроке (онлайн/оффлайн)\n/info <Ник/SteamID>'):AddAlias('U'):RunOnClient(function()
    net.Receive('ba.Lookup', function()
        local columns = util.JSONToTable(net.ReadString())
        if columns.error then
            LocalPlayer():ChatPrint(columns.error)
            return
        end
        if IsValid(fr) then fr:Remove() end
        local title = 'Информация об игроке'
        if columns.online == false then title = title .. ' (оффлайн)' end
        local frameH = 230
        local extraLines = 0
        if columns.lastseen then extraLines = extraLines + 1 end
        if columns.firstjoined then extraLines = extraLines + 1 end
        frameH = frameH + (extraLines * 21)
        fr = ui.Create('ui_frame', function(self)
            self:SetSize(428, frameH)
            self:SetTitle(title)
            self:Center()
            self:MakePopup()
        end)
        local info = ui.Create('ui_scrollpanel', function(self) self:Dock(FILL) end, fr)
        local ppanel = ui.Create('ui_panel', info)
        ppanel:SetSize(fr:GetWide(), fr:GetTall() - 35)
        local date = os.date("%H:%M:%S - %d/%m/%Y")
        local yPos = 5
        local function addRow(iconImg, label, y)
            ui.Create('DImage', function(self)
                self:SetPos(5, y + 3)
                self:SetImage(iconImg)
                self:SetSize(16, 16)
            end, ppanel)
            ui.Label(label, 'ui.22', 25, y, ppanel)
        end
        addRow('icon16/user.png', 'Ник: ' .. columns.name, yPos); yPos = yPos + 21
        addRow('icon16/user_edit.png', 'SteamID: ' .. columns.stm, yPos); yPos = yPos + 21
        addRow('icon16/shield.png', 'Привилегия: ' .. columns.group, yPos); yPos = yPos + 21
        addRow('icon16/time.png', 'Наигранное время: ' .. columns.time, yPos); yPos = yPos + 21
        addRow('icon16/clock.png', 'Дата: ' .. date, yPos); yPos = yPos + 21
        addRow('icon16/error.png', 'Варны: ' .. (columns.warns or 0) .. '/5', yPos); yPos = yPos + 21
        if columns.lastseen then
            addRow('icon16/disconnect.png', 'Последний раз был: ' .. columns.lastseen, yPos); yPos = yPos + 21
        end
        if columns.firstjoined then
            addRow('icon16/calendar.png', 'Начал играть: ' .. columns.firstjoined, yPos); yPos = yPos + 21
        end
        local btnY = yPos + 5
        local line = columns.name .. ' (' .. columns.stm .. ')'
        ui.Create('DButton', function(self)
            self:SetSize(168, 27); self:SetPos(0, btnY); self:SetText('Скопировать SteamID')
            self.DoClick = function()
                SetClipboardText(columns.stm)
                LocalPlayer():ChatPrint('Скопирован STEAMID — ' .. line)
            end
        end, ppanel)
        ui.Create('DButton', function(self)
            self:SetSize(246, 27); self:SetPos(171, btnY); self:SetText('Скопировать профиль')
            self.DoClick = function()
                local sid64 = util.SteamIDTo64(columns.stm) or ''
                SetClipboardText('https://steamcommunity.com/profiles/' .. sid64)
                LocalPlayer():ChatPrint('Скопирована ссылка на профиль')
            end
        end, ppanel)
        ui.Create('DButton', function(self)
            self:SetSize(417, 27); self:SetPos(0, btnY + 30); self:SetText('Скопировать всё')
            self.DoClick = function()
                SetClipboardText(line)
                LocalPlayer():ChatPrint('Скопировано — ' .. line)
            end
        end, ppanel)
    end)
end)

local white = Color(200,200,200)
ba.cmd.Create('Who', function(pl, args)
    ba.notify(pl, term.Get('SeeConsole'))
end):RunOnClient(function(args)
    MsgC(white, '--------------------------------------------------------\n')
    MsgC(white, '          SteamID      |      Name      |      Rank\n')
    MsgC(white, '--------------------------------------------------------\n')
    for k, v in ipairs(player.GetAll()) do
        local id = v:SteamID()
        local nick = v:Name()
        local text = string.format("%s%s %s%s ", id, string.rep(" ", math.max(0, 22 - id:len())), nick, string.rep(" ", math.max(0, 20 - nick:len())))
        text = text .. v:GetRank()
        MsgC(white, text .. '\n')
    end
end):SetHelp('Показывает информацию о всех игроках.')

ba.cmd.Create("qmenu", function(pl, args)
    pl:SendLua('OpenGiveWeaponPlus()')
end):SetFlag('u'):SetHelp('Доступ к qMenu')

ba.cmd.Create("qmenuprem", function(pl, args)
    pl:SendLua('OpenGiveWeaponPremium()')
end):SetFlag('u'):SetHelp('Доступ к qMenuPremium')

ba.cmd.Create("qmenuplus", function(pl, args)
    pl:SendLua('OpenGiveWeaponPremium()')
end):SetFlag('u'):SetHelp('Доступ к qMenuPlus')

if CLIENT then
    local qmenuPlusWeapons = {
        ["swb_357_a"] = true, ["blink"] = true, ["m9k_m4a1_sopmod"] = true,
        ["super_pistol"] = true, ["weapon_pig"] = true, ["slappers"] = true,
        ["stungun"] = true, ["weapon_c4"] = true, ["awp_asiimov"] = true,
        ["ryry_m9k_ak12"] = true, ["weapon_hack_phone"] = true,
        ["weapon_slam"] = true, ["weapon_frag"] = true,
    }
    local qmenuPremWeapons = {
        ["swb_357_a"] = true, ["blink"] = true, ["m9k_m4a1_sopmod"] = true,
        ["super_pistol"] = true, ["weapon_pig"] = true, ["slappers"] = true,
        ["stungun"] = true, ["weapon_c4"] = true, ["awp_asiimov"] = true,
        ["ryry_m9k_ak12"] = true, ["weapon_hack_phone"] = true,
        ["weapon_slam"] = true, ["weapon_frag"] = true,
        ["wiz_bloodhound"] = true, ["wiz_brick_blast"] = true,
        ["wiz_dying_neutron_star"] = true, ["wiz_lightning_caller"] = true,
        ["wiz_wizard_pistol"] = true, ["wiz_wizard_shotgun"] = true,
        ["swep_vmaxgun"] = true, ["vessel"] = true, ["tfa_ins2_rpg7_scoped"] = true,
        ["durkasl_baton"] = true, ["m9k_exile"] = true, ["m9k_minigun"] = true,
        ["weapon_vape_blueberry"] = true, ["weapon_vape_apple"] = true,
        ["weapon_vape_doshik"] = true, ["weapon_vape_grapery"] = true,
        ["weapon_cigarette_camel"] = true,
    }
    local function hasQmenuAccess(ply)
        return ply:IsRoot() or ply:HasAccess('d') or ply:HasAccess('e') or ply:GetNWBool('QmenuAccess', false) or ply:GetNWBool('QmenuPlusAccess', false) or (ply.HasPurchase and (ply:HasPurchase('qmenu') or ply:HasPurchase('qmenuplus')))
    end
    local function hasQmenuPlusAccess(ply)
        return ply:IsRoot() or ply:HasAccess('d') or ply:HasAccess('e') or ply:GetNWBool('QmenuPlusAccess', false) or (ply.HasPurchase and ply:HasPurchase('qmenuplus'))
    end
    function OpenGiveWeaponPlus()
        if not hasQmenuAccess(LocalPlayer()) then
            rp.Notify(NOTIFY_ERROR, 'Приобретите QMenu в Донате чтобы получить доступ!')
            return
        end
        if IsValid(giveframe) then giveframe:Remove() end
        giveframe = ui.Create("ui_frame")
        giveframe:SetSize(350, 400); giveframe:Center()
        giveframe:SetTitle("ARIZONA | QMenu"); giveframe:MakePopup()
        local scroll = vgui.Create("DScrollPanel", giveframe); scroll:Dock(FILL)
        for k, v in pairs(list.Get("Weapon")) do
            if qmenuPlusWeapons[k] then
                local wep = scroll:Add("ui_button"); wep:Dock(TOP); wep:DockMargin(0,3,0,0)
                wep:SetText(v.PrintName or k)
                wep.DoClick = function()
                    net.Start("GiveWeaponsPlus_BA")
                    net.WriteString(k); net.WriteString(v.PrintName or k)
                    net.SendToServer()
                end
            end
        end
    end
    function OpenGiveWeaponPremium()
        if not hasQmenuPlusAccess(LocalPlayer()) then
            rp.Notify(NOTIFY_ERROR, 'Приобретите QMenu Plus в Донате чтобы получить доступ!')
            return
        end
        if IsValid(giveframe) then giveframe:Remove() end
        giveframe = ui.Create("ui_frame")
        giveframe:SetSize(350, 400); giveframe:Center()
        giveframe:SetTitle("ARIZONA | QMenu Plus"); giveframe:MakePopup()
        local scroll = vgui.Create("DScrollPanel", giveframe); scroll:Dock(FILL)
        for k, v in pairs(list.Get("Weapon")) do
            if qmenuPremWeapons[k] then
                local wep = scroll:Add("ui_button"); wep:Dock(TOP); wep:DockMargin(0,3,0,0)
                wep:SetText(v.PrintName or k)
                wep.DoClick = function()
                    net.Start("GiveWeaponsPrem_BA")
                    net.WriteString(k); net.WriteString(v.PrintName or k)
                    net.SendToServer()
                end
            end
        end
    end
end

if SERVER then
    util.AddNetworkString("GiveWeaponsPlus_BA")
    util.AddNetworkString("GiveWeaponsPrem_BA")
    local function hasQmenuAccess(ply)
        return ply:IsRoot() or ply:HasAccess('d') or ply:HasAccess('e') or ply:GetNWBool('QmenuAccess', false) or ply:GetNWBool('QmenuPlusAccess', false) or (ply.HasPurchase and (ply:HasPurchase('qmenu') or ply:HasPurchase('qmenuplus')))
    end
    local function hasQmenuPlusAccess(ply)
        return ply:IsRoot() or ply:HasAccess('d') or ply:HasAccess('e') or ply:GetNWBool('QmenuPlusAccess', false) or (ply.HasPurchase and ply:HasPurchase('qmenuplus'))
    end
    local svQmenuPlusWeapons = {
        ["swb_357_a"] = true, ["blink"] = true, ["m9k_m4a1_sopmod"] = true,
        ["super_pistol"] = true, ["weapon_pig"] = true, ["slappers"] = true,
        ["stungun"] = true, ["weapon_c4"] = true, ["awp_asiimov"] = true,
        ["ryry_m9k_ak12"] = true, ["weapon_hack_phone"] = true,
        ["weapon_slam"] = true, ["weapon_frag"] = true,
    }
    local svQmenuPremWeapons = {
        ["swb_357_a"] = true, ["blink"] = true, ["m9k_m4a1_sopmod"] = true,
        ["super_pistol"] = true, ["weapon_pig"] = true, ["slappers"] = true,
        ["stungun"] = true, ["weapon_c4"] = true, ["awp_asiimov"] = true,
        ["ryry_m9k_ak12"] = true, ["weapon_hack_phone"] = true,
        ["weapon_slam"] = true, ["weapon_frag"] = true,
        ["wiz_bloodhound"] = true, ["wiz_brick_blast"] = true,
        ["wiz_dying_neutron_star"] = true, ["wiz_lightning_caller"] = true,
        ["wiz_wizard_pistol"] = true, ["wiz_wizard_shotgun"] = true,
        ["swep_vmaxgun"] = true, ["vessel"] = true, ["tfa_ins2_rpg7_scoped"] = true,
        ["durkasl_baton"] = true, ["m9k_exile"] = true, ["m9k_minigun"] = true,
        ["weapon_vape_blueberry"] = true, ["weapon_vape_apple"] = true,
        ["weapon_vape_doshik"] = true, ["weapon_vape_grapery"] = true,
        ["weapon_cigarette_camel"] = true,
    }
    net.Receive("GiveWeaponsPlus_BA", function(len, pl)
        if not IsValid(pl) then return end
        if not hasQmenuAccess(pl) then return end
        local wep = net.ReadString()
        net.ReadString()
        if not svQmenuPlusWeapons[wep] then return end
        if pl:HasWeapon(wep) then return end
        pl:Give(wep, true)
    end)
    net.Receive("GiveWeaponsPrem_BA", function(len, pl)
        if not IsValid(pl) then return end
        if not hasQmenuPlusAccess(pl) then return end
        local wep = net.ReadString()
        net.ReadString()
        if not svQmenuPremWeapons[wep] then return end
        if pl:HasWeapon(wep) then return end
        pl:Give(wep, true)
    end)
end