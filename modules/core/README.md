# Adding a new system-level module

Each module lives as a `.nix` file under `modules/core/`.

## 1. Create `modules/core/<name>.nix`

```nix
{ lib, config, ... }:
{
  options.modules.<name>.enable = lib.mkEnableOption "<name>";
  config = lib.mkIf config.modules.<name>.enable {
    # your config here
  };
}
```

## 2. Add it to `modules/core/default.nix`

```nix
imports = [
  # ...existing...
  ./<name>.nix
];
```

## 3. Enable it in `hosts/<hostname>/configuration.nix`

```nix
modules.<name>.enable = true;
```
