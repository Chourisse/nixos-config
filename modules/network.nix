{ ... }:

{
  networking = {
    hostName = "NixOS";
    networkmanager.enable = true;
    networkmanager.dns = "none";
    nameservers = [ "9.9.9.9" "149.112.112.112" "2620:fe::fe" "2620:fe::9" ];
  };

  services.mullvad-vpn = {
    enable = true;
    gui.enable = true;
  };
}
