if not CLIENT then return end

local WHITELIST = {
    "gmod_mcore_test",
    "r_fastzreject",
    "cl_ejectbrass",
    "in_usekeyboardsampletime",
    "rope_shake",
    "rope_wind_dist",
    "mat_disable_ps_patch",
    "mat_disable_fancy_blending",
    "r_decal_cullsize",
    "r_decals",
    "studio_queue_mode",
    "cl_phys_props_enable",
    "mat_disable_bloom",
    "cl_phys_props_max",
    "props_break_max_pieces",
    "r_propsmaxdist",
    "violence_agibs",
    "violence_hgibs",
    "cl_threaded_client_leaf_system",
    "r_threaded_client_shadow_manager",
    "r_threaded_particles",
    "r_threaded_renderables",
    "r_queued_ropes",
    "joystick",
    "violence_ablood",
    "cl_show_splashes",
    "r_lod",
    "r_shadowmaxrendered",
    "mat_shadowstate",
    "cl_threaded_bone_setup",
    "rope_smooth",
    "cl_detaildist",
    "mat_bloomscale",
    "mat_disable_lightwarp",
    "r_drawmodeldecals",
    "cl_forcepreload",
    "cl_detail_avoid_radius",
    "net_compressvoice",
    "r_maxmodeldecal",
    "r_drawdetailprops",
    "r_eyemove",
    "r_flex",
    "snd_mix_async",
    "r_drawflecks",
    "cl_showhelp",
    "nb_shadow_dist",
    "demo_avellimit",
    "r_maxdlights",
    "cl_detailfade",
    "r_3dsky",
    "mat_queue_mode",
    "cl_interp",
}

local ALLOWED = {}
for _, v in ipairs(WHITELIST) do ALLOWED[v] = true end

local function SetSafe(cmd, val)
    if not ALLOWED[cmd] then return end

    local cvar = GetConVar(cmd)
    if not cvar then return end

    local flags = cvar:GetFlags() or 0
    if bit.band(flags, FCVAR_REPLICATED) ~= 0 then return end

    pcall(cvar.SetString, cvar, tostring(val))
end

timer.Simple(25, function()
    timer.Simple(0.5, function()
        SetSafe("gmod_mcore_test", 1)
        SetSafe("r_fastzreject", -1)
    end)

    timer.Simple(1, function()
        SetSafe("cl_ejectbrass", 0)
        SetSafe("in_usekeyboardsampletime", 0)
        SetSafe("rope_shake", 0)
    end)

    timer.Simple(1.5, function()
        SetSafe("rope_wind_dist", 0)
        SetSafe("mat_disable_ps_patch", 1)
        SetSafe("mat_disable_fancy_blending", 1)
    end)

    timer.Simple(2, function()
        SetSafe("r_decal_cullsize", 0)
        SetSafe("r_decals", 2)
        SetSafe("studio_queue_mode", 1)
    end)

    timer.Simple(2.5, function()
        SetSafe("cl_phys_props_enable", 0)
        SetSafe("mat_disable_bloom", 1)
    end)

    timer.Simple(3, function()
        SetSafe("cl_phys_props_max", 0)
        SetSafe("props_break_max_pieces", 0)
        SetSafe("r_propsmaxdist", 0)
    end)

    timer.Simple(3.5, function()
        SetSafe("violence_agibs", 0)
        SetSafe("violence_hgibs", 0)
        SetSafe("cl_threaded_client_leaf_system", 1)
    end)

    timer.Simple(4, function()
        SetSafe("r_threaded_client_shadow_manager", 1)
        SetSafe("r_threaded_particles", 1)
        SetSafe("r_threaded_renderables", 1)
        SetSafe("r_queued_ropes", 1)
    end)

    timer.Simple(4.5, function()
        SetSafe("joystick", 0)
        SetSafe("violence_ablood", 0)
        SetSafe("cl_show_splashes", 0)
    end)

    timer.Simple(5.5, function()
        SetSafe("r_lod", 0)
        SetSafe("r_shadowmaxrendered", 0)
    end)

    timer.Simple(6, function()
        SetSafe("mat_shadowstate", 0)
        SetSafe("cl_threaded_bone_setup", 1)
        SetSafe("rope_smooth", 0)
        SetSafe("cl_detaildist", 0)
    end)

    timer.Simple(6.5, function()
        SetSafe("mat_bloomscale", 0)
    end)

    timer.Simple(7, function()
        SetSafe("mat_disable_lightwarp", 1)
        SetSafe("r_drawmodeldecals", 0)
    end)

    timer.Simple(7.5, function()
        SetSafe("cl_forcepreload", 1)
        SetSafe("cl_detail_avoid_radius", 0)
        SetSafe("net_compressvoice", 1)
    end)

    timer.Simple(8, function()
        SetSafe("snd_mix_async", 1)
        SetSafe("r_drawflecks", 0)
        SetSafe("cl_showhelp", 0)
        SetSafe("nb_shadow_dist", 0)
    end)

    timer.Simple(8.5, function()
        SetSafe("demo_avellimit", 0)
        SetSafe("r_maxdlights", 6)
        SetSafe("cl_detailfade", 1)
    end)

    timer.Simple(10, function()
        if GetConVar("3dskyoff") and GetConVar("3dskyoff"):GetInt() == 0 then
            SetSafe("r_3dsky", 0)
        end
    end)

    timer.Simple(12, function()
        SetSafe("r_maxmodeldecal", 0)
        SetSafe("r_drawdetailprops", 0)
        SetSafe("r_eyemove", 0)
        SetSafe("r_flex", 0)
    end)

    timer.Simple(15, function()
        SetSafe("mat_queue_mode", -1)
    end)
end)

hook.Add("InitPostEntity", "azd_fps", function()
    LocalPlayer():ConCommand("snd_restart; cl_drawmonitors 0; cl_tree_sway_dir .5 .5; r_drawflecks 1")
    hook.Remove("StartChat", "StartChatIndicator")
    hook.Remove("FinishChat", "EndChatIndicator")
end)

timer.Create("fps_cl_interp", 1, 0, function()
    local online = #player.GetAll()
    local lerp = online > 75 and math.Clamp(online * 3, 60, 250) or 120
    SetSafe("cl_interp", lerp / 1000)
end)