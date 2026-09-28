{ ... }:

{
  networking = {
    hostName = "NixOS";
    networkmanager.enable = true;
    nameservers = [ "9.9.9.9" "149.112.112.112" "2620:fe::fe" "2620:fe::9" ];
  };

  # Mullvad VPN
  services.mullvad-vpn = {
    enable = true;
    gui.enable = true;
  };
}
