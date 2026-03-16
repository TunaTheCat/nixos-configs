{pkgs, ...}:
{
  home.packages = with pkgs; [
    pavucontrol
    qpwgraph
  ];
}
