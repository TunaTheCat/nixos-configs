{ ... }:
{
  flake.modules.homeManager.gtk =
    { ... }:
    {
      # Stylix defines dark base16 colors and sets color-scheme=prefer-dark
      # (which GTK4/libadwaita honours), but GTK3 apps using adw-gtk3 (e.g.
      # Thunar) only switch to the dark variant when this flag is set. Without
      # it, dialog buttons render in light mode -> unreadable dark-on-dark text.
      gtk.gtk3.extraConfig.gtk-application-prefer-dark-theme = true;
      gtk.gtk4.extraConfig.gtk-application-prefer-dark-theme = true;
    };
}
