{ pkgs, ... }:

{
  networking = {
    hostName = "NixOS";
    networkmanager.enable = true;

    # iwd : backend bien plus stable et rapide que wpa_supplicant
    # (meilleur roaming, association plus rapide, moins de pertes de paquets)
    networkmanager.wifi.backend = "iwd";

    # Désactive l'économie d'énergie WiFi (source n°1 de débits faibles
    # et de déconnexions sur l'Intel AX200)
    networkmanager.wifi.powersave = false;

    # iwd doit être activé pour que NetworkManager puisse l'utiliser comme backend
    # (c'est ce module qui génère /etc/iwd/main.conf)
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

  # --- Intel AX200 : réglages pilote ---
  boot.extraModprobeConfig = ''
    # power_save=0 : désactive le power saving côté iwlwifi
    # uapsd_disable=1 : désactive U-APSD, connu pour causer des instabilités
    # avec certaines box/routeurs sur AX200
    options iwlwifi power_save=0 uapsd_disable=1 disable_11ax=1
    # Domaine réglementaire FR : puissance d'émission maximale légale
    options cfg80211 ieee80211_regdom="FR"
  '';

  # L'ASPM PCIe agressif provoque des freezes/déconnexions connus sur l'AX200
  boot.kernelParams = [ "pcie_aspm=off" ];

  # Power management matériel : on garde la carte WiFi (et le Bluetooth USB) allumés en permanence
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
