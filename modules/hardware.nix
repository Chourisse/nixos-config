{ pkgs, lib, ... }:

{
  hardware = {
    enableRedistributableFirmware = true;
    bluetooth.enable = true;
    amdgpu.overdrive.enable = true;

    graphics = {
      enable = true;
      enable32Bit = true;
      extraPackages = with pkgs; [
        rocmPackages.clr.icd
      ];
    };
  };

  zramSwap.enable = true;

  fileSystems = let
    btrfsOpts = [ "compress=zstd" "noatime" ];
  in {
    "/".options = lib.mkForce btrfsOpts;
    "/home".options = lib.mkForce ([ "subvol=home" ] ++ btrfsOpts);
    "/nix".options = lib.mkForce ([ "subvol=nix" ] ++ btrfsOpts);
  };

  services = {
    fstrim.enable = true;
    fwupd.enable = true;
    lact.enable = true;

    hardware.deepcool-digital-linux = {
      enable = true;
      extraArgs = [ "--mode" "gpu" ];
    };
  };

  systemd.tmpfiles.rules = [
    "z /sys/class/hwmon/hwmon*/power*_input 0444 root root -"
  ];
}
