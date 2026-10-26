{
  lib,
  config,
  ...
}:
let
  cfg = config.custom.programs.java;
in
{
  options = with lib; {
    custom.programs.java = {
      toolOptions = mkOption {
        type = with types; listOf nonEmptyStr;
        default = [ ];
        example = [ "-Djavax.net.ssl.trustStore=/path/to/truststore.jks" ];
        description = "JVM options to set in JAVA_TOOL_OPTIONS. Picked up by all JVMs.";
      };
    };
  };

  config = lib.mkIf (cfg.toolOptions != [ ]) {
    home.sessionVariables.JAVA_TOOL_OPTIONS = lib.concatStringsSep " " cfg.toolOptions;
  };
}
