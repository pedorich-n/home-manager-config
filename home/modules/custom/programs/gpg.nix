{
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.custom.programs.gpg;
in
{
  ###### interface
  options = with lib; {
    custom.programs.gpg = {
      enable = mkEnableOption "gpg";
    };
  };

  ###### implementation
  config = lib.mkIf cfg.enable {

    programs.gpg = {
      package = lib.mkDefault pkgs.gnupg;
      enable = lib.mkDefault true;
    };

    services.gpg-agent = {
      enable = lib.mkDefault true;
      enableBashIntegration = lib.mkDefault true;
      enableZshIntegration = lib.mkDefault true;
      pinentry.package = lib.mkDefault pkgs.pinentry-curses;

      # 7 days
      defaultCacheTtl = lib.mkDefault 604800;
      maxCacheTtl = lib.mkDefault 604800;
    };
  };
}
