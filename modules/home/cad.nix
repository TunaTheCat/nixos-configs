{ ... }:
{
  flake.modules.homeManager.cad =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        # Code-based modelling with headless PNG/STL export. The unstable
        # build ships the Manifold backend; the 2021 release is very slow.
        openscad-unstable
        # Viewing, measuring and STEP/DXF work on the generated models.
        freecad
      ];
    };
}
