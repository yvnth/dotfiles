{ lib, config, ... }:
{
  options.homeModules.git.enable = lib.mkEnableOption "git";

  config = lib.mkIf config.homeModules.git.enable {
    programs.git = {
      enable = true;

      settings = {
        user = {
          name = "yvnth";
          email = "yashupress@gmail.com";
          signingkey = "D9AAB78D42E14B5C08C0C2BE9012022165D97825";
        };

        init.defaultBranch = "master";

        core.editor = "nvim";

        commit.gpgsign = true;
        gpg.format = "openpgp";
      };
    };
  };
}
