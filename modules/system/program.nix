{ ... }:
{
  flake.modules.nixos.program =
    { pkgs, ... }:
    {
      programs.dconf.enable = true;
      programs.gnupg.agent = {
        enable = true;
        enableSSHSupport = false;
      };
      programs.nix-ld.enable = true;
      programs.nix-ld.libraries = with pkgs; [];

      programs.thunar = {
        enable = true;
        plugins = with pkgs.xfce; [
          thunar-archive-plugin
          thunar-volman
        ];
      };

      services.gvfs.enable = true;
      services.tumbler.enable = true;
    };
}
