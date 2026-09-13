rp.cladman = rp.cladman or {}

rp.cladman.zalog = 4500
rp.cladman.max_bags = 10
rp.cladman.money_for_bag = 850

nw.Register"rp.cladman":Write(net.WriteInt, 5):Read(net.ReadInt, 5):SetLocalPlayer()
