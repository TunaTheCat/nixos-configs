{ config, ... }:
let
  inherit (config.flake.modules) nixos;
in
{
  configurations.nixos.nix-work.module = {
    imports = [
      nixos.nix-work-hardware
      nixos.bootloader
      # nixos.secureboot  # opt in after `sbctl create-keys` && `sbctl enroll-keys --microsoft`
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
    powerManagement.cpuFreqGovernor = "powersave";

    home-manager.users.${config.username} = {
      programs.niri.settings.outputs = {
        "eDP-1".scale = 1.0;
        "DP-7".scale = 1.0;
      };
    };
  };
}
