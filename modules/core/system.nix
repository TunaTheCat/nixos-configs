{pkgs, inputs, ...}:
{
  nix = {
    settings = {
      auto-optimise-store = true;
      experimental-features = ["nix-command" "flakes"];
      substituters = [
        "https://nix-community.cachix.org"
      ];
      trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];
    };
  };
  nixpkgs = {
    overlays = [inputs.nur.overlays.default
    inputs.rust-overlay.overlays.default
    ];
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


  # Many scripts expect /bin/bash to exist
  environment.shells = [ pkgs.bash ];
  system.activationScripts.binbash = ''
    mkdir -p /bin
    ln -sfn ${pkgs.bash}/bin/bash /bin/bash
  '';

  time.timeZone = "Europe/Zurich";
  i18n.defaultLocale = "en_US.UTF-8";
  nixpkgs.config.allowUnfree = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?
}
