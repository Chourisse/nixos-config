{
  description = "Configuration NixOS";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";

    deadlock-mod-manager.url = "github:deadlock-mod-manager/deadlock-mod-manager";

    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    lanzaboote = {
      url = "github:nix-community/lanzaboote";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    caelestia-shell = {
      url = "github:caelestia-dots/shell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      lanzaboote,
      chaotic,
      ...
    }@inputs:
    {
      nixosConfigurations.NixOS = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit chaotic; };

        modules = [
          ./configuration.nix

          lanzaboote.nixosModules.lanzaboote
          chaotic.nixosModules.default
          home-manager.nixosModules.home-manager

          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              backupFileExtension = "hm-backup";
              extraSpecialArgs = { inherit inputs; };
              users.chouris = import ./home.nix;
            };
          }
        ];
      };
    };
}
