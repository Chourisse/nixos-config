{ config, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
    ];

  # Bootloader (GRUB)
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "nodev";
  boot.loader.grub.efiSupport = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.grub.theme = ./themes/CRT;

  # Use latest kernel
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # Network

  networking.hostName = "NixOS"; 
  networking.networkmanager.enable = true;

  # Time zone & co
  time.timeZone = "Europe/Paris";
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
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

  # X11 windowing system
  services.xserver.enable = true;

  # KDE Plasma
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

  # Configure X11 keymap
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Pipewire
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  programs.bash.shellAliases = {
  sc = "cd /etc/nixos && git add . && git commit -m \"Mise à jour config\" && git push";
  ff = "fastfetch";
  rs = "sudo nixos-rebuild switch";
  };

  # User account
  users.users."chouris" = {
    isNormalUser = true;
    description = "Chouris";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
      kdePackages.kate
    #  thunderbird
    ];
  };

  # Unfree packages
  nixpkgs.config.allowUnfree = true;

  # List of packages.
  environment.systemPackages = with pkgs; [
    neovim
    git
    kitty
    fastfetch
    vesktop
    librewolf
  ];

  programs.steam.enable = true;

  system.stateVersion = "26.05";

}
