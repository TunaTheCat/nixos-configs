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
    settings = {
      General = {
        Experimental = true; # Battery reporting for connected devices
      };
    };
  };

  services.blueman.enable = true;
}
      
