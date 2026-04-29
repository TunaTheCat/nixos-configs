{ ... }:
{
  flake.modules.nixos.watchdog = {
    systemd.settings.Manager.RuntimeWatchdogSec = "30s";
    systemd.settings.Manager.RebootWatchdogSec = "5min";
    systemd.settings.Manager.KExecWatchdogSec = "5min";
  };
}
