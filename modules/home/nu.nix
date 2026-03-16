{ pkgs, ... }:
{
  home.packages = with pkgs; [
    carapace
    fastfetch
    direnv
    lazygit
  ];

  programs.starship = {
    enable = true;
    enableNushellIntegration = true;
  };

  programs.nushell = {
    enable = true;

    envFile.text = ''
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

      # carapace
      source-env $"($nu.cache-dir)/carapace.nu"

      fastfetch
    '';
  };
}
