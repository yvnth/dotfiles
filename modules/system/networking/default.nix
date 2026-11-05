{ lib, config, ... }:
{
  options.modules.networking.enable = lib.mkEnableOption "networking";

  config = lib.mkIf config.modules.networking.enable {
    networking = {
      firewall = {
        enable = true;
        allowedTCPPorts = [
          22
          443
          53317
        ];
        allowedUDPPorts = [
          53317
          5353
        ];
      };
    };

    services = {
      avahi.enable = true;
      resolved.enable = true;

      openssh = {
        enable = true;
        settings = {
          PermitRootLogin = "no";
        };
      };
    };
  };
}
