--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher

sound.Add( {
	name = "csgo_knife.Deploy",
	channel = CHAN_WEAPON,
	volume = 0.4,
	level = 65,
	sound = "csgo_knife/knife_deploy1.mp3"
} )

sound.Add( {
	name = "csgo_knife.Hit",
	channel = CHAN_WEAPON,
	volume = 1.0,
	level = 65,
	sound = { "csgo_knife/knife_hit1.mp3", "csgo_knife/knife_hit2.mp3", "csgo_knife/knife_hit3.mp3", "csgo_knife/knife_hit4.mp3" }
} )

sound.Add( {
	name = "csgo_knife.HitWall",
	channel = CHAN_WEAPON,
	volume = 1.0,
	level = 65,
	sound = { "csgo_knife/knife_hit_01.mp3", "csgo_knife/knife_hit_02.mp3", "csgo_knife/knife_hit_03.mp3", "csgo_knife/knife_hit_04.mp3", "csgo_knife/knife_hit_05.mp3" }
} )

sound.Add( {
	name = "csgo_knife.HitWall_old",
	channel = CHAN_WEAPON,
	volume = 1.0,
	level = 65,
	sound = { "csgo_knife/knife_hitwall1.mp3", "csgo_knife/knife_hitwall2.mp3", "csgo_knife/knife_hitwall3.mp3", "csgo_knife/knife_hitwall4.mp3" }
} )

sound.Add( {
	name = "csgo_knife.Slash",
	channel = CHAN_WEAPON,
	volume = {0.5, 1.0},
	pitch = {97, 105},
	level = 65,
	sound = { "csgo_knife/knife_slash1.mp3", "csgo_knife/knife_slash2.mp3" }
} )

sound.Add( {
	name = "csgo_knife.Slash_old",
	channel = CHAN_WEAPON,
	volume = {0.5, 1.0},
	pitch = {97, 105},
	level = 65,
	sound = { "csgo_knife/knife_slash1_old.mp3", "csgo_knife/knife_slash2_old.mp3" }
} )

sound.Add( {
	name = "csgo_knife.Stab",
	channel = CHAN_WEAPON,
	volume = 1.0,
	level = 65,
	sound = "csgo_knife/knife_stab.mp3"
} )

-- Butterfly
sound.Add( {
	name = "csgo_ButterflyKnife.backstab01",
	channel = CHAN_ITEM,
	volume = 0.4,
	soundlevel = 65,
	sound = "csgo_knife/bknife_backstab01.mp3"
} )

sound.Add( {
	name = "csgo_ButterflyKnife.backstab02",
	channel = CHAN_ITEM,
	volume = 0.4,
	soundlevel = 65,
	sound = "csgo_knife/bknife_backstab02.mp3"
} )

sound.Add( {
	name = "csgo_ButterflyKnife.draw01",
	channel = CHAN_ITEM,
	volume = 0.6,
	soundlevel = 65,
	sound = "csgo_knife/bknife_draw01.mp3"
} )

sound.Add( {
	name = "csgo_ButterflyKnife.draw02",
	channel = CHAN_ITEM,
	volume = 0.6,
	soundlevel = 65,
	sound = "csgo_knife/bknife_draw02.mp3"
} )

sound.Add( {
	name = "csgo_ButterflyKnife.look01_a",
	channel = CHAN_ITEM,
	volume = 0.4,
	soundlevel = 65,
	sound = "csgo_knife/bknife_look01_a.mp3"
} )

sound.Add( {
	name = "csgo_ButterflyKnife.look01_b",
	channel = CHAN_ITEM,
	volume = 0.4,
	soundlevel = 65,
	sound = "csgo_knife/bknife_look01_b.mp3"
} )

sound.Add( {
	name = "csgo_ButterflyKnife.look02_a",
	channel = CHAN_ITEM,
	volume = 0.4,
	soundlevel = 65,
	sound = "csgo_knife/bknife_look02_a.mp3"
} )

sound.Add( {
	name = "csgo_ButterflyKnife.look02_b",
	channel = CHAN_ITEM,
	volume = 0.4,
	soundlevel = 65,
	sound = "csgo_knife/bknife_look02_b.mp3"
} )

sound.Add( {
	name = "csgo_ButterflyKnife.look03_a",
	channel = CHAN_ITEM,
	volume = 0.4,
	soundlevel = 65,
	sound = "csgo_knife/bknife_look03_a.mp3"
} )

sound.Add( {
	name = "csgo_ButterflyKnife.look03_b",
	channel = CHAN_ITEM,
	volume = 0.4,
	soundlevel = 65,
	sound = "csgo_knife/bknife_look03_b.mp3"
} )

sound.Add( {
	name = "csgo_KnifeFalchion.inspect",
	channel = CHAN_STATIC,
	volume = 1,
	soundlevel = 65,
	sound = "csgo_knife/knife_falchion_inspect.mp3"
} )

sound.Add( {
	name = "csgo_KnifeFalchion.draw",
	channel = CHAN_STATIC,
	volume = {0.4, 0.9},
	pitch = {97, 105},
	soundlevel = 65,
	sound = "csgo_knife/knife_falchion_draw.mp3"
} )

sound.Add( {
	name = "csgo_KnifeFalchion.Catch",
	channel = CHAN_STATIC,
	volume = {0.3, 0.7},
	pitch = {97, 105},
	soundlevel = 65,
	sound = "csgo_knife/knife_falchion_catch.mp3"
} )

sound.Add( {
	name = "csgo_KnifeFalchion.Idlev2",
	channel = CHAN_STATIC,
	volume = 1,
	soundlevel = 65,
	sound = "csgo_knife/knife_falchion_idle.mp3"
} )

sound.Add( {
	name = "csgo_Weapon.WeaponMove1", 
	channel = CHAN_ITEM,
	volume = 0.15,
	soundlevel = 65,
	sound = "csgo_knife/movement1.mp3"
} )

sound.Add( {
	name = "csgo_Weapon.WeaponMove3",
	channel = CHAN_ITEM,
	volume = 0.15,
	soundlevel = 65,
	sound = "csgo_knife/movement3.mp3"
} )

sound.Add( {
	name = "csgo_Weapon.WeaponMove2",
	channel = CHAN_ITEM,
	volume = 0.15,
	soundlevel = 65,
	sound = "csgo_knife/movement2.mp3"
} )

sound.Add( {
	name = "csgo_KnifePush.Attack1Heavy",
	channel = CHAN_STATIC,
	volume = {0.1, 0.2},
	pitch = {98, 105},
	level = 65,
	sound = { "csgo_knife/knife_push_attack1_heavy_01.mp3", "csgo_knife/knife_push_attack1_heavy_02.mp3", "csgo_knife/knife_push_attack1_heavy_03.mp3", "csgo_knife/knife_push_attack1_heavy_04.mp3" }
} )

sound.Add( {
	name = "csgo_KnifePush.LookAtStart",
	channel = CHAN_STATIC,
	volume = 0.2,
	level = 65,
	sound = { "csgo_knife/knife_push_lookat_start.mp3" }
} )

sound.Add( {
	name = "csgo_KnifePush.LookAtEnd",
	channel = CHAN_STATIC,
	volume = 0.2,
	level = 65,
	sound = { "csgo_knife/knife_push_lookat_end.mp3" }
} )

sound.Add( {
	name = "csgo_KnifePush.Draw",
	channel = CHAN_STATIC,
	volume = 0.3,
	level = 65,
	sound = { "csgo_knife/knife_push_draw.mp3" }
} )

sound.Add( {
	name = "KnifeBowie.draw",
	channel = CHAN_STATIC,
	volume = {0.7, 0.8},
    pitch = {99, 100},
	level = 65,
	sound = { "csgo_knife/knife_bowie_draw.mp3" }
} )

sound.Add( {
	name = "KnifeBowie.LookAtStart",
	channel = CHAN_STATIC,
	volume = {0.2, 0.2},
    pitch = {99, 100},
	level = 65,
	sound = { "csgo_knife/knife_bowie_inspect_start.mp3" }
} )

sound.Add( {
	name = "KnifeBowie.LookAtEnd",
	channel = CHAN_STATIC,
	volume = {0.2, 0.3},
    pitch = {99, 101},
	level = 65,
	sound = { "csgo_knife/knife_bowie_inspect_end.mp3" }
} )

--leak by matveicher
--vk group - https://vk.com/codespill
--steam - https://steamcommunity.com/profiles/76561198968457747/
--ds server - https://discord.gg/7XaRzQSZ45
--ds - matveicher
