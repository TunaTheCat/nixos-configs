{ config, ... }:
let
  inherit (config.flake.modules) nixos;
in
{
  configurations.nixos.nix-work.module = {
    imports = [
      nixos.nix-work-hardware
      nixos.bootloader
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

    networking.hostName = "nix-work";
    nixpkgs.hostPlatform = "x86_64-linux";

    # TODO: TPM2 auto-unlock — after installing, enroll with:
    #   sudo systemd-cryptenroll --tpm2-device=auto --tpm2-pcrs=7 /dev/disk/by-uuid/<YOUR-LUKS-UUID>
    # Then uncomment and fill in:
    # boot.initrd.systemd.enable = true;
    # boot.initrd.luks.devices."luks-<YOUR-LUKS-UUID>".crypttabExtraOpts = [ "tpm2-device=auto" ];
    # security.tpm2 = { enable = true; pkcs11.enable = true; tctiEnvironment.enable = true; };

    home-manager.users.${config.username}.programs.niri.settings.outputs = {
      # TODO: replace with your laptop display
      # "eDP-1" = {
      #   scale = 1.0;
      #   mode = { width = 1920; height = 1080; refresh = 60.0; };
      # };
    };
  };
}
