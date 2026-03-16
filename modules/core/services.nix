{...}:
{
  services = {
    gvfs.enable = true;
    upower.enable = true;
    power-profiles-daemon.enable = true;
    dbus.enable = true;
    fstrim.enable = true;
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
}
