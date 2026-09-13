--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

local lupkazalupka = Material("rpui/search.png", "smooth mips")

local box = draw.RoundedBox
local text = draw.SimpleText

local PANEL = {}

local check_text_match = function(text, ply)
    if ply:Name():lower():find(text, 1, true) then return true end
    if ply:SteamID():lower():find(text, 1, true) then return true end
    if ply:GetJobName():lower():find(text, 1, true) then return true end
    return false
end

function PANEL:Init()
    self.lines = {}
    do
        self.line = ui.Create('Panel', self)
        self.line:Dock(TOP)
        self.line:DockMargin(enc.w(42),enc.h(118),enc.w(44),0)
        self.line:SetTall(enc.h(2))
        function self.line:Paint(w,h)
            box(0,0,0,w,h,enc.clrs.line)
        end
    end

    do
        self.searchRight = ui.Create('Panel', self)
        self.searchRight:Dock(TOP)
        self.searchRight:DockMargin(enc.w(31),enc.h(19),enc.w(44),0)
        self.searchRight:SetTall(enc.h(70))
        function self.searchRight:Paint(w,h)
            box(0,0,0,w,h,enc.clrs.close)
        end

        self.searchRight.search = vgui.Create('DTextEntry',self.searchRight)
        self.searchRight.search:Dock(LEFT)
        self.searchRight.search:DockMargin(enc.w(26),enc.h(26),0,enc.h(26))
        self.searchRight.search:SetWide(enc.w(462))
        self.searchRight.search:SetValue('Поиск...')
        self.searchRight.search:SetFont('M_14')
        self.searchRight.search:SetDrawLanguageID(false)
        function self.searchRight.search:OnMousePressed() 
            self:SetValue("")
        end
        function self.searchRight.search:Paint(w,h)
            box(6,0,0,w,h,enc.clrs.close)
            self:DrawTextEntryText(enc.clrs.whitea, enc.clrs.whitea, color_white)
        end
        function self.searchRight.search.OnChange(s,text)
            if text == nil then
                text = s:GetValue()
            end

            if text ~= "" then
                self.scroll:ClearSelection()
            end
            text = text:lower()
            for i, line in ipairs(self.lines) do
                local ply = line.ply
                if not check_text_match(text, ply) then
                    line:SizeTo(line:GetWide(),0,0.2)
                else
                    line:SizeTo(line:GetWide(),enc.h(70),0.2)
                end
            end
        end

        self.searchRight.seatchinfo = vgui.Create('Panel', self.searchRight)
        self.searchRight.seatchinfo:Dock(LEFT)
        self.searchRight.seatchinfo:DockMargin(enc.w(26),enc.h(15),enc.w(16),enc.h(15))
        self.searchRight.seatchinfo:SetWide(enc.w(40))
        function self.searchRight.seatchinfo:Paint(w,h)
            box(4,0,0,w,h,enc.clrs.search)
            surface.SetMaterial(lupkazalupka)
            surface.SetDrawColor(255,255,255)
            surface.DrawTexturedRect(enc.w(12),enc.h(12),enc.w(16),enc.h(16))
        end
    end
    do
        self.line = ui.Create('Panel', self)
        self.line:Dock(TOP)
        self.line:DockMargin(enc.w(42),enc.h(19),enc.w(44),0)
        self.line:SetTall(enc.h(2))
        function self.line:Paint(w,h)
            box(0,0,0,w,h,enc.clrs.line)
        end
    end

    do
        self.sharedPlayers = ui.Create('Panel', self)
        self.sharedPlayers:Dock(TOP)
        self.sharedPlayers:DockMargin(enc.w(31),enc.h(26),enc.w(16),0)
        self.sharedPlayers:SetTall(enc.h(316))

        self.scroll = vgui.Create('DScrollPanel',self.sharedPlayers)
        self.scroll:Dock(FILL)
        self.scroll.Paint = function() end
        local scrolls = self.scroll:GetVBar()
        scrolls:SetWide(enc.w(2))
        scrolls.Paint = function(this, w, h) 
            box(0,0,0,w,h,enc.clrs.search)
        end
        scrolls.btnUp.Paint = function(this, w, h) end 
        scrolls.btnDown.Paint = function(this, w, h) end
        scrolls.btnGrip.Paint = function(this, w, h) 
            box(0,0,0,w,h,enc.clrs.scroll)
        end
        function self.scroll.GetSelected()
            local ret = {}
            for _, v in ipairs(self.lines) do
                if v.Selected then
                    table.insert(ret, v)
                end
            end
            return ret
        end
        function self.scroll.ClearSelection(s)
            for _, line in ipairs(self.lines) do
                if IsValid(line) then
                    line.Selected = false
                end
            end
            s:OnRowSelected()
        end
        function self.scroll:OnRowSelected()
            local plys = {}
            for k, v in ipairs(self:GetSelected()) do
                plys[k] = v.ply:EntIndex()
            end
        end
    end
end

function PANEL:SetBool(bool)
    local sharedKeys = LocalPlayer():GetNetVar('ShareProps') or {}
    for k,v in ipairs(player.GetAll()) do
        if (sharedKeys[v] == bool) or (bool == false and sharedKeys[v] == nil) then continue end
        if v == LocalPlayer() then continue end

        self.scroll.ply = vgui.Create('DButton', self.scroll)
        self.scroll.ply:Dock(TOP)
        self.scroll.ply:DockMargin(0,0,enc.w(15),enc.h(12))
        self.scroll.ply:SetTall(enc.h(70))
        self.scroll.ply:SetText('')
        self.scroll.ply.ply = v
        self.scroll.ply.line = ply
        self.scroll.ply.id = table.insert(self.lines, self.scroll.ply)
        function self.scroll.ply.Paint(s,w,h)
            local isHovered = s:IsHovered()
            local firstColor = isHovered and color_black or color_white
            local secondColor = isHovered and color_white or enc.clrs.close

            box(6,0,0,w,h,secondColor)
            text(v:Name(),'MB_14',enc.w(74),h/2,firstColor,0,1)
        end
        function self.scroll.ply:DoClick()
            cmd.Run('shareprops', v:SteamID())
            sharedKeys[v] = not bool
            timer.Simple(.1,function()
                refreshShareProp()
            end)
        end
        function self.scroll.ply:Think()
            if not IsValid(v) then self:Remove() end
        end
        
        do
            self.scroll.ply.avatar = vgui.Create('enc.avatar', self.scroll.ply)
            self.scroll.ply.avatar:Dock(LEFT)
            self.scroll.ply.avatar:DockMargin(enc.w(14),enc.h(15),0,enc.h(15))
            self.scroll.ply.avatar:SetWide(enc.w(40))
            self.scroll.ply.avatar:SetPlayer(v,64)
            self.scroll.ply.avatar.rounded = 4
        end
    end
end

function PANEL:SetMainText(text)
    self.label = vgui.Create('DLabel',self)
    self.label:SetText(text)
    self.label:SetFont('MB_24')
    self.label:SetTextColor(enc.clrs.white)
    self.label:SizeToContents()
    self.label:SetPos(enc.w(45),enc.h(31))
end

function PANEL:SetOtherText(text)
    self.olabel = vgui.Create('DLabel',self)
    self.olabel:SetText(text)
    self.olabel:SetFont('M_16')
    self.olabel:SetTextColor(enc.clrs.whitea)
    self.olabel:SizeToContents()
    self.olabel:SetPos(enc.w(45),enc.h(72))
end

function PANEL:SetPaint(color)
    self.paint = true
    self.color = color
end

function PANEL:Paint(w,h)
    if self.paint then
        box(16,0,0,w,h,self.color)
    end
end

vgui.Register('enc.new.playerspanel', PANEL, 'Panel')

--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
