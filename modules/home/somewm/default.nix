{ lib, config, ... }:
{
  options.homeModules.somewm.enable = lib.mkEnableOption "somewm";

  config = lib.mkIf config.homeModules.somewm.enable {
    home.file.".config/somewm".source =
      config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/modules/home/somewm/config";
  };
}
