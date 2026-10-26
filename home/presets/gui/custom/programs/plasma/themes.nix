{
  config,
  lib,
  pkgs,
  ...
}:
let
  catpuccinVariant = "latte";
  catpuccinAccent = "green";
in
{

  custom.programs.plasma.themes = lib.mkIf config.programs.plasma.enable {
    packages = [
      pkgs.kde-themes.otto
      pkgs.kde-themes.otto-light
      pkgs.whitesur-cursors
      pkgs.custom-wallpapers
      pkgs.papirus-icon-theme
      (pkgs.qogir-icon-theme.override { themeVariants = [ "default" ]; })
      (pkgs.catppuccin-kvantum.override {
        variant = catpuccinVariant;
        accent = catpuccinAccent;
      })
      (pkgs.catppuccin-kde.override {
        flavour = [ catpuccinVariant ];
        accents = [ catpuccinAccent ];
      })
      (pkgs.catppuccin-gtk.override {
        variant = catpuccinVariant;
        accents = [ catpuccinAccent ];
      })
    ];
  };
}
