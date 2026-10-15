{
  description = "Configuration NixOS";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    lanzaboote = {
      url = "github:nix-community/lanzaboote";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, lanzaboote, chaotic, sops-nix, ... }: {
    nixosConfigurations.NixOS = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit chaotic; };

      modules = [
        ./configuration.nix

        lanzaboote.nixosModules.lanzaboote
        chaotic.nixosModules.default
        home-manager.nixosModules.home-manager
	sops-nix.nixosModules.sops

        {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            backupFileExtension = "hm-backup";
            users.chouris = import ./home.nix;
          };
        }
      ];
    };
  };
}
