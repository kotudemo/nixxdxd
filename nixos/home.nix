# basic hm stuff
{ config, pkgs, options, ...}:
{
  imports = [ 
    ./conf.d/firefox.nix 
  ];
 /* qt = {
    enable = true;
    platformTheme = "gtk2";
    style = "gtk2"; }; */
 
  gtk = {
    enable = true;
    # iconTheme = {
    #   package = pkgs.papirus-icon-theme; 
    #   name = "Papirus-Icons";
    # };
    theme = {
      name = "Catppuccin-Macchiato-Compact-Sapphire-Dark";
      package = pkgs.catppuccin-gtk.override {
        accents = [ "sapphire" ];
        size = "compact";
        tweaks = [ "rimless" "black" ];
        variant = "macchiato";
      };
    };
  };


# Now symlink the `~/.config/gtk-4.0/` folder declaratively:
  xdg.configFile = {
    "gtk-4.0/assets".source = "${config.gtk.theme.package}/share/themes/${config.gtk.theme.name}/gtk-4.0/assets";
    "gtk-4.0/gtk.css".source = "${config.gtk.theme.package}/share/themes/${config.gtk.theme.name}/gtk-4.0/gtk.css";
    "gtk-4.0/gtk-dark.css".source = "${config.gtk.theme.package}/share/themes/${config.gtk.theme.name}/gtk-4.0/gtk-dark.css";
  }; 
  home = {
    username = "kotudemo";
    homeDirectory = "/home/kotudemo";
    stateVersion = "23.11";
    # pointerCursor = {
    #   name = "google-cursor";
    #   size = 24;
    #   package = pkgs.google-cursor;
    # };
  };
}
