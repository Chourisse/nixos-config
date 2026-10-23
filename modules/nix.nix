{ pkgs, ... }:

{
  nixpkgs.config.allowUnfree = true;

  nix = {
    settings = {
      auto-optimise-store = true;
      experimental-features = [ "nix-command" "flakes" ];
      extra-substituters = [ "https://deadlock-mod-manager.cachix.org" ];
      extra-trusted-public-keys = [
        "deadlock-mod-manager.cachix.org-1:wUjtzL6yN2i9zTq1YrXHBr0mx3LP7tBGsosk3N+/A/M="
      ];
    };
    gc = {
      automatic = false;
      dates = "weekly";
      options = "--delete-older-than 14d";
      persistent = true;
    };
  };

  chaotic = {
    nyx.cache.enable = true;
    mesa-git.enable = true;
  };

  programs = {
  nix-ld.enable = true;
  nh = {
    enable = true;
    flake = "/etc/nixos";
    clean.enable = true;
    clean.extraArgs = "--keep-since 7d --keep 5";
    };
  };

  environment.systemPackages = with pkgs; [
    git
    gparted
    sbctl
  ];
}
