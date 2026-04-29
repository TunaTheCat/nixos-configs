{ ... }:
{
  flake.modules.homeManager.apps =
    { pkgs, ... }:
    {
      programs.firefox = {
        enable = true;
        profiles.default.isDefault = true;
      };

      stylix.targets.firefox.profileNames = [ "default" ];

      home.packages = with pkgs; [
        slack
        loupe
        evince
        openvpn
        keepassxc
        joplin-desktop
      ];
    };
}
