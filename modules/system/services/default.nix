{ lib, config, ... }:
{
  options.modules.services.enable = lib.mkEnableOption "services";

  config = lib.mkIf config.modules.services.enable {
    services = {
      acpid.enable = true;
      blueman.enable = true;

      btrfs.autoScrub = {
        enable = true;
        interval = "monthly";
      };

      earlyoom.enable = true;

      fwupd.enable = true;
      gvfs.enable = true;
      printing.enable = true;
    };

    programs = {
      gnupg.agent.enable = true;
    };

    security = {
      polkit.enable = true;
    };
  };
}
