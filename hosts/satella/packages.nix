{ pkgs, inputs, ... }:

{
  fonts.packages = with pkgs; [
    lohit-fonts.tamil
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
    imv
    jq
    jujutsu
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
    nix-output-monitor
    nwg-look
    papirus-icon-theme
    pass
    pavucontrol
    pokego
    postman
    ripgrep
    rofimoji
    rustup
    satty
    slurp
    swaybg
    vlc
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
