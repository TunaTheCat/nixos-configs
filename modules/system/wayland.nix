{ ... }:
{
  flake.modules.nixos.wayland =
    { pkgs, ... }:
    {
      programs.niri.enable = true;
      programs.niri.package = pkgs.niri;

      environment.systemPackages = [ pkgs.xwayland ];

      xdg.portal = {
        enable = true;
        xdgOpenUsePortal = true;
        config = {
          common = {
            default = [ "gtk" ];
            "org.freedesktop.impl.portal.ScreenCast" = [ "gnome" ];
            "org.freedesktop.impl.portal.Screenshot" = [ "gnome" ];
          };
          niri = {
            default = [ "gnome" "gtk" ];
            "org.freedesktop.impl.portal.ScreenCast" = [ "gnome" ];
            "org.freedesktop.impl.portal.Screenshot" = [ "gnome" ];
          };
        };
        extraPortals = [
          pkgs.xdg-desktop-portal-gtk
          pkgs.xdg-desktop-portal-gnome
        ];
      };
    };
}
