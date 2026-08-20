{ ... }:
{
  flake.modules.nixos.services = {
    services.tailscale.enable = true;
    services.openssh.enable = true;
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
      wireplumber = {
        enable = true;
      };
    };

    services = {
      gvfs.enable = true;
      upower.enable = true;
      power-profiles-daemon.enable = true;
      dbus.enable = true;
      fstrim.enable = true;
      # Intel thermal management daemon — proactively manages thermals to
      # avoid hard thermal throttling on the thermally-constrained i7-1260P.
      thermald.enable = true;
    };

    services.logind.settings = {
      Login = {
        HandlePowerKey = "ignore";
      };
    };

    systemd.settings = {
      Manager = {
        DefaultTimeoutStopSec = "10s";
      };
    };
  };
}
