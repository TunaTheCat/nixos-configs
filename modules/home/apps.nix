{ ... }:
{
  flake.modules.homeManager.apps =
    { pkgs, ... }:
    {
      programs.firefox = {
        enable = true;
        profiles.default.isDefault = true;
      };
      programs.ranger = {
        enable = true;
        settings = {
          show_hidden = true;
          preview_images = true;
        };
      };
      programs.yazi = {
        enable = true;
        settings = {
          show_hidden = true;
          preview_images = true;
        };
      };
      stylix.targets.firefox.profileNames = [ "default" ];

      home.packages = with pkgs; [
        slack
        teams-for-linux
        loupe
        evince
        openvpn
        keepassxc
        joplin-desktop
        deluge
        remmina
      ];
    };
}
