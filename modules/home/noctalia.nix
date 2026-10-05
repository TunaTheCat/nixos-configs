{ inputs, ... }:
{
  flake.modules.homeManager.noctalia =
    { config, ... }:
    let
      colors = config.lib.stylix.colors.withHashtag;
    in
    {
      imports = [ inputs.noctalia.homeModules.default ];

      programs.noctalia = {
        enable = true;
        # Own cgroup + restart-on-failure, instead of living in niri's scope.
        systemd.enable = true;

        # Same base16 -> role mapping as stylix's (v4-only) noctalia-shell target.
        customPalettes.stylix.dark = with colors; {
          mPrimary = base0D;
          mOnPrimary = base00;
          mSecondary = base0E;
          mOnSecondary = base00;
          mTertiary = base0C;
          mOnTertiary = base00;
          mError = base08;
          mOnError = base00;
          mSurface = base00;
          mOnSurface = base05;
          mSurfaceVariant = base01;
          mOnSurfaceVariant = base04;
          mOutline = base03;
          mShadow = base00;
          mHover = base0C;
          mOnHover = base00;
          # Required: without a `terminal` block the palette is rejected as
          # "not found or invalid" and noctalia silently falls back to builtin.
          terminal = {
            background = base00;
            foreground = base05;
            cursor = base05;
            cursorText = base00;
            selectionBg = base02;
            selectionFg = base05;
            normal = {
              black = base00;
              red = base08;
              green = base0B;
              yellow = base0A;
              blue = base0D;
              magenta = base0E;
              cyan = base0C;
              white = base05;
            };
            bright = {
              black = base03;
              red = base08;
              green = base0B;
              yellow = base0A;
              blue = base0D;
              magenta = base0E;
              cyan = base0C;
              white = base07;
            };
          };
        };

        settings = {
          shell = {
            font_family = config.stylix.fonts.sansSerif.name;
            # Apps get their own systemd units, so restarting the shell doesn't kill them.
            launch_apps_as_systemd_services = true;
            # wl-clip-persist (niri.nix) already does this.
            clipboard_keep_from_closed_apps = false;
          };

          theme = {
            mode = "dark";
            source = "custom";
            custom_palette = "stylix";
          };

          wallpaper = {
            enabled = true;
            default.path = "${config.stylix.image}";
          };

          # `force` holds the night temperature permanently, ignoring the
          # sunrise/sunset schedule (so no [location] is needed).
          nightlight = {
            enabled = true;
            force = true;
            temperature_night = 4500;
          };

          # Replaces swayidle; locking before suspend is on by default
          # (lockscreen.lock_before_suspend).
          idle.behavior = {
            lock = {
              timeout = 600;
              action = "lock";
              enabled = true;
            };
            screen-off = {
              timeout = 900;
              action = "screen_off";
              enabled = true;
            };
          };

          widget = {
            cpu = {
              type = "sysmon";
              stat = "cpu_usage";
            };
            temp = {
              type = "sysmon";
              stat = "cpu_temp";
            };
            ram = {
              type = "sysmon";
              stat = "ram_used";
            };
            clock.format = "{:%I:%M %p}";
          };

          bar.main = {
            start = [
              "launcher"
              "workspaces"
              "active_window"
            ];
            center = [ "clock" ];
            end = [
              "cpu"
              "temp"
              "ram"
              "volume"
              "network"
              "bluetooth"
              "keyboard_layout"
              "tray"
              "notifications"
              "control_center"
              "session"
            ];
          };
        };
      };
    };
}
