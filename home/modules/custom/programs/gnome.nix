{ config, lib, ... }:
let
  cfg = config.custom.programs.gnome;
in
{
  ###### interface
  options = with lib; {
    custom.programs.gnome = {
      enable = mkEnableOption "Custom configs for Gnome";
    };
  };


  ###### implementation
  config = lib.mkIf cfg.enable {
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
        sources = [ (mkTuple [ "xkb" "us" ]) (mkTuple [ "xkb" "ru" ]) ];
      };

      "org/gnome/desktop/wm/keybindings" = {
        switch-input-source = [ "<Super>space" "XF86Keyboard" ];
        switch-to-workspace-down = [ "<Control><Alt>Right" ];
        switch-to-workspace-up = [ "<Control><Alt>Left" ];
      };

      "org/gnome/desktop/wm/preferences" = {
        num-workspaces = 3;
        workspace-names = [ "Main" "IDE" "Terminal" ];
      };

      "org/gnome/settings-daemon/plugins/media-keys" = {
        custom-keybindings = [
          "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/"
        ];
        screenshot = [ ];
      };

      "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
        binding = "Print";
        command = "flameshot gui";
        name = "Flameshot";
      };

      "org/gnome/shell/extensions/date-menu-formatter" = {
        fonr-size = 12;
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
        font = "FiraCode Nerd Font Mono 11";
        use-system-font = false;
        visible-name = "Default";
      };
    };
  };
}
