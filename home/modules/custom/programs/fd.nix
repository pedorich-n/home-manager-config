{ pkgs, lib, config, customLib, ... }:
with lib;
let
  cfg = config.custom.programs.fd;
in
{
  ###### interface
  options = {
    custom.programs.fd = {
      enable = mkEnableOption "fd";
    };
  };


  ###### implementation
  config = mkIf cfg.enable {
    home.packages = [ pkgs.fd ];

    xdg.configFile."fd/ignore" = with config.custom.misc;
      mkIf (customLib.nonEmpty globalIgnores) { text = (builtins.concatStringsSep "\n" globalIgnores) + "\n"; };
  };
}
