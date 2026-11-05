{
  lib,
  config,
  pkgs,
  ...
}:

{
  options.homeModules.waybar.enable = lib.mkEnableOption "waybar";

  config = lib.mkIf config.homeModules.waybar.enable {
    home.packages = with pkgs; [
      waybar
    ];

    home.file.".config/waybar".source =
      config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/modules/home/waybar/config";
  };
}
