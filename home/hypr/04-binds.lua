-- Raccourcis clavier/souris.
-- Base : dotfiles caelestia-dots/caelestia (hypr/hyprland/keybinds.lua),
-- adaptés à tes applications (kitty, Librewolf, Neovim, thunar, Steam).
-- Aide-mémoire complet dans MIGRATION-HYPRLAND.md.
--
-- Les actions "caelestia:..." sont des global shortcuts exposés par le shell :
-- c'est le canal officiel pour piloter launcher/drawers/lock depuis Hyprland.

local locked = { locked = true } -- actif même écran verrouillé
local repeating = { repeating = true }
local locked_repeating = { locked = true, repeating = true }
local release = { release = true } -- au relâchement de la touche
local mouse = { mouse = true }

-- ---------------------------------------------------------------------------
-- Helpers
-- ---------------------------------------------------------------------------

-- Workspaces groupés par dizaine, un groupe par écran (logique Caelestia) :
-- SUPER+3 agit sur le 3e workspace de l'écran courant, CTRL+SUPER+3 change
-- de groupe (= d'écran de référence).
local function wsaction(action, range, i)
    return function()
        local activews = hl.get_active_workspace()
        if activews then
            local id = activews.id
            local s = (i - 1) * 10 + (id % 10)
            local t = math.floor((id - 1) / 10) * 10 + i
            local z = (range == "group") and s or t

            if action == "move" then
                return hl.dispatch(hl.dsp.window.move({ workspace = z }))
            else
                return hl.dispatch(hl.dsp.focus({ workspace = z }))
            end
        end
    end
end

local function resize_by_screen(x, y)
    local screen = hl.get_active_monitor()
    if screen and type(screen.width) == "number" and type(screen.height) == "number" then
        if not (x == 0 and y == 0) then
            local w = (x and x > 0) and math.floor(screen.width * x / 100) or screen.width
            local h = (y and y > 0) and math.floor(screen.height * y / 100) or screen.height
            return { x = w, y = h, relative = false }
        end
    end
end

local function resize_active_window(x, y)
    return function()
        local win = hl.get_active_window()
        if win and win.size then
            local w = (win.size.x * (x / 100)) or 800
            local h = (win.size.y * (y / 100)) or 600
            hl.dispatch(hl.dsp.window.resize({ x = w, y = h, relative = true }))
        else
            hl.dispatch(hl.dsp.no_op())
        end
    end
end

local function move_actions(win)
    local screen = hl.get_active_monitor()

    if screen and screen.width and screen.height and win and win.size then
        local monitor_height = screen.height / screen.scale
        local monitor_width = screen.width / screen.scale

        local scale_factor = (monitor_height / 4) / win.size.y
        local target_width = win.size.x * scale_factor
        local target_height = win.size.y * scale_factor

        local x_resize = math.floor(math.max(200, target_width))
        local y_resize = math.floor(math.max(150, target_height))

        local offset = math.min(monitor_width, monitor_height) * 0.03
        local move_x = math.floor(screen.x + monitor_width - x_resize - offset)
        local move_y = math.floor(screen.y + monitor_height - y_resize - offset)

        return {
            hl.dsp.window.resize({ x = x_resize, y = y_resize, window = win }),
            hl.dsp.window.move({ x = move_x, y = move_y, relative = false, window = win }),
            hl.dsp.window.set_prop({ prop = "keep_aspect_ratio", value = "true", window = win }),
        }
    end
end

-- Bascule un special workspace ("tiroir")
local function toggle_special(name)
    return function()
        hl.dispatch(hl.dsp.workspace.toggle_special(name))
    end
end

-- Tiroir moniteur système : lance btop (dans kitty) s'il ne tourne pas déjà
local function toggle_sysmon()
    local running = false
    for _, w in ipairs(hl.get_windows() or {}) do
        if w.class == "btop" then
            running = true
            break
        end
    end
    if not running then
        hl.dispatch(hl.dsp.exec_cmd("kitty --class btop -e btop", { workspace = "special:sysmon" }))
    end
    hl.dispatch(hl.dsp.workspace.toggle_special("sysmon"))
end

-- Tiroir générique : ferme celui qui est ouvert, sinon ouvre "special"
local function toggle_any_special()
    local active = hl.get_active_special_workspace()
    local target = active and active.name:gsub("^special:", "") or "special"
    hl.dispatch(hl.dsp.workspace.toggle_special(target))
end

-- ---------------------------------------------------------------------------
-- Shell Caelestia
-- ---------------------------------------------------------------------------

-- Launcher : appui bref sur Super seul (signature Caelestia), ou SUPER+Espace
hl.bind("SUPER + SUPER_L", hl.dsp.global("caelestia:launcher"), release)
hl.bind("SUPER + Space", hl.dsp.global("caelestia:launcher"))

hl.bind("CTRL + ALT + Delete", hl.dsp.global("caelestia:session")) -- menu session
hl.bind("SUPER + N", hl.dsp.global("caelestia:sidebar")) -- barre latérale/notifs
hl.bind("CTRL + ALT + C", hl.dsp.global("caelestia:clearNotifs"), locked)
hl.bind("SUPER + K", hl.dsp.global("caelestia:showall")) -- tous les panneaux
hl.bind("SUPER + L", hl.dsp.global("caelestia:lock")) -- verrouiller

-- Entretien du shell (service systemd utilisateur "caelestia")
hl.bind("SUPER + ALT + L", hl.dsp.exec_cmd("systemctl --user restart caelestia"), release) -- redémarrer le shell
hl.bind("CTRL + SUPER + SHIFT + R", hl.dsp.exec_cmd("systemctl --user stop caelestia"), release) -- tuer le shell
hl.bind("CTRL + SUPER + ALT + R", hl.dsp.exec_cmd("systemctl --user restart caelestia"), release)

-- Mise en veille manuelle (aucune veille auto : voir shell.json)
hl.bind("SUPER + SHIFT + L", hl.dsp.exec_cmd("systemctl suspend"), locked)

-- ---------------------------------------------------------------------------
-- Workspaces
-- ---------------------------------------------------------------------------

for i = 1, 10 do
    local key = i % 10 -- le workspace 10 est sur la touche 0
    hl.bind("SUPER + " .. key, wsaction("focus", "", i))
    hl.bind("SUPER + ALT + " .. key, wsaction("move", "", i))
    hl.bind("CTRL + SUPER + " .. key, wsaction("focus", "group", i))
    hl.bind("CTRL + SUPER + ALT + " .. key, wsaction("move", "group", i))
end

-- Workspace précédent/suivant
for _, k in ipairs({ "SUPER + Page_Up", "CTRL + SUPER + Left", "SUPER + mouse_up" }) do
    hl.bind(k, hl.dsp.focus({ workspace = "-1" }), repeating)
end
for _, k in ipairs({ "SUPER + Page_Down", "CTRL + SUPER + Right", "SUPER + mouse_down" }) do
    hl.bind(k, hl.dsp.focus({ workspace = "+1" }), repeating)
end

-- Groupe (écran) précédent/suivant
hl.bind("CTRL + SUPER + mouse_up", hl.dsp.focus({ workspace = "-10" }), repeating)
hl.bind("CTRL + SUPER + mouse_down", hl.dsp.focus({ workspace = "+10" }), repeating)

-- Fenêtre vers workspace précédent/suivant
for _, k in ipairs({ "SUPER + ALT + Page_Up", "SUPER + ALT + mouse_up" }) do
    hl.bind(k, hl.dsp.window.move({ workspace = "-1" }), repeating)
end
for _, k in ipairs({ "SUPER + ALT + Page_Down", "SUPER + ALT + mouse_down" }) do
    hl.bind(k, hl.dsp.window.move({ workspace = "+1" }), repeating)
end

-- Fenêtre vers/depuis le tiroir générique
hl.bind("SUPER + ALT + S", hl.dsp.window.move({ workspace = "special:special" }))
hl.bind("CTRL + SUPER + SHIFT + Down", hl.dsp.window.move({ workspace = "e+0" }))

-- ---------------------------------------------------------------------------
-- Fenêtres : focus, déplacement, taille, groupes (onglets)
-- ---------------------------------------------------------------------------

for _, dir in ipairs({ "left", "right", "up", "down" }) do
    hl.bind("SUPER + " .. dir, hl.dsp.focus({ direction = dir }))
    hl.bind("SUPER + SHIFT + " .. dir, hl.dsp.window.move({ direction = dir }))
end

hl.bind("ALT + Tab", hl.dsp.window.cycle_next(), repeating)
hl.bind("SHIFT + ALT + Tab", hl.dsp.window.cycle_next({ next = false }), repeating)
hl.bind("CTRL + ALT + Tab", hl.dsp.group.next(), repeating)
hl.bind("CTRL + SHIFT + ALT + Tab", hl.dsp.group.prev(), repeating)
hl.bind("SUPER + Comma", hl.dsp.group.toggle())
hl.bind("SUPER + SHIFT + Comma", hl.dsp.group.lock_active())
hl.bind("SUPER + U", hl.dsp.window.move({ out_of_group = true }))

-- Redimensionnement au clavier (répétition maintenue)
hl.bind("SUPER + Minus", resize_active_window(-10, 0), repeating)
hl.bind("SUPER + Equal", resize_active_window(10, 0), repeating)
hl.bind("SUPER + SHIFT + Minus", resize_active_window(0, -10), repeating)
hl.bind("SUPER + SHIFT + Equal", resize_active_window(0, 10), repeating)
hl.bind("SUPER + ALT + Left", resize_active_window(-10, 0), repeating)
hl.bind("SUPER + ALT + Right", resize_active_window(10, 0), repeating)
hl.bind("SUPER + ALT + Up", resize_active_window(0, -10), repeating)
hl.bind("SUPER + ALT + Down", resize_active_window(0, 10), repeating)

-- Souris : déplacer/redimensionner en maintenant Super
hl.bind("SUPER + mouse:272", hl.dsp.window.drag(), mouse)
hl.bind("SUPER + mouse:273", hl.dsp.window.resize(), mouse)

hl.bind("CTRL + SUPER + Backslash", hl.dsp.window.center())
hl.bind("CTRL + SUPER + ALT + Backslash", function() -- fenêtre "normalisée" 55% x 70%, centrée
    hl.dispatch(hl.dsp.window.resize(resize_by_screen(55, 70)))
    hl.dispatch(hl.dsp.window.center())
end)
hl.bind("SUPER + ALT + Backslash", function() -- fenêtre en mode PiP épinglé
    local a = hl.get_active_window()
    if a then
        local pip = move_actions(a) or {}
        if not a.floating then
            table.insert(pip, 1, hl.dsp.window.float())
        end
        table.insert(pip, hl.dsp.window.pin({ action = "on", window = "address:" .. a.address }))
        for _, x in ipairs(pip) do
            hl.dispatch(x)
        end
    end
end)
hl.bind("SUPER + P", hl.dsp.window.pin())
hl.bind("SUPER + F", hl.dsp.window.fullscreen({ mode = "fullscreen" }))
hl.bind("SUPER + ALT + F", hl.dsp.window.fullscreen({ mode = "maximized" }))
hl.bind("SUPER + ALT + Space", hl.dsp.window.float())
hl.bind("SUPER + Q", hl.dsp.window.close())

-- ---------------------------------------------------------------------------
-- Tiroirs (special workspaces)
-- ---------------------------------------------------------------------------

hl.bind("SUPER + S", toggle_any_special)
hl.bind("CTRL + SHIFT + Escape", toggle_sysmon) -- btop
hl.bind("SUPER + M", toggle_special("music"))
hl.bind("SUPER + D", toggle_special("communication"))
hl.bind("SUPER + R", toggle_special("todo"))

-- ---------------------------------------------------------------------------
-- Applications
-- ---------------------------------------------------------------------------

hl.bind("SUPER + T", hl.dsp.exec_cmd("kitty"))
hl.bind("SUPER + W", hl.dsp.exec_cmd("librewolf"))
hl.bind("SUPER + C", hl.dsp.exec_cmd("kitty -e nvim"))
hl.bind("SUPER + E", hl.dsp.exec_cmd("thunar"))
hl.bind("SUPER + G", hl.dsp.exec_cmd("steam"))
hl.bind("CTRL + ALT + V", hl.dsp.exec_cmd("pwvucontrol"))

-- ---------------------------------------------------------------------------
-- Captures et enregistrement
-- ---------------------------------------------------------------------------

hl.bind("Print", hl.dsp.exec_cmd("caelestia screenshot"), locked)
hl.bind("SUPER + SHIFT + S", hl.dsp.global("caelestia:screenshotFreeze"))
hl.bind("SUPER + SHIFT + ALT + S", hl.dsp.global("caelestia:screenshot"))
hl.bind("CTRL + ALT + R", hl.dsp.exec_cmd("caelestia record"))
hl.bind("SUPER + ALT + R", hl.dsp.exec_cmd("caelestia record -s"))
hl.bind("SUPER + SHIFT + ALT + R", hl.dsp.exec_cmd("caelestia record -r"))
hl.bind("SUPER + SHIFT + C", hl.dsp.exec_cmd("hyprpicker -a"))

-- ---------------------------------------------------------------------------
-- Luminosité, média, volume
-- ---------------------------------------------------------------------------

hl.bind("XF86MonBrightnessUp", hl.dsp.global("caelestia:brightnessUp"), locked)
hl.bind("XF86MonBrightnessDown", hl.dsp.global("caelestia:brightnessDown"), locked)

for _, k in ipairs({ "CTRL + SUPER + Space", "XF86AudioPlay", "XF86AudioPause" }) do
    hl.bind(k, hl.dsp.global("caelestia:mediaToggle"), locked)
end
for _, k in ipairs({ "CTRL + SUPER + Equal", "XF86AudioNext" }) do
    hl.bind(k, hl.dsp.global("caelestia:mediaNext"), locked)
end
for _, k in ipairs({ "CTRL + SUPER + Minus", "XF86AudioPrev" }) do
    hl.bind(k, hl.dsp.global("caelestia:mediaPrev"), locked)
end
for _, k in ipairs({ "CTRL + SUPER + Backspace", "XF86AudioStop" }) do
    hl.bind(k, hl.dsp.global("caelestia:mediaStop"), locked)
end

for _, k in ipairs({ "SUPER + SHIFT + M", "XF86AudioMute" }) do
    hl.bind(k, hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"), locked)
end
hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"), locked)
hl.bind(
    "XF86AudioRaiseVolume",
    hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ 0; wpctl set-volume -l 1.0 @DEFAULT_AUDIO_SINK@ 10%+"),
    locked_repeating
)
hl.bind(
    "XF86AudioLowerVolume",
    hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ 0; wpctl set-volume @DEFAULT_AUDIO_SINK@ 10%-"),
    locked_repeating
)

-- ---------------------------------------------------------------------------
-- Presse-papiers et emoji (via la CLI Caelestia, sélecteur fuzzel)
-- ---------------------------------------------------------------------------

hl.bind("SUPER + V", hl.dsp.exec_cmd("pkill fuzzel || caelestia clipboard"))
hl.bind("SUPER + ALT + V", hl.dsp.exec_cmd("pkill fuzzel || caelestia clipboard -d"))
hl.bind("SUPER + Period", hl.dsp.exec_cmd("pkill fuzzel || caelestia emoji -p"))
