{ lib, config, ... }:
{
  options.modules.audio.enable = lib.mkEnableOption "audio";

  config = lib.mkIf config.modules.audio.enable {
    services = {
      pipewire = {
        enable = true;
        alsa.enable = true;
        alsa.support32Bit = true;
        pulse.enable = true;
        jack.enable = true;
        wireplumber.enable = true;
      };

      pulseaudio.enable = false;
    };

    security = {
      rtkit.enable = true;
    };
  };
}
