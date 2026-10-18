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
          package = pkgs.plemoljp-nf;
          name = "PlemolJP Console NF";
        };

        sansSerif = {
          package = pkgs.plemoljp-nf;
          name = "PlemolJP Console NF";
        };

        serif = {
          package = pkgs.plemoljp-nf;
          name = "PlemolJP Console NF";
        };

        sizes = {
          applications = 16;
          terminal = 16;
          desktop = 16;
          popups = 16;
        };
      };
    };

  };
}
