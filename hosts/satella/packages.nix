{ pkgs, ... }:
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
    age
    autotiling
    bibata-cursors
    bootdev-cli
    brightnessctl
    cliphist
    docker-buildx
    docker-compose
    eza
    element-desktop
    fd
    firefox-devedition
    fzf
    gcc
    gh
    go
    grim
    helix
    imv
    jq
    just
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
    nodejs
    nwg-look
    papirus-icon-theme
    pass
    pavucontrol
    pokego
    postman
    python314
    python314Packages.pip
    python314Packages.uv
    ripgrep
    rofimoji
    rustup
    satty
    slurp
    sops
    swaybg
    typst
    unzip
    vlc
    vscode
    waytrogen
    wget
    wl-clipboard
    wl-screenrec
    zip
    zoxide
    (callPackage ../../pkgs/rofi-pass { })
  ];
}
