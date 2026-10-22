{ pkgs, ... }:

{
  nixpkgs.config.allowUnfree = true;

  nix = {
    settings = {
      auto-optimise-store = true;
      experimental-features = [ "nix-command" "flakes" ];
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
