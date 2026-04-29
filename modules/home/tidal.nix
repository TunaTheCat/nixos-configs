{ ... }:
{
  flake.modules.homeManager.tidal =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        supercollider-with-sc3-plugins
        (haskellPackages.ghcWithPackages (hp: [ hp.tidal ]))
        qjackctl
      ];
    };
}
