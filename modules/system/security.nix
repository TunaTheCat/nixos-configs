{ ... }:
{
  flake.modules.nixos.security = {
    security.rtkit.enable = true;
    security.sudo.enable = true;
    security.polkit.enable = true;
    security.pam.services.hyprlock = {};
    security.pam.loginLimits = [
      { domain = "@audio"; item = "rtprio"; type = "-"; value = "95"; }
      { domain = "@audio"; item = "memlock"; type = "-"; value = "unlimited"; }
    ];
  };
}
