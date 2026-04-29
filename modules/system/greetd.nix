{ ... }:
{
  flake.modules.nixos.greetd =
    { pkgs, ... }:
    {
      systemd.services.greetd.serviceConfig = {
        Type = "idle";
        StandardInput = "tty";
        StandardOutput = "tty";
        TTYVTDisallocate = "yes";
      };

      services.greetd = {
        enable = true;
        settings = {
          default_session = {
            command = "${pkgs.tuigreet}/bin/tuigreet --time --remember --asterisks --cmd niri-session";
            user = "greeter";
          };
        };
      };
    };
}
