{pkgs, host, ...}:
{
  networking = {
    hostName = "${host}";
    networkmanager.enable = true;
    extraHosts = ''
      10.10.10.25 server-25.spacetek.local
    '';
    nameservers = [
      "8.8.8.8"
      "8.8.4.4"
      "1.1.1.1"
    ];
    firewall = {
      enable = true;
    };
  };
  environment.systemPackages = with pkgs; [networkmanagerapplet];
}
