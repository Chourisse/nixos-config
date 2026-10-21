{ ... }:

{
  imports = [
    ./hardware-configuration.nix

    ./modules/boot.nix
    ./modules/hardware.nix
    ./modules/network.nix
    ./modules/locale.nix
    ./modules/desktop.nix
    ./modules/gaming.nix
    ./modules/nix.nix
    ./modules/users.nix
  ];

  system.stateVersion = "26.05";
}
