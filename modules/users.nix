{ pkgs, ... }:

{
  programs.fish.enable = true;

  users.users."chouris" = {
    isNormalUser = true;
    description = "Chouris";
    extraGroups = [
      "networkmanager"
      "wheel"
      "video"
      "render"
      "i2c"
    ];
    shell = pkgs.fish;
  };
}
