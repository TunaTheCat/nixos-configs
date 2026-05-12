{ ... }:
{
  flake.modules.homeManager.waybar =
    { pkgs, ... }:
    {
      home.packages = [ pkgs.pamixer ];

      programs.waybar = {
        enable = true;
        settings = {
          mainBar = {
            layer = "top";
            position = "top";
            height = 34;

            modules-left = [
              "custom/launcher"
              "niri/workspaces"
              "niri/window"
            ];
            modules-center = [ "clock" ];
            modules-right = [
              "cpu"
              "memory"
              "pulseaudio"
              "network"
              "bluetooth"
              "niri/language"
              "tray"
            ];

            "custom/launcher" = {
              format = " ";
              tooltip = true;
              tooltip-format = "Applications";
              on-click = "fuzzel";
            };

            "niri/workspaces" = {
              format = "{icon}";
              format-icons = {
                "1" = "I";
                "2" = "II";
                "3" = "III";
                "4" = "IV";
                "5" = "V";
                "6" = "VI";
                "7" = "VII";
                "8" = "VIII";
                "9" = "IX";
              };
            };

            "niri/window" = {
              max-length = 40;
              separate-outputs = true;
            };

            clock = {
              format = " {:%I:%M %p}";
              format-alt = " {:%a %d %b}";
              tooltip = true;
              tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
            };

            cpu = {
              format = " {usage}%";
              format-alt = " {avg_frequency} GHz";
              interval = 2;
            };

            memory = {
              format = "󰍛 {}%";
              format-alt = "󰍛 {used} GiB";
              interval = 2;
            };

            pulseaudio = {
              format = "{icon} {volume}%";
              format-muted = "󰝟 {volume}%";
              format-icons.default = [
                "󰕿"
                "󰖀"
                "󰕾"
              ];
              scroll-step = 2;
              on-click = "pavucontrol";
              on-click-right = "pamixer -t";
            };

            network = {
              format-wifi = "󰤨 {signalStrength}%";
              format-ethernet = "󰈀";
              format-disconnected = "󰤭";
              tooltip-format = "Connected to {essid} {ifname} via {gwaddr}";
              format-linked = "{ifname} (No IP)";
            };

            bluetooth = {
              format = "󰂯 {status}";
              format-connected = "󰂱 {device_alias}";
              format-connected-battery = "󰂱 {device_alias} {device_battery_percentage}%";
              tooltip-format = "{controller_alias}\t{controller_address}";
              tooltip-format-connected = "{controller_alias}\t{controller_address}\n\n{device_enumerate}";
              tooltip-format-enumerate-connected = "{device_alias}\t{device_address}";
              on-click = "blueman-manager";
            };

            "niri/language".format = "󰌌 {short}";

            tray = {
              icon-size = 20;
              spacing = 8;
            };
          };
        };

        style = ''
          * {
            border: none;
            border-radius: 0px;
            padding: 0;
            margin: 0;
            font-family: "Hack Nerd Font";
            font-size: 14px;
          }

          window#waybar {
            background: alpha(@base00, 0.9);
            color: @base05;
            border-bottom: 1px solid alpha(@base03, 0.5);
          }

          tooltip {
            background: @base01;
            border: 1px solid @base03;
          }
          tooltip label {
            margin: 5px;
            color: @base05;
          }

          #custom-launcher {
            font-size: 18px;
            color: @base0D;
            margin-left: 15px;
            padding-right: 10px;
          }

          #workspaces {
            padding-left: 10px;
          }
          #workspaces button {
            color: @base04;
            padding-left: 5px;
            padding-right: 5px;
            margin-right: 10px;
          }
          #workspaces button.active {
            color: @base0E;
          }

          #window {
            margin-left: 15px;
            color: @base04;
          }

          #clock {
            color: @base05;
          }

          #cpu, #memory, #pulseaudio, #network, #bluetooth, #language, #tray {
            padding-left: 5px;
            padding-right: 5px;
            margin-right: 10px;
            color: @base05;
          }

          #tray menu {
            background: @base01;
            border: 1px solid @base03;
            padding: 8px;
          }
          #tray menuitem {
            padding: 1px;
          }

          #cpu { color: @base0B; }
          #memory { color: @base0C; }
          #pulseaudio { color: @base0D; }
          #network { color: @base0E; }
          #bluetooth { color: @base0D; }
          #language { color: @base0A; }
        '';
      };
    };
}
