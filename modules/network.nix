{ ... }:

{
  networking = {
    hostName = "NixOS";
    networkmanager.enable = true;

    nameservers = [
      "9.9.9.9"
      "149.112.112.112"
      "2620:fe::fe"
      "2620:fe::9"
    ];
  };

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
