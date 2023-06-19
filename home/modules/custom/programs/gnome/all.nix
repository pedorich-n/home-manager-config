{ lib, config, ... }:
with lib;
let
  cfg = config.custom.programs.gnome.all;
in
{
  ###### interface
  options = {
    custom.programs.gnome.all = {
      enable = mkEnableOption "All custom configs for Gnome";
    };
  };


  ###### implementation
  config = mkIf cfg.enable {
    custom.programs.gnome = {
      dconf.enable = true;
      extensions.enable = true;
    };
  };
}
