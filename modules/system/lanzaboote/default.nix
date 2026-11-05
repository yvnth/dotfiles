{
  lib,
  config,
  pkgs,
  ...
}:
{
  options.modules.lanzaboote.enable = lib.mkEnableOption "lanzaboote";

  config = lib.mkIf config.modules.lanzaboote.enable {
    boot.loader = {
      systemd-boot.enable = lib.mkForce false;
      efi.canTouchEfiVariables = true;
    };

    boot.lanzaboote = {
      enable = true;
      pkiBundle = "/var/lib/sbctl";
      autoGenerateKeys.enable = true;
      autoEnrollKeys.enable = true;
    };

    environment.systemPackages = [ pkgs.sbctl ];
  };
}
