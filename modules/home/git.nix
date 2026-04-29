{ config, ... }:
let
  username = config.username;
in
{
  flake.modules.homeManager.git =
    { pkgs, ... }:
    {
      programs.git = {
        enable = true;
        settings = {
          user = {
            name = "jb";
            email = "jb@w.ch";
          };
          init.defaultBranch = "main";
          merge.conflictStyle = "diff3";
          diff.colorMoved = "default";
          pull.ff = "only";
          color.ui = "true";
          url = {
            "git@github.com:".insteadOf = "https://github.com/";
            "ssh://git@gitlab.spacetek.ch/".insteadOf = "https://gitlab.spacetek.ch/";
          };
          core.excludesFile = "/home/${username}/.config/git/.gitignore";
        };
      };

      programs.delta = {
        enable = true;
        enableGitIntegration = true;
        options = {
          line-numbers = true;
          side-by-side = false;
          diff-so-fancy = true;
          navigate = true;
        };
      };

      services.ssh-agent.enable = true;

      home.packages = [ pkgs.gh ];
    };
}
