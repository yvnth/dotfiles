{
  description = "yvnth's NixOS config";

  inputs = {
    disko = {
      type = "github";
      owner = "nix-community";
      repo = "disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    fast-nix-gc = {
      type = "github";
      owner = "Mic92";
      repo = "fast-nix-gc";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      type = "github";
      owner = "nix-community";
      repo = "home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    lanzaboote = {
      type = "github";
      owner = "nix-community";
      repo = "lanzaboote";
      ref = "v1.2.0";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-flatpak = {
      type = "github";
      owner = "gmodena";
      repo = "nix-flatpak";
      ref = "latest";
    };

    nixpkgs = {
      type = "github";
      owner = "NixOS";
      repo = "nixpkgs";
      ref = "nixos-unstable";
    };

    nvix = {
      type = "github";
      owner = "yvnth";
      repo = "nvix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix = {
      type = "github";
      owner = "Mic92";
      repo = "sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    spicetify-nix = {
      type = "github";
      owner = "Gerg-L";
      repo = "spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    stylix = {
      type = "github";
      owner = "nix-community";
      repo = "stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      disko,
      fast-nix-gc,
      home-manager,
      lanzaboote,
      nix-flatpak,
      nixpkgs,
      nvix,
      sops-nix,
      spicetify-nix,
      stylix,
      ...
    }@inputs:
    let
      system = "x86_64-linux";
    in
    {
      nixosConfigurations.satella = nixpkgs.lib.nixosSystem {
        inherit system;

        specialArgs = {
          inherit inputs;
        };

        modules = [
          ./hosts/satella/configuration.nix
          disko.nixosModules.disko
          fast-nix-gc.nixosModules.default
          home-manager.nixosModules.home-manager
          lanzaboote.nixosModules.lanzaboote
          nix-flatpak.nixosModules.nix-flatpak
          sops-nix.nixosModules.sops
          stylix.nixosModules.stylix

          {
            home-manager = {
              backupFileExtension = "bak";
              extraSpecialArgs = {
                inherit inputs;
              };
              useGlobalPkgs = true;
              useUserPackages = true;
              users.yvnth = {
                imports = [
                  ./hosts/satella/home.nix
                  spicetify-nix.homeManagerModules.default
                ];
              };
            };
          }
        ];
      };
    };
}
