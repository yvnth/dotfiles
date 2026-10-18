{ ... }:
{
  imports = [ ../../modules/home ];

  home = {
    username = "yvnth";
    homeDirectory = "/home/yvnth";
    stateVersion = "25.11";
  };

  homeModules = {
    btop.enable = true;
    fastfetch.enable = true;
    git.enable = true;
    lazydocker.enable = true;
    lazygit.enable = true;
    mako.enable = true;
    miru.enable = true;
    nix-search.enable = true;
    rofi.enable = true;
    shell.enable = true;
    somewm.enable = true;
    spicetify.enable = true;
    starship.enable = true;
    tmux.enable = true;
    vesktop.enable = true;
    wezterm.enable = true;
    yazi.enable = true;
    zathura.enable = true;
  };
}
