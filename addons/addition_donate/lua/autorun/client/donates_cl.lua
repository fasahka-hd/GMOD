--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

net.Receive("gay_note",function()
    local gay = net.ReadTable() 
        chat.AddText(unpack(gay))
end)

local function CreateDonationMenu()
    local frame = vgui.Create("DFrame")
    frame:SetSize(400, 300)
    frame:SetTitle("Донат Меню")
    frame:SetVisible(true)
    frame:SetDraggable(true)
    frame:Center()

    local panel = vgui.Create("DPanel", frame)
    panel:SetPos(10, 30)
    panel:SetSize(380, 260)


    local function CreateItemButtons()
        for _, item in ipairs(KylDonate.Items) do
            if not item.hide then
                local button = vgui.Create("DButton", panel)
                button:SetText(item.name .. " - " .. item.cost.def .. " Kyl-монет")
                button:Dock(TOP)

                button.DoClick = function()
                    net.Start("KylDonate")
                        net.WriteString(item.id)
                        net.WriteBool(item.permitem)
                    net.SendToServer()

                    print("Вы купили " .. item.name)

                end
            else
                continue
            end
        end
    end

    CreateItemButtons()

    function frame:OnClose()
        frame:Remove()
    end
    frame:MakePopup()
end
concommand.Add("test_donate_menu", function()
    CreateDonationMenu()
end)

--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
