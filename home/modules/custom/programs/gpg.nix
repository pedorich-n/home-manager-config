{ pkgs, lib, config, ... }:
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
      package = pkgs.gnupg;
      enable = true;
    };

    services.gnome-keyring.enable = true;

    services.gpg-agent = {
      enable = true;
      # 7 days
      defaultCacheTtl = 604800;
      maxCacheTtl = 604800;
    };
  };
}
