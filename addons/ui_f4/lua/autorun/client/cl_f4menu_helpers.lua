function s(y)
    local scrW, scrH = ScrW(), ScrH()
    return math.Round(y * math.min(scrW, scrH) / 1080)
end

function AddIcon(mat, x, y, w, h, c)
    surface.SetDrawColor(c)
    surface.SetMaterial(mat)
    surface.DrawTexturedRect(x, y, w, h)
end

function NewClose(pnl) if IsValid(pnl) then pnl:Remove() end end
function width(x) return s(x * 1920 / 1080) end
function height(y) return s(y) end
function GetJobModel(index)
    local job = rp.teams[index]
    if isstring(job.model) then return job.model end
    local idx = cvar.GetValue('TeamModel' .. job.name)
    if isnumber(idx) and util.IsValidModel(job.model[idx]) then return job.model[idx] end
    return job.model[1]
end

function SetJobModel(index, modelIndex)
    local job = rp.teams[index]
    cvar.SetValue('TeamModel' .. job.name, modelIndex)
end

hook.Add("Initialize", "F4PreloadJobModels", function()
    timer.Simple(8, function()
        if not rp or not rp.teams then return end
        for k, v in pairs(rp.teams) do
            local jm = GetJobModel(k)
            if isstring(jm) then
                util.PrecacheModel(jm)
            elseif istable(jm) then
                for _, m in ipairs(jm) do
                    if isstring(m) then util.PrecacheModel(m) end
                end
            end
        end
    end)
end)

C = {
    white      = Color(255,255,255),
    bg         = Color(42,43,46),
    bg_a       = Color(28,29,32,245),
    sidebar    = Color(33,34,37),
    card       = Color(159,159,159,46),
    card_h     = Color(159,159,159,80),
    card_s     = Color(159,159,159,120),
    inner      = Color(255,255,255,18),
    gray       = Color(150,150,150),
    gray_t     = Color(175,175,175),
    gray_l     = Color(210,210,210),
    green      = Color(60,210,95),
    blue       = Color(218,62,68),
    btn        = Color(217,217,217,46),
    discord    = Color(88,101,242,255),
    telegram   = Color(38,165,228,255),
    donate     = Color(214,158,18,255),
    donate_t   = Color(255,210,60),
    gold       = Color(255,191,0,46),
    gold_t     = Color(255,200,40),
    silver     = Color(200,200,200,46),
    silver_t   = Color(225,225,225),
    bronze     = Color(204,110,40,46),
    bronze_t   = Color(224,140,70),
    rules      = Color(22,22,22),
    red        = Color(218,62,68),
    black      = Color(0,0,0),
}

mats = {
    home     = Material('f4menu/128.png','smooth mips'),
    shop     = Material('f4/items.png','smooth mips'),
    jobs     = Material('f4/jobs.png','smooth mips'),
    cards    = Material('f4/cards.png','smooth mips'),
    wardrobe = Material('f4/wardrobe.png','smooth mips'),
    settings = Material('f4/settings.png','smooth mips'),
    deposit  = Material('f4/plus.png','smooth mips'),
    dmoney   = Material('f4/az.png','smooth mips'),
    lvl1     = Material('lvlsys/1lvl.png','smooth mips'),
    lvl2     = Material('lvlsys/2lvl.png','smooth mips'),
    lvl3     = Material('lvlsys/3lvl.png','smooth mips'),
    lvl4     = Material('lvlsys/4lvl.png','smooth mips'),
}

fr = nil
function makeScroll(scrl)
    scrl.Paint = nil
    local bar = scrl.VBar
    bar:SetWide(s(6))
    bar:SetHideButtons(true)
    bar.Paint = function(_,w,h) draw.RoundedBox(8,w*0.4,0,w*0.2,h,Color(255,255,255,15)) end
    bar.btnGrip.Paint = function(_,w,h) draw.RoundedBox(8,0,0,w,h,C.card_s) end
end

gradMat = Material('gui/gradient_up')
function drawGrad(x,y,w,h)
    surface.SetDrawColor(218,62,68,26)
    surface.SetMaterial(gradMat)
    surface.DrawTexturedRect(x,y,w,h)
end

function Card(parent)
    local p = parent:Add('Panel')
    p.Paint = function(_,w,h) draw.RoundedBox(s(12),0,0,w,h,C.card) end
    return p
end

navBtns = {}
function setActiveNav(idx)
    for i=1,#navBtns do if navBtns[i] then navBtns[i]._active=(i==idx) end end
end

contentPanel = nil
function clearContent()
    if IsValid(contentPanel) then contentPanel:Remove() end
end

function newContent(parent)
    clearContent()
    contentPanel = parent:Add('Panel')
    contentPanel:Dock(FILL)
    contentPanel:DockMargin(s(24),s(24),s(24),s(24))
    contentPanel.Paint = function() end
    return contentPanel
end
