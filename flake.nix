{
  description = "Configuration NixOS";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";
    comfyui-nix.url = "github:utensils/comfyui-nix";

    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    lanzaboote = {
      url = "github:nix-community/lanzaboote";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, lanzaboote, chaotic, comfyui-nix, ... }: {
    nixosConfigurations.NixOS = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit chaotic; };
      modules = [
        ./configuration.nix
        lanzaboote.nixosModules.lanzaboote
        chaotic.nixosModules.default
        comfyui-nix.nixosModules.default
        { nixpkgs.overlays = [ comfyui-nix.overlays.default ]; }

        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.backupFileExtension = "hm-backup";
          home-manager.users.chouris = import ./home.nix;
        }
      ];
    };
  };
}
