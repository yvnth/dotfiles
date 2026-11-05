{ lib, config, ... }:
{
  options.modules.virtualization.enable = lib.mkEnableOption "virtualization";

  config = lib.mkIf config.modules.virtualization.enable {
    virtualisation = {
      docker = {
        enable = true;
      };

      libvirtd.enable = true;
    };

    programs = {
      virt-manager.enable = true;
    };
  };
}
