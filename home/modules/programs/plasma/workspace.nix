{
  config,
  lib,
  pkgs,
  ...
}:
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
        variant = "latte";
        accent = "green";
      })
      (pkgs.catppuccin-kde.override {
        flavour = [ "latte" ];
        accents = [ "green" ];
      })
    ];
  };

  programs.plasma = {
    configFile = {
      "Kvantum/kvantum.kvconfig" = {
        # General.theme = "Otto-Light";
      };

      "klassy/klassyrc" = {
        Global = {
          # LookAndFeelSet = "Otto-Light";
        };
        SystemIconGeneration = {
          KlassyDarkIconThemeInherits = "Papirus-Dark";
          KlassyIconThemeInherits = "Papirus";
        };
        ButtonColors = {
          CloseButtonIconColorActive = "AsSelected";
          CloseButtonIconColorInactive = "AsSelected";
        };

        ButtonSizing = {
          FullHeightButtonSpacingRight = 0;
          FullHeightButtonWidthMarginRight = 10;
        };

        Windeco = {
          ButtonIconStyle = "StyleFluent";
          ButtonShape = "ShapeFullHeightRoundedRectangle";
          IconSize = "IconMedium";
          MatchTitleBarToApplicationColor = true;
          WindowCornerRadius = 10;
        };
      };
    };

    workspace = {
      # colorScheme = "OttoLight";
      # theme = "Otto-Light";
      # Enabling this brings too many dependencies, see: https://github.com/nix-community/plasma-manager/blob/a4b33606111c9/modules/workspace.nix#L569
      # iconTheme = "Qogir";
      widgetStyle = "kvantum";
      windowDecorations = {
        theme = "Klassy";
        library = "org.kde.klassy";
      };
      cursor = {
        size = 24;
        # theme = "WhiteSur-cursors";
      };
      wallpaper = "${config.home.profileDirectory}/share/wallpapers/green-leaves.jpg";
    };
  };
}
