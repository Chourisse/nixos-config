{ lib, ... }:

{
  networking = {
    hostName = "NixOS";

    networkmanager = {
      enable = true;
      dns = lib.mkForce "none";

      wifi = {
        backend = "iwd";
        powersave = false;
        scanRandMacAddress = false;
      };
    };
  };

  services.resolved = {
    enable = true;

    settings.Resolve = {
      FallbackDNS = [
        "1.1.1.1#cloudflare-dns.com"
        "1.0.0.1#cloudflare-dns.com"
        "2606:4700:4700::1111#cloudflare-dns.com"
        "2606:4700:4700::1001#cloudflare-dns.com"
      ];

      DNSSEC = "allow-downgrade";
      DNSOverTLS = "opportunistic";
    };
  };

  services.mullvad-vpn = {
    enable = true;
    gui.enable = true;
  };
}
