local meta = FindMetaTable('Player')

function meta:GetPingColor()
    local c = self:Ping()
    local clr
    if c < 120 then
        clr = Color(125, 217, 33)
    elseif c < 200 then
        clr = Color(217, 132, 33)
    else
        clr = Color(217, 33, 33)
    end
    return clr
end

enc = enc or {}

if CLIENT then
    enc.icons = {
        ["*"]              = Material("icon16/application_xp_terminal.png"),
        ["uprav"]          = Material("icon16/shield.png"),
        ["team"]           = Material("icon16/monitor_lightning.png"),
        ["developer"]      = Material("icon16/wrench.png"),
        ["manager"]        = Material("icon16/world.png"),
        ["overwatch"]      = Material("icon16/eye.png"),
        ["zam-supervisior"]= Material("icon16/tux.png"),
        ["supervisior"]    = Material("icon16/world.png"),
        ["assistant"]      = Material("icon16/award_star_gold_3.png"),
        ["mlmoder"]        = Material("icon16/award_star_silver_2.png"),
        ["admin"]          = Material("icon16/award_star_bronze_1.png"),
        ["moder"]          = Material("icon16/brick_add.png"),
        ["support"]        = Material("icon16/book.png"),
        ["d-creator"]      = Material("icon16/money_dollar.png"),
        ["d-arizona"]      = Material("icon16/ruby.png"),
        ["premium"]        = Material("icon16/star.png"),
        ["d-admin"]        = Material("icon16/flag_blue.png"),
        ["d-moderator"]    = Material("icon16/shield.png"),
        ["vip"]            = Material("icon16/heart.png"),
        ["user"]           = Material("icon16/user.png"),
    }
end
