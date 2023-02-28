{ lib, config, ... }:
with lib;
let
  cfg = config.custom.programs.gpg;
in
{
  ###### interface
  options = {
    custom.programs.gpg = {
      enable = mkEnableOption "gpg";
    };
  };


  ###### implementation
  config = mkIf cfg.enable {
    programs.gpg.enable = true;

    services.gpg-agent = {
      enable = true;
      # 7 days
      defaultCacheTtl = 604800;
      maxCacheTtl = 604800;
    };
  };
}
