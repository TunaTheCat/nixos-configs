{ pkgs, ... }:
{
  # Prevent boot logs from leaking onto the greeter TTY
  systemd.services.greetd.serviceConfig = {
    Type = "idle";       # wait for other boot jobs to finish before starting
    StandardInput = "tty";
    StandardOutput = "tty";
    TTYVTDisallocate = "yes";  # clears the VT before greetd starts
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
}
