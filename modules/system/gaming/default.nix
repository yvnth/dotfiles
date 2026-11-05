{
  lib,
  config,
  pkgs,
  ...
}:

{
  options.modules.gaming.enable = lib.mkEnableOption "gaming";

  config = lib.mkIf config.modules.gaming.enable {
    programs = {
      steam = {
        enable = true;

        remotePlay.openFirewall = true;
        dedicatedServer.openFirewall = true;
        localNetworkGameTransfers.openFirewall = true;

        extraCompatPackages = with pkgs; [
          proton-ge-bin
        ];
      };

      gamemode = {
        enable = true;
        enableRenice = true;
      };

      gamescope.enable = true;
    };

    environment.systemPackages = with pkgs; [
      heroic
      mangohud
    ];
  };
}
