if not CLIENT then return end

local BLOCKED = {
    ["muzzleflash_light"] = true,
    ["mp_decals"] = true,
    ["mat_forceaniso"] = true,
    ["r_shadowrendertotexture"] = true,
    ["mat_hdr_level"] = true,
    ["r_teeth"] = true,
    ["mat_hdr_enabled"] = true,
    ["r_shadows"] = true,
    ["violence_hblood"] = true,
}

local ALLOWED = {
    ["gmod_mcore_test"] = true,
    ["r_fastzreject"] = true,
    ["cl_ejectbrass"] = true,
    ["in_usekeyboardsampletime"] = true,
    ["rope_wind_dist"] = true,
    ["cl_playerspraydisable"] = true,
    ["mat_disable_fancy_blending"] = true,
    ["r_decals"] = true,
    ["rope_shake"] = true,
    ["r_dynamic"] = true,
    ["r_decal_cullsize"] = true,
    ["cl_smooth"] = true,
    ["studio_queue_mode"] = true,
    ["cl_show_splashes"] = true,
    ["cl_phys_props_enable"] = true,
    ["mat_disable_bloom"] = true,
    ["props_break_max_pieces"] = true,
    ["violence_agibs"] = true,
    ["violence_hgibs"] = true,
    ["cl_threaded_client_leaf_system"] = true,
    ["r_threaded_client_shadow_manager"] = true,
    ["r_threaded_particles"] = true,
    ["r_threaded_renderables"] = true,
    ["r_queued_ropes"] = true,
    ["joystick"] = true,
    ["violence_ablood"] = true,
    ["r_lod"] = true,
    ["cl_threaded_bone_setup"] = true,
    ["rope_smooth"] = true,
    ["cl_detaildist"] = true,
    ["r_3dsky"] = true,
    ["mat_disable_lightwarp"] = true,
    ["r_drawmodeldecals"] = true,
    ["mat_queue_mode"] = true,
    ["cl_forcepreload"] = true,
    ["cl_detail_avoid_radius"] = true,
    ["net_compressvoice"] = true,
    ["r_maxmodeldecal"] = true,
    ["r_eyemove"] = true,
    ["snd_mix_async"] = true,
    ["r_drawflecks"] = true,
    ["demo_avellimit"] = true,
    ["r_worldlights"] = true,
}

local function SafeSet(cmd, val)
    if BLOCKED[cmd] or not ALLOWED[cmd] then return end

    local cvar = GetConVar(cmd)
    if cvar then
        local flags = cvar:GetFlags() or 0
        if bit.band(flags, FCVAR_REPLICATED) == 0 then
            pcall(cvar.SetString, cvar, tostring(val))
        end
    end
end

local opt = {
    ["gmod_mcore_test"] = "1",
    ["datacachesize"] = "512",
    ["r_fastzreject"] = "-1",
    ["cl_ejectbrass"] = "0",
    ["cl_wpn_sway_interp"] = "0",
    ["in_usekeyboardsampletime"] = "0",
    ["rope_wind_dist"] = "0",
    ["cl_playerspraydisable"] = "1",
    ["mat_disable_fancy_blending"] = "1",
    ["r_decals"] = "70",
    ["rope_shake"] = "0",
    ["r_dynamic"] = "1",
    ["r_decal_cullsize"] = "0",
    ["cl_smooth"] = "0",
    ["studio_queue_mode"] = "1",
    ["cl_show_splashes"] = "0",
    ["cl_phys_props_enable"] = "0",
    ["mat_disable_bloom"] = "1",
    ["props_break_max_pieces"] = "0",
    ["violence_agibs"] = "0",
    ["violence_hgibs"] = "0",
    ["cl_threaded_client_leaf_system"] = "1",
    ["r_threaded_client_shadow_manager"] = "1",
    ["r_threaded_particles"] = "1",
    ["r_threaded_renderables"] = "1",
    ["r_queued_ropes"] = "1",
    ["joystick"] = "0",
    ["violence_ablood"] = "0",
    ["r_lod"] = "-1",
    ["cl_threaded_bone_setup"] = "1",
    ["rope_smooth"] = "0",
    ["cl_detaildist"] = "400",
    ["r_3dsky"] = "0",
    ["mat_disable_lightwarp"] = "1",
    ["r_drawmodeldecals"] = "0",
    ["mat_queue_mode"] = "-1",
    ["cl_forcepreload"] = "1",
    ["cl_detail_avoid_radius"] = "30",
    ["net_compressvoice"] = "1",
    ["r_maxmodeldecal"] = "0",
    ["r_eyemove"] = "0",
    ["snd_mix_async"] = "1",
    ["r_drawflecks"] = "0",
    ["demo_avellimit"] = "0",
    ["r_worldlights"] = "1",
}

concommand.Add("FPS_BOOST", function()
    for cmd, val in pairs(opt) do
        SafeSet(cmd, val)
    end
    if chat then
        chat.AddText(Color(100, 255, 100), "[FPS] Boost applied safely")
    end
end)