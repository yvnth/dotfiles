{
  lib,
  config,
  pkgs,
  ...
}:
{
  options.modules.stylix.enable = lib.mkEnableOption "stylix";

  config = lib.mkIf config.modules.stylix.enable {
    stylix = {
      enable = true;

      base16Scheme = {
        base00 = "303446";
        base01 = "292c3c";
        base02 = "414559";
        base03 = "51576d";
        base04 = "626880";
        base05 = "c6d0f5";
        base06 = "f2d5cf";
        base07 = "babbf1";
        base08 = "e78284";
        base09 = "ef9f76";
        base0A = "e5c890";
        base0B = "a6d189";
        base0C = "81c8be";
        base0D = "8caaee";
        base0E = "ca9ee6";
        base0F = "eebebe";
      };

      polarity = "dark";

      fonts = {
        monospace = {
          package = pkgs.nerd-fonts.jetbrains-mono;
          name = "JetBrainsMono Nerd Font";
        };

        sansSerif = {
          package = pkgs.nerd-fonts.jetbrains-mono;
          name = "JetBrainsMono Nerd Font";
        };

        serif = {
          package = pkgs.nerd-fonts.jetbrains-mono;
          name = "JetBrainsMono Nerd Font";
        };

        sizes = {
          applications = 15;
          terminal = 15;
          desktop = 15;
          popups = 15;
        };
      };
    };

  };
}
