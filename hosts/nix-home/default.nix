{...}:
{
  imports = [
    ./hardware-configuration.nix
    ./../../modules/core
  ];

  powerManagement.cpuFreqGovernor = "performance";

  # Disable built-in MT7921 Bluetooth (Foxconn 0489:e0e2) so only the
  # ASUS BT500 USB adapter (on desk, better signal) is used.
  services.udev.extraRules = ''
    SUBSYSTEM=="usb", ATTR{idVendor}=="0489", ATTR{idProduct}=="e0e2", ATTR{authorized}="0"
  '';
}
