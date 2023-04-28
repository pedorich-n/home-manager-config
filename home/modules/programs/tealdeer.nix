{ lib, pkgs, ... }:
with lib;
{
  programs.tealdeer = {
    enable = true;
    settings = {
      display = {
        use_pager = false;
        compact = true;
      };
    };
  };

  home.activation.tealdeerCache = hm.dag.entryAfter [ "linkGeneration" ] ''
    $VERBOSE_ECHO "Rebuilding tealdeer cache"
    $DRY_RUN_CMD ${getExe pkgs.tealdeer} --update
  '';
}
