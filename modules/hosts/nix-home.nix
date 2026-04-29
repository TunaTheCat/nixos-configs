{ config, ... }:
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
      nixos.watchdog
      nixos.nh
      nixos.user
    ];

    # TPM2 auto-unlock for LUKS root
    boot.initrd.systemd.enable = true;
    boot.initrd.luks.devices."luks-21e78e14-ab2b-4857-aa46-553eeec6f345".crypttabExtraOpts = [
      "tpm2-device=auto"
    ];
    security.tpm2 = {
      enable = true;
      pkcs11.enable = true;
      tctiEnvironment.enable = true;
    };

    networking.hostName = "nix-home";
    nixpkgs.hostPlatform = "x86_64-linux";
    powerManagement.cpuFreqGovernor = "performance";

    # Disable built-in MT7921 Bluetooth (Foxconn 0489:e0e2) so only the
    # ASUS BT500 USB adapter (on desk, better signal) is used.
    services.udev.extraRules = ''
      SUBSYSTEM=="usb", ATTR{idVendor}=="0489", ATTR{idProduct}=="e0e2", ATTR{authorized}="0"
    '';

    # Dell AW3225QF via DisplayPort
    home-manager.users.${config.username}.programs.niri.settings.outputs."DP-2" = {
      scale = 1.0;
      mode = {
        width = 3840;
        height = 2160;
        refresh = 239.991;
      };
      variable-refresh-rate = false;
    };
  };
}
