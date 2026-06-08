{ ... }:
{
  flake.modules.homeManager.apps =
    { pkgs, ... }:
    {
      programs.firefox = {
        enable = true;
        profiles.default.isDefault = true;
      };
      programs.ranger = {
        enable = true;
        settings = {
          show_hidden = true;
          preview_images = true;
        };
      };
      programs.yazi = {
        enable = true;
        settings = {
          show_hidden = true;
          preview_images = true;
        };
      };
      stylix.targets.firefox.profileNames = [ "default" ];

      home.packages = with pkgs; [
        slack
        teams-for-linux
        loupe
        evince
        openvpn
        keepassxc
        joplin-desktop
        deluge
        remmina
        libreoffice-fresh
        gimp
      ];

      # Thunar uses the XFCE "helper" mechanism to find a terminal emulator
      # (for "Open Terminal Here" and for files whose handler runs in a terminal).
      # XFCE 4.20 ships no predefined helpers, so without this Thunar errors with
      # "Unable to find terminal required for application". Point it at kitty.
      xdg.dataFile."xfce4/helpers/custom-TerminalEmulator.desktop".text = ''
        [Desktop Entry]
        NoDisplay=true
        Version=1.0
        Encoding=UTF-8
        Type=X-XFCE-Helper
        X-XFCE-Category=TerminalEmulator
        Name=kitty
        Icon=kitty
        X-XFCE-Commands=${pkgs.kitty}/bin/kitty
        X-XFCE-CommandsWithParameter=${pkgs.kitty}/bin/kitty %s
      '';
      xdg.configFile."xfce4/helpers.rc".text = ''
        TerminalEmulator=custom-TerminalEmulator
      '';

      # Keep Loupe the default image viewer; installing GIMP otherwise lets it
      # grab the default handler for image types. GIMP stays available via
      # "Open With".
      xdg.mimeApps = {
        enable = true;
        defaultApplications =
          let
            loupe = "org.gnome.Loupe.desktop";
          in
          {
            "image/png" = loupe;
            "image/jpeg" = loupe;
            "image/gif" = loupe;
            "image/webp" = loupe;
            "image/bmp" = loupe;
            "image/tiff" = loupe;
            "image/svg+xml" = loupe;
            "image/avif" = loupe;
          };
      };
    };
}
