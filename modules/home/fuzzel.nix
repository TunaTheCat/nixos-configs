{ ... }:
{
  programs.fuzzel = {
    enable = true;
    settings = {
      main = {
        terminal = "kitty";
        layer = "overlay";

        width = 35;
        lines = 8;
        prompt = "  ";
      };
      border = {
        width = 2;
        radius = 8;
      };
    };
  };
}
