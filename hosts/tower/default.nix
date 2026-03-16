{...}:
{
  imports = [
    # ./configuration.nix
    ./hardware-configuration.nix
    ./../../modules/core
  ];
  powerManagement.cpuFreqGovernor = "performance";
}
