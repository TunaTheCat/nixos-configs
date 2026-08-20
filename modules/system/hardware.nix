{ ... }:
{
  flake.modules.nixos.hardware =
    { pkgs, ... }:
    {
      hardware.graphics.enable = true;
      hardware.enableRedistributableFirmware = true;

      # `sensors` CLI + hwmon labels; also backs btop/waybar temperature readouts.
      environment.systemPackages = [ pkgs.lm_sensors ];

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
