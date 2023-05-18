{ config, lib, ... }:
with lib;
{
  ###### interface
  options = {
    custom.misc.globalIgnores = mkOption {
      type = with types; listOf str;
      readOnly = true;
    };
  };


  ###### implementation
  config = {
    custom.misc.globalIgnores = [
      ".bloop/"
      ".bsp"
      ".idea/"
      ".metals/"
      ".scala"
      ".scala-build"
      ".venv/"
      ".vscode/"
      "metals.sbt"
      "target/"
      "venv/"
    ];
  };
}
