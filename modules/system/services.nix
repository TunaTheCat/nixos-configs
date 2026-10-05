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
      # No thermald: it refuses to run on ThinkPads with DYTC
      # (thinkpad_acpi/dytc_lapmode), where the firmware manages thermals;
      # power-profiles-daemon drives that via platform_profile.
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
