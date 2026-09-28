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

        nix-path = [
          "nixpkgs=${inputs.nixpkgs}"
        ];
      };

      registry.nixpkgs.flake = inputs.nixpkgs;
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
