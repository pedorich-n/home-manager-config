{ lib, config, pkgs, ... }:
with lib;
let
  cfg = config.custom.programs.gnome;
in
{
  ###### interface
  options = {
    custom.programs.gnome = {
      enable = mkEnableOption "Custom configs for Gnome";
    };
  };


  ###### implementation
  config = mkIf cfg.enable {
    home.packages = with pkgs.gnomeExtensions; [
      date-menu-formatter
      lock-keys
      notification-timeout
      unite
      workspace-switcher-manager
    ];

    dconf.settings = with lib.hm.gvariant; {
      "org/gnome/mutter" = {
        dynamic-workspaces = false;
      };

      "org/gnome/desktop/interface" = {
        clock-format = "24h";

        cursor-theme = "Yaru";
        gtk-theme = "Yaru";
        icon-theme = "Yaru";

        show-battery-percentage = true;
      };

      "org/gnome/desktop/input-sources" = {
        current = "uint32 0";
        sources = [ (mkTuple [ "xkb" "us" ]) (mkTuple [ "xkb" "ru" ]) ];
      };

      "org/gnome/desktop/wm/keybindings" = {
        switch-input-source = [ "<Super>space" "XF86Keyboard" ];
        switch-to-workspace-down = [ "<Primary><Alt>Right" ];
        switch-to-workspace-up = [ "<Primary><Alt>Left" ];
      };

      "org/gnome/desktop/wm/preferences" = {
        num-workspaces = 3;
        workspace-names = [ "Main" "IDE" "Terminal" ];
      };

      "org/gnome/settings-daemon/plugins/media-keys" = {
        custom-keybindings = [
          "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/"
          "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/"
        ];
        screenshot = [ ];
      };

      "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
        binding = "<Alt>space";
        command = "ulauncher-toggle";
        name = "Ulauncher";
      };

      "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1" = {
        binding = "Print";
        command = "flameshot gui";
        name = "Flameshot";
      };

      "org/gnome/shell/world-clocks" = {
        # It's very hard (if possible at all) to express this structure using HomeManager's Dconf types so using this trick to set the value to a literal
        locations = mkString "" // {
          __toString = _: "[<(uint32 2, <('Kyiv', 'UKKK', true, [(0.87964594300514198, 0.53348898051069749)], [(0.88022771360470919, 0.53261631588470038)])>)>, <(uint32 2, <('Tokyo', 'RJTI', true, [(0.62191898430954862, 2.4408429589140699)], [(0.62282074357417661, 2.4391218722853854)])>)>]";
        };
      };

      "org/gnome/shell/extensions/date-menu-formatter" = {
        pattern = "EEE, MMMM dd  kk : mm";
      };

      "org/gnome/shell/extensions/lockkeys" = {
        notification-preferences = "osd";
        style = "none";
      };

      "org/gnome/shell/extensions/notification-timeout" = {
        timeout = 3000; # 3 seconds
      };

      "org/gnome/shell/extensions/workspace-switcher-manager" = {
        "reverse-popup-orientation" = true;
      };

      "org/gnome/shell/extensions/unite" = {
        app-menu-ellipsize-mode = "end";
        enable-titlebar-actions = true;
        extend-left-box = false;
        greyscale-tray-icons = false;
        hide-activities-button = "auto";
        hide-aggregate-menu-arrow = false;
        hide-app-menu-arrow = true;
        hide-app-menu-icon = false;
        hide-dropdown-arrows = false;
        hide-window-titlebars = "maximized";
        notifications-position = "center";
        reduce-panel-spacing = false;
        show-desktop-name = false;
        show-legacy-tray = false;
        window-buttons-placement = "last";
        window-buttons-theme = "yaru";
      };

      "org/gnome/terminal/legacy" = {
        default-show-menubar = false;
        headerbar = mkJust false;
      };

      "org/gnome/terminal/legacy/keybindings" = {
        move-tab-left = "<Shift><Alt>Left";
        move-tab-right = "<Shift><Alt>Right";
        next-tab = "<Alt>braceright";
        prev-tab = "<Alt>braceleft";
      };


      "org/gnome/terminal/legacy/profiles:" = {
        default = "b1dcc9dd-5262-4d8d-a863-c897e6d979b9";
      };

      "org/gnome/terminal/legacy/profiles:/:b1dcc9dd-5262-4d8d-a863-c897e6d979b9" = {
        audible-bell = false;
        default-size-columns = 140;
        default-size-rows = 35;
        font = "FiraCode Nerd Font 11";
        use-system-font = false;
        visible-name = "Default";
      };
    };
  };
}
