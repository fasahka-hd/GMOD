AAS = AAS or {}


AAS.Lang = "ru"


AAS.TitleMenu = ""


AAS.FastDL = true


AAS.Mysql = false


AAS.NewTime = 1


AAS.ActivateNotification = true


AAS.OpenShopWithKey = false


AAS.ShopKey = KEY_F6


AAS.OpenBodyGroupWithKey = false


AAS.BodyGroupKey = KEY_F5


AAS.OpenModelChangerWithKey = false


AAS.ModelChangerKey = KEY_F7


AAS.LoadItemsSaved = true


AAS.LoadModelSaved = false


AAS.SellValue = 50


AAS.ModifyOffset = true


AAS.HeadLift = 2


AAS.LoadWorkshop = {
    ["148215278"] = true,
    ["3236957794"] = false,
    ["572310302"] = false,
    ["148215278"] = false,
    ["282958377"] = false,
    ["158532239"] = false,
    ["551144079"] = false,
    ["826536617"] = false,
    ["166177187"] = false,
    ["354739227"] = false,
}


AAS.WearTimeAccessory = 2


AAS.AdminRank = {
    ["root"] = true,
}


AAS.BlackListJobAccessory = {


}


AAS.AdminCommand = "/aasconfig"


AAS.OpenItemMenuCommand = false

AAS.ItemsMenuCommand = "/aas"


AAS.Gradient = {
    ["upColor"] = Color(18, 30, 42, 200),
    ["midleColor"] = Color(27, 59, 89, 200),
    ["downColor"] = Color(54, 140, 220),
}


AAS.SwepName = "Inventory Swep"


AAS.BuyItemWithSwep = true


AAS.WeightActivate = false


AAS.WeightInventory = {
    ["all"] = 4,
    ["VIP"] = 10,
}

AAS.ItemNpcModel = "models/Humans/Group01/Female_02.mdl"

AAS.ItemNpcName = "Accessory Seller"

AAS.BodyGroupModel = "models/props_c17/FurnitureDresser001a.mdl"

AAS.BodyGroupsName = "Bodygroups Changer"

AAS.ModelChanger = "models/props_c17/FurnitureDresser001a.mdl"

AAS.ModelName = "Models Changer"


AAS.BlackListBodyGroup = {


}


AAS.BlackListItemsMenu = {


}


AAS.BlackListModelsMenu = {


}


AAS.UseDarkRPModel = false


AAS.CustomModelTable = {
    ["Citizen"] = {
        "models/player/zelpa/male_01.mdl",
        "models/player/zelpa/male_03.mdl",
        "models/player/zelpa/male_05.mdl",
        "models/player/zelpa/male_06.mdl",
        "models/player/zelpa/male_07.mdl",
        "models/player/zelpa/male_08.mdl",
        "models/player/zelpa/male_09.mdl",
        "models/player/zelpa/male_10.mdl",
        "models/player/zelpa/male_11.mdl",
        "models/player/zelpa/female_01_b.mdl",
        "models/player/zelpa/female_06.mdl",
        "models/player/zelpa/female_02_b.mdl",
        "models/player/zelpa/female_03_b.mdl",
        "models/player/zelpa/female_04_b.mdl",
        "models/player/zelpa/female_06_b.mdl",
    },
    ["Civil Protection"] = {
        "models/player/zelpa/male_01.mdl",
        "models/player/zelpa/male_02.mdl",
        "models/player/zelpa/male_03.mdl",
        "models/player/zelpa/male_04.mdl",
    },
}


AAS.Colors = {
    ["whiteConfig"] = Color(255,255,255),
    ["white"] = Color(240,240,240),
    ["black"] = Color(0,0,0),
    ["black100"] = Color(0,0,0,100),
    ["black150"] = Color(0,0,0,150),
    ["black18"] = Color(18, 30, 42),
    ["black18230"] = Color(18, 30, 42, 230),
    ["black18200"] = Color(18, 30, 42, 200),
    ["black18100"] = Color(18, 30, 42, 100),
    ["background"] = Color(25, 40, 55),
    ["selectedBlue"] = Color(53, 139, 219),
    ["white200"] = Color(255,255,255,200),
    ["white50"] = Color(255,255,255,50),
    ["yellow"] = Color(255, 198, 57),
    ["darkBlue"] = Color(49, 98, 255),
    ["dark34"] = Color(34,34,34),
    ["blue77"] = Color(77, 128, 255),
    ["red49"] = Color(255, 49, 84),
    ["grey"] = Color(189,190,191,255),
    ["blue75"] = Color(75, 168, 255),
    ["grey53"] = Color(53, 139, 219),
    ["grey165"] = Color(165, 165, 165),
    ["notifycolor"] = Color(54, 140, 220),
    ["white200"] = Color(240,240,240),
    ["bought"] = Color(252, 186, 3),
}


AAS.CurrentCurrency = "$"


AAS.Currencies = {
    ["$"] = function(money)
        return "$"..money
    end,
    ["€"] = function(money)
        return money.."€"
    end
}


AAS.MaxVectorOffset = 5


AAS.MaxAngleOffset = 30


if SERVER then
    if isfunction(AAS.ChangeLangage) then
        AAS.ChangeLangage()
    end
end
