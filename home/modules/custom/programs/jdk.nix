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
  config =
    let
      jdkMajorVersion = versions.major (getVersion cfg.package);
    in
    mkIf cfg.enable {
      home = {
        packages = [ cfg.package ];
        file.".sdks/java-${jdkMajorVersion}".source = cfg.package;
      };
    };
}
