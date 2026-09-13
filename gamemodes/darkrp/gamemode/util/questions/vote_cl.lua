local VoteVGUI = {}
local QuestionVGUI = {}
local PanelNum = 0

local function s(y)
    local scrW, scrH = ScrW(), ScrH()
    return math.Round(y * math.min(scrW, scrH) / 1080)
end

local TOP_Y = 600

local function CreateDemoteFonts()
    surface.CreateFont("demote.title", { font = "Inter Bold", size = s(16), weight = 600, antialias = true, extended = true })
    surface.CreateFont("demote.sub",   { font = "Inter Bold", size = s(12), weight = 500, antialias = true, extended = true })
    surface.CreateFont("demote.timer", { font = "Inter Bold", size = s(12), weight = 500, antialias = true, extended = true })
    surface.CreateFont("demote.desc",  { font = "Inter Bold", size = s(14), weight = 600, antialias = true, extended = true })
    surface.CreateFont("demote.btn",   { font = "Inter Bold", size = s(14), weight = 500, antialias = true, extended = true })
end
CreateDemoteFonts()
hook.Add("OnScreenSizeChanged", "Demote.RecreateFonts", CreateDemoteFonts)

local COL = {
    bg       = Color(42, 43, 46),
    accent   = Color(218, 135, 62),
    gradTop  = Color(218, 135, 62, 0),
    gradBot  = Color(218, 135, 62, 26),
    track    = Color(217, 217, 217, 64),
    btnBg    = Color(255, 255, 255, 64),
    white    = Color(255, 255, 255),
    white70  = Color(255, 255, 255, 178),
}

local function DrawVGradient(x, y, w, h, cTop, cBot, steps, alphaMul)
    steps = steps or 28
    alphaMul = alphaMul or 1
    local sh = h / steps
    for i = 0, steps - 1 do
        local f = i / (steps - 1)
        surface.SetDrawColor(
            Lerp(f, cTop.r, cBot.r),
            Lerp(f, cTop.g, cBot.g),
            Lerp(f, cTop.b, cBot.b),
            Lerp(f, cTop.a, cBot.a) * alphaMul
        )
        surface.DrawRect(x, y + i * sh, w, sh + 1)
    end
end

local function WrapText(text, font, maxw, maxLines)
    text = string.gsub(text, "[\r\n]+", " ")
    surface.SetFont(font)
    local lines, line = {}, ""
    for _, word in ipairs(string.Explode(" ", text)) do
        local test = (line == "") and word or (line .. " " .. word)
        local tw = surface.GetTextSize(test)
        if tw > maxw and line ~= "" then
            lines[#lines + 1] = line
            line = word
        else
            line = test
        end
    end
    if line ~= "" then lines[#lines + 1] = line end

    if maxLines and #lines > maxLines then
        local cut = {}
        for i = 1, maxLines do cut[i] = lines[i] end
        cut[maxLines] = string.sub(cut[maxLines], 1, #cut[maxLines] - 2) .. "…"
        return cut
    end
    return lines
end

local function ReflowVotes()
    local i = 0
    for _, v in SortedPairs(VoteVGUI) do
        if IsValid(v) then
            v:MoveTo(ScrW() - v:GetWide() - s(10), s(TOP_Y) + i * (v:GetTall() + s(10)), 0.45, 0, 0.4)
            i = i + 1
        end
    end
end

local function OpenVotePanel(question, voteid, timeleft, steamid)
    if not IsValid(LocalPlayer()) then return end
    if LocalPlayer():IsBanned() then return end

    if not timeleft or timeleft == 0 then timeleft = 100 end
    local totalTime = timeleft
    local OldTime   = CurTime()

    local W, H = s(277), s(165)
    local descLines = WrapText(question or "", "demote.desc", W - s(20), 3)

    local count   = table.Count(VoteVGUI)
    local targetY = s(TOP_Y) + count * (H + s(10))

    local panel = vgui.Create("EditablePanel")
    panel:SetSize(W, H)
    panel:SetPos(ScrW(), targetY)
    panel:SetAlpha(0)
    panel:AlphaTo(255, 0.35, 0)
    panel:MoveTo(ScrW() - W - s(10), targetY, 0.55, 0, 0.35)
    panel:SetKeyboardInputEnabled(false)
    panel:SetMouseInputEnabled(true)

    panel.closing = false

    function panel:Close()
        if self.closing then return end
        self.closing = true
        VoteVGUI[voteid .. "vote"] = nil
        self:SetMouseInputEnabled(false)
        self:AlphaTo(0, 0.4, 0, function()
            if IsValid(self) then self:Remove() end
            ReflowVotes()
        end)
    end

    function panel:Think()
        if not self.closing and totalTime - (CurTime() - OldTime) <= 0 then
            self:Close()
        end
    end

    panel.Paint = function(self, w, h)
        local a = self:GetAlpha() / 255

        draw.RoundedBox(s(15), 0, 0, w, h, COL.bg)
        DrawVGradient(s(1), s(1), w - s(2), h - s(2), COL.gradTop, COL.gradBot, 28, a)

        draw.RoundedBox(s(5), s(10), s(10), s(37), s(37), COL.accent)

        draw.SimpleText("Увольнение",  "demote.title", s(54), s(11), COL.white,   TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
        draw.SimpleText("Голосование", "demote.sub",   s(54), s(31), COL.white70, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)

        draw.RoundedBox(s(3), s(165), s(30), s(102), s(5), COL.track)
        local frac  = math.Clamp((totalTime - (CurTime() - OldTime)) / totalTime, 0, 1)
        local fillW = math.max(s(5), math.Round(s(97) * frac))
        draw.RoundedBox(s(3), s(165), s(30), fillW, s(5), COL.accent)

        local rem = math.ceil(math.Clamp(totalTime - (CurTime() - OldTime), 0, 9999))
        draw.SimpleText(rem .. " сек.", "demote.timer", s(267), s(10), COL.white70, TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)

        local ty = s(57)
        for _, line in ipairs(descLines) do
            draw.SimpleText(line, "demote.desc", s(10), ty, COL.white, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
            ty = ty + s(17)
        end
    end

    local ybutton = vgui.Create("DButton", panel)
    ybutton:SetText("")
    ybutton:SetSize(s(126), s(37))
    ybutton:SetPos(s(10), s(118))
    ybutton.Paint = function(self, w, h)
        draw.RoundedBox(s(5), 0, 0, w, h, COL.btnBg)
        draw.SimpleText("Да", "demote.btn", w * 0.5, h * 0.5, COL.white70, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end
    ybutton.DoClick = function()
        LocalPlayer():ConCommand("vote " .. voteid .. " yea\n")
        panel:Close()
    end

    local nbutton = vgui.Create("DButton", panel)
    nbutton:SetText("")
    nbutton:SetSize(s(126), s(37))
    nbutton:SetPos(s(141), s(118))
    nbutton.Paint = function(self, w, h)
        draw.RoundedBox(s(5), 0, 0, w, h, COL.btnBg)
        draw.SimpleText("Нет", "demote.btn", w * 0.5, h * 0.5, COL.white70, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end
    nbutton.DoClick = function()
        LocalPlayer():ConCommand("vote " .. voteid .. " nay\n")
        panel:Close()
    end

    VoteVGUI[voteid .. "vote"] = panel
    ReflowVotes()
end

net.Receive("DoVote", function()
    local question = net.ReadString() or ""
    local voteid   = net.ReadShort()  or 0
    local timeleft = net.ReadFloat()  or 20
    local steamid  = net.ReadString() or ""
    OpenVotePanel(question, voteid, timeleft, steamid)
end)

local function KillVoteVGUI()
    local id = net.ReadShort()
    if VoteVGUI[id .. "vote"] and VoteVGUI[id .. "vote"]:IsValid() then
        VoteVGUI[id .. "vote"]:Close()
    end
end
net.Receive("KillVoteVGUI", KillVoteVGUI)

net("DoQuestion", function()
	local chatx, chaty = chat.GetChatBoxPos()
	local chatw, chath = chat.GetChatBoxSize()
	local x = chatx + chatw + 5
	local question = net.ReadString()
	local quesid = net.ReadString()
	local timeleft = net.ReadFloat()

	if timeleft == 0 then
		timeleft = 100
	end

	local OldTime = CurTime()
	local panel = ui.Create("ui_frame")
	panel:SetPos(0, ScrH() - 145)
	panel:MoveTo(x + PanelNum, ScrH() - 145, 0.15, 0, 1)
	panel:SetSize(300, 140)
	panel:SetSizable(false)
	panel:SetKeyboardInputEnabled(false)
	panel:SetMouseInputEnabled(true)
	panel:SetVisible(true)
	panel:ShowCloseButton(false)

	function panel:Close()
		PanelNum = PanelNum - 302.5
		QuestionVGUI[quesid .. "ques"] = nil
		local num = 5

		for k, v in SortedPairs(VoteVGUI) do
			v:SetPos(num, ScrH() - 145)
			num = num + 142.5
		end

		for k, v in SortedPairs(QuestionVGUI) do
			v:SetPos(num, ScrH() - 145)
			num = num + 302.5
		end

		self:Remove()
	end
	local q = ui.col.SUP:Copy()
	q.a = 25
	function panel:Think()
		self:SetTitle("Время: " .. tostring(math.Clamp(math.ceil(timeleft - (CurTime() - OldTime)), 0, 9999)))

		if timeleft - (CurTime() - OldTime) <= 0 then
			panel:Close()
		end
	end

	local label = ui.Create("DLabel")
	label:SetParent(panel)
	label:SetPos(5, 35)
	label:SetText(question)
	label:SetFont('ui.18')
	label:SizeToContents()

	local ybutton = ui.Create("ui_button")
	ybutton:SetParent(panel)
	ybutton:SetPos(5, panel:GetTall() - 30)
	ybutton:SetSize(panel:GetWide() / 2 - 7.5, 25)
	ybutton:SetText("Да(F1)")
	ybutton:SetVisible(true)

	ybutton.DoClick = function()
		LocalPlayer():ConCommand("ans " .. quesid .. " 1\n")
		panel:Close()
	end
	ybutton.Think = function()
		if input.IsKeyDown(KEY_F1) then
		LocalPlayer():ConCommand("ans " .. quesid .. " 1\n")
		panel:Close()
		end
	end
	local nbutton = ui.Create("ui_button")
	nbutton:SetParent(panel)
	nbutton:SetPos(panel:GetWide() / 2 + 2.5, panel:GetTall() - 30)
	nbutton:SetSize(panel:GetWide() / 2 - 7.5, 25)
	nbutton:SetText("Нет(F2)")
	nbutton:SetVisible(true)

	nbutton.DoClick = function()
		LocalPlayer():ConCommand("ans " .. quesid .. " 2\n")
		panel:Close()
	end
	nbutton.Think = function()
		if input.IsKeyDown(KEY_F2) then
		LocalPlayer():ConCommand("ans " .. quesid .. " 2\n")
		panel:Close()
		end
	end
	PanelNum = PanelNum + 302.5
	QuestionVGUI[quesid .. "ques"] = panel
end)

net("KillQuestionVGUI", function()
	local id = net.ReadString()

	if QuestionVGUI[id .. "ques"] and QuestionVGUI[id .. "ques"]:IsValid() then
		QuestionVGUI[id .. "ques"]:Close()
	end
end)

local function DoVoteAnswerQuestion(ply, cmd, args)
	if not args[1] then return end
	local vote = 0

	if tonumber(args[1]) == 1 or string.lower(args[1]) == "yes" or string.lower(args[1]) == "true" then
		vote = 1
	end

	for k, v in pairs(VoteVGUI) do
		if Valiui_panel(v) then
			local ID = string.sub(k, 1, -5)
			VoteVGUI[k]:Close()
			RunConsoleCommand("vote", ID, vote)

			return
		end
	end

	for k, v in pairs(QuestionVGUI) do
		if Valiui_panel(v) then
			local ID = string.sub(k, 1, -5)
			QuestionVGUI[k]:Close()
			RunConsoleCommand("ans", ID, vote)

			return
		end
	end
end

concommand.Add("rp_vote", DoVoteAnswerQuestion)