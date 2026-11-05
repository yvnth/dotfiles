{ lib, config, ... }:
{
  options.modules.zram.enable = lib.mkEnableOption "zram";

  config = lib.mkIf config.modules.zram.enable {
    zramSwap = {
      enable = true;
      algorithm = "zstd";
      memoryPercent = 50;
      priority = 100;
    };
  };
}
