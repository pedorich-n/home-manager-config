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
      ".metals/"
      ".venv/"
      ".vscode/"
      "metals.sbt"
      "venv/"
    ];
  };
}
