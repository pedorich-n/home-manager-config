{ pkgs, lib, config, ... }:
let
  cfg = config.custom.programs.gpg;
in
{
  ###### interface
  options = with lib; {
    custom.programs.gpg = {
      enable = mkEnableOption "gpg";
      description = "Enables GPG support and GPG agen service. Mostly neeed to set the settings";
    };
  };


  ###### implementation
  config = lib.mkIf cfg.enable {

    programs.gpg = {
      package = pkgs.gnupg;
      enable = true;
    };

    services.gpg-agent = {
      enable = true;
      enableBashIntegration = true;
      enableZshIntegration = true;
      pinentryPackage = lib.mkDefault pkgs.pinentry-curses;

      # 7 days
      defaultCacheTtl = 604800;
      maxCacheTtl = 604800;
    };
  };
}
