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
      programs.nix-ld.libraries = with pkgs; [ ];

      programs.thunar = {
        enable = true;
        plugins = with pkgs; [
          thunar-archive-plugin
          thunar-volman
        ];
      };

      # Provides `xfce4-mime-helper`, which exo/Thunar shell out to in order to
      # launch category helpers (e.g. the preferred TerminalEmulator). Without
      # it, opening a terminal or a Terminal=true app from Thunar fails with
      # "Could not find fallback TerminalEmulator application".
      environment.systemPackages = [ pkgs.xfce4-settings ];

      services.gvfs.enable = true;
      services.tumbler.enable = true;
    };
}
