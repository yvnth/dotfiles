hostname := `hostname -s`
sops := "sudo -E env SOPS_AGE_KEY_FILE=/var/lib/sops-nix/key.txt sops"
age_key := "/var/lib/sops-nix/key.txt"

# list all recipes when you execute just
_default:
    @just --list

# switch to the new config
[group("build")]
rebuild host=hostname:
    nh os switch . -H {{ host }}

# activate the new config without adding a boot entry
[group("build")]
test host=hostname:
    nh os test . -H {{ host }}

# add the new config as boot entry, activate on next reboot
[group("build")]
boot host=hostname:
    nh os boot . -H {{ host }}

# update flake inputs, all if none given
[group("build")]
update *input:
    nix flake update {{ input }}

# update inputs then switch
[group("build")]
upgrade: update rebuild

# run flake checks
[group("build")]
check:
    nix flake check --show-trace

# gc old generations and optimise the store
[group("build")]
clean:
    nh clean all
    sudo nix-store --optimize

# create or edit a secrets file
[group("secrets")]
sops-edit file:
    {{ sops }} {{ file }}

# decrypt and print a secrets file
[group("secrets")]
sops-view file:
    {{ sops }} -d {{ file }}

# print one key from a secrets file
[group("secrets")]
sops-extract file key:
    {{ sops }} -d --extract '["{{ key }}"]' {{ file }}

# re-encrypt every secrets file to the keys in .sops.yaml
[group("secrets")]
sops-rekey:
    #!/usr/bin/env bash
    set -euo pipefail
    for f in $(find secrets -type f -name '*.yaml'); do
      echo "updatekeys $f"
      {{ sops }} updatekeys -y "$f"
    done

# generate the host age key
[group("secrets")]
age-gen:
    sudo mkdir -p /var/lib/sops-nix
    sudo age-keygen -o {{ age_key }}
    sudo chmod 600 {{ age_key }}
    sudo chown root:root {{ age_key }}

# print the age public key for .sops.yaml
[group("secrets")]
age-pub:
    sudo age-keygen -y {{ age_key }}

# generate new key beside the old one, print its pubkey
[group("secrets")]
age-rotate-new:
    sudo age-keygen -o {{ age_key }}.new
    sudo age-keygen -y {{ age_key }}.new

# swap the new key in, run after sops-rekey with both keys
[group("secrets")]
age-rotate-swap:
    sudo mv {{ age_key }}.new {{ age_key }}
    sudo chmod 600 {{ age_key }}
    sudo chown root:root {{ age_key }}

# partition and mount a host's disks with disko, destroys data
[group("bootstrap")]
disko host:
    sudo nix --experimental-features "nix-command flakes" run github:nix-community/disko -- \
      --mode destroy,format,mount \
      hosts/{{ host }}/disko.nix

# regenerate hardware-configuration.nix for a host
[group("bootstrap")]
hwconf host:
    sudo nixos-generate-config --no-filesystems --root /mnt
    rm -f hosts/{{ host }}/hardware-configuration.nix
    sudo cp /mnt/etc/nixos/hardware-configuration.nix hosts/{{ host }}/hardware-configuration.nix

# install a host from this flake onto /mnt
[group("bootstrap")]
install host:
    sudo nixos-install --flake .#{{ host }}

