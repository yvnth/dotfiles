{
  pkgs ? import <nixpkgs> { },
}:

pkgs.mkShell {
  packages = with pkgs; [
    age
    gh
    git
    just
    neovim
    sops
  ];
}
