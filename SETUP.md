# NixOS Setup Guide — new hosts

This repo uses flake-parts + import-tree (the "dendritic" pattern). Every
`.nix` file under `modules/` is auto-imported. Hosts live in
`modules/hosts/<name>.nix` and pick which `flake.modules.nixos.*` modules
they want.

## 1. Boot the installer

Flash the minimal NixOS ISO and boot from USB:

```bash
sudo dd if=nixos-minimal-*.iso of=/dev/sdX bs=4M status=progress oflag=sync
```

Connect WiFi if needed (`wpa_cli` or `nmtui`).

## 2. Partition, encrypt, mount

Identify your disk with `lsblk`. Example for `/dev/nvme0n1`:

```bash
sudo parted /dev/nvme0n1 -- mklabel gpt
sudo parted /dev/nvme0n1 -- mkpart ESP fat32 1MiB 1GiB
sudo parted /dev/nvme0n1 -- set 1 esp on
sudo parted /dev/nvme0n1 -- mkpart primary 1GiB 100%

sudo cryptsetup luksFormat /dev/nvme0n1p2
sudo cryptsetup open /dev/nvme0n1p2 cryptroot

sudo mkfs.ext4 /dev/mapper/cryptroot
sudo mkfs.fat -F 32 /dev/nvme0n1p1

sudo mount /dev/mapper/cryptroot /mnt
sudo mkdir -p /mnt/boot
sudo mount /dev/nvme0n1p1 /mnt/boot
```

## 3. Generate the hardware config

```bash
sudo nixos-generate-config --root /mnt --no-filesystems
```

We pass `--no-filesystems` because the flake host file already declares
filesystems via the LUKS UUID — see `modules/hosts/nix-home-hardware.nix`
for the pattern. Note the LUKS UUID:

```bash
sudo blkid /dev/nvme0n1p2
```

## 4. Add the host to the flake

On another machine (or in the installer with `nix-shell -p git`):

```bash
git clone <your dotfiles remote> /mnt/etc/dotfiles
```

Create `modules/hosts/<name>-hardware.nix` mirroring the existing one:
copy `/mnt/etc/nixos/hardware-configuration.nix`'s contents into a
`flake.modules.nixos.<name>-hardware` block, fill in the LUKS UUID under
`boot.initrd.luks.devices`.

Create `modules/hosts/<name>.nix` modelled on `nix-work.nix`. Imports to
include for a working baseline:

```nix
imports = [
  nixos.<name>-hardware
  nixos.bootloader        # plain systemd-boot — works first boot
  # nixos.secureboot      # add later, AFTER enrolling sbctl keys
  nixos.system
  nixos.network
  nixos.security
  nixos.services
  nixos.program
  nixos.wayland
  nixos.hardware
  nixos.tailscale
  nixos.stylix
  nixos.greetd
  nixos.watchdog
  nixos.nh
  nixos.user
];
```

## 5. Install

```bash
sudo nixos-install --flake /mnt/etc/dotfiles#<name>
sudo reboot
```

niri is pinned to `pkgs.niri` (the cache.nixos.org binary), so install
downloads it instead of compiling from source. Lanzaboote is opt-in via
the separate `nixos.secureboot` module — keeping it out of the first
boot avoids the chicken-and-egg where the bootloader can't verify
itself before keys are enrolled.

## 6. Optional: enable secure boot

After the first successful boot, log in and:

```bash
# 1. Make sure the firmware is in Setup Mode (BIOS → reset/clear PK).
sudo sbctl status      # should show "Setup Mode: Enabled"
sudo sbctl create-keys
sudo sbctl enroll-keys --microsoft
```

Then add `nixos.secureboot` to the host's imports in
`modules/hosts/<name>.nix` and rebuild:

```bash
sudo nixos-rebuild switch --flake .#<name>
sudo sbctl verify       # everything should be signed
```

Reboot. If anything is unsigned, the EFI fallback to systemd-boot is
gone (lanzaboote sets `boot.loader.systemd-boot.enable = mkForce false`)
— you'll need a NixOS USB to recover. Do not enable secure boot blind.

## 7. Optional: TPM2 auto-unlock for LUKS

Once booted with secure boot on, bind the LUKS slot to PCR 7
(measures secure-boot state):

```bash
sudo systemd-cryptenroll --tpm2-device=auto --tpm2-pcrs=7 \
  /dev/disk/by-uuid/<LUKS-UUID>
```

Then in the host file:

```nix
boot.initrd.systemd.enable = true;
boot.initrd.luks.devices."luks-<LUKS-UUID>".crypttabExtraOpts = [ "tpm2-device=auto" ];
security.tpm2 = { enable = true; pkcs11.enable = true; tctiEnvironment.enable = true; };
```

See `modules/hosts/nix-home.nix` for a working example. There's also
`TPM-UNLOCK.md` with more detail on what PCR 7 protects against.

## 8. Per-host adjustments

- **Display**: niri output config goes in the host file under
  `home-manager.users.${config.username}.programs.niri.settings.outputs`.
  Run `niri msg outputs` once booted to find the exact connector name
  (`eDP-1`, `DP-2`, etc).
- **Scaling**: laptops usually want `scale = 1.25` or `1.5`.
- **CPU governor**: laptops `"powersave"`, desktops `"performance"`.
