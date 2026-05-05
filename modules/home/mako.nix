{ ... }:
{
  flake.modules.homeManager.mako = {
    services.mako = {
      enable = true;
      settings = {
        default-timeout = 5000;
        ignore-timeout = 1;
        border-size = 2;
        border-radius = 8;
        padding = "12";
        margin = "12";
        width = 350;
        max-visible = 3;
        layer = "overlay";
        anchor = "bottom-right";
      };
    };
  };
}
