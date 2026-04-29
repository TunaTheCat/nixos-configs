{ config, inputs, ... }:
{
  flake.modules.nixos.user =
    { pkgs, ... }:
    {
      imports = [ inputs.home-manager.nixosModules.home-manager ];

      home-manager = {
        useUserPackages = true;
        useGlobalPkgs = true;
        backupFileExtension = "hm-backup";
        extraSpecialArgs = { inherit inputs; };
        users.${config.username} = {
          imports = builtins.attrValues (config.flake.modules.homeManager or {});
          home.username = config.username;
          home.homeDirectory = "/home/${config.username}";
          home.stateVersion = "25.11";
          programs.home-manager.enable = true;
        };
      };

      users.users.${config.username} = {
        isNormalUser = true;
        description = config.username;
        extraGroups = [
          "networkmanager"
          "wheel"
        ];
        shell = pkgs.nushell;
        hashedPassword = "$y$j9T$SiImGjYtyoL4krrAWCWQ21$FobbxKFBsxRpudY8L9Z0K5wbRAipY6TljD2wEWoDqJA";
      };

      nix.settings.allowed-users = [ config.username ];
    };
}
