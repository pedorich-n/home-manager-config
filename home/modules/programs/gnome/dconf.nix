{ pkgs, lib, config, ... }:
with lib;
let
  cfg = config.custom.programs.gnome.dconf;
in
{
  ###### interface
  options = {
    custom.programs.gnome.dconf = {
      enable = mkEnableOption "Custom Dconf for Gnome";
    };
  };


  ###### implementation
  config = mkIf cfg.enable {
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
        workspace-names = [ "Main" "Idea" "Terminal" ];
      };

      "org/gnome/shell/world-clocks" = {
        locations = "[<(uint32 2, <('Berlin', 'EDDT', true, [(0.91746141594945008, 0.23241968454167572)], [(0.91658875132345297, 0.23387411976724018)])>)>, <(uint32 2, <('Kyiv', 'UKKK', false, [(0.87964594300514198, 0.53348898051069749)], @a(dd) [])>)>, <(uint32 2, <('Tokyo', 'RJTI', true, [(0.62191898430954862, 2.4408429589140699)], [(0.62282074357417661, 2.4391218722853854)])>)>]";
      };

      "org/gnome/shell/extensions/date-menu-formatter" = {
        pattern = "EEE, MMMM dd  HH : mm";
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

    };
  };
}
