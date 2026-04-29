{ inputs, ... }:
{
  flake.modules.nixos.system =
    { pkgs, ... }:
    {
      nix.settings = {
        auto-optimise-store = true;
        experimental-features = [ "nix-command" "flakes" ];
        substituters = [ "https://nix-community.cachix.org" ];
        trusted-public-keys = [
          "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        ];
      };

      nixpkgs = {
        overlays = [
          inputs.nur.overlays.default
          inputs.rust-overlay.overlays.default
        ];
        config.allowUnfree = true;
      };

      environment.systemPackages = with pkgs; [
        wget
        git
        nushell
        nil
        gnumake
        btop
        nerd-fonts.hasklug
      ];

      virtualisation.podman = {
        enable = true;
        dockerCompat = true;
        defaultNetwork.settings.dns_enabled = true;
      };

      environment.shells = [ pkgs.bash ];
      system.activationScripts.binbash = ''
        mkdir -p /bin
        ln -sfn ${pkgs.bash}/bin/bash /bin/bash
      '';

      time.timeZone = "Europe/Zurich";
      i18n.defaultLocale = "en_US.UTF-8";

      system.stateVersion = "25.05";
    };
}
