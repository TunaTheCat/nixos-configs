{ config, inputs, ... }:
let
  inherit (config) username;
in
{
  flake.modules.nixos.greetd =
    { config, ... }:
    let
      colors = config.lib.stylix.colors.withHashtag;
    in
    {
      imports = [ inputs.noctalia-greeter.nixosModules.default ];

      # Runs on greetd; the module wires up greetd, Polkit and AccountsService.
      services.displayManager.noctalia-greeter = {
        enable = true;
        cursorTheme.package = config.stylix.cursor.package;

        settings = {
          session.default = "niri";
          user.default = username;

          appearance = {
            scheme = "Synced";
            theme_mode = "dark";
            font_family = config.stylix.fonts.sansSerif.name;
            wallpaper = {
              path = "${config.stylix.image}";
              fill_mode = "crop";
            };
            # Same base16 mapping as the shell palette in home/noctalia.nix; a
            # complete palette here wins over anything the shell syncs.
            palette = with colors; {
              primary = base0D;
              on_primary = base00;
              secondary = base0E;
              on_secondary = base00;
              tertiary = base0C;
              on_tertiary = base00;
              error = base08;
              on_error = base00;
              surface = base00;
              on_surface = base05;
              surface_variant = base01;
              on_surface_variant = base04;
              outline = base03;
              shadow = base00;
              hover = base0C;
              on_hover = base00;
            };
          };

          cursor = {
            theme = config.stylix.cursor.name;
            size = config.stylix.cursor.size;
          };

          # Match niri's input.keyboard.xkb.
          keyboard = {
            layout = "us,ch";
            options = "grp:alt_caps_toggle";
          };
        };
      };
    };
}
