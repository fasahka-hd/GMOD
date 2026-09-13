local PANEL = {}

function PANEL:Init()
    self.PanelList = vgui.Create("DPanelList", self)
    self.PanelList:SetPadding(4)
    self.PanelList:SetSpacing(2)
    self.PanelList:EnableVerticalScrollbar(true)
    self:BuildList()
end

local function AddComma(n)
    local sn = tostring(n)
    sn = string.ToTable(sn)
    local tab = {}

    for i = 0, #sn - 1 do
        if i % 3 == #sn % 3 and not (i == 0) then
            table.insert(tab, ",")
        end
        table.insert(tab, sn[i + 1])
    end

    return string.Implode("", tab)
end

function PANEL:BuildList()
    self.PanelList:Clear()

    for CategoryName, v in SortedPairs(PropWhiteList) do
        local Category = vgui.Create("DCollapsibleCategory", self)
        self.PanelList:AddItem(Category)
        Category:SetExpanded(false)
        Category:SetLabel(CategoryName)
        Category:SetCookieName("EntitySpawn." .. CategoryName)
        local Content = vgui.Create("DPanelList")
        Category:SetContents(Content)
        Content:EnableHorizontal(true)
        Content:SetDrawBackground(false)
        Content:SetSpacing(2)
        Content:SetPadding(2)
        Content:SetAutoSize(true)

        for k, modelPath in pairs(PropWhiteList[CategoryName]) do
            local Icon = vgui.Create("SpawnIcon", self)
            Icon:SetModel(modelPath)
        
            Icon.DoClick = function()
                RunConsoleCommand("gm_spawn", modelPath)
            end

            local lable = vgui.Create("DLabel", Icon)
            lable:SetFont("DebugFixedSmall")
            lable:SetTextColor(color_black)
            lable:SetText(modelPath)
            lable:SetContentAlignment(5)
            lable:SetWide(self:GetWide())
            lable:AlignBottom(-42)
            Content:AddItem(Icon)
        end
    end

    self.PanelList:InvalidateLayout()
end

function PANEL:PerformLayout()
    self.PanelList:StretchToParent(0, 0, 0, 0)
end

local CreationSheet = vgui.RegisterTable(PANEL, "Panel")

local function CreateContentPanel()
    return vgui.CreateFromTable(CreationSheet)
end

local function hasQmenuAccess(ply)
    return IsValid(ply) and (ply:IsRoot() or ply:HasAccess("d") or ply:HasAccess("e") or ply:GetNWBool("QmenuAccess", false) or ply:GetNWBool("QmenuPlusAccess", false) or (ply.HasPurchase and (ply:HasPurchase("qmenu") or ply:HasPurchase("qmenuplus"))))
end

local function hasQmenuPlusAccess(ply)
    return IsValid(ply) and (ply:IsRoot() or ply:HasAccess("d") or ply:HasAccess("e") or ply:GetNWBool("QmenuPlusAccess", false) or (ply.HasPurchase and ply:HasPurchase("qmenuplus")))
end

local function RemoveSandboxTabs()
    if not IsValid(LocalPlayer()) then return end
    if LocalPlayer():IsRoot() then return end

    local hasQmenu = hasQmenuAccess(LocalPlayer())
    local hasQmenuPlus = hasQmenuPlusAccess(LocalPlayer())

    local tabstoremove = {
        language.GetPhrase("spawnmenu.content_tab"), "Spawnlists", "Списки спавна", "Пропы", "Content",
        language.GetPhrase("spawnmenu.category.npcs"), "NPCs", "NPC", "НПС",
        language.GetPhrase("spawnmenu.category.postprocess"), "Postprocess", "Постпроцессинг",
        language.GetPhrase("spawnmenu.category.dupes"), "Duplications", "Дубликаты",
        language.GetPhrase("spawnmenu.category.saves"), "Saves", "Сохранения"
    }

    if not hasQmenu then
        table.insert(tabstoremove, language.GetPhrase("spawnmenu.category.entities"))
        table.insert(tabstoremove, "Entities")
        table.insert(tabstoremove, "Энтити")
        table.insert(tabstoremove, language.GetPhrase("spawnmenu.category.weapons"))
        table.insert(tabstoremove, "Weapons")
        table.insert(tabstoremove, "Оружие")
    end

    if not hasQmenuPlus then
        table.insert(tabstoremove, language.GetPhrase("spawnmenu.category.vehicles"))
        table.insert(tabstoremove, "Vehicles")
        table.insert(tabstoremove, "Транспорт")
        table.insert(tabstoremove, "Машины")
        table.insert(tabstoremove, "Транспортные средства")
        table.insert(tabstoremove, "Автомобили")
    end

    if g_SpawnMenu and g_SpawnMenu.CreateMenu and g_SpawnMenu.CreateMenu.Items then
        local sheet = g_SpawnMenu.CreateMenu
        local items = sheet.Items
        if not items then return end

        for i = #items, 1, -1 do
            local item = items[i]
            if item and IsValid(item.Tab) then
                local tabText = string.lower(item.Tab:GetText() or "")
                for _, badName in ipairs(tabstoremove) do
                    if tabText == string.lower(badName) then
                        pcall(function() sheet:CloseTab(item.Tab, true) end)
                        break
                    end
                end
            end
        end
    end
end

hook.Add("SpawnMenuOpen", "blockmenutabs", RemoveSandboxTabs)

spawnmenu.AddCreationTab("Разрешенные пропы", CreateContentPanel, "icon16/application_view_tile.png", 4)

net.Receive("VibeRP_QmenuNotify", function()
    local qType = net.ReadString()
    if qType == "QMenu+" then
        chat.AddText(Color(255, 150, 0), "[ARZManager] ", Color(255, 255, 255), "Выдал вам доступ к ", Color(200, 50, 255), "QMenu+")
    else
        chat.AddText(Color(255, 150, 0), "[ARZManager] ", Color(255, 255, 255), "Выдал вам доступ к ", Color(0, 200, 255), "QMenu")
    end
end)