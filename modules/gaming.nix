{ pkgs, chaotic, ... }:

{
  programs = {
    steam.enable = true;
    gamemode.enable = true;

    gamescope = {
      enable = true;
      package = chaotic.packages.${pkgs.system}.gamescope_git;
    };
  };
}
