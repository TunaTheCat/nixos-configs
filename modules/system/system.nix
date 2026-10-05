{ inputs, ... }:
{
  flake.modules.nixos.system =
    { pkgs, ... }:
    {
      nix.settings = {
        auto-optimise-store = true;
        experimental-features = [
          "nix-command"
          "flakes"
        ];
        substituters = [
          "https://nix-community.cachix.org"
          "https://noctalia.cachix.org"
        ];
        trusted-public-keys = [
          "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
          "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4="
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
        fd
        unzip
        fdtools
        nmap
        # nerd-fonts.hasklug
      ];

      # oomd is on by default but monitors no cgroups unless these are set, so a
      # runaway session would thrash swap until the machine froze (2026-10-02).
      systemd.oomd = {
        # Both kill the worst offending cgroup at >80% memory pressure for 30s.
        enableRootSlice = true;
        enableUserSlices = true;
      };

      # Compressed RAM swap ahead of the slow on-disk partition.
      zramSwap.enable = true;

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
