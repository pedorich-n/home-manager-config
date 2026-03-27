{
  programs.plasma.panels = [
    {
      location = "top";
      alignment = "center";
      hiding = "none";
      lengthMode = "fill";
      floating = false;
      height = 36;

      widgets = [
        {
          name = "org.kde.plasma.lock_logout";
          config = {
            General = {
              show_lockScreen = false;
            };
          };
        }
        {
          pager = {
            general = {
              displayedText = "desktopNumber";
              showWindowOutlines = false;
            };
          };
        }
        {
          panelSpacer = {
            expanding = true;
          };
        }
        {
          digitalClock = {
            date = {
              enable = true;
              format.custom = "yyyy-MM-dd, ddd";
              position = "adaptive";
            };

            time = {
              format = "24h";
            };

            timeZone = {
              selected = [
                "Local"
                "Europe/Kyiv"
                "Europe/Berlin"
              ];
              format = "city";
            };

            calendar = {
              firstDayOfWeek = "monday";
            };

            font = {
              family = "Rubik";
              size = 11;
              style = "Regular";
              weight = 400;
            };
          };
        }
        {
          panelSpacer = {
            expanding = true;
          };
        }
        {
          systemTray = {
            icons = {
              spacing = "medium";
            };

            items = {
              shown = [
                "org.kde.plasma.battery"
              ];

              hidden = [
                "spotify-client"
                "TelegramDesktop"
                "org.kde.plasma.brightness"
                "org.kde.plasma.clipboard"
                "Xwayland Video Bridge_pipewireToXProxy"
                "org.kde.plasma.manage-inputmethod"
                "org.kde.plasma.weather"
                "org.kde.plasma.mediacontroller"
              ];

              configs = {
                battery = {
                  showPercentage = true;
                };
              };
            };

          };
        }
        {
          name = "org.kde.plasma.showdesktop";
        }
      ];

    }
    {
      location = "left";
      alignment = "center";
      hiding = "dodgewindows";
      lengthMode = "fit";
      floating = true;
      height = 66;

      widgets = [
        {
          # https://store.kde.org/p/2325705
          name = "TahoeLauncher";
          config = {
            General = {
              floating = true;
              showAllAppsInGrid = false;
              showAllAppsInList = true;
              useSystemFontSettings = true;
            };
            Shortcuts = {
              global = "";
            };
          };
        }
        {
          iconTasks = {
            launchers = [
              "applications:systemsettings.desktop"
              "preferred://filemanager"
              "preferred://browser"
              "applications:com.spotify.Client.desktop"
              "applications:org.telegram.desktop.desktop"
              "applications:code.desktop"
              "applications:org.kde.konsole.desktop"
            ];
          };
        }

      ];
    }
  ];
}
