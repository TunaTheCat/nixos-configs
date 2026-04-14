{
  pkgs,
  inputs,
  username,
  host,
  ...
}:
{
  imports = [inputs.home-manager.nixosModules.home-manager];
  home-manager = {
    useUserPackages = true;
    useGlobalPkgs = true;
    backupFileExtension = "hm-backup";
    extraSpecialArgs = {inherit inputs username host;};
    users.${username} = {
      imports = [./../../hosts/${host}/home.nix];
      home.username = "${username}";
      home.homeDirectory = "/home/${username}";
      home.stateVersion = "25.11";
      programs.home-manager.enable = true;
    };
  };

  users.users.${username} = {
    isNormalUser = true;
    description = "${username}";
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
    shell = pkgs.nushell;
    hashedPassword = "$y$j9T$SiImGjYtyoL4krrAWCWQ21$FobbxKFBsxRpudY8L9Z0K5wbRAipY6TljD2wEWoDqJA";
    subUidRanges = [{ startUid = 100000; count = 65536; }];
    subGidRanges = [{ startGid = 100000; count = 65536; }];
    # passwordFile = "/etc/nixos/secrets/pw";
    # initialPassword = "asdf";
  };
  nix.settings.allowed-users = ["${username}"];
}
