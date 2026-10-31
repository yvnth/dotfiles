{ pkgs, inputs, ... }:
{
  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-color-emoji
  ];

  services.flatpak = {
    packages = [
      "com.github.tchx84.Flatseal"
    ];
  };

  environment.systemPackages = with pkgs; [
    acpi
    bibata-cursors
    brightnessctl
    cliphist
    direnv
    eza
    element-desktop
    fd
    firefox-devedition
    fzf
    gh
    git
    grim
    jq
    just
    kdePackages.kate
    libnotify
    libreoffice
    localsend
    man-db
    man-pages
    mpv
    nemo
    networkmanagerapplet
    nh
    nsxiv
    nwg-look
    papirus-icon-theme
    pass
    pavucontrol
    pokego
    ripgrep
    rofimoji
    satty
    slurp
    swaybg
    vscode
    waytrogen
    wget
    wl-clipboard
    wl-screenrec
    zoxide
    inputs.nvix.packages.${pkgs.stdenv.hostPlatform.system}.default
    (callPackage ../../pkgs/rofi-pass { })
  ];
}
