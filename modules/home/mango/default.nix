{ lib, config, ... }:
{
  options.homeModules.mango.enable = lib.mkEnableOption "mango";

  config = lib.mkIf config.homeModules.mango.enable {
    home.file.".config/mango".source =
      config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/modules/home/mango/config";
  };
}
