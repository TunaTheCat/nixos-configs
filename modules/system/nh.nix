{ config, ... }:
{
  flake.modules.nixos.nh =
    { pkgs, ... }:
    {
      programs.nh = {
        enable = true;
        clean = {
          enable = true;
          extraArgs = "--keep-since 30d --keep 5";
        };
        flake = "/home/${config.username}/.dotfiles";
      };

      environment.systemPackages = with pkgs; [
        nvd
      ];
    };
}
