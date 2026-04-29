{ ... }:
{
  # Replace this with the output of:
  #   nixos-generate-config --root /mnt --show-hardware-config
  flake.modules.nixos.nix-work-hardware =
    {
      config,
      lib,
      modulesPath,
      ...
    }:
    {
      imports = [
        (modulesPath + "/installer/scan/not-detected.nix")
      ];

      # TODO: fill in from nixos-generate-config
      boot.initrd.availableKernelModules = [];
      boot.initrd.kernelModules = [];
      boot.kernelModules = [];
      boot.extraModulePackages = [];

      # TODO: fill in your disk layout
      # fileSystems."/" = { device = "..."; fsType = "..."; };
      # fileSystems."/boot" = { device = "..."; fsType = "vfat"; };

      swapDevices = [];

      networking.useDHCP = lib.mkDefault true;
      nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
    };
}
