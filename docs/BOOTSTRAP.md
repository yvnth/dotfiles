# Bootstrap process

## 1. Install Git

A fresh NixOS install won't have `git`, so enter a nix shell with it:

```bash
nix-shell -p git
```

## 2. Clone and Partition with Disko

```bash
git clone https://github.com/yvnth/dotfiles.git ~/dotfiles
sudo nix --experimental-features "nix-command flakes" run github:nix-community/disko -- \
  --mode destroy,format,mount \
  ~/dotfiles/hosts/<hostname>/disko.nix
```

Note: Optionally, enter a temporary shell with the [additional packages](../shell.nix) using `nix-shell` from the repository root if they are needed during the installation process.

## 3. Inject Hardware Config

```bash
sudo nixos-generate-config --no-filesystems --root /mnt
rm ~/dotfiles/hosts/<hostname>/hardware-configuration.nix
sudo cp /mnt/etc/nixos/hardware-configuration.nix ~/dotfiles/hosts/<hostname>/hardware-configuration.nix
```

## 4. Install

```bash
sudo nixos-install --flake ~/dotfiles#<hostname>
```

## 5. Chroot and First Rebuild

*Required to not get locked on login*

### Enter chroot

```bash
sudo nixos-enter --root /mnt
```

Inside the chroot:

```bash
passwd yvnth
su - yvnth -c 'git clone https://github.com/yvnth/dotfiles.git ~/dotfiles'
rm /home/yvnth/dotfiles/hosts/<hostname>/hardware-configuration.nix
cp /etc/nixos/hardware-configuration.nix /home/yvnth/dotfiles/hosts/<hostname>/hardware-configuration.nix
chown yvnth:users /home/yvnth/dotfiles/hosts/<hostname>/hardware-configuration.nix
nixos-rebuild switch --flake /home/yvnth/dotfiles#<hostname>
exit
```

```bash
reboot
```

## 6. Copy Age Key

```bash
sudo mkdir -p /var/lib/sops-nix
sudo cp /path/to/your/keys.txt /var/lib/sops-nix/key.txt
sudo chmod 600 /var/lib/sops-nix/key.txt
sudo chown root:root /var/lib/sops-nix/key.txt
```

## 7. Restore Secure Boot Keys

```bash
sudo cp -r /path/to/your/sbctl /var/lib/sbctl
sudo chmod 700 /var/lib/sbctl/keys
sudo find /var/lib/sbctl/keys -name "*.key" -exec chmod 600 {} \;
```

## 8. Build and Switch

```bash
sudo nixos-rebuild switch --flake ~/dotfiles#<hostname>
reboot
```

> After reboot, Lanzaboote will automatically enroll your keys into the firmware.
>
> Go into UEFI and enable Secure Boot if it isn't already.

## 9. Regenerate SSH Public Key

```bash
ssh-keygen -y -f ~/.ssh/id_ed25519 > ~/.ssh/id_ed25519.pub
```

## 10. Import GPG Key & Restore Password Store

```bash
gpg --import ~/.gnupg/secret-key.asc
gpg --import-ownertrust ~/.gnupg/ownertrust.txt
cp -r /path/to/your/pass ~/.password-store
```
