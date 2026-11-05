{
  lib,
  config,
  pkgs,
  ...
}:
{
  options.modules.nvidia-intel.enable = lib.mkEnableOption "nvidia-intel";

  config = lib.mkIf config.modules.nvidia-intel.enable {
    boot = {
      kernelParams = [
        "nvidia-drm.modeset=1"
        "nvidia-drm.fbdev=1"
      ];
    };

    environment.sessionVariables = {
      NIXOS_OZONE_WL = "1";
      ELECTRON_OZONE_PLATFORM_HINT = "auto";
      LIBVA_DRIVER_NAME = "iHD";
    };

    hardware = {
      graphics = {
        enable = true;
        enable32Bit = true;

        extraPackages = with pkgs; [
          intel-media-driver
          intel-compute-runtime
        ];
      };

      nvidia = {
        open = true;
        modesetting.enable = true;

        nvidiaSettings = true;
        nvidiaPersistenced = false;

        package = config.boot.kernelPackages.nvidiaPackages.latest;

        powerManagement = {
          enable = true;
          finegrained = true;
        };

        prime = {
          intelBusId = "PCI:0:2:0";
          nvidiaBusId = "PCI:1:0:0";

          offload = {
            enable = true;
            enableOffloadCmd = true;
          };
        };
      };
    };

    services.xserver.videoDrivers = [ "nvidia" ];
  };
}
