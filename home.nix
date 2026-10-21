{ pkgs, lib, ... }:

{
  imports = [
    ./home/hyprland.nix # Hyprland (config Lua via Home Manager)
    ./home/caelestia.nix # Shell QuickShell "Caelestia"
  ];

  home = {
    username = "chouris";
    homeDirectory = "/home/chouris";
    stateVersion = "26.05";

    # Terminal par défaut (Thunar, xdg-open, les raccourcis "Terminal=true")
    sessionVariables = {
      TERMINAL = "kitty";
    };

    packages = with pkgs; [

      # --- Applications déjà présentes (inchangées) ---
      neovim
      kitty
      fastfetch
      (btop.override { rocmSupport = true; })
      topgrade
      nvd

      mangohud
      protonup-qt
      prismlauncher

      librewolf
      standardnotes
      rustdesk-flutter

      python3
      appimage-run
      unrar

      # --- Bureau Hyprland/Caelestia (remplace les applications KDE) ---
      thunar # gestionnaire de fichiers (remplace Dolphin)
      thunar-volman
      thunar-archive-plugin
      file-roller # archives (remplace Ark)
      imv # visionneuse d'images (remplace Gwenview)
      mpv # vidéo, avec bascule HDR auto en plein écran (voir plus bas)
      pwvucontrol # contrôle audio PipeWire
      seahorse # interface du trousseau GNOME Keyring (remplace KWalletManager)

      # --- Outils Wayland utilisés par Caelestia (CLI, binds, sélecteurs) ---
      grim
      slurp
      swappy # captures d'écran
      gpu-screen-recorder # `caelestia record`
      fuzzel # sélecteurs presse-papiers / emoji de la CLI Caelestia
      cliphist
      wl-clipboard # historique du presse-papiers
      hyprpicker # pipette à couleurs
      libnotify # notify-send
      playerctl
      wireplumber # wpctl (binds volume)
      trash-cli # corbeille + purge automatique au login
      brightnessctl
      ddcutil # luminosité des écrans externes
      bluez # fournit mpris-proxy (commandes média Bluetooth, voir autostart)
    ];

    pointerCursor = {
      enable = true;
      name = "Bibata-Modern-Ice";
      package = pkgs.bibata-cursors;
      size = 24;
      gtk.enable = true;
    };
  };

  # Historique du presse-papiers (watchers wl-paste en services systemd)
  services.cliphist.enable = true;

  # Agent polkit : demandes d'authentification graphiques (gparted, etc.)
  services.hyprpolkitagent.enable = true;

  # Thème sombre cohérent pour les applications GTK/Qt au premier boot.
  # Caelestia recolorera ensuite depuis le fond d'écran (via sa CLI).
  gtk = {
    enable = true;
    theme = {
      name = "adw-gtk3-dark";
      package = pkgs.adw-gtk3;
    };
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };
    font = {
      name = "Inter";
      size = 11;
    };
  };

  qt = {
    enable = true;
    platformTheme.name = "gtk3";
  };

  dconf.settings."org/gnome/desktop/interface".color-scheme = "prefer-dark";

  # Neovim : le paquet nix fournit nvim.desktop avec "Terminal=true", mais
  # Thunar ne trouve aucun terminal sous Hyprland pur ("Unable to find terminal
  # required for application"). On force l'ouverture dans kitty.
  xdg.desktopEntries.nvim = {
    name = "Neovim";
    genericName = "Text Editor";
    comment = "Éditeur de texte dans le terminal kitty";
    exec = "kitty -e nvim %F";
    terminal = false;
    icon = "nvim";
    categories = [ "Utility" "TextEditor" ];
    mimeType = [
      "text/plain"
      "text/x-nix"
      "text/x-lua"
      "text/markdown"
      "text/x-python"
      "application/json"
      "application/x-shellscript"
    ];
  };

  # Terminal par défaut pour les outils Xfce (exo) utilisés par Thunar
  xdg.configFile."xfce4/helpers.rc".text = "TerminalEmulator=kitty\n";

  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "text/html" = "librewolf.desktop";
      "x-scheme-handler/http" = "librewolf.desktop";
      "x-scheme-handler/https" = "librewolf.desktop";

      # Double-clic sur un fichier texte → kitty + nvim
      "text/plain" = "nvim.desktop";
      "text/x-nix" = "nvim.desktop";
      "text/x-lua" = "nvim.desktop";
      "text/markdown" = "nvim.desktop";
      "text/x-python" = "nvim.desktop";
      "application/json" = "nvim.desktop";
      "application/x-shellscript" = "nvim.desktop";
    };
  };

  # mpv : confier la gestion des couleurs à Hyprland pour que la bascule
  # HDR automatique (render.cm_auto_hdr) se déclenche en plein écran.
  xdg.configFile."mpv/mpv.conf".text = ''
    vo=gpu-next
    target-colorspace-hint=yes
    target-colorspace-hint-mode=source
  '';

  # kitty : configuration "seedée" une seule fois. Le fichier reste ensuite
  # modifiable à la main, et la CLI Caelestia peut écrire theme.conf à côté
  # pour suivre les couleurs du fond d'écran.
  home.activation.seedKittyConfig = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    $DRY_RUN_CMD mkdir -p "$HOME/.config/kitty"
    if [ ! -e "$HOME/.config/kitty/kitty.conf" ]; then
      $DRY_RUN_CMD install -m644 ${./home/kitty.conf} "$HOME/.config/kitty/kitty.conf"
    fi
    $DRY_RUN_CMD touch "$HOME/.config/kitty/theme.conf"
  '';

  programs = {
    home-manager.enable = true;

    obs-studio = {
      enable = true;
      plugins = with pkgs.obs-studio-plugins; [ obs-vkcapture ];
    };

    fish = {
      enable = true;
      shellAliases = {
        sc = "cd /etc/nixos && git add . && git commit -m \"Update\" && git push";
        ff = "fastfetch";
        rs = "sudo nixos-rebuild switch --flake /etc/nixos#NixOS";
        tg = "topgrade -y";
      };
      interactiveShellInit = ''
        set fish_greeting
        fastfetch
      '';
    };
  };
}
