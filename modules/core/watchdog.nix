{...}:
{
  # Hardware watchdog (SP5100 TCO timer on this AMD board).
  #
  # systemd PID1 takes ownership of /dev/watchdog0 and pets it every
  # RuntimeWatchdogSec/2 seconds. If PID1 stops responding for longer than
  # RuntimeWatchdogSec, the watchdog reboots the machine without OS involvement.
  #
  # Combined with TPM2 LUKS auto-unlock (see ./tpm.nix), this means a
  # kernel-side hang recovers itself within ~1 minute, and the box comes
  # back fully — disk unlocks, networking returns, Tailscale reconnects —
  # without anyone needing physical access to type a passphrase.
  #
  # Caveat: only catches hangs severe enough to stall PID1. A pure
  # userspace hang where systemd is still scheduled won't trigger a reboot.
  # Real-world AMDGPU SDMA hangs (the case this was added for) do.
  systemd.settings.Manager.RuntimeWatchdogSec = "30s";
  systemd.settings.Manager.RebootWatchdogSec  = "5min";
  systemd.settings.Manager.KExecWatchdogSec   = "5min";
}
