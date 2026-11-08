{ ... }:
{
  flake.modules.nixos.security = {
    security.rtkit.enable = true;
    security.sudo.enable = true;
    security.polkit.enable = true;
    # gnome-keyring 50.0 aborts when an OpenSession races client registration
    # (sbx triggers it); the respawned daemon comes up locked and prompts.
    # Upstream: gnome-keyring#190. Drop once fixed in nixpkgs.
    nixpkgs.overlays = [
      (final: prev: {
        gnome-keyring = prev.gnome-keyring.overrideAttrs (old: {
          patches = (old.patches or [ ]) ++ [ ../../patches/gnome-keyring-open-session-null.patch ];
        });
      })
    ];
    security.pam.loginLimits = [
      { domain = "@audio"; item = "rtprio"; type = "-"; value = "95"; }
      { domain = "@audio"; item = "memlock"; type = "-"; value = "unlimited"; }
    ];
  };
}
