{
  pkgs ? import <nixpkgs> { },
}:

pkgs.mkShell {
  NIX_CONFIG = "extra-experimental-features = nix-command flakes";

  packages = with pkgs; [
    age
    gh
    git
    just
    sops
    ssh-to-age
    ssh-to-pgp
    tmux
  ];
}
