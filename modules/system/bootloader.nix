{ ... }:
{
  flake.modules.nixos.bootloader =
    { pkgs, ... }:
    {
      boot.loader.systemd-boot.enable = true;
      boot.loader.efi.canTouchEfiVariables = true;
      boot.kernelPackages = pkgs.linuxPackages_zen;
      boot.consoleLogLevel = 0;
      boot.kernelParams = [ "quiet" "loglevel=0" "systemd.show_status=auto" "rd.udev.log_level=3" ];
    };
}
