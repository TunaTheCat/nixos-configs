{...}:
{
  imports = [./../../modules/home];

  # Dell AW3225QF via DisplayPort
  programs.niri.settings.outputs."DP-2" = {
    scale = 1.0;
    mode = {
      width = 3840;
      height = 2160;
      refresh = 239.991;
    };
    variable-refresh-rate = false;
  };
}
