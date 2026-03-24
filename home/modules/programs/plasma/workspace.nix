{
  config,
  ...
}:
{
  programs.plasma = {
    configFile = {
      "Kvantum/kvantum.kvconfig" = {
        General.theme = "Otto-Light";
      };

      "klassy/klassyrc" = {
        Global = {
          LookAndFeelSet = "Otto-Light";
        };
        SystemIconGeneration = {
          KlassyDarkIconThemeInherits = "Qogir-Dark";
          KlassyIconThemeInherits = "Qogir";
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
          ButtonIconStyle = "StyleOxygen";
          ButtonShape = "ShapeFullHeightRoundedRectangle";
          IconSize = "IconMedium";
          MatchTitleBarToApplicationColor = true;
          WindowCornerRadius = 10;
        };
      };
    };

    workspace = {
      colorScheme = "OttoLight";
      theme = "Otto-Light";
      # Enabling this brings too many dependencies, see: https://github.com/nix-community/plasma-manager/blob/a4b33606111c9/modules/workspace.nix#L569
      # iconTheme = "Qogir";
      widgetStyle = "kvantum";
      windowDecorations = {
        theme = "Klassy";
        library = "org.kde.klassy";
      };
      cursor = {
        size = 24;
        theme = "WhiteSur-cursors";
      };
      wallpaper = "${config.home.profileDirectory}/share/wallpapers/green-leaves.jpg";
    };
  };
}
