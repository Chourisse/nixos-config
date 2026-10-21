{ pkgs, lib, ... }:

let
  tomlFormat = pkgs.formats.toml { };
in
{
  programs.hyprland = {
    enable = true;
    withUWSM = true;
    xwayland.enable = true;
  };

  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };

  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  services.displayManager.sddm.enable = lib.mkForce false;
  services.displayManager.autoLogin.enable = lib.mkForce false;

  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.dbus}/bin/dbus-run-session ${lib.getExe pkgs.cage} -s -- ${lib.getExe pkgs.regreet}";
        user = "greeter";
      };
      terminal.vt = 1;
    };
  };

  users.users.greeter.extraGroups = [
    "video"
    "render"
  ];

  services.accounts-daemon.enable = true;

  environment.etc = {
    "greetd/regreet.toml".source = tomlFormat.generate "regreet.toml" {
      GTK = {
        application_prefer_dark_theme = true;
        theme_name = "adw-gtk3-dark";
        icon_theme_name = "Papirus-Dark";
        cursor_theme_name = "Bibata-Modern-Ice";
        font_name = "Rubik 16";
      };
      commands = {
        reboot = [
          "systemctl"
          "reboot"
        ];
        poweroff = [
          "systemctl"
          "poweroff"
        ];
      };
      appearance.greeting_msg = "Bienvenue";
    };

    "greetd/regreet.css".text = ''
      window {
        background-color: #101418;
      }

      entry, button, combobox button {
        border-radius: 14px;
      }
    '';
  };

  environment.systemPackages = with pkgs; [
    regreet
    adw-gtk3
    papirus-icon-theme
    bibata-cursors
  ];

  systemd.tmpfiles.rules = [
    "d /var/log/regreet 0755 greeter greeter -"
    "d /var/lib/regreet 0755 greeter greeter -"
    "d /var/cache/regreet 0755 greeter greeter -"
  ];

  services.gnome.gnome-keyring.enable = true;
  security.pam.services.greetd.enableGnomeKeyring = true;

  services = {
    gvfs.enable = true;
    tumbler.enable = true;
    udisks2.enable = true;
    power-profiles-daemon.enable = true;
  };

  hardware.i2c.enable = true;

  services.pulseaudio.enable = false;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    wireplumber.enable = true;
  };

  security.rtkit.enable = true;
}
