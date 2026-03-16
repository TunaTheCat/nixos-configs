{...}:
{
  hardware = {
    graphics = {
      enable = true;
    };
  };
  hardware.enableRedistributableFirmware = true;

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };

  services.blueman.enable = true;
}
      
