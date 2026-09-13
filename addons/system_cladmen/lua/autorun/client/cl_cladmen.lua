CLADMEN = CLADMEN or {}
CLADMEN.Active = false
CLADMEN.DropsDone = 0
CLADMEN.DropsTotal = 0
CLADMEN.EndTime = 0

net.Receive("cladmen_order_start", function()
    CLADMEN.DropsTotal = net.ReadUInt(8)
    CLADMEN.EndTime = net.ReadFloat()
    CLADMEN.DropsDone = 0
    CLADMEN.Active = true
    surface.PlaySound("buttons/button15.wav")
end)

net.Receive("cladmen_order_update", function()
    CLADMEN.DropsDone = net.ReadUInt(8)
    CLADMEN.DropsTotal = net.ReadUInt(8)
    CLADMEN.EndTime = net.ReadFloat()
    CLADMEN.Active = true
end)

net.Receive("cladmen_order_end", function()
    local reason = net.ReadString()
    CLADMEN.Active = false
    if reason == "success" then
        surface.PlaySound("ambient/levels/canals/drip1.wav")
    elseif reason == "fail" then
        surface.PlaySound("buttons/button10.wav")
    end
end)

hook.Add("HUDPaint", "Cladmen_OrderHUD", function()
    if not CLADMEN.Active then return end
    local ply = LocalPlayer()
    if not ply:Alive() then return end
    local timeLeft = math.max(0, CLADMEN.EndTime - CurTime())
    if timeLeft <= 0 and CLADMEN.EndTime > 0 then
        CLADMEN.Active = false
        return
    end
    local w, h = 360, 100
    local x, y = 20, 20
    draw.RoundedBox(12, x, y, w, h, Color(15,15,15,220))
    draw.RoundedBox(12, x+2, y+2, w-4, h-4, Color(30,30,30,180))
    draw.SimpleText("ЗАКАЗ КЛАДМЕНА", "Trebuchet24", x + 20, y + 18, Color(220,220,220), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
    draw.SimpleText("Закладок: " .. CLADMEN.DropsDone .. " / " .. CLADMEN.DropsTotal, "DermaLarge", x + 20, y + 50, Color(255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
    local mins = math.floor(timeLeft / 60)
    local secs = math.floor(timeLeft % 60)
    local tcol = timeLeft < 60 and Color(255,80,80) or Color(255,255,255)
    draw.SimpleText(string.format("%02d:%02d", mins, secs), "DermaLarge", x + w - 20, y + 50, tcol, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
    local frac = CLADMEN.DropsTotal > 0 and (CLADMEN.DropsDone / CLADMEN.DropsTotal) or 0
    local barW = w - 40
    local barH = 14
    local barX = x + 20
    local barY = y + h - 28
    draw.RoundedBox(6, barX, barY, barW, barH, Color(50,50,50,220))
    draw.RoundedBox(6, barX, barY, barW * frac, barH, Color(80,255,100))
end)
hook.Add("HUDPaint", "Cladmen_WorldESP", function()
    local ply = LocalPlayer()
    if not IsValid(ply) then return end
    if CLADMEN.JobCheck and not CLADMEN.JobCheck(ply) then return end
    local function drawMarker(ent, txt, col)
        if not IsValid(ent) then return end
        local pos = ent:GetPos():ToScreen()
        if not pos.visible then return end
        surface.SetFont("DermaLarge")
        local tw, th = surface.GetTextSize(txt)
        local x = pos.x
        local y = pos.y
        draw.RoundedBox(4, x - tw/2 - 8, y - th/2 - 4, tw + 16, th + 8, Color(0,0,0,150))
        draw.SimpleText(txt, "DermaLarge", x, y, col, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        local dist = math.floor(ply:GetPos():Distance(ent:GetPos()) / 40)
        draw.SimpleText(dist .. " м", "Trebuchet24", x, y + th/2 + 6, col, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
    end
    for _, e in ipairs(ents.FindByClass("cladmen_drop")) do
        drawMarker(e, "! ЗАКЛАДКА", Color(220,30,30))
    end
    for _, e in ipairs(ents.FindByClass("cladmen_supply")) do
        drawMarker(e, "! ПОСЫЛКА", Color(255,200,50))
    end
end)

local activeProgress = nil
net.Receive("cladmen_progress", function()
    local ent = net.ReadEntity()
    local time = net.ReadFloat()
    local mode = net.ReadString()
    if mode == "cancel" then
        activeProgress = nil
        return
    end
    if IsValid(ent) and time > 0 then
        activeProgress = {ent = ent, endTime = CurTime() + time, startTime = CurTime(), total = time, mode = mode}
    end
end)

hook.Add("HUDPaint", "Cladmen_SupplyProgress", function()
    if not activeProgress then return end
    if not IsValid(activeProgress.ent) or CurTime() > activeProgress.endTime then
        activeProgress = nil
        return
    end
    local frac = 1 - ((activeProgress.endTime - CurTime()) / activeProgress.total)
    frac = math.Clamp(frac, 0, 1)
    local w, h = 400, 30
    local x, y = ScrW()/2 - w/2, ScrH()/2 + 80
    draw.RoundedBox(8, x, y, w, h, Color(0,0,0,180))
    draw.RoundedBox(8, x+2, y+2, (w-4)*frac, h-4, CLADMEN.ColorMain or Color(130,70,200))
    local txt = activeProgress.mode == "supply" and "Подбираю посылку..." or activeProgress.mode == "drop" and "Устанавливаю закладку..." or "Использую..."
    draw.SimpleText(txt, "Trebuchet24", x + w/2, y + h/2, Color(255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

    draw.SimpleText("Отпустите E для отмены", "Default", x + w/2, y + h + 4, Color(200,200,200), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
end)