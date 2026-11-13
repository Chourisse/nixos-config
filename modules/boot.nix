{ pkgs, lib, ... }:

{
  boot = {
    kernelPackages = pkgs.linuxPackages_cachyos;
    kernelParams = [ "acpi_enforce_resources=lax" ];
    tmp.cleanOnBoot = true;

    loader = {
      efi.canTouchEfiVariables = true;
      systemd-boot.enable = lib.mkForce false;
    };

    lanzaboote = {
      enable = true;
      pkiBundle = "/etc/secureboot";
    };
  };
}
