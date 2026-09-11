{
  description = "yvnth's NixOS config";

  inputs = {
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    fast-nix-gc = {
      url = "github:Mic92/fast-nix-gc";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    lanzaboote = {
      url = "github:nix-community/lanzaboote/v1.1.0";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    mangowm = {
      url = "github:mangowm/mango";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-flatpak = {
      url = "github:gmodena/nix-flatpak/?ref=latest";
    };

    nixmacs = {
      url = "github:yvnth/nixmacs";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixpkgs = {
      url = "github:nixos/nixpkgs/nixos-unstable";
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    spicetify-nix = {
      url = "github:Gerg-L/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    stylix = {
      url = "github:nix-community/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    waybar = {
      url = "github:Alexays/Waybar";
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
      nixmacs,
      nixpkgs,
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

              nixmacs.inputs.emacs-overlay.overlays.default

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
                  nixmacs.homeManagerModules.default
                ];
              };
            };
          }
        ];
      };
    };
}
