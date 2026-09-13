eui.bonus = eui.bonus or {}
eui.bonus.time = 18000

function eui.bonus.AddWin(pl)
    if not IsValid(pl) then return end

    if pl.AddIGSFunds then
        pl:AddIGSFunds(2500, "Награда за 5 часов игры")
    elseif IGS and IGS.Transaction then
        IGS.Transaction(pl:SteamID64(), 2500, "Награда за 5 часов игры")
    end

    pl:ChatPrint('Вы получили награду: 2500 руб. на донат-счет за отыгрыш 5 часов!')
end

nw.Register('eui.bonus:Time')
	:Write(net.WriteUInt, 32)
	:Read(net.ReadUInt, 32)
	:SetLocalPlayer()

nw.Register('eui.bonus:Win')
	:Write(net.WriteBool)
	:Read(net.ReadBool)
	:SetLocalPlayer()

nw.Register('eui.bonus:Claimed')
	:Write(net.WriteBool)
	:Read(net.ReadBool)
	:SetLocalPlayer()