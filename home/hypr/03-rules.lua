-- Règles de fenêtres, workspaces et layers.
-- Adapté des dotfiles caelestia-dots/caelestia (hypr/hyprland/rules.lua) :
-- on tague les fenêtres par famille, puis on définit chaque tag une seule fois.

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
local music_player_tag = "music_player"
local communication_app_tag = "communication_app"
local todo_app_tag = "todo_app"

-- ---------------------------------------------------------------------------
-- Règles générales
-- ---------------------------------------------------------------------------

-- Légère transparence partout, sauf en plein écran (le look "verre" de Caelestia)
hl.window_rule({ match = { fullscreen = false }, opacity = "1 override" })

-- Centrer les fenêtres flottantes (sauf XWayland : ses popups sont des fenêtres)
hl.window_rule({ match = { float = true, xwayland = false }, center = true })

-- Picture-in-picture : épinglé, flottant, ratio conservé, coin bas-droit
hl.window_rule({
    match             = { title = "Picture(-| )in(-| )[Pp]icture" },
    move              = "(monitor_w*0.98-window_w) (monitor_h*0.97-window_h)",
    pin               = true,
    float             = true,
    keep_aspect_ratio = true,
})

-- ---------------------------------------------------------------------------
-- Familles d'applications
-- ---------------------------------------------------------------------------

-- Toujours opaques (contenu où la transparence gêne)
tagged_rule(opaque_tag, {
    "kitty",                         -- terminal
    "org.quickshell",                -- Quickshell/Caelestia
    "feh|imv|swappy",                -- visionneuses d'images
    "krita|gimp|inkscape|darktable", -- édition d'image
    "resolve|kdenlive|shotcut",      -- montage vidéo
    "blender|godot",                 -- 3D
    "mpv|obs-studio",                -- vidéo / capture
}, "class")

-- Flottantes
tagged_rule(float_tag, {
    "yad|zenity",                       -- dialogues
    "org.kde.ark|ark",                    -- archives
    "org.gnome.seahorse.Application",   -- trousseau
}, "class")
tagged_rule(float_tag, {
    "File (Operation|Upload)( Progress)?", -- progression copie/déplacement
    ".* Properties",                        -- propriétés de fichier
    'Rename ".*"',                          -- renommage
}, "title")

-- Flottantes dimensionnées (dialogues de fichiers, réglages...)
tagged_rule(float_60_70_tag, {
    "(Select|Open)( a)? (File|Folder)(s)?",
    "Save As",
    "Library",
}, "title")
tagged_rule(float_60_70_tag, {
    "org.pulseaudio.pavucontrol|com.saivert.pwvucontrol", -- audio
}, "class")
tagged_rule(float_50_60_tag, {
    "system-config-printer",
}, "class")

-- Jeux : opaques, tearing autorisé (immediate), jamais d'extinction d'écran
tagged_rule(game_tag, {
    "steam_app_[0-9]+",  -- jeux Steam
    "steam_app_default", -- jeux Lutris
    "gamescope",         -- gamescope (HDR)
    "Minecraft.*",       -- Minecraft (PrismLauncher)
}, "class")

-- Lunar Client / Minecraft Java : forcer le vrai plein écran
-- (sinon la fenêtre reste fenêtrée et le menu Caelestia reste visible à gauche)
hl.window_rule({ match = { class = "^(java|Minecraft.*)$" }, fullscreen = true })
hl.window_rule({ match = { title = "^(Minecraft.*|Lunar Client \\(.*)$" }, fullscreen = true })

-- Popups XWayland parasites (fenêtres invisibles de Steam, etc.)
tagged_rule(xwl_popup_tag, {
    { xwayland = true, title = "win[0-9]+" },
    { xwayland = true, title = "", class = "", initial_title = "", initial_class = "" },
})

-- Special workspaces (tiroirs) : SUPER+M musique, SUPER+D comm, SUPER+R todo,
-- CTRL+SHIFT+Échap moniteur système (btop)
tagged_rule(system_monitor_tag, { "btop" }, "class")
tagged_rule(music_player_tag, {
    "feishin|Supersonic|Plexamp",
    "Spotify",
    "Cider",
    "com.github.th-ch.youtube-music|com-maxrave-simpmusic-MainKt",
}, "class")
tagged_rule(music_player_tag, { "Spotify|Spotify Free" }, "initial_title")
tagged_rule(communication_app_tag, {
    "discord|equibop|vesktop",
    "whatsapp",
}, "class")
tagged_rule(todo_app_tag, { "todoist" }, "class")

-- Steam : liste d'amis flottante, popups vides neutralisées
tagged_rule(float_tag, { { class = "steam", title = "Friends List" } })
tagged_rule(xwl_popup_tag, { { class = "steam", title = "" } })

-- ---------------------------------------------------------------------------
-- Définitions des tags (doivent venir après les tagged_rule)
-- ---------------------------------------------------------------------------

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
create_tag(music_player_tag, { workspace = "special:music" })
create_tag(communication_app_tag, { workspace = "special:communication" })
create_tag(todo_app_tag, { workspace = "special:todo" })

-- ---------------------------------------------------------------------------
-- Workspaces : plus d'air quand une seule fenêtre est ouverte
-- ---------------------------------------------------------------------------

hl.workspace_rule({ workspace = "w[tv1]s[false]", gaps_out = 20 })
hl.workspace_rule({ workspace = "f[1]s[false]", gaps_out = 20 })

-- ---------------------------------------------------------------------------
-- Layers (shell et outils)
-- ---------------------------------------------------------------------------

hl.layer_rule({ match = { namespace = "hyprpicker" }, animation = "fade" })
hl.layer_rule({ match = { namespace = "selection" }, animation = "fade" }) -- slurp
hl.layer_rule({ match = { namespace = "launcher" }, animation = "popin 80%", blur = true }) -- fuzzel

-- Caelestia
hl.layer_rule({ match = { namespace = "caelestia-(border-exclusion|area-picker)" }, no_anim = true })
hl.layer_rule({ match = { namespace = "caelestia-(drawers|background)" }, animation = "fade" })
