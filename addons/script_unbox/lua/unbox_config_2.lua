--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher

if SERVER then  
    AddCSLuaFile()
    AddCSLuaFile("uc2_subconfig.lua")
end
include("uc2_subconfig.lua")

BUC2.GivePermaWeaponsOnSpawn = true
BUC2.AnnounceUnboxings = true
BUC2.CanTradePermaWeapons = false
BUC2.BuyItemsWithPoints = false
BUC2.BuyItemsWithPoints2 = false
BUC2.RanksThatCanGiveItems = {
	"*",
}
BUC2.ShouldDropCratesAndKeys = false
BUC2.DropTimer = 25
BUC2.DropsAreRankLimited = true
BUC2.DropRankList = {
	"donator1",
	"donator2",
	"admins",
	"superadmin",
	"mod",
	"vip"
}


local Discount = 23

Discount = 1 - Discount/100

local rare = {
	common 		= Color(183, 170, 192),
	rare 		= Color(134, 107, 199),
	epic 		= Color(213, 112, 240),
	ultra 		= Color(255, 56, 248),
	megarare 	= Color(255, 255, 0),
	ultrarare	= Color(255, 0, 51)

}

bu_addCrate(1,"Кейс привилегий" , "У вас есть шанс выбить админку!" , Color(255, 215, 0, 255) , true , true , 349, 349*2)
bu_addMoney(2,"VIP 30d" , "" , "vip_tri_mesyaca" , rare.common , "Кейс привилегий", 200)
bu_addMoney(3,"VIP ∞" , "" , "vip_perma" , rare.common , "Кейс привилегий", 200)
bu_addMoney(4,"Модер 30д" , "" , "DModerator_tri_mesyaca" , rare.rare , "Кейс привилегий", 100)
bu_addMoney(5,"Модер ∞" , "" , "DModerator_perma" , rare.rare , "Кейс привилегий", 100)
bu_addMoney(6,"Админ 30д" , "" , "DAdmin_tri_mesyaca" , rare.rare , "Кейс привилегий", 90)
bu_addMoney(7,"Админ ∞" , "" , "DAdmin_perma" , rare.rare , "Кейс привилегий", 90)
bu_addMoney(8,"Spectator 30д" , "" , "Spectator_tri_mesyaca" , rare.epic , "Кейс привилегий", 80)
bu_addMoney(9,"Spectator ∞" , "" , "DSAdmin_perma" , rare.epic , "Кейс привилегий", 80)
bu_addMoney(10,"С-Админ 30д" , "" , "SuperAdmin_3mes" , rare.ultra , "Кейс привилегий", 70)
bu_addMoney(11,"С-Админ ∞" , "" , "SuperAdmin_perma" , rare.ultra , "Кейс привилегий", 70)
bu_addMoney(12,"Owner 30д" , "" , "Owner_tri_mesyaca" , rare.megarare , "Кейс привилегий", 60)
bu_addMoney(13,"Owner ∞" , "" , "Owner_tri_vsegda" , rare.megarare , "Кейс привилегий", 60)


bu_addCrate(16,"Кейс VIBE" , "Именной кейс сервера VIBE" , Color(178, 0, 255, 255) , true , true ,  219, 219*2)
bu_addMoney(17,"$25.000" , "" , "25k_deneg" , rare.common , "Кейс VIBE", 200)
bu_addMoney(18,"$50.000" , "" , "50k_deneg" , rare.common , "Кейс VIBE", 190)
bu_addMoney(19,"$100.000" , "" , "100k_deneg" , rare.common , "Кейс VIBE", 180)
bu_addMoney(20,"$500.000" , "" , "500_deneg" , rare.rare , "Кейс VIBE", 170)
bu_addMoney(21,"$1.000.000" , "" , "1leam_deneg" , rare.epic , "Кейс VIBE", 150)
bu_addMoney(22,"50 Руб." , "" , "igs50p" , rare.epic , "Кейс VIBE", 180)
bu_addMoney(23,"100 Руб." , "" , "igs100p" , rare.epic , "Кейс VIBE", 150)
bu_addMoney(24,"300 Руб." , "" , "igs300p" , rare.ultra , "Кейс VIBE", 120)
bu_addMoney(25,"500 Руб." , "" , "igs500p" , rare.megarare , "Кейс VIBE", 80)
bu_addMoney(26,"1000 Руб." , "" , "igs1000p" , rare.ultrarare , "Кейс VIBE", 50)
bu_addMoney(27,"Owner 30д" , "" , "case_owner_trimes" , rare.ultrarare , "Кейс VIBE", 40)

bu_addCrate(28,"Весенний кейс" , "Сезонный кейс" , Color(178, 0, 255, 255) , true , true ,  249, 249*2)
bu_addWeapon(29,"Нож" , "" , "default_case_knife" , "models/weapons/w_knife_ct.mdl", rare.common , "Весенний кейс", 200, false)
bu_addWeapon(30,"Аптечка" , "" , "case_medikkit" , "models/weapons/w_medkit.mdl", rare.common , "Весенний кейс", 200, false)
bu_addWeapon(31,"Colt Python" , "" , "m9k_coltpython" , "models/weapons/w_colt_python.mdl", rare.rare , "Весенний кейс", 200, false)
bu_addWeapon(32,"TMP" , "" , "wep_tmp" , "models/weapons/3_smg_tmp.mdl",rare.rare , "Весенний кейс", 100, false)
bu_addWeapon(33,"SR-3M Vikhr" , "" , "wep_m9k_vikhr" , "models/weapons/w_dmg_vikhr.mdl", rare.epic , "Весенний кейс", 100, false)
bu_addWeapon(34,"HK 416" , "" , "wep_m9k_m416" , "models/weapons/w_hk_416.mdl", rare.epic , "Весенний кейс", 100, false)
bu_addWeapon(35,"Double Barrel" , "" , "shotbarrel" , "models/weapons/w_double_barrel_shotgun.mdl", rare.ultra , "Весенний кейс", 100, false)
bu_addWeapon(36,"Striker-12" , "" , "m9k_striker12" , "models/weapons/w_striker_12g.mdl", rare.ultra , "Весенний кейс", 100, false)
bu_addMoney(37,"300 Руб." , "" , "igs300p" , rare.megarare , "Весенний кейс", 50)
bu_addMoney(38,"500 Руб." , "" , "igs500p" , rare.ultrarare , "Весенний кейс", 50)
bu_addMoney(39,"Owner 30д" , "" , "Owner_tri_mesyaca" , rare.ultrarare , "Весенний кейс", 50)

bu_addCrate(40,"Денежный кейс" , "Кейс с деньгами" , Color(178, 0, 255, 255) , true , true ,  129, 129*2)
bu_addMoney(41,"$25.000" , "" , "25k_deneg" , rare.common , "Денежный кейс", 200)
bu_addMoney(42,"$50.000" , "" , "50k_deneg" , rare.rare , "Денежный кейс", 200)
bu_addMoney(43,"$100.000" , "" , "100k_deneg" , rare.epic , "Денежный кейс", 180)
bu_addMoney(44,"$500.000" , "" , "500_deneg" , rare.ultra , "Денежный кейс", 170)
bu_addMoney(45,"$1.000.000" , "" , "1leam_deneg" , rare.megarare , "Денежный кейс", 160)
bu_addMoney(46,"$10.000.000" , "" , "10leamov_deneg" , rare.ultrarare , "Денежный кейс", 150)

bu_addCrate(47,"Пистолеты" , "Кейс с пистолетами" , Color(178, 0, 255, 255) , true , true ,  239, 239*2)
bu_addWeapon(48,"P08 Luger" , "" , "wep_m9k_luger" , "models/weapons/w_luger_p08.mdl", rare.common , "Пистолеты", 200, false)
bu_addWeapon(49,"Glock-18" , "" , "wep_m9k_glock" , "models/weapons/w_dmg_glock.mdl", rare.common , "Пистолеты", 100, false)
bu_addWeapon(50,"HK USP" , "" , "wep_m9k_hkusp" , "models/weapons/w_pist_fokkususp.mdl", rare.common , "Пистолеты", 100, false)
bu_addWeapon(51,"Desert Eagle" , "" , "m9k_deaglee" , "models/weapons/w_tcom_deagle.mdl", rare.rare , "Пистолеты", 100, false)
bu_addWeapon(52,"Colt 1911" , "" , "wep_m9k_colt911" , "models/weapons/s_dmgf_co1911.mdl", rare.rare , "Пистолеты", 100, false)
bu_addWeapon(53,"Colt Python" , "" , "m9k_coltpython" , "models/weapons/w_colt_python.mdl", rare.rare , "Пистолеты", 100, false)
bu_addWeapon(54,"Raging Bull" , "" , "m9k_ragingbullk" , "models/weapons/w_taurus_raging_bull.mdl", rare.epic , "Пистолеты", 80, false)
bu_addWeapon(55,"Remington" , "" , "wep_m9k_rem1858" , "models/weapons/w_remington_1858.mdl", rare.epic , "Пистолеты", 80, false)
bu_addWeapon(56,"Beretta" , "" , "wep_m9k_beretta" , "models/weapons/w_beretta_m92.mdl", rare.epic , "Пистолеты", 80, false)
bu_addWeapon(57,"RBull Scoped" , "" , "wep_m9k_rbscope" , "models/weapons/w_raging_bull_scoped.mdl", rare.ultra , "Пистолеты", 80, false)
bu_addWeapon(58,"HL2 Magnum" , "" , "magnun_case_hl2" , "models/weapons/w_357.mdl", rare.megarare , "Пистолеты", 60, false)
bu_addWeapon(59,"Ковбойка" , "" , "cowboy" , "models/weapons/w_357.mdl", rare.ultrarare , "Пистолеты", 10, false)

bu_addCrate(54,"Пистолеты-Пулеметы" , "Кейс с пистолетами-пулеметами" , Color(178, 0, 255, 255) , true , true ,  279, 279*2)
bu_addWeapon(55,"MAC-10" , "" , "wep_case_mac" , "models/weapons/3_smg_mac10.mdl", rare.common , "Пистолеты-Пулеметы", 200, false)
bu_addWeapon(56,"TMP" , "" , "wep_case_tmp" , "models/weapons/3_smg_tmp.mdl", rare.common , "Пистолеты-Пулеметы", 200, false)
bu_addWeapon(57,"HK UMP" , "" , "wep_case_ump" , "models/weapons/3_smg_ump45.mdl", rare.common , "Пистолеты-Пулеметы", 200, false)
bu_addWeapon(58,"P90" , "" , "wep_case_p90" , "models/weapons/3_smg_p90.mdl", rare.rare , "Пистолеты-Пулеметы", 200, false)
bu_addWeapon(59,"MP-40" , "" , "m9k_case_mp40" , "models/weapons/w_mp40smg.mdl", rare.rare , "Пистолеты-Пулеметы", 150, false)
bu_addWeapon(60,"MP5" , "" , "wep_case_mp5" , "models/weapons/w_hk_mp5sd.mdl", rare.epic , "Пистолеты-Пулеметы", 150, false)
bu_addWeapon(61,"Tommy Gun" , "" , "m9k_case_thompson" , "models/weapons/w_tommy_gun.mdl", rare.epic , "Пистолеты-Пулеметы", 150, false)
bu_addWeapon(62,"KRISS Vector" , "" , "m9k_case_vector" , "models/weapons/w_kriss_vector.mdl", rare.ultra , "Пистолеты-Пулеметы", 130, false)
bu_addWeapon(63,"KAC PDW" , "" , "wep_case_kac" , "models/weapons/w_kac_pdw.mdl", rare.ultra , "Пистолеты-Пулеметы", 130, false)
bu_addWeapon(64,"MP7" , "" , "wep_case_mp7" , "models/weapons/w_mp7_silenced.mdl", rare.megarare , "Пистолеты-Пулеметы", 80, false)
bu_addWeapon(65,"MP9" , "" , "wep_case_mp9" , "models/weapons/w_brugger_thomet_mp9.mdl", rare.ultrarare , "Пистолеты-Пулеметы", 80, false)

bu_addCrate(66,"Штурмовые винтовки" , "Кейс со штурмовыми винтовками" , Color(178, 0, 255, 255) , true , true ,  399, 399*2)
bu_addWeapon(67,"FAMAS" , "" , "wep_case_famas" , "models/weapons/3_rif_famas.mdl", rare.common , "Штурмовые винтовки", 200, false)
bu_addWeapon(68,"M16A4 ACOG" , "" , "wep_m9k_case_m16a4_acog" , "models/weapons/w_dmg_m16ag.mdl", rare.common , "Штурмовые винтовки", 200, false)
bu_addWeapon(69,"FN FAL" , "" , "wep_case_fal" , "models/weapons/w_fn_fal.mdl", rare.common , "Штурмовые винтовки", 200, false)
bu_addWeapon(70,"Steyr AUG" , "" , "wep_case_m9k_auga3" , "models/weapons/w_auga3.mdl", rare.rare , "Штурмовые винтовки", 200, false)
bu_addWeapon(71,"AK-74" , "" , "bp_ak74" , "models/weapons/w_tct_ak47.mdl", rare.rare , "Штурмовые винтовки", 100, false)
bu_addWeapon(72,"L85" , "" , "wep_case_l85" , "models/weapons/w_l85a2.mdl", rare.rare , "Штурмовые винтовки", 100, false)
bu_addWeapon(73,"AK-47" , "" , "m9k_case_aka47" , "models/weapons/w_ak47_m9k.mdl", rare.epic , "Штурмовые винтовки", 100, false)
bu_addWeapon(74,"M4A1" , "" , "wep_case_m4a1" , "models/weapons/w_m4a1_iron.mdl", rare.epic , "Штурмовые винтовки", 100, false)
bu_addWeapon(75,"SIG SG550" , "" , "wep_case_sg550" , "models/weapons/3_snip_sg550.mdl", rare.ultra , "Штурмовые винтовки", 100, false)
bu_addWeapon(76,"SIG SG552" , "" , "wep_case_sg552" , "models/weapons/3_rif_sg552.mdl", rare.ultra , "Штурмовые винтовки", 100, false)
bu_addWeapon(77,"F2000" , "" , "wep_case_m9k_f2000" , "models/weapons/w_fn_f2000.mdl", rare.ultra , "Штурмовые винтовки", 100, false)
bu_addWeapon(78,"HK 416" , "" , "wep_case_m9k_m416" , "models/weapons/w_hk_416.mdl", rare.megarare , "Штурмовые винтовки", 80, false)
bu_addWeapon(79,"TAR-21" , "" , "wep_case_tar21" , "models/weapons/w_imi_tar21.mdl", rare.megarare , "Штурмовые винтовки", 80, false)
bu_addWeapon(80,"ACR" , "" , "bp_acr" , "models/weapons/w_masada_acr.mdl", rare.megarare , "Штурмовые винтовки", 80, false)
bu_addWeapon(81,"SCAR" , "" , "wep_case_scar" , "models/weapons/w_fn_scar_h.mdl", rare.megarare , "Штурмовые винтовки", 80, false)
bu_addWeapon(82,"AS VAL" , "" , "wep_case_m9k_val" , "models/weapons/w_dmg_vally.mdl", rare.ultrarare , "Штурмовые винтовки", 60, false)
bu_addWeapon(129,"Minigun" , "" , "m9k_case_minigunn" , "models/weapons/w_m134_minigun.mdl", rare.ultrarare , "Штурмовые винтовки", 40, false)

bu_addCrate(83,"Снайперские винтовки" , "Кейс со снайперскими винтовками" , Color(178, 0, 255, 255) , true , true ,  449, 449*2)
bu_addWeapon(84,"AWP" , "" , "wep_case_awp" , "models/weapons/3_snip_awp.mdl", rare.common , "Снайперские винтовки", 100, false)
bu_addWeapon(85,"AI AW50" , "" , "wep_case_aw50" , "models/weapons/w_acc_int_aw50.mdl", rare.rare , "Снайперские винтовки", 100, false)
bu_addWeapon(86,"M24" , "" , "wep_case_m24" , "models/weapons/w_snip_m24_6.mdl", rare.rare , "Снайперские винтовки", 100, false)
bu_addWeapon(87,"HL SL8" , "" , "wep_case_sl8" , "models/weapons/w_hk_sl8.mdl", rare.epic , "Снайперские винтовки", 100, false)
bu_addWeapon(88,"PSG-1" , "" , "wep_case_psg" , "models/weapons/w_hk_psg1.mdl", rare.epic , "Снайперские винтовки", 100, false)
bu_addWeapon(89,"Barret M98B" , "" , "wep_case_m98b" , "models/weapons/w_barrett_m98b.mdl", rare.epic , "Снайперские винтовки", 100, false)
bu_addWeapon(90,"SVT-40" , "" , "wep_case_svt" , "models/weapons/w_svt_40.mdl", rare.ultra , "Снайперские винтовки", 80, false)
bu_addWeapon(91,"Intervention" , "" , "wep_case_inter" , "models/weapons/w_snip_int.mdl", rare.ultra , "Снайперские винтовки", 80, false)
bu_addWeapon(92,"T.C. G2" , "" , "wep_case_tcg2" , "models/weapons/w_g2_contender.mdl", rare.ultra , "Снайперские винтовки", 80, false)
bu_addWeapon(93,"Barret M82" , "" , "wep_case_m82" , "models/weapons/w_barret_m82.mdl", rare.megarare , "Снайперские винтовки", 60, false)
bu_addWeapon(94,"SVD Dragunov" , "" , "wep_case_drag" , "models/weapons/w_svd_dragunov.mdl", rare.megarare , "Снайперские винтовки", 60, false)
bu_addWeapon(95,"Dragunov SVU" , "" , "wep_case_svu" , "models/weapons/w_dragunov_svu.mdl", rare.megarare , "Снайперские винтовки", 60, false)
bu_addWeapon(96,"Vintorez" , "" , "wep_case_vss" , "models/weapons/w_vss.mdl", rare.ultrarare , "Снайперские винтовки", 60, false)

bu_addCrate(99,"Оружейный микс" , "Кейс с разным оружием" , Color(178, 0, 255, 255) , true , true ,  299, 299*2)
bu_addWeapon(100,"Нож" , "" , "default_case_knife" , "models/weapons/w_knife_ct.mdl", rare.common , "Оружейный микс", 200, false)
bu_addWeapon(101,"Glock-18" , "" , "wep_case_m9k_glock" , "models/weapons/w_dmg_glock.mdl", rare.common , "Оружейный микс", 100, false)
bu_addWeapon(102,"Desert Eagle" , "" , "m9k_deaglee" , "models/weapons/w_tcom_deagle.mdl", rare.rare , "Оружейный микс", 100, false)
bu_addWeapon(103,"Beretta" , "" , "wep_m9k_beretta" , "models/weapons/w_beretta_m92.mdl", rare.rare , "Оружейный микс", 100, false)
bu_addWeapon(104,"RBull Scoped" , "" , "wep_m9k_rbscope" , "models/weapons/w_raging_bull_scoped.mdl", rare.rare , "Оружейный микс", 25, false)
bu_addWeapon(105,"P90" , "" , "wep_case_p90" , "models/weapons/3_smg_p90.mdl", rare.rare , "Оружейный микс", 100, false)
bu_addWeapon(106,"MP5" , "" , "wep_case_mp5" , "models/weapons/w_hk_mp5sd.mdl", rare.rare , "Оружейный микс", 100, false)
bu_addWeapon(107,"KRISS Vector" , "" , "m9k_vector" , "models/weapons/w_kriss_vector.mdl", rare.epic , "Оружейный микс", 80, false)
bu_addWeapon(108,"KAC PDW" , "" , "wep_case_kac" , "models/weapons/w_kac_pdw.mdl", rare.epic , "Оружейный микс", 80, false)
bu_addWeapon(109,"FAMAS" , "" , "wep_case_famas" , "models/weapons/3_rif_famas.mdl", rare.epic , "Оружейный микс", 80, false)
bu_addWeapon(110,"AK-47" , "" , "m9k_aka47" , "models/weapons/w_ak47_m9k.mdl", rare.epic , "Оружейный микс", 80, false)
bu_addWeapon(111,"M4A1" , "" , "wep_case_m4a1" , "models/weapons/w_m4a1_iron.mdl", rare.epic , "Оружейный микс", 80, false)
bu_addWeapon(112,"TAR-21" , "" , "wep_case_tar21" , "models/weapons/w_imi_tar21.mdl", rare.ultra , "Оружейный микс", 80, false)
bu_addWeapon(113,"SCAR" , "" , "wep_case_scar" , "models/weapons/w_fn_scar_h.mdl", rare.ultra , "Оружейный микс", 70, false)
bu_addWeapon(114,"AWP" , "" , "wep_case_awp" , "models/weapons/3_snip_awp.mdl", rare.ultra , "Оружейный микс", 70, false)
bu_addWeapon(115,"PSG-1" , "" , "wep_case_psg" , "models/weapons/w_hk_psg1.mdl", rare.ultra , "Оружейный микс", 70, false)
bu_addWeapon(116,"Intervention" , "" , "wep_case_inter" , "models/weapons/w_snip_int.mdl", rare.ultra , "Оружейный микс", 70, false)
bu_addWeapon(117,"Double Barrel" , "" , "case_shotbarrel" , "models/weapons/w_double_barrel_shotgun.mdl", rare.ultra , "Оружейный микс", 60, false)
bu_addWeapon(118,"Striker-12" , "" , "m9k_case_striker12" , "models/weapons/w_striker_12g.mdl", rare.megarare , "Оружейный микс", 60, false)
bu_addWeapon(119,"SPAS-12" , "" , "m9k_case_spas12" , "models/weapons/w_spas_12.mdl", rare.megarare , "Оружейный микс", 60, false)
bu_addWeapon(120,"Jackhammer" , "" , "wep_case_jhammer" , "models/weapons/w_pancor_jackhammer.mdl", rare.megarare , "Оружейный микс", 60, false)
bu_addWeapon(121,"USAS" , "" , "wep_case_usas" , "models/weapons/w_usas_12.mdl", rare.ultrarare , "Оружейный микс", 60, false)
bu_addWeapon(122,"MP7" , "" , "wep_case_mp7" , "models/weapons/w_mp7_silenced.mdl", rare.ultrarare , "Оружейный микс", 60, false)
bu_addWeapon(123,"AS VAL" , "" , "wep_case_m9k_val" , "models/weapons/w_dmg_vally.mdl", rare.ultrarare , "Оружейный микс", 60, false)
bu_addWeapon(124,"Vintorez" , "" , "wep_case_vss" , "models/weapons/w_vss.mdl", rare.ultrarare , "Оружейный микс", 60, false)

bu_addCrate(125,"Кейс Rande" , "Именной кейс ютубера Rande" , Color(178, 0, 255, 255) , true , true ,  300, 300*2)
bu_addMoney(126,"$25.000" , "" , "25k_deneg" , rare.common , "Кейс Rande", 200)
bu_addMoney(127,"$50.000" , "" , "50k_deneg" , rare.common , "Кейс Rabde", 190)
bu_addMoney(128,"$100.000" , "" , "100k_deneg" , rare.common , "Кейс Rande", 180)
bu_addMoney(129,"$500.000" , "" , "500_deneg" , rare.rare , "Кейс Rande", 170)
bu_addMoney(130,"$1.000.000" , "" , "1leam_deneg" , rare.epic , "Кейс Rande", 150)
bu_addMoney(131,"50 Руб." , "" , "igs50p" , rare.epic , "Кейс Rande", 180)
bu_addMoney(132,"100 Руб." , "" , "igs100p" , rare.epic , "Кейс Rande", 150)
bu_addMoney(133,"300 Руб." , "" , "igs300p" , rare.ultra , "Кейс Rande", 120)
bu_addMoney(134,"500 Руб." , "" , "igs500p" , rare.megarare , "Кейс Rande", 80)
bu_addMoney(135,"1000 Руб." , "" , "igs1000p" , rare.ultrarare , "Кейс Rande", 50)
bu_addWeapon(136,"Ковбойка" , "" , "cowboy" , "models/weapons/w_357.mdl", rare.ultrarare , "Кейс Rande", 10, false)

//print("[UNBOXING INFO] UNBOXING CONFIG LOADED!")

if CLIENT then
	// Custom case icons;
	file.CreateDir("unbox")
	BUC2.CustomCrateIcons = {
		[ "Весенний кейс" ] = {"https://i.imgur.com/tDnFY0A.png", "unbox/ivesnakace.jpg"},
		[ "Денежный кейс" ] = {"https://i.imgur.com/6IWoRUx.png", "unbox/imoneycase.jpg"},
		[ "Кейс привилегий" ] = {"https://i.imgur.com/4de79UG.png","unbox/irankscase.jpg"},
		[ "Пистолеты" ] = {"https://i.imgur.com/spFG3A5.png","unbox/ipistcase.jpg"},
		[ "Пистолеты-Пулеметы" ] = {"https://i.imgur.com/SUqjnS6.png","unbox/ippcase.jpg"},
		[ "Штурмовые винтовки" ] = {"https://i.imgur.com/q22Gu8a.png","unbox/ishtrmv.jpg"},
		[ "Снайперские винтовки" ] = {"https://i.imgur.com/RK7Gnia.png","unbox/isnipcase.jpg"},
		[ "Оружейный микс" ] = {"https://i.imgur.com/gH7cLjT.png","unbox/iindmixcase.jpg"},
		[ "Кейс VIBE" ] = {"https://i.imgur.com/8bMt5dj.png","unbox/iinnmixcase.jpg"},
		[ "Кейс Rande" ] = {"https://i.imgur.com/RfBEkGO.png","unbox/randeyoutube.jpg"},
	}

	for k,v in next, BUC2.CustomCrateIcons do
		BUC2.CustomCrateIcons[ k ] = nil
		http.Fetch( v[1], function( data )
			file.Write( v[2], data )
	   		BUC2.CustomCrateIcons[ k ] = Material( "data/" .. v[2] )
	   		BUC2.CustomCrateIcons[ k ]:GetTexture( "$basetexture" ):Download( )
		end )
	end
end

local function getAllWeapons( )
	local result = {}
	for k,v in pairs( BUC2.ITEMS ) do
		if not v.weaponName then continue end
		result[ v.weaponName ] = true
	end
	return result
end
BUC2.UpgradeToItems = getAllWeapons( )
BUC2.UpgradeFromItems = getAllWeapons( )
 
-- BUC2.UpgradeToItems = {
-- 	[ "igs_uid" ] = true,
-- }

--[[	-- Upgrade From .. TO
BUC2.UpgradeFromItems = {
	[ "igs_uid" ] = true,
}
--]]

--leak by matveicher
--vk group - https://vk.com/gmodffdev
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/V329W7Ce8g
--ds - matveicher
