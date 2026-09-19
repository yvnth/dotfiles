# Adding a new user-level module

Each module lives in its own directory under `modules/home/`.

## 1. Create `modules/home/<name>/default.nix`

```nix
{ lib, config, pkgs, ... }:
{
  options.homeModules.<name>.enable = lib.mkEnableOption "<name>";
  config = lib.mkIf config.homeModules.<name>.enable {
    home.packages = with pkgs; [
      <name>
    ];
    home.file.".config/<name>".source =
      config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/modules/home/<name>/config";
  };
}
```

## 2. Add it to `modules/home/default.nix`

```nix
imports = [
  # ...existing...
  ./<name>
];
```

## 3. Enable it in `hosts/<hostname>/home.nix`

```nix
homeModules.<name>.enable = true;
```
