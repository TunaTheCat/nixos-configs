{ ... }:
{
  flake.modules.nixos.wayland =
    { pkgs, ... }:
    {
      programs.niri.enable = true;

      environment.systemPackages = [ pkgs.xwayland ];

      xdg.portal = {
        enable = true;
        xdgOpenUsePortal = true;
        config = {
          common.default = [ "gtk" ];
          niri.default = [ "gtk" ];
        };
        extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
      };
    };
}
