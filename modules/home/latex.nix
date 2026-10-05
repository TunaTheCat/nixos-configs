{ ... }:
{
  flake.modules.homeManager.latex =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        texliveFull
        texlab
        tex-fmt
      ];
    };
}
