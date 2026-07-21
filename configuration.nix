{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  # Bootloader & Kernel
  boot = {
    kernelPackages = pkgs.linuxPackages_xanmod_latest;
    kernelParams = [ "amdgpu.ppfeaturemask=0xffffffff" ];
    tmp.cleanOnBoot = true;

    loader = {
      efi.canTouchEfiVariables = true;
      grub = {
        enable = true;
        device = "nodev";
        efiSupport = true;
        theme = ./themes/CRT;
      };
    };
  };

  # CPU power
  boot.kernelModules = [ "zenpower" ];
  boot.extraModulePackages = with config.boot.kernelPackages; [ zenpower ];
  boot.blacklistedKernelModules = [ "k10temp" ];

  # Networking & Hardware
  networking = {
    hostName = "NixOS";
    networkmanager.enable = true;
  };

  hardware = {
    bluetooth.enable = true;
    enableRedistributableFirmware = true;
    graphics.enable32Bit = true;
    amdgpu.overdrive.enable = true;
  };

  zramSwap.enable = true;

  # Localization
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

  # Fonts
  fonts.packages = with pkgs; [
  noto-fonts
  noto-fonts-color-emoji
  inter
  nerd-fonts.jetbrains-mono
  nerd-fonts.fira-code
  ];

  fonts.fontconfig.defaultFonts = {
  serif = [ "Noto Serif" ];
  sansSerif = [ "Inter" ];
  monospace = [ "JetBrainsMono Nerd Font" ];
  };

  # Services & Desktop Environment
  services = {
    xserver = {
      enable = true;
      xkb = {
        layout = "us";
        variant = "";
      };
    };

    displayManager.sddm.enable = true;
    desktopManager.plasma6.enable = true;

    fstrim.enable = true;
    fwupd.enable = true;
    lact.enable = true;

    pulseaudio.enable = false;
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };
  };

  # Required for PipeWire real-time scheduling
  security.rtkit.enable = true;

  # Nix Package Manager
  nixpkgs.config.allowUnfree = true;

  nix = {
    settings.auto-optimise-store = true;
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 14d";
    };
  };

  # User Configuration
  users.users."chouris" = {
    isNormalUser = true;
    description = "Chouris";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
      kdePackages.kate
      # thunderbird
    ];
  };

  # System Packages
  environment.systemPackages = with pkgs; [
    neovim
    git
    kitty
    fastfetch
    vesktop
    librewolf
    (btop.override { rocmSupport = true; })
    topgrade
    goverlay
    mangohud
    protonup-qt
    prismlauncher
    zed-editor
    standardnotes
    rustdesk-flutter
    pinta
  ];

  # Programs & Gaming
  programs = {
    steam.enable = true;
    gamemode.enable = true;
    gamescope.enable = true;

    # Enables unpatched dynamic binaries execution on NixOS
    nix-ld.enable = true;

    bash.shellAliases = {
      sc = "cd /etc/nixos && git add . && git commit -m \"Mise à jour config\" && git push";
      ff = "fastfetch";
      rs = "sudo nixos-rebuild switch";
    };
  };

  system.stateVersion = "26.05";
}
