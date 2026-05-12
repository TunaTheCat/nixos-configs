{ ... }:
{
  flake.modules.homeManager.btop = {
    stylix.targets.btop.enable = false;

    programs.btop = {
      enable = true;
      settings = {
        color_theme = "kanagawa-wave";
        vim_keys = true;
      };
    };
  };
}
