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

    xdg.configFile."fd/ignore" =
      let
        ignores = config.custom.misc.globalIgnores;
      in
      mkIf (customLib.nonEmpty ignores) { text = (builtins.concatStringsSep "\n" ignores) + "\n"; };
  };
}
