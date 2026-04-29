{ ... }:
{
  flake.modules.homeManager.kitty = {
    programs.kitty = {
      enable = true;
      settings = {
        scrollback_lines = 10000;
        enable_audio_bell = false;
        window_padding_width = 4;
        cursor_shape = "underline";
        draw_minimal_borders = "yes";
        hide_window_decorations = "yes";
        scrollback_pager = ''sh -c "hx /tmp/kitty_scrollback_buffer"'';
      };
      keybindings = {
        "ctrl+shift+h" = "show_scrollback";
      };
    };
  };
}
