{ pkgs, ... }:

{
  networking = {
    hostName = "NixOS";
    networkmanager.enable = true;

    networkmanager.wifi.backend = "iwd";

    networkmanager.wifi.powersave = false;

    wireless.iwd = {
      enable = true;
      settings = {
        General = {
          EnableNetworkConfiguration = true;
        };
        Scan = {
          DisablePeriodicScanning = false;
        };
        Network = {
          NameResolvingService = "systemd";
        };
      };
    };

    nameservers = [
      "9.9.9.9"
      "149.112.112.112"
      "2620:fe::fe"
      "2620:fe::9"
    ];
  };

  services.udev.extraRules = ''
    ACTION=="add", SUBSYSTEM=="net", KERNEL=="wlan*", RUN+="${pkgs.iw}/bin/iw dev %k set power_save off"
    ACTION=="add", SUBSYSTEM=="pci", ATTR{class}=="0x028000", ATTR{power/control}="on"
    ACTION=="add", SUBSYSTEM=="usb", ATTR{bInterfaceClass}=="e0", ATTR{power/control}="on"
  '';

  services.resolved = {
    enable = true;

    settings.Resolve = {
      DNS = [
        "9.9.9.9#dns.quad9.net"
        "149.112.112.112#dns.quad9.net"
      ];

      FallbackDNS = [
        "2620:fe::fe"
        "2620:fe::9"
      ];

      Domains = [ "~." ];
      DNSSEC = "allow-downgrade";
      DNSOverTLS = "opportunistic";
    };
  };

  services.mullvad-vpn = {
    enable = true;
    gui.enable = true;
  };
}
