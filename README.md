# NixOS Dotfiles ❄️

Personal [NixOS](https://nixos.org/) configuration, managed with [home-manager](https://github.com/nix-community/home-manager) and [flakes](https://wiki.nixos.org/wiki/Flakes).

See [Bootstrap](docs/BOOTSTRAP.md) for fresh install instructions.

## Repo layout

```
docs/             # reference documentation
hosts/            # per-machine configuration
modules/system/   # system-level modules
modules/home/     # home-manager modules
pkgs/             # custom packages
secrets/          # sops-nix encrypted secrets
```

## Documentation

- [Adding a system module](modules/system/README.md)
- [Adding a home module](modules/home/README.md)
- [Adding a new host](docs/NEW-HOST.md)
- [Adding a new user](docs/NEW-USER.md)
- [Adding a custom package](pkgs/README.md)
- [Hosts](hosts/README.md)
- [Managing secrets](secrets/README.md)

## Stack

- **My text editor of choice:** [Neovim](https://neovim.io) • [My Neovim configuration](https://github.com/yvnth/nvix)
- **Window manager:** [Hyprland](https://hypr.land/)
- **Secure Boot:** [Lanzaboote](https://github.com/nix-community/lanzaboote)
- **Secrets:** [sops-nix](https://github.com/Mic92/sops-nix)
