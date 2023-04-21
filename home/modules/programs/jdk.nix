{ pkgs, lib, config, ... }:
with lib;
let
  cfg = config.custom.programs.jdk;

  jdk-17-default = pkgs.jdk17;
in
{
  ###### interface
  options = {
    custom.programs.jdk = {
      enable = mkEnableOption "JDK";


      # Just a central place to hold reference for system-wide JDK package
      package = mkOption {
        type = types.package;
        default = jdk-17-default;
        description = "JDK to use";
      };
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
