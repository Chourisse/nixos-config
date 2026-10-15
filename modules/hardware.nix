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
    "/".options = btrfsOpts;
    "/home".options = btrfsOpts;
    "/nix".options = btrfsOpts;
  };

  services = {
    fstrim.enable = true;
    fwupd.enable = true;
    lact.enable = true;

    hardware.deepcool-digital-linux = {
      enable = true;
      extraArgs = [ "--mode" "gpu" ];
    };

    btrbk.instances."nixos" = {
      onCalendar = "hourly";
      settings = {
        timestamp_format = "long";
        snapshot_preserve_min = "2d";
        snapshot_preserve = "48h 7d 4w";
        volume."/" = {
          snapshot_dir = ".snapshots";
          subvolume = {
            "home" = {};
          };
        };
      };
    };
  };

  systemd.tmpfiles.rules = [
    "z /sys/class/hwmon/hwmon*/power*_input 0444 root root -"
  ];
}
