{ lib, ... }:
{
  ###### interface
  options = with lib; {
    custom.misc.globalIgnores = mkOption {
      type = with types; listOf str;
      readOnly = true;
    };
  };


  ###### implementation
  config = {
    custom.misc.globalIgnores = [
      ".ammonite"
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
      "__pycache__/"
    ];
  };
}
