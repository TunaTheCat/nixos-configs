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
      imports = [./../home];
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
    hashedPassword= "$y$j9T$SiImGjYtyoL4krrAWCWQ21$FobbxKFBsxRpudY8L9Z0K5wbRAipY6TljD2wEWoDqJA";
    # passwordFile = "/etc/nixos/secrets/pw";
    # initialPassword = "asdf";
  };
  nix.settings.allowed-users = ["${username}"];
}
