{
  lib,
  config,
  pkgs,
  ...
}:

{
  options.homeModules.mako.enable = lib.mkEnableOption "mako";

  config = lib.mkIf config.homeModules.mako.enable {
    home.packages = with pkgs; [
      mako
    ];

    home.file.".config/mako".source =
      config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/modules/home/mako/config";
  };
}
