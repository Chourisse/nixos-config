{ pkgs, ... }:

{
  home = {
    username = "chouris";
    homeDirectory = "/home/chouris";
    stateVersion = "26.05";

    packages = with pkgs; [

      neovim
      kitty
      fastfetch
      (btop.override { rocmSupport = true; })
      topgrade
      nvd
      obs-studio-plugins.obs-vkcapture

      mangohud
      protonup-qt
      prismlauncher

      librewolf
      standardnotes
      rustdesk-flutter

      python3
      appimage-run
      unrar
    ];
  };

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
