{ pkgs, username, ... }:
let
  inherit (builtins) attrValues;
in
{
  programs.git = {
    enable = true;

    # All git config (including user info) now goes inside 'settings'
    settings = {
      user = {
        name = "rustyRoby95";
        email = "a@bc.de";
      };
      init.defaultBranch = "main";
      merge.conflictStyle = "diff3";
      diff.colorMoved = "default";
      pull.ff = "only";
      color.ui = "true";
      url = {
        "git@github.com:".insteadOf = "https://github.com/";
        "git@gitlab.spacetek.ch:".insteadOf = "https://gitlab.spacetek.ch/";
      };
      core.excludesFile = "/home/${username}/.config/git/.gitignore";
    };
  };

  # Delta is now configured completely outside of programs.git
  programs.delta = {
    enable = true;
    enableGitIntegration = true; # Required to automatically wire it up with Git
    options = {
      line-numbers = true;
      side-by-side = false;
      diff-so-fancy = true;
      navigate = true;
    };
  };

  services.ssh-agent.enable = true;

  home.packages = attrValues { inherit (pkgs) gh; };
}
