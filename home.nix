{ pkgs, lib, ... }:

{
  imports = [
    ./home/hyprland.nix
    ./home/caelestia.nix
  ];

  home = {
    username = "chouris";
    homeDirectory = "/home/chouris";
    stateVersion = "26.05";

    sessionVariables = {
      TERMINAL = "kitty";
    };

    packages = with pkgs; [

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
      brave
      standardnotes
      rustdesk-flutter

      python3
      appimage-run
      unrar

      kdePackages.dolphin
      kdePackages.ark
      kdePackages.kdegraphics-thumbnailers
      kdePackages.ffmpegthumbs
      kdePackages.kio-extras
      imv
      mpv
      pwvucontrol
      seahorse

      grim
      slurp
      swappy
      gpu-screen-recorder
      fuzzel
      cliphist
      wl-clipboard
      hyprpicker
      libnotify
      playerctl
      wireplumber
      trash-cli
      brightnessctl
      ddcutil
      bluez
    ];

    pointerCursor = {
      enable = true;
      name = "Bibata-Modern-Ice";
      package = pkgs.bibata-cursors;
      size = 24;
      gtk.enable = true;
    };
  };

  services.cliphist.enable = true;

  services.hyprpolkitagent.enable = true;

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

  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "text/html" = "librewolf.desktop";
      "x-scheme-handler/http" = "librewolf.desktop";
      "x-scheme-handler/https" = "librewolf.desktop";

      "inode/directory" = "org.kde.dolphin.desktop";
      "application/zip" = "org.kde.ark.desktop";
      "application/x-tar" = "org.kde.ark.desktop";
      "application/gzip" = "org.kde.ark.desktop";
      "application/x-7z-compressed" = "org.kde.ark.desktop";
      "application/vnd.rar" = "org.kde.ark.desktop";

      "text/plain" = "nvim.desktop";
      "text/x-nix" = "nvim.desktop";
      "text/x-lua" = "nvim.desktop";
      "text/markdown" = "nvim.desktop";
      "text/x-python" = "nvim.desktop";
      "application/json" = "nvim.desktop";
      "application/x-shellscript" = "nvim.desktop";
    };
  };

  xdg.configFile."mpv/mpv.conf".text = ''
    vo=gpu-next
  '';

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
        sc = "cd /etc/nixos && git add -A; and git diff --cached --quiet; or git commit -m \"Update\"; and git pull --rebase origin main; and git push";
        ff = "fastfetch";
        rs = "sudo nixos-rebuild switch --flake /etc/nixos#NixOS";
        tg = "topgrade -y";
      };
      interactiveShellInit = ''
        set fish_greeting
        fastfetch

        function nix
            if test "$argv[1]" = run
                nohup command nix run $argv[2..] >/dev/null 2>&1 &
                disown
            else
                command nix $argv
            end
        end
      '';
    };
  };
}
