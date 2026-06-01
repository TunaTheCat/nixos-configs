{ ... }:
{
  flake.modules.nixos.network =
    { pkgs, ... }:
    {
      networking = {
        networkmanager = {
          enable = true;
          dispatcherScripts = [
            {
              source = pkgs.writeText "wifi-wired-exclusive" ''
                if [ "$2" = "up" ] || [ "$2" = "down" ]; then
                  has_wired=$(${pkgs.networkmanager}/bin/nmcli -t -f DEVICE,TYPE,STATE dev | grep 'ethernet:connected' | grep -c .)
                  if [ "$has_wired" -gt 0 ]; then
                    ${pkgs.networkmanager}/bin/nmcli radio wifi off
                  else
                    ${pkgs.networkmanager}/bin/nmcli radio wifi on
                  fi
                fi
              '';
              type = "basic";
            }
          ];
        };
        extraHosts = ''
          10.10.10.25 server-25.spacetek.local docker.spacetek.ch
        '';
        nameservers = [
          "8.8.8.8"
          "8.8.4.4"
          "1.1.1.1"
        ];
        firewall = {
          enable = true;
          trustedInterfaces = [ "tailscale0" ];
        };
      };

      environment.systemPackages = with pkgs; [ networkmanagerapplet ];
    };
}
