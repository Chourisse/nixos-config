{ config, ... }:

{
  wayland.windowManager.hyprland = {
    enable = true;

    # Le binaire et le portail sont fournis par le module NixOS (programs.hyprland)
    package = null;
    portalPackage = null;

    # Hyprland ≥ 0.55 : configuration Lua (hyprlang est déprécié)
    configType = "lua";

    # La session systemd est gérée par UWSM (côté système) : surtout pas
    # l'intégration systemd de Home Manager, elles entrent en conflit.
    systemd.enable = false;

    # Réglages purement "données" -> traduits en un appel hl.config({ ... }).
    # Tout ce qui est logique (moniteurs, binds, règles) vit dans ./hypr/*.lua
    settings.config = {

      general = {
        layout = "dwindle";
        allow_tearing = true; # requis pour la règle "immediate" sur les jeux
        gaps_workspaces = 20;
        gaps_in = 5;
        gaps_out = 10;
        border_size = 1;
        col = {
          # Couleurs fixes : le shell Caelestia, lui, se recolore tout seul
          # depuis le fond d'écran ; les bordures Hyprland ne suivent pas.
          active_border = "rgba(a8c7fae6)";
          inactive_border = "rgba(8e919911)";
        };
      };

      dwindle = {
        preserve_split = true;
        smart_split = false;
        smart_resizing = true;
      };

      decoration = {
        rounding = 15;
        rounding_power = 2;

        blur = {
          enabled = true;
          xray = false;
          special = false; # pas de flou derrière les special workspaces
          ignore_opacity = true; # permet le flou des fenêtres semi-transparentes
          new_optimizations = true;
          popups = true;
          input_methods = true;
          size = 8;
          passes = 2;
        };

        shadow = {
          enabled = true;
          range = 15;
          render_power = 4;
          color = "rgba(00000040)";
        };
      };

      # Les courbes d'animation détaillées sont dans hypr/00-animations.lua
      animations.enabled = true;

      input = {
        # "us" comme dans l'ancienne config. Passage en AZERTY possible ici
        # ("fr"), mais tous les raccourcis de hypr/04-binds.lua sont pensés
        # en disposition US (SUPER+Q etc.).
        kb_layout = "us";
        numlock_by_default = true;
        repeat_delay = 250;
        repeat_rate = 35;
        focus_on_close = 1;
        sensitivity = 0;
        accel_profile = "flat"; # aucune accélération souris (gaming)
      };

      binds.scroll_event_delay = 0;
      cursor.hotspot_padding = 1;

      misc = {
        animate_manual_resizes = false;
        animate_mouse_windowdragging = false;
        disable_hyprland_logo = true;
        force_default_wallpaper = 0; # le fond d'écran est géré par Caelestia
        on_focus_under_fullscreen = 2;
        allow_session_lock_restore = true; # récupère le lock Caelestia si le shell crashe
        middle_click_paste = false;
        focus_on_activate = true;
        session_lock_xray = true;
        mouse_move_enables_dpms = true;
        key_press_enables_dpms = true;
        background_color = "rgb(101418)";
      };

      # ---------------------------------------------------------------------
      # HDR / gestion des couleurs
      # Stratégie : bureau SDR (mais 10 bit + wide gamut via cm="auto" sur
      # l'écran principal, voir hypr/01-monitors.lua) et bascule automatique
      # en HDR dès qu'un contenu HDR passe en plein écran.
      #   cm_auto_hdr = 1 -> primaires BT.2020 (preset "hdr")
      #   cm_auto_hdr = 2 -> primaires lues dans l'EDID (preset "hdredid"),
      #                      à essayer si les couleurs HDR semblent fausses.
      # ---------------------------------------------------------------------
      render = {
        cm_enabled = true;
        cm_auto_hdr = 1;
      };

      # Annonce le HDR comme "préféré" à gamescope (détection HDR dans les jeux)
      quirks.prefer_hdr = 2;

      # XWayland toujours à l'échelle native (utile si un jour scale != 1)
      xwayland.force_zero_scaling = true;
    };

    # Fichiers Lua de la configuration Hyprland (chargés dans cet ordre)
    extraLuaFiles = {
      "00-animations" = ./hypr/00-animations.lua;
      "01-monitors" = ./hypr/01-monitors.lua;
      "02-env" = ./hypr/02-env.lua;
      "03-rules" = ./hypr/03-rules.lua;
      "04-binds" = ./hypr/04-binds.lua;
      "05-autostart" = ./hypr/05-autostart.lua;
    };
  };

  # Expose les variables de session Home Manager à UWSM, pour que les
  # services systemd utilisateur (Caelestia, cliphist, polkit...) les voient.
  xdg.configFile."uwsm/env".source =
    "${config.home.sessionVariablesPackage}/etc/profile.d/hm-session-vars.sh";
}
