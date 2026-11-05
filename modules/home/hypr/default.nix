{ lib, config, ... }:

{
  options.homeModules.hypr.enable = lib.mkEnableOption "hypr";

  config = lib.mkIf config.homeModules.hypr.enable {
    home.file.".config/hypr".source =
      config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/modules/home/hypr/config";
  };
}
