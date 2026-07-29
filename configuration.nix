{ config, pkgs, lib, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  # ==========================================
  # 1. Système & Démarrage
  # ==========================================
  boot = {
    kernelPackages = pkgs.linuxPackages_xanmod_latest;
    kernelParams = [ "amdgpu.ppfeaturemask=0xffffffff" "acpi_enforce_resources=lax" ];
    tmp.cleanOnBoot = true;

    # Configuration de l'EFI
    loader.efi.canTouchEfiVariables = true;

    # Desactivation de systemd-boot
    loader.systemd-boot.enable = lib.mkForce false;

    # Lanzaboote (module fourni par flake.nix)
    lanzaboote = {
      enable = true;
      pkiBundle = "/etc/secureboot";
    };
  };

  # ==========================================
  # 2. Matériel & Réseau
  # ==========================================
  networking = {
    hostName = "NixOS";
    networkmanager.enable = true;
    nameservers = [ "9.9.9.9" "149.112.112.112" "2620:fe::fe" "2620:fe::9" ];
  };

  hardware = {
    bluetooth.enable = true;
    enableRedistributableFirmware = true;
    amdgpu.overdrive.enable = true;

    graphics = {
      enable = true;
      enable32Bit = true;
    };
  };

  zramSwap.enable = true;

  # Consommation CPU (Wattage)
  systemd.tmpfiles.rules = [
    "z /sys/class/hwmon/hwmon*/power*_input 0444 root root -"
    "z /sys/class/powercap/intel-rapl:*/energy_uj 0444 root root -"
  ];

  # ==========================================
  # 3. Localisation & Polices
  # ==========================================
  time.timeZone = "Europe/Paris";

  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocaleSettings = {
      LC_ADDRESS = "fr_FR.UTF-8";
      LC_IDENTIFICATION = "fr_FR.UTF-8";
      LC_MEASUREMENT = "fr_FR.UTF-8";
      LC_MONETARY = "fr_FR.UTF-8";
      LC_NAME = "fr_FR.UTF-8";
      LC_NUMERIC = "fr_FR.UTF-8";
      LC_PAPER = "fr_FR.UTF-8";
      LC_TELEPHONE = "fr_FR.UTF-8";
      LC_TIME = "fr_FR.UTF-8";
    };
  };

  fonts = {
    packages = with pkgs; [
      noto-fonts
      noto-fonts-color-emoji
      inter
      nerd-fonts.jetbrains-mono
      nerd-fonts.fira-code
    ];
    fontconfig.defaultFonts = {
      serif = [ "Noto Serif" ];
      sansSerif = [ "Inter" ];
      monospace = [ "JetBrainsMono Nerd Font" ];
    };
  };

  # ==========================================
  # 4. Environnement de Bureau & Services
  # ==========================================
  services = {
    # Serveur X
    xserver = {
      enable = true;
      xkb = {
        layout = "us";
        variant = "";
      };
    };

    # Gestionnaire de bureau et Connexion automatique
    displayManager = {
      sddm.enable = true;
      autoLogin = {
        enable = true;
        user = "chouris";
      };
    };
    desktopManager.plasma6.enable = true;

    hardware.deepcool-digital-linux = {
      enable = true;
      extraArgs = [ "--mode" "gpu" ];
    };

    # Services d'optimisation et matériels
    fstrim.enable = true;
    fwupd.enable = true;
    lact.enable = true;

    # Mullvad VPN (Daemon et CLI uniquement)
    mullvad-vpn = {
      enable = true;
      package = pkgs.mullvad;
    };

    # Gestion du Son (PipeWire)
    pulseaudio.enable = false;
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };
  };

  # Requis pour la planification temps réel de PipeWire
  security.rtkit.enable = true;

  # ==========================================
  # 5. Programmes & Jeux
  # ==========================================
  programs = {
    steam.enable = true;
    gamemode.enable = true;
    gamescope.enable = true;

    # Permet l'exécution de binaires dynamiques non patchés sur NixOS
    nix-ld.enable = true;

    fish.enable = true;
  };

  # ==========================================
  # 6. Paquets Système & Gestionnaire Nix
  # ==========================================
  nixpkgs.config.allowUnfree = true;

  nix = {
    settings = {
      auto-optimise-store = true;
      experimental-features = [ "nix-command" "flakes" ];
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 3d";
      persistent = true;
    };
  };

  environment.systemPackages = with pkgs; [
    git
    kdePackages.partitionmanager
    sbctl
  ];

  # ==========================================
  # 7. Utilisateurs & Groupes
  # ==========================================
  users.users."chouris" = {
    isNormalUser = true;
    description = "Chouris";
    extraGroups = [ "networkmanager" "wheel" ];
    shell = pkgs.fish;
  };

  system.stateVersion = "26.05";
}
