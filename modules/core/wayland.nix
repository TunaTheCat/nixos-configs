{pkgs, ...}:
{
  # Niri is a scrollable-tiling Wayland compositor.
  # We use the nixpkgs module.
  programs.niri = {
    enable = true;
  };

  # XWayland for running X11 apps in Wayland
  environment.systemPackages = [ pkgs.xwayland ];

  xdg.portal = {
    enable = true;
    xdgOpenUsePortal = true;
    config = {
      common.default = ["gtk"];
      niri.default = [
        "gtk"
      ];
    };
    extraPortals = [pkgs.xdg-desktop-portal-gtk];
  };
}
