{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.custom.programs.hmd;
in
{
  options = {
    custom.programs.hmd = {
      enable = lib.mkEnableOption "Home-Manager Diff";

      package = lib.mkPackageOption pkgs "hmd" { };

      runOnSwitch = lib.mkEnableOption "Run HMD on home-manage switch" // {
        default = true;
      };
    };
  };

  config.home = lib.mkIf cfg.enable {
    packages = [ cfg.package ];

    activation = lib.mkIf cfg.runOnSwitch {
      hmd = lib.hm.dag.entryAfter [ "linkGeneration" ] ''
        $VERBOSE_ECHO "Home Manager Generations Diff"
        $DRY_RUN_CMD ${lib.getExe cfg.package} --auto
      '';
    };
  };
}
