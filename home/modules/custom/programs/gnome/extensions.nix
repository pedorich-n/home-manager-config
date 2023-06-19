{ pkgs, lib, config, ... }:
with lib;
let
  cfg = config.custom.programs.gnome.extensions;
in
{
  ###### interface
  options = {
    custom.programs.gnome.extensions = {
      enable = mkEnableOption "Gnome Extensions";
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
  };
}
