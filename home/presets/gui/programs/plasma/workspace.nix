{
  config,
  ...
}:
let
  #LINK - packages/wallpapers/default.nix
  wallpaperPath = "${config.home.profileDirectory}/share/wallpapers/green-leaves.jpg";
in
{

  programs.plasma = {
    configFile = {
      "Kvantum/kvantum.kvconfig" = {
        General.theme = "catppuccin-latte-green";
      };

      "klassy/klassyrc" = {
        Global = {
          LookAndFeelSet = "Catppuccin-Latte-Green";
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
      colorScheme = "CatppuccinLatteGreen";
      theme = "default"; # Breeze
      # Enabling this brings too many dependencies, see: https://github.com/nix-community/plasma-manager/blob/a4b33606111c9/modules/workspace.nix#L569
      # iconTheme = "Papirus-Light";
      widgetStyle = "kvantum";
      windowDecorations = {
        theme = "Klassy";
        library = "org.kde.klassy";
      };
      cursor = {
        size = 24;
        theme = "Qogir";
      };
      wallpaper = wallpaperPath;
    };

    kscreenlocker = {
      appearance = {
        alwaysShowClock = true;
        showMediaControls = true;
        wallpaper = wallpaperPath;
      };
    };
  };
}
