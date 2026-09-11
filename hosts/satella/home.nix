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
    java.enable = true;
    lazydocker.enable = true;
    lazygit.enable = true;
    mango.enable = true;
    miru.enable = true;
    nix-search.enable = true;
    rofi.enable = true;
    shell.enable = true;
    spicetify.enable = true;
    starship.enable = true;
    swaylock.enable = true;
    swaync.enable = true;
    tmux.enable = true;
    vesktop.enable = true;
    waybar.enable = true;
    wezterm.enable = true;
    yazi.enable = true;
    zathura.enable = true;
  };
}
