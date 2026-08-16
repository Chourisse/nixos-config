{ config, pkgs, ... }:

{
  home.username = "chouris";
  home.homeDirectory = "/home/chouris";
  home.stateVersion = "26.05";

  programs.home-manager.enable = true;

  # Fish : alias et lancement de Fastfetch
  programs.fish = {
    enable = true;
    shellAliases = {
      sc = "cd /etc/nixos && git add . && git commit -m \"Update Config\" && git push";
      ff = "fastfetch";
      rs = "sudo nixos-rebuild switch --flake /etc/nixos#NixOS";
      tg = "topgrade -y";
    };
    interactiveShellInit = ''
      set fish_greeting
      fastfetch
    '';
  };

  # Paquets utilisateur
  home.packages = with pkgs; [
    neovim
    kitty
    fastfetch
    librewolf
    (btop.override { rocmSupport = true; })
    topgrade
    goverlay
    mangohud
    protonup-qt
    prismlauncher
    zed-editor
    standardnotes
    rustdesk-flutter
    pinta
    vesktop
    python3
  ];
}
