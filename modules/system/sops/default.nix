{ lib, config, ... }:
{
  options.modules.sops.enable = lib.mkEnableOption "sops";

  config = lib.mkIf config.modules.sops.enable {
    sops.age.keyFile = "/var/lib/sops-nix/key.txt";

    sops.secrets.ssh_private_key = {
      sopsFile = ../../../secrets/satella/yvnth/ssh.yaml;
      key = "private_key";
      path = "/home/yvnth/.ssh/id_ed25519";
      owner = "yvnth";
      mode = "0400";
    };

    sops.secrets.gpg_private_key = {
      sopsFile = ../../../secrets/common/gpg.yaml;
      key = "private_key";
      path = "/home/yvnth/.gnupg/secret-key.asc";
      owner = "yvnth";
      mode = "0400";
    };

    sops.secrets.gpg_owner_trust = {
      sopsFile = ../../../secrets/common/gpg.yaml;
      key = "owner_trust";
      path = "/home/yvnth/.gnupg/ownertrust.txt";
      owner = "yvnth";
      mode = "0400";
    };
  };
}
