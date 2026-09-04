{ config, lib, ... }:
let
  inherit (config.flake.modules) nixos;
in
{
  configurations.nixos.nix-home.module = {
    imports = [
      nixos.nix-home-hardware
      nixos.bootloader
      nixos.secureboot
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
      nixos.nh
      nixos.user
    ];

    networking.hostName = "nix-home";
    nixpkgs.hostPlatform = "x86_64-linux";
    powerManagement.cpuFreqGovernor = "performance";
    boot.kernelParams = [ "amdgpu.ppfeaturemask=0xffffdfff" ];

    # Disable built-in MT7921 Bluetooth (Foxconn 0489:e0e2) so only the
    # ASUS BT500 USB adapter (on desk, better signal) is used.
    services.udev.extraRules = ''
      SUBSYSTEM=="usb", ATTR{idVendor}=="0489", ATTR{idProduct}=="e0e2", ATTR{authorized}="0"
    '';

    home-manager.users.${config.username} = {
      # Dell AW3225QF via DisplayPort
      programs.niri.settings.outputs."DP-2" = {
        scale = 1.0;
        mode = {
          width = 3840;
          height = 2160;
          refresh = 239.991;
        };
        variable-refresh-rate = false;
      };

      # AMD Ryzen (k10temp), unlike nix-work's Intel coretemp default in waybar.nix.
      # PCI address of the SMU function is stable across boots/hwmonN renumbering.
      programs.waybar.settings.mainBar.temperature.hwmon-path-abs =
        lib.mkForce "/sys/devices/pci0000:00/0000:00:18.3/hwmon";
    };
  };
}
