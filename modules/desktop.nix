{ pkgs, lib, ... }:

let
  tomlFormat = pkgs.formats.toml { };
in
{
  # ---------------------------------------------------------------------------
  # Compositeur : Hyprland, session gérée par UWSM (recommandé par le wiki NixOS)
  # ---------------------------------------------------------------------------
  programs.hyprland = {
    enable = true;
    withUWSM = true; # crée la session "Hyprland (uwsm-managed)" dans le greeter
    xwayland.enable = true; # Steam et les applications X11
  };

  # Portail GTK en plus de celui de Hyprland (sélecteur de fichiers, etc.)
  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };

  # Force les applications Electron/Chromium en Wayland natif
  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  # ---------------------------------------------------------------------------
  # Login : greetd + ReGreet (GTK4), stylé aux couleurs de Caelestia
  # Caelestia n'a pas de greeter officiel : c'est l'équivalent déclaratif.
  # ReGreet tourne dans le compositeur minimal "cage".
  # ---------------------------------------------------------------------------
  # SDDM (ancien écran de login Plasma) doit être coupé explicitement
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

  # Le greeter a besoin d'accéder à la carte graphique (sinon écran noir)
  users.users.greeter.extraGroups = [
    "video"
    "render"
  ];

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

    # Fond "#101418" (surface sombre de Caelestia) + coins arrondis Material
    "greetd/regreet.css".text = ''
      window {
        background-color: #101418;
      }

      entry, button, combobox button {
        border-radius: 14px;
      }
    '';
  };

  # Thèmes devant être visibles par la session du greeter (utilisateur "greeter")
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

  # ---------------------------------------------------------------------------
  # Trousseau de clés (remplace KWallet), déverrouillé automatiquement au login
  # ---------------------------------------------------------------------------
  services.gnome.gnome-keyring.enable = true;
  security.pam.services.greetd.enableGnomeKeyring = true;

  # ---------------------------------------------------------------------------
  # Services que Plasma fournissait : fichiers, vignettes, montages, profils
  # ---------------------------------------------------------------------------
  services = {
    gvfs.enable = true; # corbeille, MTP et réseau dans Thunar
    tumbler.enable = true; # vignettes dans Thunar
    udisks2.enable = true; # montage des périphériques
    power-profiles-daemon.enable = true; # profils de performance dans Caelestia
  };

  # DDC/CI : permet à Caelestia (via ddcutil) de régler la luminosité des écrans
  hardware.i2c.enable = true;

  # ---------------------------------------------------------------------------
  # Audio (inchangé par rapport à l'ancienne configuration Plasma)
  # ---------------------------------------------------------------------------
  services.pulseaudio.enable = false;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    wireplumber.enable = true;
  };

  # Requis pour PipeWire
  security.rtkit.enable = true;
}
