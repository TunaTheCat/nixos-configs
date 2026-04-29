{ ... }:
{
  flake.modules.nixos.hardware = {
    hardware.graphics.enable = true;
    hardware.enableRedistributableFirmware = true;

    hardware.bluetooth = {
      enable = true;
      powerOnBoot = true;
      settings = {
        General = {
          Experimental = true;
        };
      };
    };

    services.blueman.enable = true;
  };
}
