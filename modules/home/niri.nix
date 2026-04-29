{
  inputs,
  pkgs,
  config,
  ...
}:
let
  terminal = "kitty";
  browser = "firefox";
  screenshot = pkgs.writeShellScriptBin "screenshot" ''
    dir="$HOME/Pictures/Screenshots"
    mkdir -p "$dir"
    file="$dir/$(date '+%Y-%m-%d_%H-%M-%S').png"

    case "$1" in
      --copy)
        ${pkgs.grim}/bin/grim -g "$(${pkgs.slurp}/bin/slurp)" - | ${pkgs.wl-clipboard}/bin/wl-copy
        ;;
      --save)
        ${pkgs.grim}/bin/grim -g "$(${pkgs.slurp}/bin/slurp)" "$file"
        ;;
      --swappy)
        ${pkgs.grim}/bin/grim -g "$(${pkgs.slurp}/bin/slurp)" - | ${pkgs.swappy}/bin/swappy -f -
        ;;
      *)
        echo "Usage: screenshot [--copy|--save|--swappy]"
        exit 1
        ;;
    esac
  '';

  powermenu = pkgs.writeShellScriptBin "powermenu" ''
    choice=$(printf "%s\n" \
      $'\uf023  Lock' \
      $'\uf08b  Logout' \
      $'\U000f0904  Suspend' \
      $'\uf021  Reboot' \
      $'\uf011  Shutdown' \
      | ${pkgs.fuzzel}/bin/fuzzel --dmenu --hide-prompt --width 18 --lines 5)

    case "$choice" in
      *Lock)     ${pkgs.hyprlock}/bin/hyprlock ;;
      *Logout)   niri msg action quit ;;
      *Suspend)  systemctl suspend ;;
      *Reboot)   systemctl reboot ;;
      *Shutdown) systemctl poweroff ;;
    esac
  '';
in
{
  imports = [ inputs.niri.homeModules.niri ];

  home.packages = with pkgs; [
    hyprpolkitagent
    swayidle
    swaybg
    wl-clipboard
    wl-clip-persist
    playerctl
    grim
    slurp
    swappy
    networkmanagerapplet
    poweralertd
    screenshot
    powermenu
  ];

  programs.niri = {
    enable = true;
    settings = {
      cursor = {
        theme = config.stylix.cursor.name;
        size = config.stylix.cursor.size;
      };

      spawn-at-startup = [
        {
          command = [
            "dbus-update-activation-environment"
            "--all"
            "--systemd"
            "WAYLAND_DISPLAY"
            "XDG_CURRENT_DESKTOP"
          ];
        }
        {
          command = [
            "systemctl"
            "--user"
            "import-environment"
            "WAYLAND_DISPLAY"
            "XDG_CURRENT_DESKTOP"
          ];
        }
        { command = [ "nm-applet" ]; }
        { command = [ "poweralertd" ]; }
        {
          command = [
            "wl-clip-persist"
            "--clipboard"
            "both"
          ];
        }

        {
          command = [
            "systemctl"
            "--user"
            "start"
            "hyprpolkitagent"
          ];
        }
        {
          command = [
            "swaybg"
            "-m"
            "fill"
            "-i"
            "${../../wallpapers/nix_dark_4k.png}"
          ];
        }
        { command = [ "waybar" ]; }
        {
          command = [
            "swayidle"
            "-w"
            "timeout"
            "600"
            "hyprlock"
            "timeout"
            "900"
            "niri msg action power-off-monitors"
            "before-sleep"
            "hyprlock"
          ];
        }
      ];

      input = {
        keyboard = {
          xkb = {
            layout = "us,ch";
            options = "grp:alt_caps_toggle";
          };
          repeat-delay = 300;
        };
        touchpad = {
          natural-scroll = true;
        };
      };

      layout = {
        gaps = 12;
        center-focused-column = "never";
        default-column-width.proportion = 0.5;
        focus-ring.enable = false;
        border = {
          enable = true;
          width = 2;
          active.color = "#9d7cd8";
          inactive.color = "#3b3b4f";
        };
      };

      debug = {
        honor-xdg-activation-with-invalid-serial = { };
      };

      binds =
        let
          bind = title: action: {
            inherit action;
            hotkey-overlay = { inherit title; };
          };
          hidden = action: {
            inherit action;
            hotkey-overlay.hidden = true;
          };
        in
        {
          # Launchers
          "Mod+Return" = bind "Terminal" { spawn = [ terminal ]; };
          "Mod+B" = bind "Browser" { spawn = [ browser ]; };
          "Mod+D" = bind "App Launcher" { spawn = [ "fuzzel" ]; };
          "Mod+E" = bind "File Explorer" { spawn = [ "thunar" ]; };
          "Mod+Escape" = bind "Lock Screen" { spawn = [ "hyprlock" ]; };
          "Mod+N" = bind "Toggle Notifications" {
            spawn = [
              "makoctl"
              "toggle"
            ];
          };

          # Window Management
          "Mod+Q" = bind "Close Window" { close-window = { }; };
          "Mod+F" = bind "Maximize Column" { maximize-column = { }; };
          "Mod+Shift+F" = bind "Fullscreen" { fullscreen-window = { }; };
          "Mod+Space" = bind "Toggle Floating" { toggle-window-floating = { }; };

          # Screenshots
          "Print" = bind "Screenshot (Copy)" {
            spawn = [
              "screenshot"
              "--copy"
            ];
          };
          "Mod+Shift+S" = bind "Screenshot (Copy)" {
            spawn = [
              "screenshot"
              "--copy"
            ];
          };
          "Mod+Print" = bind "Screenshot (Save)" {
            spawn = [
              "screenshot"
              "--save"
            ];
          };
          "Mod+Shift+Print" = bind "Screenshot (Edit)" {
            spawn = [
              "screenshot"
              "--swappy"
            ];
          };

          # Focus (arrows hidden — vim keys shown)
          "Mod+Left" = hidden { focus-column-left = { }; };
          "Mod+Right" = hidden { focus-column-right = { }; };
          "Mod+Up" = hidden { focus-window-up = { }; };
          "Mod+Down" = hidden { focus-window-down = { }; };
          "Mod+H" = bind "Focus Left" { focus-column-left = { }; };
          "Mod+J" = bind "Focus Down" { focus-window-or-workspace-down = { }; };
          "Mod+K" = bind "Focus Up" { focus-window-or-workspace-up = { }; };
          "Mod+L" = bind "Focus Right" { focus-column-right = { }; };

          # Move Windows (arrows hidden — vim keys shown)
          "Mod+Shift+Left" = hidden { move-column-left = { }; };
          "Mod+Shift+Right" = hidden { move-column-right = { }; };
          "Mod+Shift+Up" = hidden { move-window-up = { }; };
          "Mod+Shift+Down" = hidden { move-window-down = { }; };
          "Mod+Shift+H" = bind "Move Left" { move-column-left = { }; };
          "Mod+Shift+J" = bind "Move Down" { move-window-down = { }; };
          "Mod+Shift+K" = bind "Move Up" { move-window-up = { }; };
          "Mod+Shift+L" = bind "Move Right" { move-column-right = { }; };

          # Workspaces
          "Mod+1" = bind "Workspace 1" { focus-workspace = 1; };
          "Mod+2" = bind "Workspace 2" { focus-workspace = 2; };
          "Mod+3" = bind "Workspace 3" { focus-workspace = 3; };
          "Mod+4" = bind "Workspace 4" { focus-workspace = 4; };
          "Mod+5" = bind "Workspace 5" { focus-workspace = 5; };
          "Mod+6" = bind "Workspace 6" { focus-workspace = 6; };
          "Mod+7" = bind "Workspace 7" { focus-workspace = 7; };
          "Mod+8" = bind "Workspace 8" { focus-workspace = 8; };
          "Mod+9" = bind "Workspace 9" { focus-workspace = 9; };
          "Mod+Shift+1" = bind "Move to WS 1" { move-column-to-workspace = 1; };
          "Mod+Shift+2" = bind "Move to WS 2" { move-column-to-workspace = 2; };
          "Mod+Shift+3" = bind "Move to WS 3" { move-column-to-workspace = 3; };
          "Mod+Shift+4" = bind "Move to WS 4" { move-column-to-workspace = 4; };
          "Mod+Shift+5" = bind "Move to WS 5" { move-column-to-workspace = 5; };
          "Mod+Shift+6" = bind "Move to WS 6" { move-column-to-workspace = 6; };
          "Mod+Shift+7" = bind "Move to WS 7" { move-column-to-workspace = 7; };
          "Mod+Shift+8" = bind "Move to WS 8" { move-column-to-workspace = 8; };
          "Mod+Shift+9" = bind "Move to WS 9" { move-column-to-workspace = 9; };

          # Resize
          "Mod+Minus" = bind "Shrink Width" { set-column-width = "-10%"; };
          "Mod+Equal" = bind "Grow Width" { set-column-width = "+10%"; };
          "Mod+Shift+Minus" = bind "Shrink Height" { set-window-height = "-10%"; };
          "Mod+Shift+Equal" = bind "Grow Height" { set-window-height = "+10%"; };

          # Columns
          "Mod+C" = bind "Consume into Column" { consume-window-into-column = { }; };
          "Mod+X" = bind "Expel from Column" { expel-window-from-column = { }; };
          "Mod+Tab" = bind "Toggle Tabbed" { toggle-column-tabbed-display = { }; };

          # Scroll Workspaces (hidden from overlay)
          "Mod+WheelScrollDown" = hidden { focus-workspace-down = { }; };
          "Mod+WheelScrollUp" = hidden { focus-workspace-up = { }; };
          "Mod+TouchpadScrollDown" = hidden { focus-workspace-down = { }; };
          "Mod+TouchpadScrollUp" = hidden { focus-workspace-up = { }; };

          # Hotkey Overlay
          "Mod+Shift+Slash" = bind "Show Hotkeys" { show-hotkey-overlay = { }; };

          # Media
          "XF86AudioRaiseVolume" = bind "Volume Up" {
            spawn = [
              "wpctl"
              "set-volume"
              "@DEFAULT_AUDIO_SINK@"
              "5%+"
            ];
          };
          "XF86AudioLowerVolume" = bind "Volume Down" {
            spawn = [
              "wpctl"
              "set-volume"
              "@DEFAULT_AUDIO_SINK@"
              "5%-"
            ];
          };
          "XF86AudioMute" = bind "Mute" {
            spawn = [
              "wpctl"
              "set-mute"
              "@DEFAULT_AUDIO_SINK@"
              "toggle"
            ];
          };

          "XF86AudioPlay" = bind "Play/Pause" {
            spawn = [
              "playerctl"
              "play-pause"
            ];
          };
          "XF86AudioNext" = bind "Next Track" {
            spawn = [
              "playerctl"
              "next"
            ];
          };
          "XF86AudioPrev" = bind "Prev Track" {
            spawn = [
              "playerctl"
              "previous"
            ];
          };
        };

      window-rules = [
        {
          matches = [
            { app-id = "mpv"; }
            { app-id = "org.gnome.Loupe"; }
          ];
          open-floating = true;
        }
        {
          matches = [
            {
              app-id = "firefox";
              title = "Picture-in-Picture";
            }
          ];
          open-floating = true;
        }
      ];
    };
  };
}
