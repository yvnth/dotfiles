# Adding a New User

## 1. Add User to System Config

Add the user to `hosts/<hostname>/configuration.nix`:

```nix
users.users.<username> = {
  isNormalUser = true;
  description = "<username>";
  shell = pkgs.zsh;
  extraGroups = [
    "wheel"
    "networkmanager"
  ];
};
```

## 2. Create Home Config

Create `hosts/<hostname>/home.nix` for the user, using `hosts/satella/home.nix` as a reference:

```nix
{ ... }:
{
  imports = [ ../../modules/home ];

  home = {
    username = "<username>";
    homeDirectory = "/home/<username>";
  };

  homeModules = {
    # enable modules as needed
  };
}
```

## 3. Add to Home Manager in Flake

Add the user under `home-manager.users` in `flake.nix`:

```nix
home-manager.users.<username> = {
  imports = [
    ./hosts/<hostname>/home.nix
  ];
};
```

## 4. Create Secrets Directory

```bash
mkdir -p secrets/<hostname>/<username>
```

## 5. Add Secrets

Add secrets if needed:

```bash
sops secrets/<hostname>/<username>/<name>.yaml
```

Reference them in `modules/core/sops.nix`:

```nix
sops.secrets.<name> = {
  sopsFile = ../../secrets/<hostname>/<username>/<name>.yaml;
  key = "<key>";
  path = "/home/<username>/path/to/secret";
  owner = "<username>";
  mode = "0400";
};
```

## 6. Build and Switch

```bash
sudo nixos-rebuild switch --flake ~/dotfiles#<hostname>
```
