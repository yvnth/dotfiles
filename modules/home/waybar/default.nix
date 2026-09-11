{
  lib,
  config,
  pkgs,
  inputs,
  ...
}:

{
  options.homeModules.waybar.enable = lib.mkEnableOption "waybar";

  config = lib.mkIf config.homeModules.waybar.enable {
    home.packages = [
      inputs.waybar.packages.${pkgs.stdenv.hostPlatform.system}.waybar
    ];

    home.file.".config/waybar".source =
      config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/modules/home/waybar/config";
  };
}
