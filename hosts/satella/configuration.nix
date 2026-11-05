{ pkgs, ... }:

{
  imports = [
    ./disko.nix
    ./hardware-configuration.nix
    ./packages.nix
    ../../modules/system
  ];

  boot.kernelPackages = pkgs.linuxPackages_latest;

  modules = {
    audio.enable = true;
    battery.enable = true;
    flatpak.enable = true;
    lanzaboote.enable = true;
    networking.enable = true;
    nix.enable = true;
    nvidia-intel.enable = true;
    services.enable = true;
    sops.enable = true;
    stylix.enable = true;
    virtualization.enable = true;
    zram.enable = true;
  };

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = false;
  };

  networking = {
    hostName = "satella";
    networkmanager.enable = true;
  };

  time.timeZone = "Asia/Tokyo";

  i18n.defaultLocale = "en_US.UTF-8";

  programs = {
    zsh.enable = true;

    hyprland = {
      enable = true;
      xwayland.enable = true;
    };
  };

  services.displayManager.ly = {
    enable = true;
    settings = {
      animation = "matrix";
      bigclock = "en";
      numlock = true;
    };
  };

  users.users.yvnth = {
    isNormalUser = true;
    description = "yvnth";
    shell = pkgs.zsh;
    initialPassword = "changeme";
    extraGroups = [
      "wheel"
      "networkmanager"
      "audio"
      "video"
      "docker"
      "libvirtd"
    ];
  };

  xdg.portal = {
    enable = true;
    xdgOpenUsePortal = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-gtk
      pkgs.xdg-desktop-portal-hyprland
    ];
    config = {
      common.default = [ "gtk" ];
      hyprland.default = [
        "hyprland"
        "gtk"
      ];
    };
  };

  system.stateVersion = "25.11";
}
