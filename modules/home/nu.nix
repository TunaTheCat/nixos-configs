{ ... }:
{
  flake.modules.homeManager.nu =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        carapace
        fastfetch
        direnv
      ];

      programs.starship = {
        enable = true;
        enableNushellIntegration = true;
      };

      programs.nushell = {
        enable = true;

        envFile.text = ''
          # tools installed outside nix (e.g. the antigravity `agy` cli)
          use std/util "path add"
          path add $"($env.HOME)/.local/bin"

          $env.CARAPACE_BRIDGES = 'zsh,fish,bash,inshellisense'
          mkdir $"($nu.cache-dir)"
          carapace _carapace nushell | save --force $"($nu.cache-dir)/carapace.nu"
        '';

        configFile.text = ''
          $env.config.buffer_editor = "hx"
          $env.config.edit_mode = "vi"
          $env.config.cursor_shape = {
            vi_insert: line
            vi_normal: block
          }
          $env.config.show_banner = false
          $env.config.color_config = { hints: mr }
          $env.config.use_kitty_protocol = true

          $env.EDITOR = "hx"

          use std/dirs

          alias lg = lazygit
          alias ex = yazi

          # direnv hook
          $env.config.hooks.pre_prompt = ($env.config.hooks.pre_prompt | append { ||
            if (which direnv | is-empty) {
              return
            }

            direnv export json | from json | default {} | load-env
            if 'ENV_CONVERSIONS' in $env and 'PATH' in $env.ENV_CONVERSIONS {
              $env.PATH = do $env.ENV_CONVERSIONS.PATH.from_string $env.PATH
            }
          })

          # Over SSH nothing unlocks gnome-keyring (PAM only does it for greetd),
          # so Secret Service clients like sbx hang on an unlock prompt drawn on
          # the laptop's screen. Unlock (or create) the login keyring here.
          def keyring-unlock [] {
            let pw = (input -s "keyring password: ")
            print ""
            $pw | ^gnome-keyring-daemon --unlock | complete | ignore
          }
          if ($env.SSH_CONNECTION? != null) {
            let locked = (do { ^timeout 3 busctl --user get-property org.freedesktop.secrets /org/freedesktop/secrets/collection/login org.freedesktop.Secret.Collection Locked } | complete)
            if $locked.exit_code != 0 or ($locked.stdout | str trim) == "b true" {
              keyring-unlock
            }
          }

          # carapace
          source-env $"($nu.cache-dir)/carapace.nu"
          alias tidal = ghci -ghci-script (^find /nix/store -name "BootTidal.hs" | lines | first)
          fastfetch
        '';
      };
    };
}
