{ ... }:
{
  flake.modules.nixos.security = {
    security.rtkit.enable = true;
    security.sudo.enable = true;
    security.polkit.enable = true;
    # Unlock the login keyring on password SSH logins too (greetd/login already
    # do), so Secret Service clients like sbx don't block on an unlock prompt
    # that can only appear on the physical screen.
    security.pam.services.sshd.enableGnomeKeyring = true;
    security.pam.loginLimits = [
      { domain = "@audio"; item = "rtprio"; type = "-"; value = "95"; }
      { domain = "@audio"; item = "memlock"; type = "-"; value = "unlimited"; }
    ];
  };
}
