{ ... }:

{
  imports = [
    ./hardware-configuration.nix

    ./modules/boot.nix      # Kernel, EFI, Secure Boot
    ./modules/hardware.nix  # GPU, BTRFS
    ./modules/network.nix   # Réseau, DNS, VPN
    ./modules/locale.nix    # Heure, langue, polices
    ./modules/desktop.nix   # Plasma, SDDM, audio
    ./modules/gaming.nix    # Steam, Gamemode, Gamescope
    ./modules/ai.nix        # Ollama, Open WebUI, SearXNG
    ./modules/nix.nix       # Réglages Nix, Chaotic-Nyx, paquets système
    ./modules/users.nix     # Utilisateur et shell
  ];

  system.stateVersion = "26.05";
}
