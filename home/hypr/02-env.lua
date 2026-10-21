-- Variables d'environnement de la session (applications lancées par Hyprland).
-- Les services systemd utilisateur reçoivent en plus les variables Home Manager
-- via ~/.config/uwsm/env (voir home/hyprland.nix).

-- Curseur
hl.env("XCURSOR_THEME", "Bibata-Modern-Ice")
hl.env("XCURSOR_SIZE", "24")

-- Boîtes à outils en Wayland natif
hl.env("GDK_BACKEND", "wayland,x11")
hl.env("QT_QPA_PLATFORM", "wayland;xcb")
hl.env("QT_WAYLAND_DISABLE_WINDOWDECORATION", "1")
hl.env("QT_AUTO_SCREEN_SCALE_FACTOR", "1")
hl.env("SDL_VIDEODRIVER", "wayland,x11,windows")
hl.env("CLUTTER_BACKEND", "wayland")
hl.env("ELECTRON_OZONE_PLATFORM_HINT", "auto")

-- Terminal par défaut (Thunar, xdg-open, les raccourcis "Terminal=true")
hl.env("TERMINAL", "kitty")

-- Session
hl.env("XDG_CURRENT_DESKTOP", "Hyprland")
hl.env("XDG_SESSION_TYPE", "wayland")
hl.env("XDG_SESSION_DESKTOP", "Hyprland")

-- Java AWT (PrismLauncher, etc.)
hl.env("_JAVA_AWT_WM_NONREPARENTING", "1")
