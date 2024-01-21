{ lib, pkgs, config, ... }:
with lib;
{
  programs.tealdeer = {
    settings = {
      display = {
        use_pager = false;
        compact = true;
      };
    };
  };

  home.activation = mkIf config.programs.tealdeer.enable {
    tealdeerCache = hm.dag.entryAfter [ "linkGeneration" ] ''
      $VERBOSE_ECHO "Rebuilding tealdeer cache"
      $DRY_RUN_CMD ${getExe pkgs.tealdeer} --update
    '';
  };
}
