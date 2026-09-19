{
  lib,
  config,
  inputs,
  ...
}:
{
  options.modules.nix.enable = lib.mkEnableOption "nix";

  config = lib.mkIf config.modules.nix.enable {
    nix = {
      settings = {
        experimental-features = [
          "nix-command"
          "flakes"
        ];

        substituters = [
          "https://nix-community.cachix.org"
        ];

        trusted-public-keys = [
          "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        ];

        trusted-users = [
          "root"
          "yvnth"
        ];
      };

      registry.nixpkgs.flake = inputs.nixpkgs;
      nixPath = [ "nixpkgs=${inputs.nixpkgs}" ];
    };

    services = {
      fast-nix-gc = {
        enable = true;
        automatic = true;
        dates = "weekly";
        deleteOlderThan = "30d";
      };

      fast-nix-optimise = {
        enable = true;
        automatic = true;
        dates = "weekly";
      };
    };

    nixpkgs.config.allowUnfree = true;
  };
}
