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

  sops = {
  defaultSopsFile = ./secrets/secrets.yaml;
age.keyFile = "/var/lib/sops-nix/key.txt";
  age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
  secrets."searxng_env" = {};
 };

  system.stateVersion = "26.05";
}
