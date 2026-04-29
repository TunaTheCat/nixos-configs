{ ... }:
{
  flake.modules.homeManager.audio =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        pavucontrol
        qpwgraph
      ];
    };
}
