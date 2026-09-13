--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher

function IGS.Purchase(sItemUID, count, callback)
    if type(count) == "function" then
        callback = count
        count = 1
    end
    
    count = count or 1
    
    net.Start("IGS.Purchase")
        net.WriteString(sItemUID)
        net.WriteUInt(count, 8)
    net.SendToServer()

    net.Receive("IGS.Purchase", function()
        local errMsg = net.ReadIGSError()
        local ITEM = IGS.GetItemByUID(sItemUID)
        
        if errMsg then
            if callback then 
                callback(errMsg, nil) 
            end
            hook.Run("IGS.OnFailedPurchase", ITEM, errMsg)
        else
            local invDbID = IGS.C.Inv_Enabled and net.ReadUInt(IGS.BIT_INV_ID) or nil
            if callback then 
                callback(nil, invDbID) 
            end
            hook.Run("IGS.PlayerPurchasedItem", LocalPlayer(), ITEM, invDbID)
        end
    end)
end

function IGS.Activate(iInvID, callback)
    net.Start("IGS.Activate")
        net.WriteUInt(iInvID, IGS.BIT_INV_ID)
        net.WriteBool(callback ~= nil)
    net.SendToServer()

    if not callback then return end
    net.Receive("IGS.Activate", function()
        local ok = net.ReadBool()
        local iPurchID = ok and net.ReadUInt(IGS.BIT_PURCH_ID) or nil
        local sMsg = net.ReadIGSMessage()
        callback(ok, iPurchID, sMsg)
    end)
end

function IGS.UseCoupon(sCoupon, callback)
    net.Start("IGS.UseCoupon")
        net.WriteString(sCoupon)
    net.SendToServer()

    net.Receive("IGS.UseCoupon", function()
        if callback then
            callback(net.ReadIGSError())
        end
    end)
end

function IGS.GetPaymentURL(iSum, fCallback)
    net.Start("IGS.GetPaymentURL")
        net.WriteDouble(iSum)
    net.SendToServer()

    net.Receive("IGS.GetPaymentURL", function()
        if fCallback then
            fCallback(net.ReadString())
        end
    end)
end
function IGS.UICharge(iSum)
    IGS.GetPaymentURL(iSum, function(url)
        if url and url ~= "" then
            gui.OpenURL(url)
        end
    end)
end

local cache, last_update = {}, 0
function IGS.GetLatestPurchases(fCallback)
    if not fCallback then return end
    
    if last_update + 60 >= os.time() then
        fCallback(cache)
        return
    end

    net.Start("IGS.GetLatestPurchases")
    net.SendToServer()
    
    net.Receive("IGS.GetLatestPurchases", function()
        local dat = {}
        for i = 1, net.ReadUInt(IGS.BIT_LATEST_PURCH) do
            dat[i] = net.ReadIGSPurchase()
        end

        cache = dat
        last_update = os.time()

        fCallback(dat)
    end)
end

function IGS.GetMyTransactions(fCallback)
    if not fCallback then return end
    
    net.Start("IGS.GetMyTransactions")
    net.SendToServer()

    net.Receive("IGS.GetMyTransactions", function()
        local dat = {}
        for i = 1, net.ReadUInt(IGS.BIT_TX) do
            dat[i] = net.ReadIGSTx()
        end

        fCallback(dat)
    end)
end

function IGS.GetMyPurchases(fCallback)
    if not fCallback then return end
    
    net.Start("IGS.GetMyPurchases")
    net.SendToServer()

    net.Receive("IGS.GetMyPurchases", function()
        local dat = {}
        for i = 1, net.ReadUInt(8) do
            dat[i] = net.ReadIGSPurchase()
        end

        fCallback(dat)
    end)
end

function IGS.GetInventory(fCallback)
    if not fCallback then return end
    
    net.Start("IGS.GetInventory")
    net.SendToServer()

    net.Receive("IGS.GetInventory", function()
        local d = {}
        for i = 1, net.ReadUInt(7) do
            d[i] = net.ReadIGSInventoryItem()
        end
        fCallback(d)
    end)
end

function IGS.DropItem(iID, fCallback)
    if not IGS.C.Inv_AllowDrop then
        IGS.ShowNotify("Дроп предметов отключен администратором", "Ошибка")
        return
    end

    net.Start("IGS.DropItem")
        net.WriteUInt(iID, IGS.BIT_INV_ID)
    net.SendToServer()

    net.Receive("IGS.DropItem", function()
        local ent = net.ReadEntity()
        if fCallback then
            fCallback(ent)
        end
    end)
end

net.Receive("IGS.PaymentStatusUpdated", function()
    local t = {}
    t.paymentType = net.ReadString()
    t.orderSum    = net.ReadString()
    t.method      = net.ReadString()

    if t.method == "error" then
        t.errorMessage = net.ReadString()
    end

    hook.Run("IGS.PaymentStatusUpdated", t)
end)

net.Receive("IGS.UI", function()
    IGS.UI()
end)

--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher