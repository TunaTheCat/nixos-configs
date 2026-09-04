{ ... }:
{
  flake.modules.nixos.network =
    { pkgs, ... }:
    {
      networking = {
        networkmanager = {
          enable = true;
          # Per-link DNS via systemd-resolved instead of a flat /etc/resolv.conf.
          # Fixes the real problem behind the old wifi-wired-exclusive dispatcher:
          # glibc only reads the first 3 nameservers, so a global public-DNS list
          # displaced the DHCP-provided internal resolvers and .local never resolved.
          dns = "systemd-resolved";
          # No dispatcherScripts: NM route metrics already prefer ethernet (100)
          # over wifi (600), so both links can stay up and ethernet still wins.
          # Killing the radio also persisted WirelessEnabled=false, which stranded
          # the machine with no network when booting undocked.
        };
        # Split-horizon override: internal IP for a name that resolves publicly.
        extraHosts = ''
          10.10.10.25 server-25.spacetek.local docker.spacetek.ch
          10.10.10.112 server-27.spacetek.local
        '';
        # No networking.nameservers: each link supplies its own DNS, so the
        # ethernet DHCP servers handle spacetek.local. Public lookups fall
        # through to services.resolved.settings.Resolve.FallbackDNS.
        firewall = {
          enable = true;
          trustedInterfaces = [ "tailscale0" ];
        };
      };

      services.resolved = {
        enable = true;
        settings.Resolve = {
          # Internal AD-style zones are typically unsigned.
          DNSSEC = false;
          # .local is reserved for mDNS and resolved would route spacetek.local to
          # multicast rather than the internal unicast servers. Disabling mDNS makes
          # it use unicast DNS for that zone.
          MulticastDNS = false;
          FallbackDNS = [
            "1.1.1.1"
            "8.8.8.8"
          ];
        };
      };

      environment.systemPackages = with pkgs; [ networkmanagerapplet ];
    };
}
