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


      # Just a central place to hold reference for system-wide JDK package
      package = mkOption {
        type = types.package;
        default = pkgs.jdk17;
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
