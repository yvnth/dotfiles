# Adding a new system-level module

Each module lives in its own directory under [modules/system/](../system/).

## 1. Create `modules/system/<name>/default.nix`

```nix
{ lib, config, ... }:
{
  options.modules.<name>.enable = lib.mkEnableOption "<name>";
  config = lib.mkIf config.modules.<name>.enable {
    # your config here
  };
}
```

## 2. Add it to [default.nix](./default.nix)

```nix
imports = [
  # ...existing...
  ./<name>
];
```

## 3. Enable it in `hosts/<hostname>/configuration.nix`

```nix
modules.<name>.enable = true;
```
