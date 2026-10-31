{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.custom.programs.codegraph;
in
{
  options = {
    custom.programs.codegraph = {
      enable = lib.mkEnableOption "CodeGraph";

      package = lib.mkPackageOption pkgs "codegraph" { };

      mcp.enable = lib.mkEnableOption "the CodeGraph MCP server";

      telemetry.enable = lib.mkEnableOption "anonymous usage telemetry" // {
        description = ''
          Whether CodeGraph may send anonymous usage statistics.
          See https://github.com/colbymchenry/codegraph/blob/main/TELEMETRY.md
        '';
      };
    };
  };

  config = lib.mkIf cfg.enable {
    home = {
      packages = [
        cfg.package
      ];

      sessionVariables = lib.mkIf (!cfg.telemetry.enable) {
        CODEGRAPH_TELEMETRY = "0";
      };
    };

    programs.mcp.servers.codegraph = lib.mkIf cfg.mcp.enable {
      command = lib.getExe cfg.package;
      args = [
        "serve"
        "--mcp"
      ];
      # TODO: uncomment when this is released upstream. See https://github.com/colbymchenry/codegraph/commit/47526d2078e578deed8dae1c9db87f7df89f9de8
      #++ lib.optional (!cfg.telemetry.enable) "--no-telemetry";
    };

    custom.globalIgnores = [ ".codegraph/" ];
  };
}
