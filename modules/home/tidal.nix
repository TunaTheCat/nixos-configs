{ ... }:
{
  flake.modules.homeManager.tidal =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        supercollider
      ];
    };
}
