{ pkgs, lib, config, ... }:
with lib;
let
  cfg = config.custom.programs.jdk;
in
{
  ###### interface
  options = {
    custom.programs.jdk = {
      enable = mkEnableOption "JDK";

      package = (mkPackageOption pkgs "jdk17" { }) // { readOnly = true; };
    };
  };


  ###### implementation
  config = mkIf cfg.enable {
    home.packages = [ cfg.package ];

    custom.misc.sdkLinks.paths = {
      "java-17" = cfg.package;
    };
  };
}
