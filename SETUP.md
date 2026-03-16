# NixOS Setup Guide — T14s (and new hosts)

## Prerequisites

Push the dotfiles to a git remote (if not already done):

```bash
cd ~/.dotfiles
git init
git add .
git commit -m "initial commit"
git remote add origin git@github.com:<user>/dotfiles.git
git push -u origin main
```

## 1. Create a bootable NixOS USB

Download the minimal ISO from https://nixos.org/download/#nixos-iso and flash it:

```bash
sudo dd if=nixos-minimal-*.iso of=/dev/sdX bs=4M status=progress oflag=sync
```

## 2. Boot the installer

Boot from USB. Connect to WiFi if needed:

```bash
sudo systemctl start wpa_supplicant
wpa_cli
> add_network 0
> set_network 0 ssid "SSID"
> set_network 0 psk "PASSWORD"
> enable_network 0
> quit
```

## 3. Partition the disk

Identify your disk with `lsblk`. Example for `/dev/nvme0n1`:

```bash
sudo parted /dev/nvme0n1 -- mklabel gpt
sudo parted /dev/nvme0n1 -- mkpart ESP fat32 1MiB 1GiB
sudo parted /dev/nvme0n1 -- set 1 esp on
sudo parted /dev/nvme0n1 -- mkpart primary 1GiB 100%
```

## 4. Encrypt and format

```bash
sudo cryptsetup luksFormat /dev/nvme0n1p2
sudo cryptsetup open /dev/nvme0n1p2 cryptroot

sudo mkfs.ext4 /dev/mapper/cryptroot
sudo mkfs.fat -F 32 /dev/nvme0n1p1

sudo mount /dev/mapper/cryptroot /mnt
sudo mkdir -p /mnt/boot
sudo mount /dev/nvme0n1p1 /mnt/boot
```

## 5. Generate hardware config and install a minimal system

```bash
sudo nixos-generate-config --root /mnt
```

Edit `/mnt/etc/nixos/configuration.nix` to add a minimal bootable system:

```nix
{ pkgs, ... }:
{
  imports = [ ./hardware-configuration.nix ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nix-work";
  networking.networkmanager.enable = true;

  users.users.jb = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" ];
    initialPassword = "changeme";
  };

  environment.systemPackages = with pkgs; [ git vim ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  system.stateVersion = "25.11";
}
```

Install and reboot:

```bash
sudo nixos-install
sudo reboot
```

## 6. Clone dotfiles and create the laptop host

Log in as `jb`, then:

```bash
git clone git@github.com:<user>/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
```

Copy the generated hardware config into a new host:

```bash
mkdir -p hosts/t14s
sudo cp /etc/nixos/hardware-configuration.nix hosts/t14s/
```

Create `hosts/t14s/default.nix`:

```nix
{ ... }:
{
  imports = [
    ./hardware-configuration.nix
    ./../../modules/core
  ];

  # Laptop-specific
  powerManagement.cpuFreqGovernor = "powersave";
  services.thermald.enable = true;
  services.tlp.enable = true;
}
```

## 7. Add the new host to flake.nix

Add a second entry under `nixosConfigurations`:

```nix
nix-work = nixpkgs.lib.nixosSystem {
  modules = [
    ./hosts/t14s
    stylix.nixosModules.stylix
    inputs.lanzaboote.nixosModules.lanzaboote
    { nixpkgs.hostPlatform = system; }
  ];
  specialArgs = {
    host = "nix-work";
    inherit self inputs username;
  };
};
```

## 8. Build and switch

```bash
cd ~/.dotfiles
sudo nixos-rebuild switch --flake .#nix-work
```

After first successful boot, set up secure boot (optional):

```bash
sudo sbctl create-keys
sudo sbctl enroll-keys --microsoft   # must be in Setup Mode
sudo nixos-rebuild switch --flake .#nix-work
```

## 9. Laptop-specific adjustments

Things to check after first deploy:

- **Display**: Remove or adjust the `outputs."HDMI-A-1"` block in `niri.nix` — the laptop display will have a different output name (e.g., `eDP-1`). Run `niri msg outputs` to find it.
- **Scaling**: The T14s likely needs `scale = 1.25` or `1.5` depending on the panel resolution.
- **Trackpad**: Already configured in niri (`touchpad.natural-scroll = true`).
- **Secure Boot**: The T14s firmware must be in Setup Mode before enrolling keys. Reset Secure Boot keys in BIOS first.
