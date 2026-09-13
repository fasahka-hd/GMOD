if SERVER then return end

local BP = {}
BP.BASE_W = 1921
BP.BASE_H = 1080
BP.MAX_LEVEL = 40
BP.Page = 0
BP.LevelScroll = 0
BP.TargetLevelScroll = 0
BP.Frame = nil
BP.LeftButton = nil
BP.RightButton = nil
BP.Data = {level = 1, exp = 0, premium = false, tasks = {}, progress = {}}

local COL_CARD = Color(42, 43, 46)
local COL_GRAD_R = 218
local COL_GRAD_G = 62
local COL_GRAD_B = 68
local COL_LINE = Color(87, 68, 72)
local COL_TASK = Color(159, 159, 159, 64)
local WHITE = Color(255, 255, 255)
local BG_DIM = Color(0, 0, 0, 145)
local GREEN = Color(80, 200, 120)

local mats = {
    bg = Material('f4/battlepass/bg.png', 'smooth mips'),
    header = Material('lvlsys/azlogolvl.png', 'smooth mips'),
    level1 = Material('lvlsys/1lvl.png', 'smooth mips'),
    level10 = Material('lvlsys/1lvl.png', 'smooth mips'),
    level20 = Material('lvlsys/2lvl.png', 'smooth mips'),
    level30 = Material('lvlsys/3lvl.png', 'smooth mips'),
    level40 = Material('lvlsys/4lvl.png', 'smooth mips'),
    money = Material('hud/dollar.png', 'smooth mips'),
    donate = Material('f4/az.png', 'smooth mips'),
}

local function X(v) return math.Round(v * ScrW() / BP.BASE_W) end
local function Y(v) return math.Round(v * ScrH() / BP.BASE_H) end
local function S(v) return math.Round(v * math.min(ScrW() / BP.BASE_W, ScrH() / BP.BASE_H)) end

local function MakeFonts()
    surface.CreateFont('BP.Text12', { font = 'Inter', size = S(12), weight = 700, extended = true, antialias = true })
    surface.CreateFont('BP.Text14', { font = 'Inter', size = S(14), weight = 600, extended = true, antialias = true })
    surface.CreateFont('BP.Text18', { font = 'Inter', size = S(18), weight = 500, extended = true, antialias = true })
    surface.CreateFont('BP.Text20', { font = 'Inter', size = S(20), weight = 500, extended = true, antialias = true })
    surface.CreateFont('BP.Bold20', { font = 'Inter', size = S(20), weight = 700, extended = true, antialias = true })
    surface.CreateFont('BP.Close', { font = 'Inter', size = S(34), weight = 800, extended = true, antialias = true })
    surface.CreateFont('BP.Arrow', { font = 'Inter', size = S(28), weight = 800, extended = true, antialias = true })
end

MakeFonts()
hook.Add('OnScreenSizeChanged', 'ArizonaRP.BattlePass.Fonts', MakeFonts)

local function DrawCard(x, y, w, h, r)
    draw.RoundedBox(r, x, y, w, h, COL_CARD)
    local rows = math.max(1, h)
    for i = 0, rows do
        local t = i / rows
        local a = math.floor(t * 26)
        if a > 0 then
            local inset = 0
            if i < r then
                local dy = r - i
                inset = r - math.sqrt(math.max(0, r * r - dy * dy))
            elseif i > h - r then
                local dy = i - (h - r)
                inset = r - math.sqrt(math.max(0, r * r - dy * dy))
            end
            surface.SetDrawColor(COL_GRAD_R, COL_GRAD_G, COL_GRAD_B, a)
            surface.DrawRect(x + inset, y + i, math.max(0, w - inset * 2), 1)
        end
    end
end

local function DrawImage(mat, x, y, w, h, fallback)
    if mat and not mat:IsError() then
        surface.SetMaterial(mat)
        surface.SetDrawColor(255, 255, 255)
        surface.DrawTexturedRect(x, y, w, h)
        return
    end
    surface.SetDrawColor(145, 22, 22, 145)
    surface.DrawRect(x, y, w, h)
    surface.SetDrawColor(255, 255, 255, 80)
    surface.DrawOutlinedRect(x, y, w, h, 1)
end

local function DrawHeaderIcon(x, y)
    if mats.header and not mats.header:IsError() then
        DrawImage(mats.header, x + X(28), y + Y(4), X(60), Y(59), '')
        return
    end
    surface.SetDrawColor(255, 136, 0)
    draw.NoTexture()
    surface.DrawPoly({{x=x,y=y},{x=x+X(100),y=y+Y(18)},{x=x+X(73),y=y+Y(99)},{x=x+X(11),y=y+Y(83)}})
    surface.SetDrawColor(255, 162, 96)
    surface.DrawPoly({{x=x+X(13),y=y+Y(10)},{x=x+X(86),y=y+Y(25)},{x=x+X(65),y=y+Y(85)},{x=x+X(21),y=y+Y(73)}})
end

local function DrawLevel(num, x, y)
    local size = X(36)
    surface.SetDrawColor(COL_LINE)
    surface.DrawRect(x, y, size, size)
    draw.SimpleText(tostring(num), 'BP.Bold20', x + size / 2, y + size / 2, WHITE, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
end

local function IsIconLevel(lvl)
    return lvl == 1 or lvl % 10 == 0
end

local function LevelMat(lvl)
    if lvl == 1 then return mats.level1 end
    if lvl == 10 then return mats.level10 end
    if lvl == 20 then return mats.level20 end
    if lvl == 30 then return mats.level30 end
    if lvl == 40 then return mats.level40 end
    return mats.money
end

local function IsDonateLevel(lvl)
    return lvl == 11 or lvl == 15 or lvl == 21 or lvl == 25 or lvl == 29 or lvl == 35 or lvl == 39
end

local function GetRewardText(lvl)
    if lvl == 1 then return "Старт" end
    if lvl == 10 then return "1 LVL" end
    if lvl == 20 then return "2 LVL" end
    if lvl == 30 then return "3 LVL" end
    if lvl == 40 then return "4 LVL" end
    if IsDonateLevel(lvl) then return "200₽" end
    local m = { [2]="10к", [3]="20к", [4]="30к", [5]="40к", [6]="50к", [7]="65к", [8]="80к", [9]="100к" }
    if m[lvl] then return "$" .. m[lvl] end
    local val = math.min(250, 100 + (lvl - 9) * 10)
    return "$" .. val .. "к"
end

local function DrawReward(lvl, centerX, y)
    local text = GetRewardText(lvl)
    draw.SimpleText(text, 'BP.Text14', centerX, y - Y(18), IsDonateLevel(lvl) and Color(255, 210, 60) or WHITE, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    if IsIconLevel(lvl) then
        local size = X(48)
        DrawImage(LevelMat(lvl), centerX - size / 2, y, size, size, '')
    elseif IsDonateLevel(lvl) then
        local size = X(32)
        DrawImage(mats.donate or mats.money, centerX - size / 2, y + X(6), size, size, '')
    else
        local size = X(26)
        DrawImage(mats.money, centerX - size / 2, y + X(8), size, size, '')
    end
    local curLvl = LocalPlayer():GetNWInt("BP_Level", BP.Data.level or 1)
    if lvl > 1 and lvl <= curLvl then
        if BP.Data.claimed and BP.Data.claimed[lvl] then
            local bw, bh = X(88), Y(22)
            draw.RoundedBox(S(6), centerX - bw / 2, y + Y(33), bw, bh, Color(45, 110, 65, 190))
            draw.SimpleText("✓ ПОЛУЧЕНО", 'BP.Text12', centerX, y + Y(44), Color(180, 255, 200), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        else
            local bw, bh = X(66), Y(22)
            draw.RoundedBox(S(6), centerX - bw / 2, y + Y(33), bw, bh, GREEN)
            draw.SimpleText("ВЗЯТЬ", 'BP.Text14', centerX, y + Y(44), WHITE, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        end
    end
end

local function DrawLevels(scroll)
    scroll = math.Round(scroll)
    local clipX = X(160)
    local clipY = Y(390)
    local clipW = X(1625)
    local clipH = Y(145)

    render.SetScissorRect(clipX, clipY, clipX + clipW, clipY + clipH, true)
    surface.SetDrawColor(COL_LINE)
    surface.DrawRect(math.Round(X(209) - scroll), Y(500) - math.max(1, Y(2)), X((BP.MAX_LEVEL - 1) * 144 + 1572), math.max(1, Y(5)))

    for i = 1, BP.MAX_LEVEL do
        local lx = math.Round(X(209 + (i - 1) * 144) - scroll)
        DrawLevel(i, lx, Y(482))
        local centerX = math.Round(X(227 + (i - 1) * 144) - scroll)
        DrawReward(i, centerX, Y(425))
    end
    render.SetScissorRect(0, 0, 0, 0, false)
end

local function DrawWrappedText(text, font, x, y, maxWidth, color, lineHeight)
    surface.SetFont(font)
    local words = string.Explode(" ", text)
    local lines = {}
    local current = ""

    for _, word in ipairs(words) do
        local test = current == "" and word or (current .. " " .. word)
        if surface.GetTextSize(test) <= maxWidth then
            current = test
        else
            if current ~= "" then table.insert(lines, current) end
            current = word
        end
    end
    if current ~= "" then table.insert(lines, current) end

    for i, line in ipairs(lines) do
        draw.SimpleText(line, font, x, y + (i-1) * (lineHeight or 22), color or WHITE)
    end
end

local function DrawTask(x, y, taskID)
    local task = BP.Data.tasks[taskID]
    if not task then return end

    local prog = BP.Data.progress[taskID] or 0
    local done = BP.Data.progress[taskID .. "_done"] or false

    local w = X(370)
    local h = Y(56)

    draw.RoundedBox(S(8), x, y, w, h, done and Color(55, 115, 65, 135) or COL_TASK)

    local title = task.desc
    DrawWrappedText(title, 'BP.Text18', x + X(8), y + Y(3), w - X(16), WHITE, 12)

    local barY = y + Y(28)
    local barW = w - X(16)
    surface.SetDrawColor(45, 45, 45)
    surface.DrawRect(x + X(8), barY, barW, Y(5))

    surface.SetDrawColor(done and GREEN or Color(218, 62, 68))
    surface.DrawRect(x + X(8), barY, barW * math.min(1, prog / task.target), Y(5))

    draw.SimpleText(prog .. "/" .. task.target, 'BP.Text18', x + X(8), barY + Y(10), WHITE)
end

local function DrawTasks()
    local col = 0
    local row = 0
    local ids = {}
    for id in pairs(BP.Data.tasks) do table.insert(ids, id) end
    table.sort(ids)

    for i = 1, math.min(12, #ids) do
        DrawTask(X(185 + col * 385), Y(560 + row * 66), ids[i])
        col = col + 1
        if col >= 4 then col, row = 0, row + 1 end
    end
end

local function MaxPage()
    return math.max(0, math.ceil((BP.MAX_LEVEL - 11) / 4))
end

local function SetPage(page)
    page = math.Clamp(page, 0, MaxPage())
    if page == BP.Page then return end
    BP.Page = page
    BP.TargetLevelScroll = X(BP.Page * 4 * 144)
end

local function MovePage(delta)
    SetPage(BP.Page + delta)
end

local function DrawBattlePass()
    if mats.bg and not mats.bg:IsError() then
        surface.SetMaterial(mats.bg)
        surface.SetDrawColor(255, 255, 255)
        surface.DrawTexturedRect(0, 0, ScrW(), ScrH())
    else
        surface.SetDrawColor(BG_DIM)
        surface.DrawRect(0, 0, ScrW(), ScrH())
    end

    local cardX = X(163)
    local cardY = Y(287)
    local cardW = X(1618)
    local cardH = Y(505)

    DrawCard(cardX, cardY, cardW, cardH, S(30))
    DrawHeaderIcon(X(177), Y(307))

    local desc = "Arizona LVL’S - Это уникальная система уровней, за повышения уровней вы будете получать награды, титулы, бонусы! За каждое выполненое задание вы получите 1exp. Для повышения уровня требуется 10exp"
    DrawWrappedText(desc, 'BP.Text20', X(301), Y(311), X(555), WHITE, 24)

    local rightX = cardX + cardW - X(460)
    local lvl = LocalPlayer():GetNWInt("BP_Level", BP.Data.level or 1)
    local exp = BP.Data.exp or 0
    local premium = BP.Data.premium or false

    draw.SimpleText("Уровень: " .. lvl .. " / " .. BP.MAX_LEVEL, 'BP.Bold20', rightX, Y(320), WHITE)
    draw.SimpleText("EXP: " .. exp .. " / 10" .. (premium and "  (Premium x2)" or ""), 'BP.Text20', rightX, Y(345), WHITE)

    DrawLevels(BP.LevelScroll)
    DrawTasks()
end

local function RefreshButtons()
    if IsValid(BP.LeftButton) then BP.LeftButton:SetVisible(BP.Page > 0) end
    if IsValid(BP.RightButton) then BP.RightButton:SetVisible(BP.Page < MaxPage()) end
end

local function ArrowPaint(self, w, h, txt)
    draw.RoundedBox(S(8), 0, 0, w, h, self:IsHovered() and Color(159, 159, 159, 95) or Color(159, 159, 159, 55))
    draw.SimpleText(txt, 'BP.Arrow', w / 2, h / 2 - S(1), WHITE, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
end

function BP.Open()
    if IsValid(BP.Frame) then BP.Frame:Remove() end

    BP.Page = 0
    BP.LevelScroll = 0
    BP.TargetLevelScroll = 0

    local fr = vgui.Create('EditablePanel')
    BP.Frame = fr
    fr:SetSize(ScrW(), ScrH())
    fr:MakePopup()
    fr.Paint = DrawBattlePass

    fr.Think = function()
        BP.LevelScroll = Lerp(FrameTime() * 9, BP.LevelScroll, BP.TargetLevelScroll)
        if math.abs(BP.LevelScroll - BP.TargetLevelScroll) < 0.5 then BP.LevelScroll = BP.TargetLevelScroll end
        RefreshButtons()
    end

    fr.OnKeyCodePressed = function(_, key)
        if key == KEY_ESCAPE or key == KEY_F4 then
            gui.HideGameUI()
            if IsValid(fr) then fr:Remove() end
            return true
        end
    end

    fr.OnMousePressed = function(_, code)
        if code ~= MOUSE_LEFT then return end
        local mx, my = fr:CursorPos()
        if my >= Y(390) and my <= Y(520) then
            local curLvl = LocalPlayer():GetNWInt("BP_Level", BP.Data.level or 1)
            for i = 2, curLvl do
                if not (BP.Data.claimed and BP.Data.claimed[i]) then
                    local centerX = math.Round(X(227 + (i - 1) * 144) - BP.LevelScroll)
                    if math.abs(mx - centerX) <= X(50) then
                        net.Start("BP_ClaimReward")
                            net.WriteUInt(i, 8)
                        net.SendToServer()
                        return
                    end
                end
            end
        end
    end

    local close = fr:Add('DButton')
    close:SetSize(S(48), S(48))
    close:SetPos(ScrW() - S(78), S(38))
    close:SetText('')
    close.Paint = function(self, w, h)
        draw.RoundedBox(S(8), 0, 0, w, h, self:IsHovered() and Color(255,255,255,90) or Color(255,255,255,60))
        draw.SimpleText('×', 'BP.Close', w / 2, h / 2, WHITE, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end
    close.DoClick = function() if IsValid(fr) then fr:Remove() end end

    local arrowSize = S(34)
    local cardX = X(163)
    local cardW = X(1618)
    local arrowY = math.Round(Y(483))

    local claimAll = fr:Add('DButton')
    claimAll:SetSize(X(200), Y(40))
    claimAll:SetPos(math.Round(cardX + cardW - X(220)), Y(314))
    claimAll:SetText('')
    claimAll.Paint = function(self, w, h)
        local count = 0
        local curLvl = LocalPlayer():GetNWInt("BP_Level", BP.Data.level or 1)
        for l = 2, curLvl do
            if not (BP.Data.claimed and BP.Data.claimed[l]) then count = count + 1 end
        end
        local bg = count > 0 and (self:IsHovered() and Color(90, 215, 130) or GREEN) or Color(159, 159, 159, 46)
        draw.RoundedBox(S(8), 0, 0, w, h, bg)
        local txt = count > 0 and ("Забрать все (" .. count .. ")") or "Всё получено"
        draw.SimpleText(txt, 'BP.Text18', w / 2, h / 2, WHITE, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end
    claimAll.DoClick = function()
        local count = 0
        local curLvl = LocalPlayer():GetNWInt("BP_Level", BP.Data.level or 1)
        for l = 2, curLvl do
            if not (BP.Data.claimed and BP.Data.claimed[l]) then count = count + 1 end
        end
        if count > 0 then
            net.Start("BP_ClaimAll")
            net.SendToServer()
        end
    end

    BP.LeftButton = fr:Add('DButton')
    BP.LeftButton:SetSize(arrowSize, arrowSize)
    BP.LeftButton:SetPos(math.Round(cardX + S(16)), arrowY)
    BP.LeftButton:SetText('')
    BP.LeftButton.Paint = function(self, w, h) ArrowPaint(self, w, h, '‹') end
    BP.LeftButton.DoClick = function() MovePage(-1) end

    BP.RightButton = fr:Add('DButton')
    BP.RightButton:SetSize(arrowSize, arrowSize)
    BP.RightButton:SetPos(math.Round(cardX + cardW - arrowSize - S(16)), arrowY)
    BP.RightButton:SetText('')
    BP.RightButton.Paint = function(self, w, h) ArrowPaint(self, w, h, '›') end
    BP.RightButton.DoClick = function() MovePage(1) end

    RefreshButtons()

    net.Start("BP_RequestData")
    net.SendToServer()
end

net.Receive("BP_SendData", function()
    BP.Data.level = net.ReadUInt(8)
    BP.Data.exp = net.ReadUInt(16)
    BP.Data.premium = net.ReadBool()

    BP.Data.tasks = {}
    BP.Data.progress = {}

    local count = net.ReadUInt(8)
    for i = 1, count do
        local id = net.ReadUInt(8)
        local name = net.ReadString()
        local desc = net.ReadString()
        local target = net.ReadUInt(16)
        local prog = net.ReadUInt(16)
        local done = net.ReadBool()
        BP.Data.tasks[id] = {name = name, desc = desc, target = target}
        BP.Data.progress[id] = prog
        BP.Data.progress[id .. "_done"] = done
    end
    BP.Data.claimed = {[1] = true}
    for l = 1, BP.MAX_LEVEL do
        BP.Data.claimed[l] = net.ReadBool()
    end
end)

net.Receive("BP_LevelUp", function()
    local newLvl = net.ReadUInt(8)
    BP.Data.level = newLvl
    BP.Data.claimed = BP.Data.claimed or {[1] = true}
    for l = 1, BP.MAX_LEVEL do
        BP.Data.claimed[l] = (l <= newLvl)
    end
end)

net.Receive("BP_ClaimSuccess", function()
    local lvl = net.ReadUInt(8)
    BP.Data.claimed = BP.Data.claimed or {[1] = true}
    if lvl == 0 then
        for l = 2, (BP.Data.level or 1) do
            BP.Data.claimed[l] = true
        end
    else
        BP.Data.claimed[lvl] = true
    end
end)

net.Receive("BP_OpenUI", function()
    BP.Open()
end)

concommand.Remove('battlepass')
concommand.Add('battlepass', BP.Open)