{ pkgs, ... }:
let
  # Build a 640x640 NixOS snowflake for the Kraken Elite LCD
  # Background matches the ashes base16 scheme (base00)
  krakenLogo = pkgs.runCommand "kraken-nix-logo" {
    nativeBuildInputs = [ pkgs.imagemagick pkgs.librsvg ];
  } ''
    rsvg-convert -w 480 -h 480 \
      ${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg \
      -o snowflake.png
    magick -size 640x640 xc:"#1C2023" snowflake.png \
      -gravity center -composite PNG:$out
  '';
in
{
  environment.systemPackages = [ pkgs.liquidctl ];

  services.udev.packages = [ pkgs.liquidctl ];

  systemd.services.liquidctl-setup = {
    description = "Configure NZXT Kraken Elite 360";
    after = [ "systemd-udev-settle.service" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = [
        "${pkgs.liquidctl}/bin/liquidctl initialize --match kraken"
        # static mode is broken on firmware 2.x — gif mode works as a workaround
        # https://github.com/liquidctl/liquidctl/issues/757
        "${pkgs.liquidctl}/bin/liquidctl --match kraken set lcd screen gif ${krakenLogo}"
      ];
    };
  };

  # The Kraken Elite firmware resets the LCD if the host stops talking to it.
  # Re-apply every 90s to keep the image persistent.
  systemd.timers.liquidctl-setup = {
    description = "Periodically refresh Kraken Elite LCD";
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnBootSec = "5s";
      OnUnitActiveSec = "90s";
    };
  };
}
