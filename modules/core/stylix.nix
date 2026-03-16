{ pkgs, ... }:
{
  stylix = {
    enable = true;
    image = ../../wallpapers/nix_dark_4k.png;

    polarity = "dark";
    base16Scheme = "${pkgs.base16-schemes}/share/themes/ashes.yaml"; # kanagawa-dragon
    fonts = {
      monospace = {
        package = pkgs.nerd-fonts.hasklug;
        name = "Hasklug Nerd Font";
      };
      sansSerif = {
        package = pkgs.nerd-fonts.hasklug;
        name = "Hasklug Nerd Font";
      };
      serif = {
        package = pkgs.nerd-fonts.hasklug;
        name = "Hasklug Nerd Font";
      };
      emoji = {
        package = pkgs.noto-fonts-color-emoji;
        name = "Noto Color Emoji";
      };
      sizes = {
        applications = 9;
        terminal = 9;
        desktop = 9;
        popups = 9;
      };
    };

    cursor = {
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Classic";
      size = 16;
    };

    iconTheme = {
      enable = true;
      package = pkgs.papirus-icon-theme;
      dark = "Papirus-Dark";
      light = "Papirus-Light";
    };
  };
}
