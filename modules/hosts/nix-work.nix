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

    home-manager.users.${config.username} =
      { pkgs, ... }:
      let
        displayWatcher = pkgs.writeShellScript "niri-display-watcher" ''
          set -u
          internal="eDP-1"
          external="DP-6"

          apply() {
            if ${pkgs.niri}/bin/niri msg outputs 2>/dev/null | ${pkgs.gnugrep}/bin/grep -q "($external)"; then
              ${pkgs.niri}/bin/niri msg output "$internal" off || true
            else
              ${pkgs.niri}/bin/niri msg output "$internal" on || true
            fi
          }

          apply
          ${pkgs.systemd}/bin/udevadm monitor --kernel --subsystem-match=drm | while IFS= read -r _; do
            sleep 0.2
            apply
          done
        '';
      in
      {
        programs.niri.settings = {
          outputs = {
            "eDP-1" = {
              scale = 1.0;
              mode = {
                width = 1920;
                height = 1200;
                refresh = 60.001;
              };
              position = { x = 0; y = 0; };
            };
            "DP-6" = {
              scale = 1.0;
              mode = {
                width = 3840;
                height = 2160;
                refresh = 59.996;
              };
            };
          };

          spawn-at-startup = [
            { command = [ "${displayWatcher}" ]; }
          ];
        };
      };
  };
}
