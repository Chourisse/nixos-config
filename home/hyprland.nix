{ config, ... }:

{
  wayland.windowManager.hyprland = {
    enable = true;

    package = null;
    portalPackage = null;

    configType = "lua";

    systemd.enable = false;

    settings.config = {

      general = {
        layout = "dwindle";
        allow_tearing = true;
        gaps_workspaces = 20;
        gaps_in = 5;
        gaps_out = 10;
        border_size = 1;
        col = {
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
          special = false; 
          ignore_opacity = true;
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

      animations.enabled = true;

      input = {
        kb_layout = "us";
        numlock_by_default = true;
        repeat_delay = 250;
        repeat_rate = 35;
        focus_on_close = 1;
        sensitivity = 0;
        accel_profile = "flat";
      };

      binds.scroll_event_delay = 0;
      cursor.hotspot_padding = 1;

      misc = {
        animate_manual_resizes = false;
        animate_mouse_windowdragging = false;
        disable_hyprland_logo = true;
        force_default_wallpaper = 0; 
        on_focus_under_fullscreen = 2;
        allow_session_lock_restore = true; 
        middle_click_paste = false;
        focus_on_activate = true;
        session_lock_xray = true;
        mouse_move_enables_dpms = true;
        key_press_enables_dpms = true;
        background_color = "rgb(101418)";
      };

      render = {
        cm_enabled = true;
        cm_auto_hdr = 1;
        direct_scanout = 0;
        send_content_type = true;
      };

      quirks.prefer_hdr = 2;

      xwayland.force_zero_scaling = true;
    };

    extraLuaFiles = {
      "00-animations" = ./hypr/00-animations.lua;
      "01-monitors" = ./hypr/01-monitors.lua;
      "02-env" = ./hypr/02-env.lua;
      "03-rules" = ./hypr/03-rules.lua;
      "04-binds" = ./hypr/04-binds.lua;
      "05-autostart" = ./hypr/05-autostart.lua;
    };
  };

  xdg.configFile."uwsm/env".source =
    "${config.home.sessionVariablesPackage}/etc/profile.d/hm-session-vars.sh";
}
