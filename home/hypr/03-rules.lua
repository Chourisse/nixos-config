local function tagged_rule(tag, matches, field)
    for _, match in ipairs(matches) do
        if field then
            local t = {}
            t[field] = match
            match = t
        end
        hl.window_rule({ match = match, tag = "+" .. tag })
    end
end

local function create_tag(tag, rules)
    local rule = { match = { tag = tag } }
    for k, v in pairs(rules) do
        rule[k] = v
    end
    hl.window_rule(rule)
end

local opaque_tag = "opaque"
local float_tag = "float"
local float_50_60_tag = "float_50_60"
local float_60_70_tag = "float_60_70"
local float_70_80_tag = "float_70_80"
local game_tag = "game"
local xwl_popup_tag = "xwl_popup"
local system_monitor_tag = "system_monitor"


hl.window_rule({ match = { fullscreen = false }, opacity = "1 override" })


hl.window_rule({ match = { float = true, xwayland = false }, center = true })

hl.window_rule({
    match             = { title = "Picture(-| )in(-| )[Pp]icture" },
    move              = "(monitor_w*0.98-window_w) (monitor_h*0.97-window_h)",
    pin               = true,
    float             = true,
    keep_aspect_ratio = true,
})


tagged_rule(opaque_tag, {
    "kitty",
    "org.quickshell",
    "feh|imv|swappy",
    "krita|gimp|inkscape|darktable",
    "resolve|kdenlive|shotcut",
    "blender|godot",
    "mpv|obs-studio",
}, "class")


tagged_rule(float_tag, {
    "yad|zenity",
    "org.kde.ark|ark",
    "org.gnome.seahorse.Application",
}, "class")
tagged_rule(float_tag, {
    "File (Operation|Upload)( Progress)?",
    ".* Properties",
    'Rename ".*"',
}, "title")


tagged_rule(float_60_70_tag, {
    "(Select|Open)( a)? (File|Folder)(s)?",
    "Save As",
    "Library",
}, "title")
tagged_rule(float_60_70_tag, {
    "org.pulseaudio.pavucontrol|com.saivert.pwvucontrol",
}, "class")
tagged_rule(float_50_60_tag, {
    "system-config-printer",
}, "class")


tagged_rule(game_tag, {
    "steam_app_[0-9]+",
    "steam_app_default",
    "gamescope",
    "Minecraft.*",
    "Lunar Client [0-9].*",
}, "class")


hl.window_rule({ match = { class = "^(java|Minecraft.*|Lunar Client [0-9].*)$" }, fullscreen = true })
hl.window_rule({ match = { title = "^(Minecraft.*|Lunar Client [0-9].*)$" }, fullscreen = true })


tagged_rule(xwl_popup_tag, {
    { xwayland = true, title = "win[0-9]+" },
    { xwayland = true, title = "", class = "", initial_title = "", initial_class = "" },
})


tagged_rule(system_monitor_tag, { "btop" }, "class")


tagged_rule(float_tag, { { class = "steam", title = "Friends List" } })
tagged_rule(xwl_popup_tag, { { class = "steam", title = "" } })


create_tag(opaque_tag, { opaque = true })
create_tag(float_tag, { float = true })
create_tag(float_50_60_tag, { float = true, size = "(monitor_w*0.5) (monitor_h*0.6)", center = true })
create_tag(float_60_70_tag, { float = true, size = "(monitor_w*0.6) (monitor_h*0.7)", center = true })
create_tag(float_70_80_tag, { float = true, size = "(monitor_w*0.7) (monitor_h*0.8)", center = true })
create_tag(game_tag, { opaque = true, immediate = true, idle_inhibit = "always" })
create_tag(xwl_popup_tag, {
    no_dim    = true,
    no_shadow = true,
    no_blur   = true,
    opaque    = true,
    rounding  = 10,
})
create_tag(system_monitor_tag, { workspace = "special:sysmon" })


hl.workspace_rule({ workspace = "w[tv1]s[false]", gaps_out = 20 })
hl.workspace_rule({ workspace = "f[1]s[false]", gaps_out = 20 })


hl.layer_rule({ match = { namespace = "hyprpicker" }, animation = "fade" })
hl.layer_rule({ match = { namespace = "selection" }, animation = "fade" })
hl.layer_rule({ match = { namespace = "launcher" }, animation = "popin 80%", blur = true })


hl.layer_rule({ match = { namespace = "caelestia-(border-exclusion|area-picker)" }, no_anim = true })
hl.layer_rule({ match = { namespace = "caelestia-(drawers|background)" }, animation = "fade" })
