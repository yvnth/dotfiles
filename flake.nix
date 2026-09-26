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
      ref = "v1.1.0";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    mangowm = {
      type = "github";
      owner = "mangowm";
      repo = "mango";
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

    waybar = {
      type = "github";
      owner = "Alexays";
      repo = "Waybar";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      disko,
      fast-nix-gc,
      home-manager,
      lanzaboote,
      mangowm,
      nix-flatpak,
      nixpkgs,
      nvix,
      sops-nix,
      spicetify-nix,
      stylix,
      waybar,
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
          mangowm.nixosModules.mango
          nix-flatpak.nixosModules.nix-flatpak
          sops-nix.nixosModules.sops
          stylix.nixosModules.stylix

          {
            nixpkgs.overlays = [
              waybar.overlays.default

              (final: prev: {
                xdg-desktop-portal-wlr = prev.xdg-desktop-portal-wlr.overrideAttrs (_: {
                  version = "0.7.0";
                  src = prev.fetchFromGitHub {
                    owner = "emersion";
                    repo = "xdg-desktop-portal-wlr";
                    rev = "776113a4f014639c29d8de8fcb513493ef7b491f";
                    hash = "sha256-EwBHkXFEPAEgVUGC/0e2Bae/rV5lec1ttfbJ5ce9cKw=";
                  };
                });
              })
            ];
          }

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
